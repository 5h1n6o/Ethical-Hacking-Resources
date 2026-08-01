# Reconnaissance（技術的偵察）

Reconnaissance は、攻撃対象に対して **技術的にアクセス可能な情報を収集するフェーズ**です。  
OSINT（公開情報収集）とは別章であり、ここでは「実際にターゲットへアクセスして得られる情報」を扱います。

Boot2Root テンプレートの **Recon 章の詳細版**として機能します。

---

# 🎯 目的

- 外部から見えるサービスを把握する  
- 攻撃可能なサービスを特定する  
- 次の Enumeration / Initial Access の方向性を決める  
- 内部ネットワークの存在を推測する  
- OSCP レポートで必要な「攻撃の根拠」を整理する  

---

# 📘 目次

1. Port Scanning  
   - Nmap  
   - RustScan  
   - Masscan  
2. Banner Grab / Version Detection  
3. HTTP / SSL Recon  
4. SMB / FTP / SSH Recon  
5. Attack Surface Identification  
6. Boot2Root との連携

---

# 1. Port Scanning

ポートスキャンは Recon の中心であり、  
**攻撃の入口を決める最重要フェーズ**です。

---

## 1.1 Nmap（最重要）

### 主なスキャン
```
nmap -p- -T4 -v <TARGET>
nmap -sC -sV -O -T4 <TARGET>
nmap --script vuln <TARGET>
```

### 確認ポイント
- 開いているポート  
- サービスの種類  
- バージョン（古いほど exploit が多い）  
- Web / SMB / FTP / SSH の有無  
- 内部 Web（8080/8000/5000）  
- DB（3306 / 5432）  
- Redis（6379）  

### 頻出ポート
| Port / Service | Attack Vector（攻撃の糸口） | Next Action（次のアクション） |
| :--- | :--- | :--- |
| **21 / FTP** | Anonymousログイン、書き込み権限、ソース露出, | `anonymous`ログインの試行,,, ファイル一覧の確認とダウンロード,, バナーからのバージョン特定 |
| **22 / SSH** | バナーからのOS/バージョン特定、認証情報, | バナーによるOS/OpenSSHバージョンの特定,, `Hydra`による辞書攻撃・ブルートフォース,, Metasploitの`ssh_login`モジュール |
| **23 / Telnet** | 平文の認証情報、バナーによるOS特定 | `nc` または `telnet` でのバナー取得、既知の脆弱性（FreeBSD等）の確認 |
| **25 / SMTP** | ユーザー名の露出、オープンリレー | `VRFY` コマンドによる有効ユーザー名の列挙、`EXPN` コマンドの試行 |
| **53 / DNS** | ゾーン情報の漏洩、DNSスプーフィング | `nslookup` / `dig` による名前解決、ゾーン転送（AXFR）の試行 |
| **80 / HTTP** | Webサーバー、CMS、公開ディレクトリ,,, | `curl -I`（バナー取得）, `whatweb`（技術特定）, `Nikto`（脆弱性スキャン）,, `Gobuster`/`Wfuzz`（ディレクトリ列挙）,, ソースコード解析, |
| **443 / HTTPS** | SSL/TLS情報の露出、WAFの存在, | SSL証明書の詳細確認, NSEスクリプト（`ssl-heartbleed`など）による脆弱性診断, `Nikto` |
| **139 / 445 / SMB** | 共有フォルダ、Nullセッション、脆弱なプロトコル,, | `smbclient -N -L`（共有列挙）, `enum4linux`（詳細列挙）, 既知の脆弱性（MS08-067, EternalBlueなど）の確認, |
| **3306 / MySQL** | 外部アクセスの許可、未認証アクセス、認証情報, | `mysql -u root`（パスワードなしログイン）の試行,, Webサーバー上の`config.php`等からの認証情報の探索, |
| **6379 / Redis** | ※情報源に記述なし | （情報源にはRedisに関する直接的な記述はありません） |
| **8080 / 8000 / 5000** | 管理画面、API、Webプロキシ、開発用サーバー,, | ブラウザでのアクセス確認,, APIヘッダー（JSON等）の確認, `Gobuster`等による隠しパスの探索, |
| **111 / SunRPC (rpcbind)** | 登録済みサービス情報の露出 | `rpcinfo -p` によるプログラム番号、バージョン、動的ポートの列挙 |
| **161 / SNMP** | デフォルトのコミュニティ名、システム構成情報の露出 | `snmpwalk` でのプロセス、ソフトウェア、ネットワーク情報の列挙 |
| **1433 / MS SQL** | 脆弱な `sa` アカウント、未認可アクセス | `mssql_ping` によるインスタンス特定、`mssql_login` によるブルートフォース |
| **3389 / RDP** | 既知の脆弱性（MS12-020等）、認証情報の不足 | Metasploitでの脆弱性チェック、`Hydra` / `Ncrack` による認証突破 |
| **5900 / VNC** | 未認証アクセス、脆弱な認証 | `vnc_none_auth` スキャナーによるパスワードなしアクセスの確認 |
| **6667 / IRC** | バックドアが仕込まれたサービス（UnrealIRCd等） | `nc` によるバナー取得、既知のバックドアコマンドの検証 |
| **5985 / WinRM** | HTTP経由のリモート管理アクセス | `Invoke-Command` によるコマンド実行の試行、認証設定の確認 |
| **2049 / NFS** | 公開共有ディレクトリ、不適切なアクセス制御 | `rpcinfo` によるNFS確認、マウント可能なディレクトリ（Shares）の列挙 |
| **その他の古いサービス** | バナーに現れる旧バージョンの脆弱性,, | `searchsploit`によるExploit探索,,, CVE番号に基づく公開PoCの調査,, バナーグラビングによる詳細特定 |

---

## 1.2 RustScan（高速）

```
rustscan -a <TARGET> --ulimit 5000 -- -sC -sV
```

### 使いどころ
- ポートだけ高速で知りたいとき  
- Nmap の前処理として最適  

---

## 1.3 Masscan（超高速）

```
masscan -p1-65535 <TARGET> --rate=10000
```

### 使いどころ
- 大規模ポートスキャン  
- FW / ACL の存在確認  

---

# 2. Banner Grab / Version Detection

```
nc -nv <TARGET> <PORT>
curl -I http://<TARGET>
openssl s_client -connect <TARGET>:443
```

### 目的
- サービスの種類  
- バージョン  
- ミドルウェア  
- 内部ホスト名（SSL CN/SAN）  

---

# 3. HTTP / SSL Recon

### HTTP
```
curl -I http://<TARGET>
whatweb <TARGET>
ffuf -u http://<TARGET>/FUZZ -w common.txt
```

### SSL
```
openssl s_client -connect <TARGET>:443
```

### 確認ポイント
- Server: Apache / nginx / IIS  
- X-Powered-By: PHP / ASP.NET  
- admin パネルの存在  
- 内部ホスト名（CN/SAN）  

---

# 4. SMB / FTP / SSH Recon

## SMB
```
smbclient -N -L //<TARGET>/
```

### 確認ポイント
- anonymous  
- 認証情報  
- バックアップファイル  

---

## FTP
```
ftp <TARGET>
```

### 確認ポイント
- anonymous  
- 書き込み可能か  
- Web ソースコードの有無  

---

## SSH
```
ssh -v user@<TARGET>
```

### 確認ポイント
- バナー情報  
- OS / バージョン  
- ユーザー名の推測  

---

# 5. Attack Surface Identification

Recon の結果から、攻撃可能な面を特定する。

### 主な攻撃面
- Web（最も突破口が多い）  
- SMB（認証情報）  
- FTP（WebShell）  
- DB（弱パスワード）  
- Redis（未認証）  
- 内部 Web（Pivot 必須）  

---

# 6. Boot2Root との連携

Boot2Root の **Recon 章**は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Recon
↓
Enumeration
↓
Initial Access
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Reconnaissance に集約します。

---

# 🎯 この章の目的

- Recon の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
