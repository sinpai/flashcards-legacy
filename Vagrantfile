# -*- mode: ruby -*-
# vi: set ft=ruby :

required_plugins = %w( vagrant-vbguest )
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end
Vagrant.configure("2") do |config|

  # Box used is CentOS 7
  config.vm.box = "centos/7"

  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './Berksfile'

  config.vm.network :forwarded_port, guest: 3000, host: 3000  # rails

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "git"
    chef.add_recipe "vim"
    chef.add_recipe "rbenv::default"
    chef.add_recipe "rbenv::ruby_build"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "nodejs::nodejs_from_binary"
    chef.add_recipe "flashcards-recipe"

    chef.json = {
      postgresql: {
        version: '9.5',
        config: {
          listen_addresses: '*'
        },
        pg_hba: [
          {type: "local", db: "all", user: "postgres", addr: nil, method: "trust"},
          {type: 'host', db: 'all', user: 'all', addr: '0.0.0.0/0', method: 'md5'},
          {type: 'host', db: 'all', user: 'all', addr: '::1/128', method: 'md5'}
        ],
        password: {
          postgres: "passpost"
        }
      },
      rbenv: {
        user_installs: [{
                          user: 'vagrant',
                          rubies: ["2.3.3"],
                          global: "2.3.3",
                          gems: {
                            "2.3.3" => [
                              { name: "bundler" }
                            ]
                          }
                        }]
      }
    }
  end
end
