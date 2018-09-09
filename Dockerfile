FROM ubuntu

RUN apt-get update && \
    apt-get install -y sshuttle

RUN echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

COPY start.sh ./

CMD ["./start.sh"]