resource_name :vmware_workstation

provides :vmware_desktop, platform: %w(debian ubuntu)

property :license, String, required: true, sensitive: true
property :version, String, name_property: true
property :source_url, String, default: lazy { |r| "http://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-#{r.version}.x86_64.bundle" }

action :install do
  case node['platform']
  when 'ubuntu', 'debian'
    pkg_path = ::File.join(Chef::Config[:file_cache_path],
      /VMware-Workstation-Full.*/.match(new_resource.source_url)[0])

    # https://wiki.archlinux.org/index.php/VMware#Entering_the_Workstation_Pro_license_key
    execute 'install_ws' do
      user 'root'
      cwd '/tmp'
      command <<-EOH
      bash #{pkg_path}\
      --eulas-agreed\
      --console\
      --required\
      --set-setting vmware-workstation serialNumber #{new_resource.license}
      EOH
      sensitive true
      action :nothing
    end

    remote_file pkg_path do
      source new_resource.source_url
      action :create_if_missing
      notifies :run, 'execute[install_ws]', :immediately
    end
  else
    Chef::Log.info("VMware Workstation is not yet supported on #{node['platform']}")
  end
end
