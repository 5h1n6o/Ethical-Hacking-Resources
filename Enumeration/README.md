# Enumeration（外部サービスの詳細調査）

Enumeration は、Reconnaissance で見つけたサービスを **深掘りし、攻撃可能なポイントを特定するフェーズ**です。

Boot2Root テンプレートの **Enumeration 章の詳細版**として機能します。

---

# 🎯 目的

- Recon で見つけたサービスを詳細に分析する  
- Web / SMB / FTP / SSH / DB などの内部構造を把握する  
- 脆弱性の有無を確認する  
- 初期侵入（Initial Access）につながる突破口を見つける  
- OSCP レポートで必要な「攻撃の根拠」を整理する  

---

# 📘 目次

1. Web Enumeration  
2. SMB Enumeration  
3. FTP Enumeration  
4. SSH Enumeration  
5. Database Enumeration  
6. Service-Specific Enumeration  
7. Vulnerability Enumeration  
8. Attack Surface Confirmation  
9. Boot2Root との連携

---

# 1. Web Enumeration

Web は最も突破口が多いため、最優先で深掘りする。

## 1.1 HTTP Header / Banner
```
curl -I http://<TARGET>
whatweb <TARGET>
```

### 確認ポイント
- Server（Apache / nginx / IIS）  
- X-Powered-By（PHP / ASP.NET）  
- リダイレクト先（admin / login）  

---

## 1.2 Directory / File Enumeration
```
ffuf -u http://<TARGET>/FUZZ -w common.txt -e php,txt,bak,old
dirsearch -u http://<TARGET>
```

### 確認ポイント
- 隠しディレクトリ  
- バックアップファイル  
- 管理画面  
- API エンドポイント  

---

## 1.3 Web Application Enumeration
```
nikto -h http://<TARGET>
```

### 確認ポイント
- 古い CMS  
- 既知の脆弱性  
- 危険な設定  

---

## 1.4 JavaScript / API Enumeration
```
curl http://<TARGET>/app.js
```

### 確認ポイント
- 隠し API  
- 認証ロジック  
- 内部 URL  

---

# 2. SMB Enumeration

```
smbclient -N -L //<TARGET>/
smbclient //<TARGET>/<SHARE>
```

### 確認ポイント
- anonymous アクセス  
- 認証情報（.txt / .conf / .ini）  
- バックアップファイル  
- Web ソースコード  

---

# 3. FTP Enumeration

```
ftp <TARGET>
```

### 確認ポイント
- anonymous  
- 書き込み可能か  
- Web ソースコード  
- 設定ファイル  

---

# 4. SSH Enumeration

```
ssh -v user@<TARGET>
```

### 確認ポイント
- バナー情報  
- OS / バージョン  
- ユーザー名の推測  
- 公開鍵の有無  

---

# 5. Database Enumeration

## 5.1 MySQL
```
mysql -h <TARGET> -u root -p
```

### 確認ポイント
- 弱パスワード  
- ユーザー情報  
- Web アプリの DB  

---

## 5.2 PostgreSQL
```
psql -h <TARGET> -U postgres
```

### 確認ポイント
- 認証情報  
- テーブル構造  
- 内部サービスの情報  

---

# 6. Service-Specific Enumeration

## 6.1 Redis
```
redis-cli -h <TARGET>
```

### 確認ポイント
- 未認証アクセス  
- CONFIG GET dir  
- SSH key 書き込み可能か  

---

## 6.2 RDP / VNC
```
nmap -p 3389 --script rdp-enum-encryption <TARGET>
```

---

## 6.3 SNMP
```
snmpwalk -v2c -c public <TARGET>
```

---

# 7. Vulnerability Enumeration

## 7.1 searchsploit
```
searchsploit apache 2.4
searchsploit openssl
```

## 7.2 Nmap vuln scripts
```
nmap --script vuln <TARGET>
```

---

# 8. Attack Surface Confirmation

Enumeration の結果から、初期侵入の方向性を決定する。

### 例：
- Web → SQLi / RCE / SSRF  
- SMB → 認証情報 → SSH / Web  
- FTP → WebShell アップロード  
- DB → 弱パスワード → 横展開  
- Redis → SSH key 書き込み  
- 内部 Web → Pivot 必須  

---

# 9. Boot2Root との連携

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

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Enumeration に集約します。

---

# 🎯 この章の目的

- Enumeration の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
