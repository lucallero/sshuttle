#!/bin/bash

# forward kill signal to $child 
_term() {
    kill -TERM "$child" 2>/dev/null # Forward signal to child
}

_start(){
# Wating..
child=$!
wait "$child"
# Greeting ...
echo "bye!"
}

# Traping signals
trap _term SIGINT SIGTERM


# Checking for mandatories env variables.
STOP=0
set -- "USER"  "MODE"  "HOST" "SUBNET"
for i; do
    env | grep $i > /dev/null
    RC=$?
    if [[ $RC == 1 ]];then
	echo "Env variable $i was not set, I need it!"
	STOP=1
    fi
done

if [[ $MODE == "genkey" ]];then
    if [ ! -f /home/${USER}/.ssh/id_rsa ];then
        echo "User: $USER"
        mkdir -p /home/${USER}/.ssh
        ssh-keygen -f /home/${USER}/.ssh/id_rsa -t rsa -N ''                
        echo "Copy following pub key to your server:"
        echo "`cat /home/${USER}/.ssh/id_rsa.pub`"
        echo "Host *
                StrictHostKeyChecking no
                UserKnownHostsFile=/dev/null" >> /home/${USER}/.ssh/config
        exit 0
    else
        echo "File exists, /home/${USER}/.ssh/id_rsa.pub, copy to your server and run with MODE=connect"
        exit 0
    fi  
elif [[ $RUN_MODE == "connect" ]];then
    # Main process
    env | grep PORT > /dev/null
    RC=$?
    if [ $# -eq 0 ] && [ $RC == 1 ];then    
        #if no port specified use default
        sshuttle -vr $USER@$HOST -x 10.0.0.0/8 -x 192.168.0.0/16 $SUBNET &    
    else
        sshuttle -vr $USER@$HOST:$PORT -x 10.0.0.0/8 -x 192.168.0.0/16 $SUBNET &    
    fi
else
    echo "Please, variable MODE only accepts 'genkey' or 'connect'."
    exit 1
fi

_start
