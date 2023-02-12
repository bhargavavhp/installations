## Maven installation on ubuntu
```
cd /usr/local
wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar xvf apache-maven-3.6.3-bin.tar.gz 
ln -s apache-maven-3.6.3 apache-maven
sudo vi /etc/profile.d/apache-maven.sh
```
please insert below lines to /etc/profile.d/apache-maven.sh
```
export JAVA_HOME=/usr/lib/jvm/java-11-oracle
export M2_HOME=/usr/local/apache-maven
export MAVEN_HOME=/usr/local/apache-maven
export PATH=${M2_HOME}/bin:${PATH}
```
```
source /etc/profile.d/apache-maven.sh
mvn -version ( to verify maven version ) 
```

For more details https://tecadmin.net/install-apache-maven-on-ubuntu/  
## easy way to install
```
sudo apt install maven
```
