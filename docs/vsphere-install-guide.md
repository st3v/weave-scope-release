# vSphere Installation Guide
## Prerequisites
You will need the following information:  
Cloud Controller API: $CC_HOST  
UAA Host: $UAA_HOST  
UAA Admin Client Password: $UID_PWD  
Ops Manager Host: $OPSMGR_HOST   
Ops Manager Port: $PORT    
Ops Manager PWD: $OPSMGR_PWD  
bosh Director VM Host: $BOSH_HOST    
bosh Director UID: $BOSH_UID    
bosh Director PWD: $BOSH_PWD    

## Procedure
1. ssh into your Ops Manager VM, entering $OPSMGR_PWD when prompted:   
    
    $ ssh ubuntu@$OPSMGR_HOST -p $PORT  
    
2. Clone the weave-scope-release  
    
    $ mkdir -p ~/github  
    $ cd ~/githu  
    $ git clone https://github.com/st3v/weave-scope-release.git
    $ cd weave-scope-release  
    
3.  Target your Bosh Director VM, entering $BOSH_UID and $BOSH_PWD credentials when prompted:
    
    $ bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target $BOSH_HOST

4. Edit ~/github/weave-scope-release/manifests/vsphere-scope-app.yml as follows:  
    
    Replace <YOUR UID> with the value from:  
    $ bosh status --uuid  
    
    Replace <YOUR VERSION> with the version shown from:  
    $ bosh stemcells  
    
    Replace <YOUR AZ1> with the AZ(s) from the 'azs' section of:  
    $ bosh cloud-config  
    
    
    Replace <YOUR VM> with a choice from the 'vm_types' section of:  
    $ bosh cloud-config  
    
    Replace <YOUR NETWORK> with a choice from the 'networks' section of:  
    $ bosh cloud-config  

5. Attempt to upload the release. If it does not work, create a new release and then upload:  
    
    $ cd ~/github/weave-scope-release  
    $ bosh upload release
    (If the above step fails)
    $ bosh create release
    $ bosh upload release

6. Add a new user for the Weave Probe to access the Cloud Controller:
    
    $ uaac target $UAA_HOST --skip-ssl-validation  
    $ uaac token client get admin -s $UID_PWD  
    $ uaac client add cf-admin-ro --name cf-admin-ro --secret cf-admin-ro-secret \
    --authorized_grant_types client_credentials,refresh_token --authorities cloud_controller.admin

7. Edit ~/github/weave-scope-release/manifests/addon.yml as follows:  

    Replace target_addr (line 14) with the IP address from:  
    $ bosh vms scope-app
    
    Replace `cf` credentials as the end of the file as follows:
    api_url: $CC_HOST  
    client_id: cf-admin-ro   
    client_secret: cf-admin-ro-secret  

8. Update your runtime-config with the Probe addon:  
    
    $ bosh update runtime-config ~/github/weave-scope-release/manifests/addon.yml

9. Apply the new config just to the Scope App, to test it is working:  
    
    $ bosh -d ~/github/weave-scope-release/manifests/vsphere-scope-app.yml deploy  
    
10. Browse to the IP address you obtained in Step 7, and verify you have a single node running:  
    
    http://<SCOPE APP IP>:4040/  
    
11. Assuming all is well, obtain the name of your ERT bosh release, and then deploy:  
    
    $ bosh deployments 
    (Observe name of CF deployment, e.g. cf-12375y37e97038333)  
    $ bosh -d /var/tempest/workspaces/default/deployments/cf-12375y37e97038333.yml deploy  
    
12. Browse back to the URL you opened in Step 10, and watch the nodes appear, one by one:

<img src="https://github.com/bendalby82/weave-scope-release/blob/master/docs/images/full-scope.png" width="500">

    
    

