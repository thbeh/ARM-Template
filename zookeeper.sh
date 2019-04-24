#!/bin/bash
add-apt-repository ppa:linuxuprising/java -y
apt-get-update
echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | sudo /usr/bin/debconf-set-selections
# apt-get install oracle-java8-installer

cd /usr/local

wget https://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.14.tar.gz
tar -xvf "zookeeper-3.4.14.tar.gz"

touch zookeeper-3.4.14/conf/zoo.cfg

echo "tickTime=2000" >> zookeeper-3.4.14/conf/zoo.cfg
echo "dataDir=/var/lib/zookeeper" >> zookeeper-3.4.14/conf/zoo.cfg
echo "clientPort=2181" >> zookeeper-3.4.14/conf/zoo.cfg
echo "initLimit=5" >> zookeeper-3.4.14/conf/zoo.cfg
echo "syncLimit=2" >> zookeeper-3.4.14/conf/zoo.cfg
 
i=1
while [ $i -le $2 ]
do
    echo "server.$i=10.140.193.$(($i+31)):2888:3888" >> zookeeper-3.4.14/conf/zoo.cfg
    i=$(($i+1))
done

mkdir -p /var/lib/zookeeper

echo $(($1+1)) >> /var/lib/zookeeper/myid

zookeeper-3.4.14/bin/zkServer.sh start
