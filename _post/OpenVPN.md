### https://qiita.com/horus19761108/items/9c7879149218d9325c5e

### https://www.google.com/search?sxsrf=ALeKk00cmamq4RhNztz4EQa2M-LFLEGAoQ%3A1605543719846&ei=J6eyX66QM5al-Qapvp_4DQ&q=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+centos&oq=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+ce&gs_lcp=CgZwc3ktYWIQARgAMgQIABAeOgQIABBHOgIIADoECCEQFVD-IFjyNGCwPmgAcAJ4AIABT4gB6gGSAQEzmAEAoAEBqgEHZ3dzLXdpesgBBsABAQ&sclient=psy-ab

### https://www.google.com/search?sxsrf=ALeKk01A4p3Hlja64a9gdNudM7p8Jl3WGA%3A1605543728527&ei=MKeyX_beH4r_wAOJoSQ&q=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+centos8&oq=vpn%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC+%E6%A7%8B%E7%AF%89+centos8&gs_lcp=CgZwc3ktYWIQAzIFCAAQzQI6BAgAEB5Qxw1Yxw1gmBBoAHAAeACAAWOIAb0BkgEBMpgBAKABAaoBB2d3cy13aXrAAQE&sclient=psy-ab&ved=0ahUKEwj2tvC8vIftAhWKP3AKHYkQCQAQ4dUDCA0&uact=5

---


```

dnf --enablerepo=epel -y install openvpn easy-rsa net-tools

cd /usr/share/easy-rsa/3/pki
./easyrsa build-ca
./easyrsa build-server-full server1 nopass
./easyrsa build-client-full client1 nopass
./easyrsa gen-dh
openvpn --genkey --secret ./pki/ta.key
cp -pR /usr/share/easy-rsa/3/pki/{issued,private,ca.crt,dh.pem,ta.key} /etc/openvpn/server/

vi /etc/sysctl.d/10-ipv4_forward.conf
+ net.ipv4.ip_forward = 1
sysctl  --system
 
cp /usr/share/doc/openvpn/sample-config-files/server.conf /etc/openvpn/server/
vi /etc/openvpn/server/server.conf
+ port 1194
+ ;proto tcp
+ proto udp
+ ca ca.crt
+ issued/server1.crt
+ key private/server1.crt
+ dh dh.pem
+ server 192.168.100.0 255.255.255.0
+ push "route 10.0.0.0 255.255.255.0"
+ keepalive 10 120
+ tls-auth ta.key 0
+ comp-lzo
+ persist-key
+ persist-tun
+ status /var/log/openvpn-status.log
+ log        /var/log/openvpn.log
+ log-append /var/log/openvpn.log
+ verb3
systemctl enable --now openvpn-server@server
firewall-cmd --add-port=1194/udp --permanent
firewall-cmd --reload

// client pc
./etc/openvpn/server/ca.crt
./etc/openvpn/server/ta.key
./etc/openvpn/server/issued/client1.crt
./etc/openvpn/server/private/client1.key

```

```
```

```
```

```
```

```
```

```
```













