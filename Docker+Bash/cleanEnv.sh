#! /bin/bash
#Autor: Adail Horst (the.spaww@gmail.com)
### Env clean ###
#set -x
#
IMAGENAME="nginx_haproxy-image"
NETWORKNAME="nginx-net"
NUMBER=10

for i in `seq 1 $NUMBER`; do
  if [ "$(docker ps -a -f name=nginx-server$i | grep nginx-server$i )" ]; then
    echo "Stopping nginx-server$i"
    docker stop "nginx-server$i"
    echo "Removing nginx-server$i"
    docker rm "nginx-server$i"
  fi
done

if [ "$(docker network ls -f name=$NETWORKNAME)" ]; then
  # Creating docker network
  echo "Removing $NETWORKNAME"
  docker network rm $NETWORKNAME
fi

if [ "$(docker image ls -q $IMAGENAME)" ]; then
  # Creating docker network
  echo "Removing $IMAGENAME"
  docker image rm $IMAGENAME
fi
