# Credential Access（認証情報探索）

Credential Access は、侵入後に **パスワード・鍵・トークン・Cookie・APIキーなどの認証情報を収集するフェーズ**です。

Boot2Root テンプレートの **Credential Access 章の詳細版**として機能します。

---

# 🎯 目的

- OS / アプリケーション / DB / API の認証情報を収集する  
- 横展開（Lateral Movement）の突破口を見つける  
- PrivEsc（権限昇格）に必要な情報を取得する  
- 内部ネットワークの他ホストへ侵入する  
- OSCP レポートで必要な「認証情報の根拠」を整理する  

---

# 📘 目次

1. パスワード探索  
2. 設定ファイルからの認証情報取得  
3. SSH / GPG / 秘密鍵の探索  
4. Web アプリケーションの認証情報  
5. データベースの認証情報  
6. メモリ・プロセスからの認証情報  
7. ブラウザ・Cookie・Token  
8. キャッシュ・ログからの認証情報  
9. 横展開（Lateral Movement）への利用  
10. Boot2Root との連携

---

# 1. パスワード探索

```
grep -Ri "password" /
grep -Ri "pass" /
grep -Ri "pwd" /
grep -Ri "token" /
grep -Ri "secret" /
```

### よく見つかる場所
- `/etc/passwd`（ユーザー一覧）  
- `/etc/shadow`（ハッシュ）  
- `/etc/mysql/my.cnf`  
- `/var/www/html/config.php`  
- `.env` ファイル  
- `.bash_history`  

---

# 2. 設定ファイルからの認証情報取得

```
find / -type f -name "*.conf" 2>/dev/null
find / -type f -name "*.ini" 2>/dev/null
find / -type f -name "*.json" 2>/dev/null
```

### よくある突破口
- DB 認証情報  
- APIキー  
- SMTP 認証情報  
- Web アプリの管理者パスワード  

---

# 3. SSH / GPG / 秘密鍵の探索

```
ls -la ~/.ssh
cat ~/.ssh/id_rsa
```

### 確認ポイント
- id_rsa（秘密鍵）  
- authorized_keys  
- known_hosts  
- SSH config（内部ホストの情報）  

### 横展開の例
```
ssh -i id_rsa user@internal-host
```

---

# 4. Web アプリケーションの認証情報

```
cat /var/www/html/*.php
cat /var/www/html/config/*
```

### よくある突破口
- DB 認証情報  
- 管理者パスワード  
- APIキー  
- JWT Secret  

---

# 5. データベースの認証情報

## MySQL
```
mysql -u root -p
select user, host, authentication_string from mysql.user;
```

## PostgreSQL
```
psql -U postgres
```

### 確認ポイント
- 弱パスワード  
- Web アプリのユーザー情報  
- OS ユーザーと同じパスワード  

---

# 6. メモリ・プロセスからの認証情報

```
ps aux
strings /proc/<PID>/mem
```

### よくある突破口
- 実行中プロセスの環境変数  
- DB パスワード  
- APIキー  

---

# 7. ブラウザ・Cookie・Token

```
ls -la ~/.mozilla
ls -la ~/.config/google-chrome
```

### 確認ポイント
- Cookie  
- セッション情報  
- JWT  
- OAuth Token  

---

# 8. キャッシュ・ログからの認証情報

```
find /var/log -type f
grep -Ri "password" /var/log
```

### よくある突破口
- ログに残った認証情報  
- バックアップファイル  
- 過去のセッション情報  

---

# 9. 横展開（Lateral Movement）への利用

Credential Access の結果は横展開に直結する。

### よくある横展開の流れ
- SSH鍵 → 内部ホストへ侵入  
- DB 認証情報 → 他サービスへログイン  
- Web 管理者パスワード → RCE  
- APIキー → 内部 API へアクセス  
- Cookie → セッションハイジャック  

---

# 10. Boot2Root との連携

Boot2Root の Credential Access 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Privilege Escalation
↓
Credential Access
↓
Internal Enumeration / Pivot / Lateral Movement
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Credential Access に集約します。

---

# 🎯 この章の目的

- Credential Access の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
