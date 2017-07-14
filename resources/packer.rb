resource_name :packer_install
default_action :install

property :version, String, name_property: true
property :bin_dir, String, default: '/usr/local/bin'

action :install do
  ver = new_resource.version
  bin_dir = new_resource.bin_dir
  case node['platform']
  when 'mac_os_x'
    pkg_name = "packer_#{ver}_darwin_amd64.zip"
  when 'ubuntu', 'debian'
    package 'unzip'
    pkg_name = "packer_#{ver}_linux_amd64.zip"
  end

  pkg_path = ::File.join(Chef::Config[:file_cache_path], pkg_name)

  directory bin_dir do
    recursive true
    mode   '0755'
    action :create
  end

  execute 'unpack_packer' do
    cwd Chef::Config[:file_cache_path]
    command <<-EOH
      unzip #{pkg_path} -d #{bin_dir}
    EOH
    action :nothing
  end

  remote_file pkg_path do
    source "https://releases.hashicorp.com/packer/#{ver}/#{pkg_name}"
    action :create_if_missing
    notifies :run, 'execute[unpack_packer]', :immediately
  end
end
