# sshuttle
A Docker conteiner for sshuttle 

## Hot to run...

As sshuttle mess with iptables rules to made it's magic, you need to run the container with net privilegs, e.g. --cap-add=NET_ADMIN --cap-add=NET_RAW.

Set USER, HOST and SUBNET environments variables, where USER and HOST are the targe host for ssh to connect and SUBNET sets the subnet you want to proxy through sshuttle.

Example: `docker run -e --cap-add=NET_ADMIN --cap-add=NET_RAW -e USER=alice -e HOST=yourserver.com -e SUBNET=172.17.0.0/24 lcallero/sshuttle`

## Volume

Upon build a private/public RSA key pair was generated, for testing purposes you may use if you want, but you should mount a volume at '/home/$USER/.ssh' with your own key pair.

Obs.:
TCP forward is enabled, so sshuttle will act as a router, e.g. `net.ipv4.ip_forward = 1` and parameter `--listen 0.0.0.0/0` set on startup. If you need change it on runtime with `exec` or make your own image FROM lcallero/sshuttle.