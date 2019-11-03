



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




