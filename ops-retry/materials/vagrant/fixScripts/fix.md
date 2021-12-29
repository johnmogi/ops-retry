excercise 2 doesn't print on the loading script.
ssh between servers - restart:
192.168.100.11

https://superuser.com/questions/671191/how-to-ssh-between-a-cluster-of-vagrant-guest-vms

2.sudo ed -s /etc/hosts <<< $'g/www.ascii-art.de/d\nw'
<!-- # curl http://www.ascii-art.de/ascii/ab/007.txt
# sudo sed -i '/127.0.0.1 www.ascii-art.de/d' /etc/hosts -->

0. bu old scripts:
sudo ssh-keygen -t rsa -f id_rsa -y
cat id_rsa.pub | ssh server2 'cat >> .ssh/authorized_keys'
sudo service sshd restart
ssh-keygen -f "/home/vagrant/.ssh/known_hosts" -R 192.168.100.11
sudo ssh-keyscan -H 192.168.100.11 >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 192.168.100.11 >> /home/vagrant/.ssh/id_rsa
sudo service ssh reload
sudo ssh-copy-id -i ~/.ssh/id_rsa server2
ssh server2
------------
sudo -u root chmod +x /etc/hosts
echo 'PermitRootLogin prohibit-password' | sudo tee -a /etc/ssh/sshd_config
# sudo -u root sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
echo '192.168.100.10 server1' | sudo tee -a /etc/hosts
sudo systemctl restart ssh
# Disable StrictHostKeyChecking
echo "Host *" > /home/vagrant/.ssh/config && echo " StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
ssh-keygen -N "" -f /home/vagrant/.ssh/id_rsa
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/server1.key
ssh-copy-id 
chown -R vagrant:vagrant /home/vagrant/
echo "StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
sudo apt update
sudo apt install sshpass
sudo sshpass -p vagrant ssh -o StrictHostKeyChecking=no vagrant@192.168.100.11 cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
sudo -u vagrant ssh-keygen -P "" -t rsa -f /home/vagrant/.ssh/id_rsa2 -q
sudo sshpass -p "vagrant" ssh-copy-id -i /home/vagrant/.ssh/id_rsa2.pub vagrant@192.168.100.11
sudo systemctl restart ssh
sudo -u root chmod +x /etc/hosts
sudo sh -c 'echo "192.168.100.11 server2" >> /etc/hosts'
ssh-keygen -N "" -f /home/vagrant/.ssh/id_rsa
ssh-keygen -R 192.168.100.11
# allow password auhentication (so server2 can connect to server1)
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# restart ssh service


6. 
#example ./exercise6-fix.sh /vagrant/Vagrantfile /etc/crontab  /tmp #Copy Files: Vagrantfile,crontab to RemoteServerDirectory:tmp

set -e

# At least 2 arguments should be passed
if [ $# -lt 2 ]
then
    echo "Please insert the correct number of arguments [min 2 arguments]"
    exit
else 
	case `hostname` in  
		server1) rmserver=server2 ;;
		server2) rmserver=server1 ;; 
	esac
fi

#Getting arguments 
FILES=${@:1:$#-1} #File lists
DIR=${@:$#} #last arguments - directory on remote server
myFileSizeCheck="" #calculate files size in bytes

for file in ${FILES}; do
		let myFileSizeCheck+=$(stat -c %s $file);
		#printf "%d\n" $myFileSizeCheck
done

scp $FILES `whoami`@$rmserver:$DIR
printf "%d\n" $myFileSizeCheck;

exit