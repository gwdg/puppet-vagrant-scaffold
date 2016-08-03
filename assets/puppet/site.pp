# use roles to define different deployment path for your nodes 
# var $role is used in hiera definition so its possible to separate your parameters in different hiera files like
# $role = database
# and puppet/hiera/roles/database.yaml
# the hiera.yaml includes some rules to look first into the role parameters and then in common.yaml

$role = 'myrole'
include ::puppet-vagrant-scaffold::roles::myrole

# or node definitions
# All the compute nodes
#node /^compute\d+\./ {
#
#    $role = 'compute'
#    include ::puppet-vagrant-scaffold::roles::compute
#}

# Provide simulated shared mass storage (via nfs)
#node /^nfs\./ {
#
#    $role = 'nfs'
#    include ::puppet-vagrant-scaffold::roles::nfs
#}