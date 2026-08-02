# Enumeration（外部サービスの詳細調査）

Enumeration は、Reconnaissance で見つけたサービスを **深掘りし、攻撃可能なポイントを特定するフェーズ**です。

---

## 🎯 目的

- Recon で見つけたサービスを詳細に分析する  
- Web / SMB / FTP / SSH / DB などの内部構造を把握する  
- 脆弱性の有無を確認する  
- 初期侵入（Initial Access）につながる突破口を見つける  

---

## 🔍 攻撃フロー
1. 対象サービスの特定（Recon の結果を基に）
2. サービスごとの詳細調査（プロトコル・バージョン・設定）
3. 脆弱性の有無を確認（NSE / スクリプト / 手動検証）
4. 認証情報の探索（弱パスワード・デフォルト設定）
5. Web / SMB / FTP / DB などの個別列挙
6. 初期侵入につながるポイントを抽出

---

## 🧭 Attack Surface Deep Dive（攻撃面の深掘り）
Recon で特定した Attack Surface を、  
サービス単位でさらに詳細に調査する。

- **Web**：ディレクトリ列挙、技術スタック、認証方式  
- **SMB**：共有一覧、匿名アクセス、権限  
- **FTP**：匿名ログイン、書き込み可否  
- **SSH**：バージョン、脆弱な暗号化方式  
- **DB（MySQL / PostgreSQL）**：弱パスワード、権限  
- **メール（SMTP / IMAP）**：VRFY / EXPN  
- **内部 Web**：Pivot 必須のサービス

※ Boot2Root の Writeup では実際の結果を記録し、  
Pentest-Playbook では「判断基準」を記述する。

---

## 🛠 代表コマンド（最低限）

- [Web Enumeration](#web-enumeration)  
- [SMB Enumeration](#smb-enumeration)  
- [FTP Enumeration](#ftp-enumeration)  
- [SSH Enumeration](#ssh-enumeration)  
- [Database Enumeration](#database-enumeration)  
- [Service-Specific Enumeration](#service-specific-enumeration)  
- [Vulnerability Research](#vulnerability-research)  


---

## Web Enumeration

Web は最も突破口が多いため、最優先で深掘りする。

### HTTP Header / Banner
```
curl -I http://<TARGET>
whatweb <TARGET>
```

#### 確認ポイント
- Server（Apache / nginx / IIS）  
- X-Powered-By（PHP / ASP.NET）  
- リダイレクト先（admin / login）  

---

### Directory / File Enumeration
```
ffuf -u http://<TARGET>/FUZZ -w common.txt -e php,txt,bak,old
dirsearch -u http://<TARGET>
```

#### 確認ポイント
- 隠しディレクトリ  
- バックアップファイル  
- 管理画面  
- API エンドポイント  

---

### Web Application Enumeration
```
nikto -h http://<TARGET>
```

#### 確認ポイント
- 古い CMS  
- 既知の脆弱性  
- 危険な設定  

---

### JavaScript / API Enumeration
```
curl http://<TARGET>/app.js
```

#### 確認ポイント
- 隠し API  
- 認証ロジック  
- 内部 URL  

---

## SMB Enumeration

```
smbclient -N -L //<TARGET>/
smbclient //<TARGET>/<SHARE>
```

#### 確認ポイント
- anonymous アクセス  
- 認証情報（.txt / .conf / .ini）  
- バックアップファイル  
- Web ソースコード  

---

## FTP Enumeration

```
ftp <TARGET>
```

#### 確認ポイント
- anonymous  
- 書き込み可能か  
- Web ソースコード  
- 設定ファイル  

---

## SSH Enumeration

```
ssh -v user@<TARGET>
```

#### 確認ポイント
- バナー情報  
- OS / バージョン  
- ユーザー名の推測  
- 公開鍵の有無  

---

## Database Enumeration

### MySQL
```
mysql -h <TARGET> -u root -p
```

#### 確認ポイント
- 弱パスワード  
- ユーザー情報  
- Web アプリの DB  

---

### PostgreSQL
```
psql -h <TARGET> -U postgres
```

#### 確認ポイント
- 認証情報  
- テーブル構造  
- 内部サービスの情報  

---

## Service-Specific Enumeration

### Redis
```
redis-cli -h <TARGET>
```

#### 確認ポイント
- 未認証アクセス  
- CONFIG GET dir  
- SSH key 書き込み可能か  

---

### RDP / VNC
```
nmap -p 3389 --script rdp-enum-encryption <TARGET>
```

---

### SNMP
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
