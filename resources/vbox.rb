resource_name :vbox_install
default_action :install

property :version, String, name_property: true

action :install do
  latest = Chef::HTTP::Simple.new('http://download.virtualbox.org').get('virtualbox/LATEST.TXT').strip
  shasums = Chef::HTTP::Simple.new('http://download.virtualbox.org').get("virtualbox/#{latest}/SHA256SUMS")
  patch = /VirtualBox-#{latest}-(.*)-OSX.dmg/.match(shasums)[1]

  ver = new_resource.version.nil? ? "#{latest}-#{patch}" : new_resource.version
  semver = ver.split('-').first

  case node['platform']
  when 'mac_os_x'
    dmg_package "VirtualBox #{ver}" do
      app 'VirtualBox'
      source "http://download.virtualbox.org/virtualbox/#{semver}/VirtualBox-#{ver}-OSX.dmg"
      type 'pkg'
    end
  when 'ubuntu', 'debian'
    package 'dkms'
    package "linux-headers-#{node['kernel']['release']}" if node['platform'] == 'ubuntu'
    package 'linux-headers-amd64' if node['platform'] == 'debian'

    apt_repository 'virtualbox' do
      uri          'http://download.virtualbox.org/virtualbox/debian'
      arch         'amd64'
      distribution distribution node['lsb']['codename']
      components   ['contrib']
      key          'https://www.virtualbox.org/download/oracle_vbox_2016.asc'
      sensitive true
    end

    package 'virtualbox-5.1' do
      version "#{ver}~#{node['platform']}~#{node['lsb']['codename']}"
    end
  end

  expk_name = "Oracle_VM_VirtualBox_Extension_Pack-#{ver}.vbox-extpack"
  expk_path = ::File.join(Chef::Config[:file_cache_path], expk_name)

  execute 'vbox_extpack_install' do
    cwd Chef::Config[:file_cache_path]
    command <<-EOH
      VBoxManage extpack install #{expk_path} --replace --accept-license=#{node['bento']['ext_pack_license']}
    EOH
    action :nothing
  end

  remote_file expk_path do
    source "http://download.virtualbox.org/virtualbox/#{semver}/#{expk_name}"
    action :create_if_missing
    notifies :run, 'execute[vbox_extpack_install]', :immediately
  end
end
