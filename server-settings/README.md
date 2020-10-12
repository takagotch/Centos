###### 自宅サーバー CentOS8
---
https://centossrv.com/

```
```

```
```

```
```

```.sh
// easy centos8 settings server

sudo dnf -y update
sudo dnf -y install epel-release
sudo dnf repolist
sudo dnf -y gropinstall Xcfe
vi /etc/slinux/config
+ SELINUX = disabled
sudo hostnamectl set-hostname tky.local
sudo /sbin/sysctl -w net.ipv4.ip_forward=1
vi /etc/ssh/sshd_config
+ PermitRootLogin no
+ PermitEmptyPasswords no
vi /etc/gdm/custom.conf
+ TimedLoginEnable=true
+ TimedLogin=username
+ TimedLoginDelay=3
sudo reboot
```

```
```

