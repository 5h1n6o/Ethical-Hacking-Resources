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

### 🌐 Web
- ディレクトリ列挙  
  - [ffuf](https://github.com/5h1n6o/Security-Tools/blob/main/ffuf/README.md)  
  - [gobuster](https://github.com/5h1n6o/Security-Tools/blob/main/gobuster/README.md)
- 技術スタック  
  - [whatweb](https://github.com/5h1n6o/Security-Tools/blob/main/whatweb/README.md)
- 認証方式  
  - [Burp Suite](https://github.com/5h1n6o/Security-Tools/blob/main/burp/README.md)
- 脆弱性（SQLi / RCE / LFI / SSRF / SSTI / XXE）  
  - [Burp Suite](https://github.com/5h1n6o/Security-Tools/blob/main/burp/README.md)
  - [curl](https://github.com/5h1n6o/Security-Tools/blob/main/curl/README.md)

---

### 📁 SMB
- 共有一覧  
  - [smbclient](https://github.com/5h1n6o/Security-Tools/blob/main/smbclient/README.md)
  - [smbmap](https://github.com/5h1n6o/Security-Tools/blob/main/smbmap/README.md)
- Anonymous アクセス  
  - [enum4linux-ng](https://github.com/5h1n6o/Security-Tools/blob/main/enum4linux-ng/README.md)
- 認証情報  
  - [netexec](https://github.com/5h1n6o/Security-Tools/blob/main/netexec/README.md)
- AD ドメイン名の取得  
  - [rpcclient](https://github.com/5h1n6o/Security-Tools/blob/main/rpcclient/README.md)

---

### 🧬 LDAP
- BaseDN  
  - [ldapsearch](https://github.com/5h1n6o/Security-Tools/blob/main/ldapsearch/README.md)
- ユーザー列挙  
  - [windapsearch](https://github.com/5h1n6o/Security-Tools/blob/main/windapsearch/README.md)
- グループ列挙  
  - [ldapdomaindump](https://github.com/5h1n6o/Security-Tools/blob/main/ldapdomaindump/README.md)

---

### 🎭 Kerberos
- AS-REP Roasting  
  - [GetNPUsers.py](https://github.com/5h1n6o/Security-Tools/blob/main/impacket/GetNPUsers.md)
- Kerberoasting  
  - [GetUserSPNs.py](https://github.com/5h1n6o/Security-Tools/blob/main/impacket/GetUserSPNs.md)
- Impacket  
  - [Impacket](https://github.com/5h1n6o/Security-Tools/blob/main/impacket/README.md)

---

### 📡 FTP
- ftp  
- curl

---

### 🔐 SSH
- ssh  
- [ssh2john](https://github.com/5h1n6o/Security-Tools/blob/main/john/README.md)

---

### 🗄 Database（MySQL / PostgreSQL / MSSQL）
- mysql  
- psql  
- [impacket-mssqlclient](https://github.com/5h1n6o/Security-Tools/blob/main/impacket/mssqlclient.md)

---

### ✉️ メール（SMTP / IMAP）
- [smtp-user-enum](https://github.com/5h1n6o/Security-Tools/blob/main/smtp-user-enum/README.md)
- [swaks](https://github.com/5h1n6o/Security-Tools/blob/main/swaks/README.md)

---

### 📡 SNMP
- [snmpwalk](https://github.com/5h1n6o/Security-Tools/blob/main/snmpwalk/README.md)

---

### 🛰 内部 Web
- curl  
- ffuf  
- proxychains（Pivot後）

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
