Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.synced_folder ".", "/home/ubuntu/webodm", create: true

  config.vm.provision "shell", path: "webodm_install.sh"


end
