#! /bin/bash
#Autor: Adail Horst (the.spaww@gmail.com)
### Start nginx and haproxy ###
#set -x
#
nginx &
haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
