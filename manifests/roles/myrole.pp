#
# use roles as entrypoint for your different nodes or use cases
#
class puppet-vagrant-scaffold::roles::ci inherits ::puppet-vagrant-scaffold::roles::base {

    class { 'puppet-vagrant-scaffold::component_class_1': } ->
    class { 'puppet-vagrant-scaffold::component_class_2': }
}
