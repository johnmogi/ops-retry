#!/bin/bash
#add fix to exercise2 here
sudo chmod +x /etc/hosts
sudo sed -i '/ascii.art.de/d' /etc/hosts
curl http://www.ascii-art.de/ascii/ab/007.txt