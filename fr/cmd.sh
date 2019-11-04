#### systemd, journald, firewald, tuned




# 1804/Kernel3.10/systemd/firewald/NetworkManager/SELinux
# BIND/unbound/Apache/Postfix/Dovecot/Samba/chrony/Docker
# NetworkManager, systemd, firewalled, VirtualX
# DNS, WWW external public server, DHCP, LDAP, NetworkServer managed control way

## grub

vi /etc/default/grub

cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg.org
grub2-mkconfig -o /boot/grub2/grub.cfg

grub-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

reboot
cat /proc/cmdline

cd /etc/grub.d/
cp 40_custom 40_custom.org
chomd -x 40_custom.org

grep -A 14 "CentOS Linux" /boot/grub2/grub.cfg
vi 40_custom

vi /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
awk -F\' '$i=="menuntry " {print $2}' /boot/grub/grub.cfg                 '
reboot
vi /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg && reboot


## systemd
systemctl get-default
systemctl list-units --type=target --all --no-pager
systemctl set-default graphical.target
systemctl get-default
reboot

ls -l /lib/systemd/system/runlevel*target
systemctl isolate multi-user.target
systemctl isolate graphical.target
runlevel
systemctl get-default
systemctl isolate rescue.target

systemctl -t service list-unit-files
systemctl -r service list-unit-files | grep -i ftp
systemctl status vsftpd
systemctl start vsftpd
systemctl status vsftpd

systemctl stop vsftpd
systemctl status vsftpd
systemctl enable vsftpd
systemctl -t service is-enalbed vsftpd

cd /usr/lib/systemcd/system
cat graphical.target
pwd
cat multi-user.target
cat basic.target
cat sysinit.target
pwd
cat sshd.service
pwd
grep Before=network.target ./*.service
pwd 
cat auditd.service
systemctl show --all httpd
mkdir /etc/systemcd/system/httpd.service.d/
cd /etc/systemd/system/httpd.service.d/
vi 10-httpd.conf

systemctl daemon-reload

localetl

localetl set-locale LANG=ja_JP.utf8
localetl
cat /etc/locale.conf

localctl list-keymaps
localetl set-keymap jp106
cat /etc/vconsole.conf

timedatectl
timedatectl set-time 2014-09-06
timeatectl

timedatectl set-time 19:51:00
timedatectl

timedatectl set-time "2019-09-06 19:55:00"
timedatectl
timedatectl list-timezones
timedatectl set-timezone Asia/Tokyo

## syslog   journald rsyslog
systemctl status systemd-journald
journalclt -b
journalctl --since="2014-09-05 01:23:45" --until="2014-09-07 04:56:00"
journalctl --since="2014-09-06 00:03:27" --until="2014-09-07 11:56:00" -u sshd.service
journalctl --since-today
journalctl -f
journalctl -p warning
journalctl -p err
journalctl -p 0
journalctl -p 1
journalctl -p 2
journalctl -p 3
journalctl -p 4
journalctl -p 5
journalctl -p 6

logger -p daemon.emerg "*** TEST LOG **"

journalctl -p 9
logger -p daemon.alert "*** ALERT TEST LOG ***."
journalctl -p i

journalctl -k
journalctl _PID=10765

journalctl /usr/sbin/crond
df -HT | grep tmpfs

cp /etc/systemd/journald.conf /etc/systemd/journald.conf.org
vi /etc/systemd/journald.conf

systemctl restart systemd-journald
cd /var/log/journal/xxxx/
ls -l
cat /etc/machines-id

vi /etc/systemd/journald.conf
systemctl restart systemd-journald
journalctl --disk-usage

vi /etc/rsyslog.conf

touch /var/log/journalctl_log_172.16.70.2
firewall-cmd-zone=public --add-port=514/udp --permanent
firewall-cmd --reload
firewall-cmd --list-all

systemctl restart rsyslog
systemctl status rsyslog

firewall-cmd --zone=public --add-port=514/udp --permanent
firewall-cmd --reload

systemctl start sysemd-journald
systemctl status systemd-journald
journalctl -o short -f | nc -uv 172.16.70.99 514


mkdir -p /var/log/journal/'cat /etc/machine-id'
journalctl --setup-keys --force

journalctl --verify-key ee2e0e-045220-a3cec8-f111f8/17ec78-35a4e900

yum install -y sos

sosreport -a --report

pwd
tar sJvf /var/tmp/sosreport-centos70n02-201410221-3807.tar.xz -C
ls -F
cd sosreport-centos70n02-20141022103807/
ls -F
cd
ls -F
mv sosreport-centos70n02-20141022103807 /var/www/html/
systemctl start httpd
firewall-cmd --list-all
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload

cd /var/www/html/
chmod 755 ./sosreport-centos70n02-20141022103807
cd ./sosreport-centos70n02-20141022103807
chmod -R 655 ./sos_commands
chmod -R 655 ./sos_logs
chmod -R 655 ./sos_reports
  


## NetworkManager

ls -l /sys/class/net/
ls -l /sys/class/net/

nmcli connection

nmcli connection down eno1
nmcli connection show
nmcli connection up eno1
nmcli device
nmcli device show
nmcli device show eno1

nmcli connection modify eno1 ipv4.addresses "10.0.0.82/24 10.0.0.1"
nmcli connection down eno1 && nmcli connection up eno1

nmcli device show eno1

nmcli connection modify eno1 ipv4.dns "10.0.0.254 10.0.0.253"
nmcli connection modify eno1 ipv4.routes "10.0.0.0/24 10.0.0.1"
nmcli connection down eno1 && nmcli connection up eno1
nmcli device show eno1

nmcli device show eno1 | grep DNS
cat /etc/resolv.conf
vi /etc/NetworkManager/NetworkManager.conf
nmcli connection modify eno1 ipv4.dns "10.0.0.253"

nmcli connection down eno1 && nmcli connection up eno1
nmcli device show eno1 | grep DNS
systemctl restart network

cat /etc/resolv.conf
nmcli device
nmcli connection delete eno1
nmcli device

nmcli connection add type ehternet ifname eno1 con-name eno1
nmcli device

nmcli connection modify eno1 ipv4.method manual ipv4.addresses "192.168.0.82"
nmcli connection down eno1 && nmcli connection up eno1
nmcli device show eno1
cat /etc/sysconfig/network-scripts/ifcfg-eno1

nmcli general hostname
nmcli general hostname centos70n254.jpn.linux.hp.com
hostname
cat /etc/hostname


nmcli networking
nmcli networking on
ip link
nmcli networking off
nmcli networking
ip link

nmtui


ip a

ip addr add 192.168.0.82/255.255.0 dev eno3
ip add show eno3

ip link

ip route add default via 192.168.0.254
ip route del default via 192.168.0.254

ip neigh
ip neigh flush 172.16.1.115

ip -a l
ss -ant # tcp socket ss
ss -anu


yum install -y teamd
nmlic connection add team con-name team0 ifname team0 config '{"runner"}'
nmcli connection modify team0 ipv4.method manual ipc4.addresses "172.16.70"
nmcli connection add type team-slave autoconnect no ifname eth0 master team0
nmcli connection add type team-slave autoconnect no ifname ens7 master team0
systemctl restart network
nmcli connection modify team-slave-sns7 connection.autoconnect yes

ip a

nmcli c

cat /etc/sysconfg/network-scripts/ifcfg-team0
cat /etc/sysconfg/network-scripts/ifcfg-tem-slave-eth0
cat /etc/sysconfig/network-scripts/ifcfg-team-slave-sns7


nmcli device

cp /etc/default/grub /etc/default/grub.org
vi /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg
reboot


cd /etc/sysconfig/network-scripts/
cat ifcfg-eth0
cat ifcfg-eht1
reboot





cd /etc/sysconfig/network-scripts/
mv ifcfg-ano1 org.ifcfg-eno1
mv ifcfg-eno2 org.ifcfg-eno2
mv ifcfg-eno3 org.ifcfg-eno3
mv ifcfg-eno4 org.ifcfg-eno4
cp org.ifcfg-eno1 ifcfg-eth0
cp org.ifcfg-eno2 ifcfg-eth1
cp org.ifcfg-eno3 ifcfg-eth2
cp org.ifcfg-eno3 ifcfg-eth3

vi ifcfg-eth0
reboot
nmcli device show

## docker KVM 6



pwd
ls -l
docker build -t cents7_apache .
docker images
docker run --name apache001 --privileged -i -t -d -p 80:80 centos7_apache /sbin/init
docker ps -a
nsenter -t $(docker inspect --format '{{.State.Pid}}' apache001) -i -m -n -p -u /bin/bash

systemctl status httpd
ip a | grep inet
curl 172.17.0.26/index.html



systemctl enable cgconfig
systemctl start cgconfig
lssubsys -am
cgcreate -t tky:kty -g net_cls:/test01
cgset -r net_cls.classid=x000100002 /test01
cat /sys/fs/cgroup/net_cls/test01/net_cls.classid
ip a

tc qdisc add dev enp0s25 root handle 1: htb
tc class add dev enp0s25 parent 1: classid 1:2 htb rate 256kbps
tc filter add dev enp0s25 parent 1: protocol ip prio 10 handle 1: cgroup

cd 
dd if=/dev/zero of=/root/testfile bs=1024k count=30
ls -lh testfile
md5sum ./testfile
vi /root/scp.sh
chmod +x /root/scp.sh
tc class change dev enp0s25 parent 1: classid 1:2 htb rate 100kps
cgexec --sticky -g net_cls:test01 ./scp.sh
tc class change dev enp0s25 parent 1: classid 1:2 htb rate 1mbps
time cgexec --sticky -g net_cls:test01 ./scp.sh
tc class change dev enp0s25 parent 1: classid 1:2 htb rate 10mbps

cgcreate -t tky:tky -g blkio:/test01
ls -l /sys/fs/cgroup/blkio/test01/
ls -l /dev/sda
cget -r blkio.throttle.read_iops_device="8:0 10" /test01
vi /root/io.sh
chmod +x /root/io.sh
cgset -r blkio.throttle.read_iops_device="8:0 10" /test01
cgexec --sticky -g blkio:test01 ./io.sh

cget -r blkio.throttle.read_iops_device="8:0 50" /test01
cgexec --sticky -g blkio:test01 ./io.sh
cgset -r blkio.throttle.read_iops_device="8:0 500" /test01
.io/.sh

systemctl set-property httpd.service MemoryLimit=1G
systemctl deamon-reload ; systemctl restart httpd.service
cat /etc/systemd/system/httpd.service.d/90-MemoryLimit.conf


## OpenLMI 7
yum install -y openlmi
systemctl start tog-pegasus
systemctl enable tog-pegasus

firewall-cmd --permanent --add-port=5989/tcp
firewall-cmd --reload
setenforce 0

cat /etc/Pegasus/access.conf | grep -v ^
passwd pegasus
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release
yum install -y openlmi-scripts*
cp /etc/Pegasus/server.pem /etc/pki/ca-trust/source/anchors/managed-machine-cert.pem
update-ca-trust extract
lmi -h localhost hwinfo
lmi -h localhost system

lmi -h localhost storage list

lsscsi
lmi storage raid create --name myraid001 5 sdb sdc sdd
lmi storage vg create myvg001 myraid001
lmi storage lv create myvg001 myvol001 400G
ls -l /dev/mapper/myvg001-myvol001

lmi storage fs create xfs myvol001
mkdir /myvol001
lmi storage mount create /dev/mapper/myvg001-myvol001 /myvol001/

lmi storage raid show

lmi -h localhost net device list
lmi -h localhost sw install httpd

lmi -h localhost sw show pkg httpd
lmi service show nginx

lmi service start nginx
lmi service show nginx

## 8 firewald iptables
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --list-all-zones
firewall-cmd --state
firewall-cmd --get-zones
firewall-cmd --get-active-zones

yum install -y nfs-utils
systemctl start nfs-server
systemctl status nfs-server
vi /etc/exports
systemctl reload nfs-server
exportfs -av
showmount -e localhost
systemctl eneble nfs-server

firewall-cmd --permanent --zone=public --add-service=nfs

firewall-cmd --reload
firewall-cmd --zone=public --list-services
firewall-cmd --list-all
cat /etc/firewald/zones/public.xml
mount -t nfs 172.16.70.1:/home/ /mnt/
df -HT | grep nfs

firewall-cmd --permanent --zone=public --remove=service=nfs
firewall-cmd --reload

vi /etc/sysctl.conf
sysctl -p

cat /proc/sys/net/ipv4/ip_forward
firewall-cmd --get-active-zones
firewall-cmd --permanent --zone=trusted --change-interface=ens7
firewall-cmd --get-active-zones
firewall-cmd --permanent --zone public --add-masquerede
firewall-cmd --reload

firewall-cmd --list-all --zone=public
firewall-cmd --list-all --zone=trusted

cd /etc/firewalld/zones/
cat public.xml
cat trusted.xml

vi /etc/grub.d/40_custom
grub2-mkconfig -o /boot/grub2/grub2.cfg
reboot
vi /etc/grub.d/40_custom
grub2-mkconfig -o /boot/grub2/grub2.cfg
reboot

cat /etc/grub.d/40_custom
grep ^CLASS= /etc/grub.d/10_linux
cp /etc/grub.d/10_linux /root/10_linux.org
vi /etc/grub.d/10_linux

grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

cat /etc/grub.d/40_custom

cp /etc/grub.d/40_custom /root/40_custom.org
grub2-mkpasswd-pbkdf2
vi /etc/grub.d/40_custom
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

yum install -y system-storage-manager
ssm list

ssm create --fatype xfs -p pool1001 -e /dev/sda4 /mnt
ssm list
df -HT

echo "Hello encrypted LVM" > /mnt/testfile
unmount /mnt
cryptsetup luksClose /dev/mapper/encrypted001

ssm list volumes
cryptsetup luksOpen /dev/mapper/pool1001-lvo001 encrypted001
ssm list volumes
mount /dev/maper/encrypted001 /mnt

## 9 tuned
grep -v "^# /etc/tuned/tuned-main.conf"
tybed-adm list

systemctl start tuned
tuned-adm profile powersave
tuned-adm active
cd /usr/lib/tuned
ls -F
cd /usr/lib/tuned/latency-performance
cat ./tuned.conf | grep -v "^#" | grep -v "^$"

mkdir -p /etc/tuned/myhadoop001
vi /etc/tuned/myhadoop001/tuned.conf
tuned-adm profile myhadoop001
tuned-adm profiles:
tail -f /var/log/tuned/tuned.log

vi /etc/sysctl.conf
sysctl -p
cat /proc/sys/vm/nr_hugepages

vi /etc/sysctl.conf
sysctl -p
cat /proc/sys/vm/drop_caches
vi /etc/sysctl.conf
sysctl -p
cat /proc/sys/vm/swappiness
cat /sys/block/sda/queue/scheduler
echo cfq > /sys/block/sda/queue/scheduler
cat /sys/blocksda/queue/scheduler

echo noop > /sys/block/sda/queue/scheduler
cat /sys/block/sda/queue/scheduler

cat /proc/sys/kernel/numa_balancing
vi /etc/sysctl.conf
sysctl -p
cat /proc/sys/kernel/numa_balancing

numactl -H
lscpu
cat /proc/cpuinfo | grep processor | wc -l
less /etc/libvirt/qemu/centos70vm01.xml
virsh edit centos70vm01
virsh start centos70vm01
virsh vcpinfo centos70vm01

yum install -y tuna
tuna -Q
numactl --hardware
tune -S 1 -q 'eht*' -x
tuna -Q | grep eth

tuna -c 12 -t rsyslogd -m
tuna -t rsyslogd -P
grep Cpus_allowed_list /proc/'pgrep rsyslogd' /status
tuna -c 0-23 -t rsyslogd -m 
tuna -t rsyslogd -P
grep Cpus_allowed_list /proc/'pgrep rsyslogd'/status

tuna -S O -t rsyslogd -m
grep Cpus_allowed_list /proc/'pgrep rsyslogd'/status

tuna -g
ls -l /etc/tuna



## 10 kickstart

## 11 hadoop

## 12 ceph



