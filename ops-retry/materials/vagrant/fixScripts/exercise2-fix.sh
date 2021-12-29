#!/bin/bash
#add fix to exercise2 here
# sudo ed -s /etc/hosts <<< $'g/www.ascii-art.de/d\nw'
sudo sed -i '/127.0.0.1 www.ascii-art.de/d' /etc/hosts
curl http://www.ascii-art.de/ascii/ab/007.txt