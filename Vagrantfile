# vim: set syntax=ruby:

Vagrant.configure('2') do |config|
  (0..0).each do |it|
    config.vm.define :"node-#{it}" do |node|
      node.vm.box = 'generic/debian10'
      node.vm.hostname = "node-#{it}"
      node.vm.network :private_network,
          ip: "192.168.1.#{100 + it}",
          dev: 'bridge0',
          mode: 'bridge',
          type: 'bridge'

      # node.ssh.insert_key = true
      # node.ssh.private_key_path = ["ssh/insecure_key", "/home/asyd/.vagrant.d/insecure_private_key"]
      # node.vm.provision "file", source: "ssh/authorized_keys", destination: "~/.ssh/authorized_keys"

      config.vm.provision 'ansible' do |ansible_node|
        ansible_node.playbook = 'playbook.yml'
      end
    end
  end

  config.vm.define :haproxy do |node|
    node.vm.box = 'generic/debian10'
    node.vm.hostname = 'haproxy'
    node.vm.network :private_network,
      ip: '192.168.1.10',
      dev: 'bridge0',
      mode: 'bridge',
      type: 'bridge'

    config.vm.provision 'ansible' do |ansible_haproxy|
      ansible_haproxy.playbook = 'haproxy.yml'
    end
  end
end
