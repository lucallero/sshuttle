FROM ubuntu

RUN apt-get update && \
    apt-get install -y sshuttle

RUN echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

COPY start.sh ./

CMD ["./start.sh"]