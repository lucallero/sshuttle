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
set "MODE"  
for i; do
    env | grep $i > /dev/null
    RC=$?
    if [[ $RC == 1 ]];then
	echo "Env variable $i was not set, I need it!"
	STOP=1
    fi
done

if [[ $MODE == "genkey" ]];then
    if [ ! -f /root/.ssh/id_rsa ];then        
        mkdir -p /root/.ssh
        ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''                
        echo "Copy following pub key to your server:"
        echo "`cat /root/.ssh/id_rsa.pub`"
        exit 0
    else
        echo "File exists, /root/.ssh/id_rsa.pub, copy to your server and run with MODE=connect"
        exit 0
    fi  
elif [[ $MODE == "sshuttle" ]];then
    # Main process
    env | grep PORT > /dev/null
    RC=$?
    if [ $# -eq 0 ] && [ $RC == 1 ];then    
        #if no port specified use default
        sshuttle -vr root@$HOST -x 10.0.0.0/8 -x 192.168.0.0/16 $SUBNET &    
    else
        sshuttle -vr root@$HOST:$PORT -x 10.0.0.0/8 -x 192.168.0.0/16 $SUBNET &    
    fi
else
    echo "Please, variable MODE only accepts 'genkey' or 'sshuttle'."
    exit 1
fi

_start
