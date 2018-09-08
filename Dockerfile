FROM ubuntu

RUN apt-get update && \
    apt-get install -y sshuttle

  

CMD ["sshuttle", "-r", "$USER@$HOST", "-x", "10.0.0.0/8", "-x", "192.168.0.0/16", "172.17.0.0/24" ]