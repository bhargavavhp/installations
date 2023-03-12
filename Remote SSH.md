## Configuring VS code for GCP VM - Remote SSH
 - Open VS code in administrator mode
 - Go to extensions and install Remote SSH, kubernetes, kubernetes support
 - Open terminal in VS code and type below gcloud command
 ```
 gcloud compute config-ssh
 ```
 - This will show ssh configuration in ssh (refresh if needed)
 - Open the master kubernetes VM configuration and add your system user to master host and save it
 ```
 Host k8s-master.us-central1-c.theta-petal-377814
    HostName <ip-auto-published>
    IdentityFile C:\Users\<Username>\.ssh\google_compute_engine
    UserKnownHostsFile=C:\Users\<Username>\.ssh\google_compute_known_hosts
    HostKeyAlias=compute.8408380812835562933
    IdentitiesOnly=yes
    CheckHostIP=no
    User <Username>   <======== HERE
```
- Open the k8s master host, this will open remote ssh to VM
   - **Note: Provided you have added your ssh keys in GCP account**
- In the terminal go to the workspace directory you want to work and give ```code .```
- This will open the current directory in VS code
