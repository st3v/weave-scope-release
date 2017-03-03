# vSphere Installation Guide
## Prerequisites
You will need the following information:  
Ops Manager Host: $OPSMGR_HOST  
Ops Manager Port: $PORT  
bosh Director VM Host: $BOSH_HOST  
bosh Director UID: $BOSH_UID  
bosh Director PWD: $BOSH_PWD  

## Gather Resources
1. ssh into your Ops Manager VM  
    
    ssh ubuntu@$OPSMGR_HOST -p $PORT  
    
2. Clone the weave-scope-release  
    
    mkdir -p ~/github  
    cd ~/githu  
    git clone https://github.com/st3v/weave-scope-release.git
    cd weave-scope-release  
    
3.  Target your Bosh Director VM, entering $BOSH_UID and $BOSH_PWD credentials when prompted:
    
    bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target $BOSH_HOST

4. Create 



