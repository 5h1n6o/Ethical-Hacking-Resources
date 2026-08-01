# Lateral Movement（横展開）

Lateral Movement は、内部ネットワークの別ホストへ  
**認証情報・Pivot・内部サービスを利用して侵入するフェーズ**です。

Boot2Root テンプレートの **Lateral Movement 章の詳細版**として機能します。

---

# 🎯 目的

- 内部ネットワークの別ホストへ侵入する  
- Credential Access で得た認証情報を利用する  
- Pivot を使って内部サービスへアクセスする  
- 内部ホストの PrivEsc を行い、最終的に root / SYSTEM を取得する  
- OSCP レポートで必要な「横展開の根拠」を整理する  

---

# 📘 目次

1. SSH 横展開  
2. SMB 横展開  
3. RDP / VNC 横展開  
4. 内部 Web / API からの横展開  
5. 内部 DB からの横展開  
6. 内部サービスの悪用  
7. Pivot と組み合わせた横展開  
8. 横展開後の PrivEsc  
9. Boot2Root との連携

---

# 1. SSH 横展開（最も一般的）

Credential Access で取得した SSH鍵・パスワードを利用する。

## SSH鍵で横展開
```
ssh -i id_rsa user@192.168.1.50
```

## パスワードで横展開
```
ssh user@192.168.1.50
```

### 確認ポイント
- 同じパスワードを使い回している  
- authorized_keys に他ユーザーの鍵がある  
- known_hosts に内部ホストの情報がある  

---

# 2. SMB 横展開

```
smbclient -U user //<TARGET>/share
```

### よくある突破口
- SMB に認証情報が保存されている  
- Web ソースコード → DB 認証情報 → SSH  
- バックアップファイル → パスワード漏洩  

---

# 3. RDP / VNC 横展開（Windows）

## RDP
```
xfreerdp /u:user /p:pass /v:192.168.1.60
```

## VNC
```
vncviewer 192.168.1.60
```

### 確認ポイント
- 弱パスワード  
- 再利用パスワード  
- 管理者アカウントの存在  

---

# 4. 内部 Web / API からの横展開

Pivot で内部 Web にアクセスし、  
管理画面や API を利用して横展開する。

### 例：内部 Web 管理画面
```
http://127.0.0.1:8080/admin
```

### よくある突破口
- 管理者ログイン  
- RCE（Command Injection）  
- SSH鍵のダウンロード  
- DB 認証情報の漏洩  

---

# 5. 内部 DB からの横展開

## MySQL
```
mysql -h 192.168.1.60 -u admin -p
```

## PostgreSQL
```
psql -h 192.168.1.60 -U postgres
```

### よくある突破口
- ユーザー情報 → パスワード再利用  
- SSH パスワードが DB に保存されている  
- Web 管理者パスワード → RCE  

---

# 6. 内部サービスの悪用

### Redis
```
redis-cli -h 192.168.1.70
```

- 未認証アクセス  
- SSH authorized_keys 書き込み  

### Jenkins / Tomcat / Webmin
内部管理ツールは横展開の宝庫。

---

# 7. Pivot と組み合わせた横展開

Pivot（SSH / Chisel / Ligolo-ng）で内部サービスへアクセスし、  
そこから横展開する。

### 例：Pivot → 内部 Web → RCE → SSH鍵取得 → 横展開

```
ssh -L 8080:127.0.0.1:8080 user@pivot
curl http://127.0.0.1:8080/admin
```

---

# 8. 横展開後の PrivEsc

横展開したホストでも必ず以下を行う：

```
whoami
id
hostname
sudo -l
ss -tulnp
```

### 目的
- 新しい PrivEsc の突破口を探す  
- 内部ネットワークのさらに奥へ進む  
- 最終的に root / SYSTEM を取得する  

---

# 9. Boot2Root との連携

Boot2Root の Lateral Movement 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Pivot
↓
Lateral Movement
↓
PrivEsc（別ホスト）
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Lateral Movement に集約します。

---

# 🎯 この章の目的

- Lateral Movement の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
