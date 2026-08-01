# Local Enumeration（侵入後のローカル調査）

Local Enumeration は、初期侵入後に **ローカル環境の情報を収集し、権限昇格や横展開の突破口を探すフェーズ**です。

Boot2Root テンプレートの **Local Enumeration 章の詳細版**として機能します。

---

# 🎯 目的

- 現在の権限・ユーザー情報を把握する  
- OS / カーネル / パッケージ情報を収集する  
- 実行中プロセス・サービスを確認する  
- 認証情報（パスワード・鍵・トークン）を探索する  
- 内部ネットワークの存在を確認する  
- 権限昇格（PrivEsc）や横展開の突破口を見つける  
- OSCP レポートで必要な「侵入後の根拠」を整理する  

---

# 📘 目次

1. 基本情報（whoami / id / hostname）  
2. OS / カーネル情報  
3. ユーザー・グループ情報  
4. ファイル・ディレクトリ調査  
5. プロセス・サービス調査  
6. ネットワーク調査  
7. 認証情報の探索  
8. Sudo 調査  
9. Cron / Timer 調査  
10. Capability / SUID / SGID 調査  
11. コンテナ環境の調査  
12. Boot2Root との連携

---

# 1. 基本情報

```
whoami
id
hostname
pwd
```

### 確認ポイント
- 現在の権限  
- 所属グループ  
- ホスト名（内部ネットワークのヒント）  

---

# 2. OS / カーネル情報

```
uname -a
cat /etc/os-release
lsb_release -a
```

### 確認ポイント
- カーネルの脆弱性（DirtyCow / DirtyPipe など）  
- OS の種類（Ubuntu / CentOS / Debian）  

---

# 3. ユーザー・グループ情報

```
cat /etc/passwd
cat /etc/group
last
```

### 確認ポイント
- ログイン可能ユーザー  
- 管理者グループ  
- 横展開の候補ユーザー  

---

# 4. ファイル・ディレクトリ調査

```
ls -la
find / -type f -name "*.conf" 2>/dev/null
find / -type f -name "*.txt" 2>/dev/null
find / -type f -name "*.log" 2>/dev/null
```

### 確認ポイント
- 認証情報（DB / API / SSH）  
- バックアップファイル  
- Web ソースコード  
- ログファイル  

---

# 5. プロセス・サービス調査

```
ps aux
ps -ef
systemctl list-units --type=service
```

### 確認ポイント
- root 権限で動いているサービス  
- 脆弱なサービス  
- 内部 Web / DB / API  

---

# 6. ネットワーク調査

```
ip a
ip route
ss -tulnp
netstat -tulnp
```

### 確認ポイント
- 内部サービス（8080 / 8000 / 5000 など）  
- DB（3306 / 5432）  
- Redis（6379）  
- Pivot / Port Forward の候補  

---

# 7. 認証情報の探索

```
grep -Ri "password" /
grep -Ri "pass" /
grep -Ri "token" /
grep -Ri "secret" /
```

### 確認ポイント
- DB 認証情報  
- APIキー  
- SSH鍵  
- Web アプリの設定ファイル  

---

# 8. Sudo 調査

```
sudo -l
```

### 確認ポイント
- パスワード不要の sudo  
- 特定コマンドの sudo 実行  
- 権限昇格の突破口  

---

# 9. Cron / Timer 調査

```
crontab -l
ls -la /etc/cron*
systemctl list-timers
```

### 確認ポイント
- 書き込み可能な cron  
- root 実行のスクリプト  
- PrivEsc の候補  

---

# 10. Capability / SUID / SGID 調査

## SUID
```
find / -perm -4000 -type f 2>/dev/null
```

## Capability
```
getcap -r / 2>/dev/null
```

### 確認ポイント
- SUID バイナリ（python / bash / nmap）  
- Capabilities（cap_setuid など）  
- PrivEsc の突破口  

---

# 11. コンテナ環境の調査

```
cat /proc/1/cgroup
docker ps
```

### 確認ポイント
- コンテナ内かどうか  
- ホストへの脱出可能性  
- 内部ネットワークの存在  

---

# 12. Boot2Root との連携

Boot2Root の Local Enumeration 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Initial Access
↓
Local Enumeration
↓
Privilege Escalation
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Local Enumeration に集約します。

---

# 🎯 この章の目的

- Local Enumeration の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
