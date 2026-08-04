# Enumeration（外部サービスの詳細調査）

Enumeration は、Reconnaissance で見つけたサービスを **深掘りし、攻撃可能なポイントを特定するフェーズ**です。

---

## 🎯 目的

- Recon で見つけたサービスを詳細に分析する  
- Web / SMB / FTP / SSH / DB / AD などの内部構造を把握する  
- 脆弱性の有無を確認する  
- 認証情報の有無を確認する  
- 初期侵入（Initial Access）につながる突破口を見つける  
- AD 攻撃の前提情報（LDAP / Kerberos / SMB）を抽出する  
---

## 🔍 攻撃フロー
1. 対象サービスの特定（Recon の結果を基に）
2. サービスごとの詳細調査（プロトコル・バージョン・設定）
3. 脆弱性の有無を確認（NSE / スクリプト / 手動検証）
4. 認証情報の探索（弱パスワード・デフォルト設定）
5. Web / SMB / FTP / DB / AD などの個別列挙
6. 初期侵入につながるポイントを抽出

---

## 🧭 Attack Surface Deep Dive（攻撃面の深掘り）
Recon で特定した Attack Surface を、  
サービス単位でさらに詳細に調査する。

### Web
- ディレクトリ列挙  
- 技術スタック  
- 認証方式  
- 脆弱性（SQLi / RCE / LFI / SSRF / SSTI / XXE）  

### SMB
- 共有一覧  
- Anonymous アクセス  
- 認証情報（.txt / .conf / .ini）  
- バックアップファイル  
- Web ソースコード  
- AD ドメイン名の取得  
- NetExec / CrackMapExec での列挙

### LDAP
- BaseDN  
- ユーザー列挙  
- グループ列挙  
- AD の構造把握  
- windapsearch / ldapsearch / ldapdomaindump

### Kerberos
- AS-REP Roasting の対象ユーザー  
- Kerberoasting の対象 SPN  
- ドメイン名の確認  
- Impacket（GetNPUsers / GetUserSPNs）

### FTP
- anonymous  
- 書き込み可能か  
- WebShell アップロード可否

### SSH
- バナー情報  
- OS / バージョン  
- ユーザー名の推測  
- 公開鍵の有無  
- ssh2john によるハッシュ抽出

### Database（MySQL / PostgreSQL / MSSQL）
- 弱パスワード  
- Web アプリの DB  
- テーブル構造  
- xp_cmdshell（MSSQL）  
- impacket-mssqlclient

### メール（SMTP / IMAP）
- VRFY / EXPN  
- ユーザー列挙  
- swaks / smtp-user-enum

### SNMP
- snmpwalk による情報漏洩  
- OSCP では内部情報の宝庫

### 内部 Web
- Pivot 必須のサービス  
- AD 管理ポータルが隠れている場合あり
※ Boot2Root の Writeup では実際の結果を記録し、  
Pentest-Playbook では「判断基準」を記述する。

---

## 🛠 代表コマンド（最低限）

### Directory / File Enumeration
```
ffuf -u http://<TARGET>/FUZZ -w common.txt -e php,txt,bak,old
dirsearch -u http://<TARGET>
```

### Web Enumeration
```
curl -I http://<TARGET>
whatweb <TARGET>
ffuf -u http://<TARGET>/FUZZ -w common.txt -e php,txt,bak,old
dirsearch -u http://<TARGET>
nikto -h http://<TARGET>
curl http://<TARGET>/app.js
```

### SMB Enumeration
```
smbclient -N -L //<TARGET>/
smbclient //<TARGET>/<SHARE>
smbmap -H <TARGET>
enum4linux-ng <TARGET>
netexec smb <TARGET> -u '' -p ''
rpcclient -U '' <TARGET>
```

### LDAP Enumeration（OSCP強化）
```
ldapsearch -x -H ldap://<TARGET> -b "DC=example,DC=com"
windapsearch --dc-ip <TARGET>
ldapdomaindump <TARGET>
```

### Kerberos Enumeration（OSCP強化）
```
kerbrute userenum --dc <TARGET> users.txt
GetNPUsers.py <DOMAIN>/ -dc-ip <TARGET>
GetUserSPNs.py <DOMAIN>/ -dc-ip <TARGET>
```

### FTP Enumeration
```
ftp <TARGET>
```

### SSH Enumeration
```
ssh -v user@<TARGET>
ssh-keyscan <TARGET>
```

### Database Enumeration
#### MySQL
```
mysql -h <TARGET> -u root -p
```

#### PostgreSQL
```
psql -h <TARGET> -U postgres
```

#### MSSQL（OSCP強化）
```
impacket-mssqlclient <user>:<pass>@<TARGET>
```

### Service-Specific Enumeration
#### Redis
```
redis-cli -h <TARGET>
```

#### RDP / VNC
```
nmap -p 3389 --script rdp-enum-encryption <TARGET>
```

#### SNMP
```
snmpwalk -v2c -c public <TARGET>
```
---

## Vulnerability Research

### 脆弱性調査おすすめツール

|  優先度  | ツール / 手法                                  | 目的                | コマンド・検索例                                     | 確認するポイント                  |
| :---: | :---------------------------------------- | :---------------- | :------------------------------------------- | :------------------------ |
| ★★★★★ | **SearchSploit**                          | Exploitの有無を確認     | `searchsploit apache 2.4.18`                 | 公開Exploit、PoC、EDB-ID      |
| ★★★★★ | **Google検索**                              | 最新の情報や攻略記事を探す     | `Apache 2.4.18 exploit`<br>`OpenSSH 7.2 CVE` | 攻略記事、GitHub、ブログ           |
| ★★★★☆ | **NVD (National Vulnerability Database)** | CVEの詳細を確認         | `CVE-2024-6387`                              | CVSS、影響バージョン、修正版          |
| ★★★★☆ | **GitHub**                                | PoCやExploitコードを探す | `CVE-2024-6387 github`                       | PoC、README、使用方法           |
| ★★★★☆ | **Metasploit**                            | 利用可能なモジュールを確認     | `search apache`                              | exploit / auxiliary モジュール |
| ★★★☆☆ | **Nmap NSE**                              | 脆弱性の簡易チェック        | `nmap --script vuln TARGET`                  | 既知の脆弱性、設定不備               |
| ★★★☆☆ | **Exploit-DB**                            | Web上でExploitを検索   | `Apache 2.4.18 exploit`                      | Exploitコード、PoC            |
| ★★☆☆☆ | **CVE Detailsなど**                         | 関連CVEを一覧で確認       | `Apache 2.4.18 CVE`                          | 関連CVEの一覧                  |

SearchSploit → Google → NVD → GitHub → Metasploitという流れを習慣化する。

### searchsploit
```
searchsploit apache 2.4
searchsploit openssl
```

### Nmap vuln scripts
```
nmap --script vuln <TARGET>
```

---

## 📚 詳細（ツールの使い方）
ツールの詳細な使い方は Security-Tools に集約しています。

- nmap → Security-Tools / nmap  
- ffuf → Security-Tools / ffuf  
- smbclient → Security-Tools / smbclient  
- redis-cli → Security-Tools / redis  
- mysql → Security-Tools / mysql

---
## Boot2Root との連携

Boot2Root の Enumeration 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Reconnaissance
↓
Enumeration
↓
Initial Access
```
