# vim: set syntax=ruby:

N = 2
Vagrant.configure('2') do |config|
  # The haproxy box will also be used as vault
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
      ansible_haproxy.groups = {
        'vault' => ['haproxy'],
      }
    end
  end

  (0..N).each do |it|
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

      # Run ansible only when all boxes are up
      if it == N
        config.vm.provision 'ansible' do |ansible_node|
          ansible_node.groups = {
            'nomad' => %w(node-0 node-1 node-2),
          }
          ansible_node.playbook = 'nomad.yml'
        end
      end
    end
  end
end
