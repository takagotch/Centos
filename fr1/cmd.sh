// HTTP
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

// vsftpd.service FTP
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload

mkdir /var/ftp/incoming
chown ftp /var/incoming
semanage fcontext -a -t public_content_rw_t "/var/ftp/ubcoming(/.*)?"
restorecon -R /var/ftp/incoming

firewall-cmd --permanent --add-service=dns
firewall-cmd --reload

named-checkconf -z
named-checkconf -z
systemctl reload named.service
systemctl restart named-chroot.service
systemctl reload named-chroot.service

named-compilezone -f raw -F text -o /tmp/nscg.jp.db.nscg.jp. nscg.jp.db

dnssec-keygen -a hmac-md5 -b 128 -n HOST master-slave
grep Key Kmaster-slave.+157+12840.private

chown -R named:named /var/named/dynamic/
restorecon -R /var/named/dynamic/

dnssec-keygen -r /dev/random -a RSASHA256 -b 1024 -n zone nscg.jp

dnssec-keygen -r /dev/random -f KSK -a RSASHA256 -b 2048 -n ZONE nscg.jp


cd /var/named
dnssec-signzone -o necg.jp necg.jp.db
dnssec-signzone -K /home/admin/work/dns -o nsag.jp necg.jp.db

dig +dnssec nscg.jp.

//
rndc reload nscg.jp
rndc retransfer nscg.jp
rndc stats
rndc status

named-checkconf /etc/named.conf

cd /var/named
named-checkzone nscg.jp nscg.jp.db

host ns1.nscg.jp. 127.0.0.1
host 192.168.7.2 127.0.0.1
host 2991:db8::2 127.0.0.1

dig @127.0.0.1 ns1.nscg.jp a in

server 127.0.0.1
update add new.nscg.jp. 600 IN A 192.168.7.29
update delete new.nscg.jp. IN A



unbound-checkconf
unbound-control reload

firewall-cmd --permanent --add-service=dns
firewall-cmd --reload


host www.google.com. 192.168.7.3

firewall-cmd --permanent --add-service-dhcp
firewall-cmd --reload

cp /usr/lib/systemd/system/shcpd.service /etc/systemd/system/

systemctl --system daemon-reload

dhcpd -t -cf /etc/dhcp/dhcpd.conf
dhcp -t -cf /etc/dchp/dhcpd.conf

firewall-cmd --permanet --add=service=dhcpv6
firewall-cmd --reload

cp /usr/lib/systemd/system/dhcp6.service /etc/systemd/system/
systemctl --system daemon-reload

dhcpd -6 -t -cf /etc/dhcp/dhcp6.conf

cp /usr/lib/systemd/system/dhcrelay.service /etc/systemd/system/

systemctl --system daemon-reload

cp /usr/lib/systemd/system/shcrelay.service /etc/systemd/system/dhcrelay6.service

systemctl --system daemon-reload

firewall-cmd --permanent --add-service=ldap
firewall-cmd --reload

cp /usr/share/openldap=servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

systemctl start slapd.service

systemctl status slapd.service
ldapsearch -LLL -y EXTERNAL -H ldapi:/// -b 'olcDatabase={2}hdb,cn=config'

slappasswd

ldapmodify -Y EXTERNAL -H ldapi:/// -f hdb-init.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/opendap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif

ldapadd -x -D "cn=Manager,dc=nscg,dc=ip" -W -f init.ldif

ldapsearh -x -LLL -b "dc=nscg,dc=jp" "{objectClass=*}"

ldapadd -x -D "cn=Manager,dc=nscg,dc=jp" -W -f user.ldif

ldapdelete -x -D "cn=Manager,dc=nesc,dc=jp" -W "uid=user03,ou=People,dc=nscg,dc=jp"

ldapmodify -x -D "cn=Manager,dc=nscg,dc=jp" -W -f modify01.ldif

ldapsearch -x -LLL "dc=nscg,dc=jp" "(uid=user02)" gecos description

ldapmodify -x -D "cn=Manager,dc=nscg,dc=jp" -W -f modify02.ldif
ldapsearch -x -LLL -b "dc=nscg,dc=jp" "(uid=user02)" descriptions
ldapmodify -x -D "cn=Manager,dc=nscg,dc=jp" -W -f modify03.ldif

ldapsearch -x -LLL -b "dc=nscg,dc=jp" "(uid=user02)" gecos

ldapmodify -x -D "cn=Manager,dc=nscg,dc=jp" -W -f modify04.ldif
ldapsearch -x -LLL "dc=nscg,dc=jp" "(uid=user02)" gecos description homeDirectory

ldapmodify -Y EXTERNAL -H ldapi:/// -f config-rootdn.ldif
ldapsearch -x -LLL -D 'cn=admin,cn=config' -b 'cn=config' cn=config-W

ldapmodify -Y EXTERNAL -H ldap1:/// -f config-tls.ldif
ldapsearch -x -LLL 'cn=config' -D 'cn=admin,cn=config' cn=config -W -Z

ldapsearch -x -LLL -b 'cn=config' -D 'cn=admin,cn=config' cn=config -W -Z

ldapsearch -x -LLL -b 'cn=config' -D 'ch=admin,cn=config' cn=config -W -H ldap://centos7.nscg.jp

authconfig --update --enabledap --enabledapauth

mkdir /home/user01
su - user01

authconfig --config --enalbessd --enablessdauth

mkdir /home/user01
su - user01

ldapmodify -Y EXTERNAL -H ldapi:/// -f access.ldif
ldapsearch -x -LLL "dc=nscg,dc=jp" "(uid=user01)"
ldapsearch -x -LLL "dc=nscg, dc=jp" "(uid=user01)"

ldapadd -x -D "cn=Manager,dc=nscg,dc=jp" -W -f admin.ldif
ldapsearch -x -LLL -b "dc=nscg,dc=jp" "{uid=user01}" userPassword
ldapsearch -x -LLL -b "dc=nscg,dc=jp" -D "cn=Admin,dc=nscg,dc=jp" -W "(uid=user01)" userPassword

ldapmodify -x -D cn=admin,cn=config -f loglevel.ldif -W

ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -b "cn=schema,cn=config" "(objectClass=olcSchemaConfig)" dn

mkdir /tmp/work
mkdir /tmp/work/slapd.d

cd /tmp/work
slaptest -f autofs.config -F ./slapd.d
slaptest -f autofs.config -F ./slapd.d
ls slapd.d/cn=config/cn=schema/
cp slapd.d/cn=config/cn=schema/cn=\{1\}autofs.ldif authfs.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f syncprov-module.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f syncprov.ldif

ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -b "olcDatabase={2}hdb,cn=config" olcDbIndex

ldapmodify -Y EXTERNAL -H ldapi:/// -f index.ldif

cd /var/lib/ldap
db_stat -m

cd /var/lib/ldap
db_stat -t

firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload

mkdir /export/home
mkdir /export/local
mount --bind /home /export/home
mount --bind /usr/local /export/local

mkdir /nfs
mount -t nfe4 nfssv:/ /nfs
ls /nfs
df

exportfs -av
exportfs -v

sbowmount -e
exportfs -u 192.168.0.0/24:/export
exportfs -v

showmount
showmount -d

shouwmount -a

mount -t nfs -o nfsvers=3 nfssv:/export/home /nfs/home
mount -t nfs4 nfssv:/ /nfs
unmount /nfs/home

systemctl list-units --type=mount

cd /nfs/home/
ls -l

cd kawamura
touch memo.txt
ls -l memo.txt
nfs4_getfactl memo.txt

nfs4_setfacl -a A::OWNER@:x memo.txt
nfs4_getfacl_memo.txt


firewall-cmd --permanent --add-service=samba
firewall-cmd --permanent --add-service=samba-client
firewall-cmd --reload

testparm -sv

ls -Z /export/
chcon -t samba_share_t export/public
ls -Z /ecport/

useradd takagotch
useradd -s /sbin/nologin kawamura

pdbedit -a -u takagotch
pdbedit -Lw
pdedit -x -u takagotch
pdbedit -l smbpasswd:/etc/smbpasswd.old
pdbedit -e tdbsam:/bar/lib/samba/private/passwd.backup
pdbedit -i smbpasswd:/etc/smbpasswd -e tdbsam:/var/lib/samba/private/tdbeam.tdb

pdbedit -a -u root
net rpc user
net rpc user add takagotch
net rpc user delete takagotch
net rpc user password takagotch

smbpasswd takagotch
net rpc password takagotch

smbpasswd

net rpc join member -U Adminstrator
net rap domain

smbpasswd -r NTPDC -U takagotch

cp /usr/bin/smbclient /var/lib/samba/scripts/
ls -ldZ /var/lib/samba/scripts/smbclient

groupadd smbshare
mkdir /opt/samba/usersshares
chgrp smbshare /opt/samba/usershares
chmod 1770 /opt/samba/usershares

net usershare add project /opt/samba/usershares
net usershare delete project
net usershare list wildcard-sharename
net usershare info wildcard-sharename

setsebool samba_enable_home_dirs on

testparm /etc/samba/smb.conf

testparm /etc/samba/smb.conf cobra 192.168.0.49
sudo smbstatus
sudo smbcontrol smbd debug 10
smbclient -L 192.168.0.4
smbclient -U takagotch //anaconda/homes

mkdir -p /smb/public
mount -t cifs //anaconda/public /smb/public -o user=smbguest.guest.rw
umount /smb/public

firewall-cmd ==permanent --add-rich-rule='rule family=ipv4 source address="192.168.0.0./16" service name=ntp accept'
firewall-cmd --reload

chronyc sources

chronyc -h 192.168.7.2 sources

firewall-cmd --permanent --add-port=3128/tcp
firewall-cmd --reload

squidclient http://www.google.co.jp/

setsebool -P squid_use_tproxy on

firewall-cmd --permanent --zone=internal --add-port=3128/tcp
firewall-cmd --permanent --direct --add-rule ipv4 nat PREROUTING O -i enp0s8 -p tcp
firewall-cmd --reload

squid -z

firewall-cmd --permanent --add-service=postgresql
firewall-cmd --reload

su - postgres
initdb -E utf8 -D /var/lib/pgsql/data

su - postgres
psql -h 192.168.7.3
\l
\q

firewall-cmd --permanent --add-service=mysql
firewall-cmd --reload

mysqladmin -u root password 'admin'
mysqladmin -p -u root -h localhost password 'admin'

mysql -u root -p mysql
CREATE USER testuser@centos7g.nscg.jp IDENTIFIED BY 'test';
\q

firewall-cmd --permanent --add-rich-rule='rule family=ipv4 port port=11211 protocol="tcp" source address="192.168.7.1" accept'
firewall-cmd --reload

telnet 127.0.0.1 11211
set test 0 0 5
abcde
get test
delete test
quit

grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl set-default multi-user.target

cd /etc/systemd/system
cp /usr/lib/system/system/vnserver@.service vnserver@:0.service

systemctl daemon-reload

firewall-cmd --permanent --add-service=vnc-server
ifrewall-cmd --reload
vncpasswd

firewall-cmd --permanet -add-service=pmcd
firewall-cmd --reload

pminfo -h 192.168.7.3
pminfo -t -h 192.168.7.3
pminfo -t -h 192.168.7.3 swap
pmval -h 192.168.7.3 -s 5 network.interface.total.bytes
pmval -h 192.168.7.3 -s 5 -i enp0s3 network.interface.total bytes
pmatop -h 192.168.7.3.5

systemctl NetworkManager restart

nmcli n off
nmcli n c
nmcli n on
nmcli n on
nmcli n c
nmcli g ho
nmcli g ho anaconda.nscg.jp
hostname
hostnamectl
nmcli d
nmcli --fields TYPE d

nmcli d show enp0s5
nmcli c
nmcli c show enp0s5
nmcli --field ipv4 c show enp0s5
nmcli c a type ehternet con-name enp0s8 ifname enp0s8

nmcli c m enp0s ipv4.method auto
nmcli c m enp0s3 ipv4.addresses ""
nmcli c m enp0s3 ipv4.dns "" ipv4.dns-search ""

nmcli c m enp0s3 ipv4.method manual
nmcli c m enp0s3 ipv4.addresses "192.168.108.3/24 192.168.108.2"
nmcli c m enp0s3 ipv4.dns "192.168.108.1 192.168.108.2"
nmcli c m enp0s3 ipv4.dns-search "nscg.jp"

nmcli c m enp0s3 ipv4.routes "192.168.111.0/24 192.168.108.1"

nmcli c m enp0s3 +ipv4.dns "192.168.108.3"
nmcli c m enp0s3 -ipv4.dns 1
nmcli c d enp0s3
nmcli c u enp0s3

nmcli c
nmcli c
nmcli c m bond0 ipv4.method manual ipv4.addresses "10.211.55.28/24 10.211.55.1"
nmcli c m bond0 ipv4.dns "10.211.55.1" ipv4.dns-search ""

nmcli c a type bond-slave autoconnect no iframe enp0s5 master bond0
nmcli c a type bond-slave autoconnect no ifname enp0s6 master bond0
nmcli c

nmcli c m enp0s5 connection.autoconnect no
nmcli c m bond-slave-enp0s5 connection.autoconnect yes
nmcli c m bond-slave-enp0s6 connection.autoconnect yes
systemctl restart network
nmcli c

ip addr show
cat /proc/net/bonding/bond0


ifenslave -c bond0 enp0s6
cat /prc/net/bonding/bond0

nmcli c
nmcli c a type team con-name team0 iframe team0
nmcli c

nmcli c m team0 ipv4.method manual ipv4.addresses "10.211.55.26/24.10.211.55.1"
nmcli c m team0 ipv4.dns "10.211.55.1 ipv4.dns-search"

nmcli c a type team-slave autoconnect no iframe enp0s5 master team0
nmcli c a type team-slave autoconnect no iframe enp0s6 master team0

nmcli c

nmcli c m enp0s5 connection.autoconnect no
nmcli c m team-slave-enp0s5 connection.autoconnect yes
nmcli c m enp0s6 connection.autoconnect no
nmcli c m team-slave-enp0s6 connection.autoconnect yes
sytemctl restart network
nmcli c

ip addr show
teamdctl team0 state

nmcli c a type bridge ifname br0
nmcli c a type bridge-slave ifname enp0s5 master bridge-br0
nmcli c m enp0s5 ipv4.addresses "" ipv4.dns "" ipv4.method disable

ip link show

ip -s link show
ip link set down dev enp0s5
ip address show
ip address add local 10.211.55.10/8 brd 10.255.255 dev enp0s5
ip address show dev enp0s5
ip address delete local 10.211.55.10/8 brd 10.255.255.255 dev enp0s5
ip address show dev enp0s5

ip route show
ip route add 10.211.59/24 via 10.211.55.1 dev enp0s5
ip route show

ip route get 10.211.59.4

ip route delete 10.211.59/24
ip route show

ip neigh show

ip neigh add to 10.211.55.2 dev enp0s5
ip neigh show

ss

ss -a
ss -ta

ping -c 10 192.168.1.1
traceroute router.nscg.jp
tracepath router.nscg.jp
rpcinfo -p
ifconfig

ifconfig enp0s5 down
ifconfig enp0s5 up

ifconfig enp0s5 inet 10.211.55.10 netmask 10.255.255.255

netstat -t -u
netstat -a -t -u | grep LISTEN

route

arp
arp -s 10.211.55.1 00:lc:42:00:00:18
arp -a

arp -d 192.168.1.1
arp -a

hostname -v

ls -l /lib/systemd/system/runlevel*.target
systemctl list-unit-files
systemctl list-unit-files -t service

systemctl disable postfix.service
systemctl enable postfix.service
systemctl is-enabled postfix.service

systemctl enable postfix

systemctl mask postfix.service
systemctl unmask postfix.service
systemctl stop postfix.service
systemctl start postfix.service
systemctl restart postfix.service
systemctl reload postfix.service
systemctl is-active postfix.service
systemctl status postfix.service

systemctl list-units

systemctl list-sockets
systemctl list-dependencies

firewall-cmd --permanent --add-port=514/top
firewall-cmd --permanent --add-port=514/udp
firewall-cmd --reload

logwatch --output stdout
logwatch --service postfix --output stdout

snmpget -v1 localhost -c public system.sysName.()
SNMPv2-MIB:sysName.O = STRING: centos7g

sumpgetnext -v1 localhost -c public system.sysName
snmpgetnext -v1 localhost -c public system.sysName.O

snmpwalk -v1 localhost -c public ucdavis.dskTable
dnmpdelta -v1 localhost -c public -Cp 10 interfaces.ifTable.ifEntry.iflnOctets.3

LANG=ja_JP.euc_JP mrtg /etc/mrtg/mrtg.cfg
LANG=ja_JP.encJP mrtg /etc/mrtg/mrtg.cfg

indexmaker /etc/mrtg/mrtg.cfg > /var/www/mrtg/index.html

firewall-cmd --permanent --add-service=amanda-client
firewall-cmd --reload

passwd amandabackup
chown amandabackup /etc/amanda

cp /usr/systemd/system/amanda.socket /etc/systemd/system/amanda-server.socket
cp /usr/lib/systemd/system/amanda@.service /etc/systemd/system/amanda-server@.service

systemctl --system daemon-reload

firewall-cmd --permanent --add=service=amanda-client
firewall-cmd -reload

chown amandabackup /etc/amanda

su amandabackup
mkdir /var/lib/amanda/vtapes/sample
restorecon /var/lib/amanda/vtapes/sample

su amandabackup
amserverconfig sample --template harddisk --mailto admin --dumpcycle 1week --runspercycle 7 --tapecycle 7 --runtapes 1 --tapedev /var/lib/amanda/vtapes/sample/

su amandabackup
amandaclient --config sample --client centos7g --diskdev /home --dumptype user-star -m

su amandabackup
amacheck weekly


su amandabackup
amdump sample

amrecover sample
listdisk

setdisk /home
ls
cd admin
ls

add comps.xml.org
add Maildir
list
delete comps.xml.org
lcd /tmp
extract
y
y
quit

su amandabackup
amtape sample show
amtape sample slot 1
su amandabackup
amrestore file:/var/lib/amanda/sample/tape 192.168.7.3 etc

su amandahackup
amrestore -p file:/var/lib/amanda/sample/tap 192.168.7.3 192.168.7.3 etc | tar xf -

su amandabackup
amtapetype -f /dev/nat0

firewall-cmd --permanent --add-service=bacula-client
firewall-cmd --reload

firewall-cmd --permanent --add-service=bacula
firewall-cmd --reload

firewall-cmd --permanent --add-service=bacula
firewall-cmd --reload

alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so

mysql -u root -p
CREATE DATABASE bacula;
grant all privileges on bacula.* to bacula@192.168.3.202;
set password for bacula@192.168.3.202=password('bacula');

/usr/libexec/bacula/make_mysql_tables -u bacula -h 192.168.7.3 -p

alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so

systemctl reload postgresql.service

su - postgres
psql
CREATE DATABASE bacula ENCODING 'SQL_ASCII' LC_COLLATE 'C' LC-CTYPE 'C' TEMPLATE template0;
ALTER DATABASE bacula SET DATESTYLE to 'ISO, YMD';
q

/usr/libexec/bacula/make_bacula_tables -U postgres -h 192.168.7.3

/usr/libexec/bacula/grant_postgresql_privileges -U posgres -h 192.168.7.3
psql -U postgres -h 192.168.7.3
alter user bacula with unencrypted password 'bacula';
q

systemctl reload postgresql.service

chgrp bacula /etc/bacula/bat.conf
chmod g+r /etc/bacula/bat.conf

gpasswd -a admin bacula

bconsole
*q

bconsole
*status
ALL
*q

bconsole
label
test
1
catalog-volume
1
q

bconsole
run
1

yes
message


virt-manager
virt-install --name 'centos7-2' --ram1024 --disk=/var/lib/libvirt/images/cento7-2.img.size=8 --location=/var/lib/libirt/images/centos7.iso --extra-args='console-tty0 console=ttySo,115200n8'

virsh list --all
virsh start centos7-2
virsh shutdown centos7-2
virsh destroy centos7-2
virsh vncdisplay centos6
virsh save centos7 --file /var/lib/libvirt/qemu/save/save/centos7.img
virsh restore /varlib/libvirt/qemu/save/centos7.img
virsh setmem centos7 768M
virsh setmaxmem centos7 1G
virsh setvcpus centos7 2
virsh setvcpus centos7 2 --config --maximum
virsh-clone --original=centos7 --auto-clone

docker search centos
docker pull centos
docker images
docker run -it --name centos7 centos:7 /bin/bash
exit
docker attach centos7
docker ps
docker ps -a
docker inspect centos7
docker stop centos7
docker start centos7
docker restartcentos7
docker commit -a NSCG -m "CentOS 7 test image" centos7 localrepo:test
docker images localrepo
docker images -t
docker rm centos7
docker rm -f centos7
docker run -it --name webserver-devel --volume=/home/admin/html:/mnt centos:7 /bin/bash

yum install install httpd
vi /etc/httpd/conf/httpd.conf
chcon -R system_u:object_r:docker_var_lib_t:s0 /home/admin/html
cp -rp /mnt/* /var/www/html/
restorecon -R /home/admin/html
eixt
docker commit -a NSCG -m "CentOS 7 webserver" werbserver-devel localrepo:webserver-1
docker rm webserver-devel
docker run -d --name webserver --expose=80 localrepo:webserver-1 /usr/sbin/httpd -D FOREGROUND
docker inspect webserver | grep -i address
docker rm -f webserver
docker run -d --name webserver --expose=80 --publish 80:80 localrepo:webserver-1 / usr/sbin/httpd -D FOREGROUND

echo "1" >/proc/sys/net/ipv4/ip_forward

echo "1" > /proc/sys/net/ipv4/ip_forward

firewall-cmd --set-default-zone internal
firewall-cmd --get-default-zone

firewall-cmd --permanent --zone=external --change-interface=enp0s5
firewall-cmd --permanent --zone=external --list-all

firewall-cmd --reload

firewall-cmd --permanent --zone=external --add-forward-port="port=10080:proto=tcp: toaddr=192.168.100.8:toport=80"
firewall-cmd --permanent --zone=external --list-all

firewall-cmd --reload

cd /etc/pki/tls/certs
make localhost.crt

JP
Osaka
osaka
NSCG
www.nscg.jp
webmaster@nscg.jp

mv /etc/pki/tls/certs/localhost.key /etc/pki/tls/private/

mv localhost.key localhost.key.org
openssl rsa -in localhost.key.org-out localhost.key

cd /etc/pki/tls/certs/
make server.csr

mv /etc/pki/tls/cers/server.key /etc/pki/tls/private/

openssl x509 -noout -text -in localhost.crt

firewall-cmd --permanent --add-rich-rule='rule family=ipv4 service name=telnet source address=102.168.7.0/24 accept'
firewall-cmd --permanent --add-rich-rule='rule family=ipv6 service name=telnet source address=2001:db8::/64 accept'
firewall-cmd --reload

firewall-cmd --permanet --add-service=rpc-bind
firewall-cmd --reload

firewall-cmd --permanent --add-serice=ttp
firewall-cmd --reload

firewall-cmd --permanent --direct --get-all-rules
firewall-cmd --permanent --direct --remove-rule ipv4 filter OUTPUT 3 -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
firewall-cmd --direct --remove-rule ipv4 filter OUTPUT 3 -m state --state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT

firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p icmp -j ACCEPT 
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 2 -m state --state ESTABLISHED,RELATED -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 3 -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 4 -m state --state NEW -m udp -p udp --dport domain -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 5 -m state --state NEW -m tcp -p tcp --dport domain -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 99 -j REJECT 
firewall-cmd --reload

firewall-cmd --permanent --list-rich-rules
firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="192.168.3.207" port port="11211" protocol="tcp" accept'
firewall-cmd --reload

firewall-cmd --permanet --add-rich-rule='rule family=ipv4 source address="192.168.3.207" serivce name=vnc-server accept'
firewall-cmd --reload
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address="192.168.3.0/24" port port=pop3 protocol=tcp accept'
firewall-cmd --reload

firewall-cmd --permanent --list-rich-rules

firewall-cmd --permanent --list-forward-ports

firewall-cmd --permanent --remove-forward-port="port=10022:proto=tcp:toaddr=192.168.7.2:toport=22"
firewall-cmd --reload

firewall-cmd --permanent --add-forwad-port="port=10022:proto=tcp:toaddr=192.168.7.2:toport=22"
firewall-cmd --reload

firewall-cmd --permanent --list-ports

firewall-cmd --permanent --add-port=5900-5903/tcp
firewall-cmd --permanent -add-port=pop3/tcp
firewall-cmd --reload

firewall-cmd --permanent --remove-port=5900-5903
firewall-cmd --reload

firewall-cmd --permanet --permanent --list-services

firewall-cmd --permanet --remove-service=http
firewall-cmd --reload

firewall-cmd --reload

firewall-cmd --zone=work --change-interface=enp0s3
firewall-cmd --get-active-zone
firewall-cmd --permanent --list-all

firewall-cmd -get-services

firewall-cmd --permanent --add-services=http

firewall-cmd --get-zones
firewallc-md --get-default-zone
firewall-cmd --set-default-zone-internal
firewall-cmd --get-active-zone

firewall-cmd --reload
systemctl reload firewalld.service


ldd /bin/bash
pwd
ls 
echo /*
setsebool slinuxuser_use_ssh_chroot_on

mkdir -p /home/chroot/home
mv /home/chroot/home
mv /home/restuser /home/chroot/home/
ln -s chroot/home/restuser /home/restuser

mkdir /home/chroot/bin /home/chroot/lib64
cp -p /bin/bash /home/chroot/bin/
cp -p /lib64/libinfo.so.5 /lib64/libdl.so.2 /lib64/libc.so.6 /lib64/ld-linux-x86-64.so.2 /home/chroot/lib64

ssh 192.168.2.50

cat id_dsa.pub >> authorized_kes
chmod 600 authorized_keys

cat id_rsa.pub >> authoried_keys
chomd 600 authorized_keys

cat identity.pub >> authorized_keys
chomd 600 authorized_keys

chmod 700 /home/tarou/.ssh

ssh-keygen -t rsa1

ssh-keygen -t dsa
ssh-keygen -t rsa

firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

semodule -r local
samodule -l

semodule -u local.pp
semodule -l
semodule -l

semodule -i local.pp

checkmodule -M -m -o local.mod.to
semodule.package -o local.pp -m local.mod

audit2allow-M local < /tmp/postfix-avc.log


sestatus

fixfiles onboot
shutdown -r now

usermod -Z staff_u testuser
useradd -Z user_u_test_user
semange login -d testuser

semanage login -l
semanage login -a -a guest_u testuser
semanage login -l

ssh 192.168.7.3 -l testuser
ld
ping 192.168.7.1

semanage module --enable zabbix

semanage login -l

semanage permissive -d sshd_t
semanage module --disable zabbix
semanage module -l
semanage permissive -l
ps -Z -C sshd

semanage port -l
semanage port -l | grep -w 22
semanage port -a -t ssh_port_t -p tcp 9022
semanage port -l | grep -w ssh_port_t

semanage port -d -t ssh_port_t -p tcp 9022
semanage port -l | grep -w ssh_port_t

semanage fcontext -l

semanage fcontext -a -t public_context_t "/var/example(/.*)?"
restorecon -R /var/example
ls -ldZ /var/example/

semanage fcontext -m -t public_context_rw_t "/var/example(/.*)?"
restorecon -R /var/example
ls -ldZ /var/example/

semanage fcontext -d "/var/example(/.*)?"
restorecon -R /var/example
ls -ldZ /var/example/

cd /
start -H=exustar -cvz -f /tmp/log.tar.gz var/log/maillog*
start -xattr -xvz -f /tmp/log.tar.gz

ls -lZ /etc/passwd
cp /etc/passwd .
ls -lZ passwd
rm -passwd
cp --preserve=context /etc/passwd .
ls -lZ passwd

fixfiles onboot
shutdown -r now

restorecon -v -R /home

sesearch --allow -n -s ftpd_t -t public_context_t

sesearch --allow -b allow_ftpd_anon_write

chcon system_u:object_r:var_log_t:s0 log

seinfo

ls -lZ /etc/passwd

LANG=C man ls
ps -Z -C rsyslogd
id -Z
ls -lZ /etc/passwd

sestatus

setsebool -P ftp_home_dir 1
getsebool ftp_home dir

getenforce

mkdir /mnt/dvd
mount -r /dev/dvd /mnt/dvd
umount /dev/dvd

cd /mnt/dvd/Packages
yum localinstal squid-3.3.8-11.el7.x86_64.rpm

yum install squid

yum update squid

yum install squid
yum remove perl-DBI
yum provides /lib64/libwrap.so.0
yum plist docecot
yum info squid
yum update NetworkManager
yum list perl*
yum install squid

rpm -ihv httpd-2.4.6-17.el7.centos.1.x86.64.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
rpm -qai gpg-pubkey*

yum provides /usr/lib/systemd/system/httpd.service
yum info httpd

grub2-mkpasswd-pbkdf2
grub2-mkconfig -o /boot/grub2/grub.cfg

admin

ps -aux

firewall-cmd --pemanent --add-service=smtp
firewall-cmd --reload

firewall-cmd -- permanent --add-serice=smtp
firewall-cmd --reload

cyradm --user cyrus localhost
setaclaimbox user.testuser cyrus x
deletemailbox user.testuser
quit

passwd cyrus
cyradm --user cyrus localhost
createmailbox user.testuser
quit

chown cyrus:mail /home/imap
chmod 700 /home/imap

semanage fcontext -a -t mail_spool_t "/home/imap(/.*)?"
restorecon -R /home/imap

firewall-cmd --permanent --add-service=imaps
firewall-cmd --permanent -add-service=pop3s
firewall-cmd --reload

firewall-cmd --permanent --add-port=imap/tcp
fireall-cmd-permanent --add_port=pop3/tcp
fireall-cmd --reload

1 CAPABILITY

sudo ./remove_member nscg takagotch@nscg.jp

sudo ./add_members -r - nscg
takagotch@scg.jp

sudo ./rmlist nscg
sudo ./newlist
#listname nscg
./list_lists

sudo newaliases

cd /usr/lib/mailman/bin
sudo ./newlist mailman

sudo /usr/lib/mailman/bin/mmsitepass
ls -l /etc/mailman/adm.pw
sudo chgrp mailman /etc/mailman/adm.pw
sudo chmod g+w /etc/mailman/adm.pw
ls -l /etc/mailman/adm.pw



