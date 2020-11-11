
###### https://centossrv.com/openssh.shtml






```
yum -y install telnet-server
chkconfig telnet on
/etc/rc.d/init.d/xinetd restart
// https://centossrv.com/teraterm-private.shtml
// IPaddress
// telnet
// OK
centos   // user name
password // passward
su -
password

// uninstall
vi /etc/rc.d/init.d/ssh stop
yum -y remove openssh

// install
yum -y install pam-devel
wget http://ftp.jaist.ac.jp/pub/OpenBSD/OpenSSH/portable/openssh-5.3p1.tar.gz
tar zxvf openssh-5.3p1.tar.gz
vi openssh-5.3p1/contrib/redhat/openssh.spec

```

```
```

```
```

