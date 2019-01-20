#! /bin/bash
#Autor: Adail Horst (the.spaww@gmail.com)
### Create and start a enviroment with nginx and haproxy ###
#set -x
#

IMAGENAME="nginx_haproxy-image"
NETWORKNAME="nginx-net"
# Amount of containers
NUMBER=2;
docker build -t $IMAGENAME -f nginx_haproxy-dockerfile .

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
echo "Creating network $NETWORKNAME"
docker network create $NETWORKNAME

for i in `seq 1 $NUMBER`; do
#  echo "==> Container number $i"
  echo "Creating container nginx-server$i"
  PORT=$(expr 8090 + $i);
  echo "<html><body>nginx $i</body></html>" >  index$i.html
  sudo docker run --net=$NETWORKNAME -p "$PORT:8080" -d -v "${PWD}/index$i.html:/usr/share/nginx/html/index.html" --name "nginx-server$i" $IMAGENAME
  docker logs "nginx-server$i"
done

#echo "List runing containers"
#docker ps

#echo "Check communication betweeen 2 containers by name"
#docker exec -ti nginx-server1 ping nginx-server2 -c 3
#docker exec -ti nginx-server2 ping nginx-server1 -c 3

echo "Check if nginx and haproxy is running in each machine (needs curl in /usr/bin/curl)"
for i in `seq 1 $NUMBER`; do
  PORT=$(expr 8090 + $i);
  /usr/bin/curl "http://localhost:$PORT" -s | grep "nginx $i" && echo "Nginx and HAProxy in nginx-server$i status OK" || echo "Nginx and HAProxy in nginx-server$i status FAIL"
done
