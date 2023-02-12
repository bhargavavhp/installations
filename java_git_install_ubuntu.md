## Java 8 installation on ubuntu

### using default jdk
```
sudo apt-get -y install default-jdk
```
### using openjdk
```
sudo apt update
sudo apt install openjdk-8-jdk openjdk-8-jre
set path 
```
```
cat >> /etc/environment <<EOL
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
EOL
```
### select which ever java version you need
```
sudo update-alternatives --config java
```

## Java 11 - openjdk
```
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install openjdk-11-jdk
```

## Java 11 - oracle installer
```
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt-get install oracle-java11-installer
sudo apt-get install oracle-java11-set-default #to set java 11 as default
java -version
```
for more details - https://tecadmin.net/install-oracle-java-11-on-ubuntu-16-04-xenial/

#### Java 11 installation in GCP machine 
  - download **jdk-11.0.12_linux-x64_bin.tar.gz** from https://www.oracle.com/java/technologies/downloads/#java11 and place it under **/var/cache/oracle-jdk11-installer-local**
```
sudo apt-get install oracle-java11-installer-local
sudo apt install oracle-java11-set-default-local
```

## Git installation
 ```
apt-get update
apt-get install git
git --version #to verify git version
```
