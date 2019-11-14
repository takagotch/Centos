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



