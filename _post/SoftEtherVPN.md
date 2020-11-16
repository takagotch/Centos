### https://centossrv.com/softethervpnserver.shtml

### https://www.google.com/search?sxsrf=ALeKk00cmamq4RhNztz4EQa2M-LFLEGAoQ%3A1605543719846&ei=J6eyX66QM5al-Qapvp_4DQ&q=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+centos&oq=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+ce&gs_lcp=CgZwc3ktYWIQARgAMgQIABAeOgQIABBHOgIIADoECCEQFVD-IFjyNGCwPmgAcAJ4AIABT4gB6gGSAQEzmAEAoAEBqgEHZ3dzLXdpesgBBsABAQ&sclient=psy-ab

---




```
// http://www.softether-download.com/files/softether/
// http://www.softether-download.com/files/softether/v4.34-9745-rtm-2020.04.05-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz

tar zxvf softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz
cd vpnserver
make

yes, yes

cd
mv vpnserver/ usr/local/
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver
./vpncmd
3
check
exit
cd
rm -f softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz
```

```
vi /etc/systemd/vpnserver.service
systemctl start vpnserver
systemctl enable vpnserver
// ONU直差し
// ONU + router
// router
// UDP 500port, UDP4500port
// firewall
// UDP 500port, UDP4500port
// http://tt0.link/tool/portcheck/

systemctl stop vpnserver
vi /usr/local/vpnserver/vpn_server.config
 // bool Enabled false
 // bool Enabled false
 // bool Enabled false
systemctl start vpnserver
vi /etc/cron.daily/vpnserver
chmod +x /etc/cron.daily/vpnserver

```

```
vi UserPasswordSet.txt
user2 /GROP:none /REALNAME:none /NOTE:none
user3 /GROUP:none /REALNAME:none /NOTE:none
user2 /PASSWORD:user2password
user3 /PASSWORD:user3password

/usr/local/vpnserver/vpncmd /server localhost:5555 /in:UserPasswordSet.txt
pass
```

```
nmcli device
nmcli c add type bridge ifname br0
nmcli con modify bridge-br0 bridge.stp no 
nmcli con modify bridge-br0 ipv4.method manual ipv4.addresses 192.168.1.1 ipv4.dns "8.8.8.8.8.8.4.4"
nmcli con add type bridge-slave ifname eth0 master bridge-br0
nmcli c del eth0
reboot
brctl show
ip addr show


```

```
nmcli device
vi /etc/systemd/system/vpnserver.service
systemctl daemon-reload
vi /usr/local/vpnserver/add_tap.sh
```

```
```


