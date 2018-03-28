# server update
sudo apt update
sudo apt upgrade
sudo timedatectl set-timezone Australia/Brisbane

# Jena/Fuseki
sudo apt install -y tomcat8 tomcat8-admin

# map port 80 to 8080 - can't get Tomcat to run on port 80 in AWS
sudo /sbin/iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
sudo /sbin/iptables -A INPUT -i eth0 -p tcp --dport 8080 -j ACCEPT
sudo /sbin/iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo nano /var/lib/tomcat8/conf/tomcat-users.xml
# add in         
# <role rolename="manager-gui"/> 
# <user username="admin" password="{TOMCAT_ADMIN_PWD}" roles="manager-gui,admin-gui"/>

# Tomcat enviro vars
# find enviro vars ps aux | grep catalina
# in .profile, add:
# CATALINA_BASE=/var/lib/tomcat8
# CATALINA_HOME=/usr/share/tomcat8
source .profile
sudo nano /etc/default/tomcat8 --> set heap size to 256m

# get Fuseki
wget http://apache.mirror.serversaustralia.com.au/jena/binaries/apache-jena-fuseki-3.6.0.tar.gz
# check http://apache.mirror.serversaustralia.com.au/jena/binaries/ for latest

# load the Fuseki WAR into Tomcat
tar -xzf apache-jena-fuseki-3.4.0.tar.gz
sudo cp apache-jena-fuseki-3.4.0/fuseki.war /var/lib/tomcat8/webapps/

# create the Fuseki data dir
sudo mkdir /etc/fuseki
sudo chown tomcat8 /etc/fuseki/

# start the Fuseki webapp in Tomcat manager http://{IP-ADDRESS}/manager/html/
# all config for Fuseki is now in /etc/fuseki/
# visit Fuseki web UI: http://{IP-ADDRESS}/fuseki/

# set up auth for Fuseki
# edit /etc/fuseki/shiro.ini as per instructions in file. pwd {FUSEKI_WEB_ADMIN_PWD}

#
#	Configuring Fuseki
#
# create a "relatives" DB via the web UI, select persistent storage
# DB is set to /etc/fuseki/databases/relatives
# DB config is set to /etc/fuseki/configuration/relatives.ttl -- relatives-default.ttl in this repo
# load the relatives.ttl file via web UI
#	SELECT shows 25 triples
