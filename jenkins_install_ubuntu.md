## Jenkins installation
``` 
wget https://updates.jenkins-ci.org/download/war/2.162/jenkins.war
```
 - if you want any other version to be installed visit https://updates.jenkins-ci.org/download/war/ download particular version
 - jenkins runs default on 8080 port
```
java -jar jenkins.war  
java -jar jenkins.war --httpPort=5000 #if you want run on any other port use this, in my case its 5000 port 
nohup java -jar jenkins.jar & #to run jenkins process in background
```

## Jenkins as a service 
```
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install jenkins
systemctl start jenkins
systemctl status jenkins
```
