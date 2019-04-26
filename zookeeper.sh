#!/bin/bash
# add-apt-repository ppa:linuxuprising/java -y
# apt-get-update
# echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | sudo /usr/bin/debconf-set-selections
apt-get install openjdk-8-jdk -y

cd /usr/local

wget https://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.14.tar.gz
wget https://www-us.apache.org/dist/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz

tar -xvf "zookeeper-3.4.14.tar.gz"
tar -zxvf "apache-drill-1.15.0.tar.gz"

touch zookeeper-3.4.14/conf/zoo.cfg

echo "tickTime=2000" >> zookeeper-3.4.14/conf/zoo.cfg
echo "dataDir=/var/lib/zookeeper" >> zookeeper-3.4.14/conf/zoo.cfg
echo "clientPort=2181" >> zookeeper-3.4.14/conf/zoo.cfg
echo "initLimit=5" >> zookeeper-3.4.14/conf/zoo.cfg
echo "syncLimit=2" >> zookeeper-3.4.14/conf/zoo.cfg
 
i=1
while [ $i -le $2 ]
do
    echo "server.$i=10.140.193.$(($i+35)):2888:3888" >> zookeeper-3.4.14/conf/zoo.cfg
    i=$(($i+1))
done

mkdir -p /var/lib/zookeeper

echo $(($1+1)) >> /var/lib/zookeeper/myid

zookeeper-3.4.14/bin/zkServer.sh start

mv apache-drill-1.15.0/conf/drill-override.conf apache-drill-1.15.0/conf/drill-override.bak

cat << EOF >> apache-drill-1.15.0/conf/drill-override.conf 
drill.exec: {
	cluster-id: "zdsdrillcluster"
	zk.connect: "10.140.193.36:2181,10.140.193.37:2181,10.140.193.38:2181"
}
EOF

apache-drill-1.15.0/bin/drillbit.sh start