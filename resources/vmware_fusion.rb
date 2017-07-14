resource_name :vmware_fusion

provides :vmware_desktop, platform: 'mac_os_x'

property :license, String, required: true, sensitive: true
property :version, String, name_property: true
property :source_url, String, default: lazy { |r| "http://download3.vmware.com/software/fusion/file/VMware-Fusion-#{r.version}.dmg" }

action :install do
  # borrowed from https://github.com/RoboticCheese/vmware-fusion-chef/blob/master/libraries/resource_vmware_fusion_config.rb#L44-L49
  execute 'init_fusion' do
    p = '/Applications/VMware Fusion.app/Contents/Library/Initialize VMware Fusion.tool'
    command "#{p.gsub(' ', '\\ ')} set '' '' '#{new_resource.license}'"
    sensitive true
    action :nothing
  end

  dmg_package 'VMware Fusion' do
    source source_url
    action :install
    notifies :run, 'execute[init_fusion]', :immediately
  end
end
