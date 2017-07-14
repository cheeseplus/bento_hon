# tests for a bento builder

describe package('git') do
  it { should be_installed }
end

describe file('/usr/local/bin/packer') do
  it { should exist }
  it { should be_executable }
end

describe command('vagrant --version') do
  its('stdout') { should match /Vagrant 1.9.7/ }
end

describe command('chef --version') do
  its('stdout') { should match /Chef Development Kit Version: 1.5.0/ }
end

describe command('VBoxManage --version') do
  its('stdout') { should match /5.1.22r115126/ }
end

case os[:family]
when 'debian'
  describe command('grep vmx /proc/cpuinfo') do
    its('stdout') { should match /vmx/ }
  end

  describe command('vmware --version') do
    its('stdout') { should match /VMware Workstation 12.5.7 build-5813279/ }
  end
when 'mac_os_x'
  path = File.join('/Applications/VMware\ Fusion.app/Contents/Library')
  fusion_cmd = File.join(path, 'vmware-vmx -v')
  describe command(fusion_cmd) do
    its('stdout') { should match /VMware Fusion 8.5.8 build-5824040 Release/ }
  end
end
