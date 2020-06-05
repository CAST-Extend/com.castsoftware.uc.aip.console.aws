Vagrant.configure("2") do |config|
  config.vm.box = "StefanScherer/windows_2019"
  config.vm.guest = :windows

  # Configure Vagrant to use WinRM instead of SSH
  config.vm.communicator = "winrm"

  # Configure WinRM Connectivity
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.provider "virtualbox" do |vb|
     vb.name = "webitest-WindowsServer2019"
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true
   end
end
