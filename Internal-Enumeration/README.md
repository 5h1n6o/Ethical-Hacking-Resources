# Internal Enumeration（内部ネットワーク探索）

Internal Enumeration は、初期侵入後に **内部ネットワークの構造・サービス・ホストを探索し、横展開や Pivot の突破口を見つけるフェーズ**です。

Boot2Root テンプレートの **Internal Enumeration 章の詳細版**として機能します。

---

# 🎯 目的

- 内部ネットワークの構造を把握する  
- 内部サービス（Web / DB / API / 管理ツール）を発見する  
- 他ホストへの横展開の突破口を見つける  
- Pivot / Port Forward の必要性を判断する  
- OSCP レポートで必要な「内部調査の根拠」を整理する  

---

# 📘 目次

1. ネットワークインターフェースの確認  
2. ルーティング情報の確認  
3. 内部サービスの確認  
4. 内部ホストの探索  
5. 内部 Web / API の探索  
6. 内部 DB / Redis / メッセージキュー  
7. 認証情報を使った内部アクセス  
8. Pivot / Port Forward の判断  
9. Boot2Root との連携

---

# 1. ネットワークインターフェースの確認

```
ip a
ifconfig
```

### 確認ポイント
- 内部ネットワーク（10.x / 172.16.x / 192.168.x）  
- 複数 NIC（eth0 / eth1 / ens33 など）  
- VPN / Docker / LXC の仮想 NIC  

---

# 2. ルーティング情報の確認

```
ip route
route -n
```

### 確認ポイント
- 内部ネットワークの存在  
- 複数のサブネット  
- ゲートウェイの位置  
- Pivot の必要性  

---

# 3. 内部サービスの確認

```
ss -tulnp
netstat -tulnp
lsof -i
```

### よく見つかる内部サービス
- 内部 Web（8080 / 8000 / 5000）  
- DB（3306 / 5432）  
- Redis（6379）  
- 管理ツール（Webmin / Jenkins / Tomcat）  

---

# 4. 内部ホストの探索

## ARP
```
arp -a
```

## Ping Sweep（内部ネットワーク）
```
for i in {1..254}; do ping -c 1 192.168.1.$i; done
```

## nmap（内部ネットワーク）
```
nmap -sV 192.168.1.0/24
```

### 確認ポイント
- 内部ホストの存在  
- 管理サーバ  
- DBサーバ  
- 横展開の候補  

---

# 5. 内部 Web / API の探索

```
curl http://127.0.0.1:8080
curl http://127.0.0.1:8000
curl http://127.0.0.1:5000
```

### 確認ポイント
- 管理画面  
- API エンドポイント  
- 認証バイパス  
- 内部専用サービス  

---

# 6. 内部 DB / Redis / メッセージキュー

## MySQL
```
mysql -h 127.0.0.1 -u root -p
```

## PostgreSQL
```
psql -h 127.0.0.1 -U postgres
```

## Redis
```
redis-cli -h 127.0.0.1
```

### 確認ポイント
- 認証情報  
- 内部データ  
- SSH鍵書き込みの可能性  

---

# 7. 認証情報を使った内部アクセス

Credential Access の結果を利用する。

### 例：SSH鍵で内部ホストへ横展開
```
ssh -i id_rsa user@192.168.1.50
```

### 例：DB 認証情報で内部 DB へアクセス
```
mysql -h 192.168.1.60 -u admin -p
```

---

# 8. Pivot / Port Forward の判断

内部サービスが外部からアクセスできない場合、  
Pivot / Port Forward が必要になる。

### よくあるケース
- 内部 Web（8080 / 8000 / 5000）  
- 内部 DB（3306 / 5432）  
- 内部 API  
- 内部管理ツール  

### Pivot の例（SSH）
```
ssh -L 8080:127.0.0.1:8080 user@target
```

---

# 9. Boot2Root との連携

Boot2Root の Internal Enumeration 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Credential Access
↓
Internal Enumeration
↓
Pivot / Lateral Movement
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Internal Enumeration に集約します。

---

# 🎯 この章の目的

- Internal Enumeration の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
