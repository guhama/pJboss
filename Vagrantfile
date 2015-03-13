Vagrant.configure("2") do |config|
  module_name = "jboss"
  config.vm.box = "Centos 6.4 x64 2"
  config.vm.box_url = 'http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box'
  #config.vm.synced_folder ".", "/etc/puppet/modules/jboss", nfs: false
  config.vm.synced_folder "./hiera", "/etc/puppet", nfs: false
  vm = {
    ip: '192.168.57.100',
    hostname: module_name ,
  }

  config.vm.define vm[:hostname] do |dev|
    dev.vm.hostname = vm[:hostname]
    dev.vm.network :private_network, ip: vm[:ip]

    dev.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end
  end

  #config.vm.provision :puppet do |puppet|
  config.vm.provision :shell, :inline => <<-PUPPET
    #puppet.facter = {
    #  ipaddress: vm[:ip],
    #  keystore: '/vagrant/spec/fixtures/files/keystore',
    #}
    export FACTER_keystore='/vagrant/spec/fixtures/files/keystore'
    export FACTER_ipaddress=#{vm[:ip]}

    sudo -E puppet apply -d --modulepath='/vagrant/spec/fixtures/modules' /vagrant/spec/fixtures/manifests/site.pp

    #puppet.options = "--verbose --debug"
    #puppet.module_path = ['spec/fixtures/modules']
    #puppet.manifests_path = 'spec/fixtures/manifests'
    #puppet.manifest_file  = 'init.pp'

  PUPPET
end
