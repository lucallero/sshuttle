# sshuttle
A Docker conteiner for sshuttle 

## Hot to run...

As sshuttle mess with iptables rules to made it's magic, you need to run the container with net privilegs, e.g. --cap-add=NET_ADMIN --cap-add=NET_RAW.

Set HOST and SUBNET environments variables, where HOST is the targe host for sshutle to connect and SUBNET is/are the subnet you want to proxy through sshuttle.

Example: `docker run -e --cap-add=NET_ADMIN --cap-add=NET_RAW -e HOST=yourserver.com -e SUBNET=172.17.0.0/24 lcallero/sshuttle`

## Volume

Upon build a private/public RSA key pair was generated, for testing purposes you may use if you want, but I strongly recommend you to mount a volume at '/root/.ssh' with your own key pair.

Obs.:
By default tcp forward is enabled and sshuttle command will act as a router, e.g. `net.ipv4.ip_forward = 1` and parameter `--listen 0.0.0.0/0` set on sshuttle command. If want to change chang it on runtime with exec or make your own image FROM lcallero/sshuttle.