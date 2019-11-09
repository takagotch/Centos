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




