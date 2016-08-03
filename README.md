# Vagrant 

see possible vagrant nodes and status

    vagrant status 

start one node (puppet is installed / setup automaticly over vagrant)
  
    vagrant up <node>

ssh into vagrant node

    vagrant ssh <node>

# Puppet without vagrant

Run tools/puppet/bootstrap.sh to create the puppet infrastruktur on you node (runs automaticly setup.sh and modules.sh). At the end you have your puppet module and all modules in modules.env are ready. Hiera and and the site.pp will be also ready.

If you want to change the depending modules, edit modules.env and run tools/puppet/modules.sh again.

Modify /etc/puppet/environments/common.yaml and other hiera files as you need. 
	
## Run masterless Puppet

edit /etc/puppet/manifests/site.pp as you need and run
	
    sudo puppet apply --debug --verbose /etc/puppet/manifests/site.pp

or 
    sudo tools/puppet/run.sh