# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require 'pp'
require 'yaml'

environment = 1

class ErbRender < OpenStruct
  def self.from_hash(t, h)
    ErbRender.new(h).render(t)
  end

  def render(template)
    ERB.new(template).result(binding)
  end
end

class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

vagrant_base = File.expand_path(File.dirname(__FILE__))

env_base = YAML.load_file("#{vagrant_base}/env/base.yaml")
data = { environment: environment, ip_suffix: env_base['ip_suffix']}
#pp ErbRender::from_hash(env_base['networks']['interface1']['ip'], data)

nodes = Dir["#{vagrant_base}/env/nodes/*.yaml"].map { |v| File.basename(v, '.yaml')} 

Vagrant.configure(2) do |config|
  
  nodes.each do |node|
    
    s = IO.read("#{vagrant_base}/env/nodes/#{node}.yaml")
    s = s.gsub('#{environment}', environment.to_s) 

    node_config = YAML.load(s)
    node_config = env_base.deep_merge(node_config) 
    node_config = Marshal.load(Marshal.dump(node_config) )#deep clone

    quantity = node_config.has_key?("quantity") ? node_config['quantity'] : 1

    (1..quantity).each do |count|

      node_identifier = quantity > 1 ? "#{node}_#{count}" : node

      config.vm.define node_identifier do |vm_config|

        if node_config['domain'].to_s.empty?
          vm_config.vm.hostname   = "#{node_identifier.gsub('_', '-')}"
        else 
          vm_config.vm.hostname   = "#{node_identifier.gsub('_', '-')}.#{node_config['domain']}"
        end

        vm_config.vm.box        = node_config['box']
        vm_config.vm.box_url    = node_config['box_url'] if node_config.has_key?("box_url")

        vm_config.ssh.password  = "vagrant" 

        node_config['memory'] = ErbRender::from_hash(node_config['memory'], {})

        vm_config.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory",  node_config['memory']]
          vb.customize ["modifyvm", :id, "--cpus",    node_config['cores']]  unless node_config['cores'].nil?
          vb.customize ["modifyvm", :id, "--vrde", "on"]                     unless node_config['vrdp'].nil?
          vb.customize ["modifyvm", :id, "--vrdeport", node_config['vrdp']]  unless node_config['vrdp'].nil?
          vb.customize ["modifyvm", :id, "--vrdemulticon", "on"]             unless node_config['vrdp'].nil?
        end

        # Define networks
        ip_suffix = ErbRender::from_hash(node_config['ip_suffix'], { count: count }) 

        unless node_config['networks'].nil?
          node_config['networks'].each do |interface, interface_cfg|

            if interface_cfg == 'nil' || interface_cfg.nil?
              next unless base_config['networks'].has_key?(interface)

              ip            = env_base['networks'][interface]['ip']
              netmask       = env_base['networks'][interface]['netmask']
              network_type  = env_base['networks'][interface]['type']
              auto_cfg      = false
            else
              ip            = interface_cfg['ip']
              netmask       = interface_cfg['netmask']
              network_type  = interface_cfg['type'].nil?    ? 'private_network' : interface_cfg['type']
              auto_cfg      = interface_cfg['autoconf'].nil?  ? true : interface_cfg['autoconf']
            end
                          
            ip  = ErbRender::from_hash( ip, { environment: environment, ip_suffix: ip_suffix })

            # pp "#{ip} | #{netmask} | #{network_type} | #{auto_cfg}"
            vm_config.vm.network network_type, ip: ip, netmask: netmask, auto_config: auto_cfg
          end
        end

        # Define portforwarding
        port_offset = node_config['port_offset']
        port_offset = ErbRender::from_hash( port_offset, { count: count }) if port_offset
                
        unless node_config['port_forward'].nil?
          node_config['port_forward'].each do |port_forward_config|
            host = port_forward_config['host']
            host = ErbRender::from_hash( host, { port_offset: port_offset })

            #pp "#{node_identifier}" + 'port guest: ' + port_forward_config['guest'].to_s + ', host: ' + host.to_s

            if port_forward_config['guest_ip'].nil?
              vm_config.vm.network :forwarded_port, guest: port_forward_config['guest'], host: host
            else
              guest_ip = port_forward_config['guest_ip']
              guest_ip = ErbRender::from_hash( guest_ip, { environment: environment, count: count })
               
              pp "#{node_identifier}" + 'port guest: ' + port_forward_config['guest'].to_s + ', host: ' + host.to_s + ', guest_ip: ' + guest_ip.to_s
              
              vm_config.vm.network :forwarded_port, guest: port_forward_config['guest'], host: host, guest_ip: guest_ip
            end
          end
        end
         
        #Provision scripts
        unless node_config['provisioner'].nil?
          node_config['provisioner'].each do |script|
            unless node_config['env'].nil?
              vm_config.vm.provision "shell", path: script, env: node_config['env']
            else
              vm_config.vm.provision "shell", path: script
            end
          end
        end
      end
    end
  end
end