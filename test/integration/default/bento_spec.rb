# tests for a bento builder

describe command('git') do
  it { should exist }
end

describe command('/usr/local/bin/packer --version') do
  its('stdout') { should match /1.1.1/ }
end

describe command('/usr/local/bin/vagrant --version') do
  its('stdout') { should match /2.0.0/ }
end

describe command('/opt/chefdk/bin/chef --version') do
  its('stdout') { should match /2.3.4/ }
end

describe command('/usr/local/bin/vboxmanage --version') do
  its('stdout') { should match /5.1.30r118389/ }
end

case os[:family]
when 'debian'
  describe command('grep vmx /proc/cpuinfo') do
    its('stdout') { should match /vmx/ }
  end

  describe command('vmware --version') do
    its('stdout') { should match /12.5.7 build-5813279/ }
  end

  describe command('vagrant plugin list') do
    its('stdout') { should match /vagrant-vmware-workstation \(4.0.24\)/ }
  end
when 'darwin'
  describe command('/Applications/VMware\ Fusion.app/Contents/Library/vmware-vmx -v') do
    its('stderr') { should match /10.0.1 build-6754183/ }
  end

  describe command('/usr/local/bin/vagrant plugin list') do
    its('stdout') { should match /vagrant-vmware-fusion \(5.0.0\)/ }
    its('stdout') { should match /vagrant-parallels \(1.7.7\)/ }
  end
end
