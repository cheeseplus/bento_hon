#
# Cookbook Name:: bento
# Recipe:: default
#
apt_update if node['platform_family'].include?('debian')

include_recipe 'vagrant::default'

%w(vagrant-parallels vagrant-vmware-fusion).each do |plugin|
  vagrant_plugin plugin do
    user node['bento']['user']
  end
end

packer_install node['bento']['packer']

parallels_install node['bento']['parallels']

vbox_install node['bento']['virtualbox']

vmware_desktop 'vmware' do
  version node['bento']['vmware']
  license node['bento']['vmware_key']
end
