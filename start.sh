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

# Main process
sshuttle -vr $USER@$HOST -x 10.0.0.0/8 -x 192.168.0.0/16 $SUBNET &

_start
