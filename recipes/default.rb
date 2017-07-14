#
# Cookbook Name:: bento
# Recipe:: default
#

include_recipe 'vagrant'

chef_ingredient 'chefdk' do
  version node['bento']['chefdk']
end

packer_install node['bento']['packer']
parallels_install node['bento']['parallels']
vbox_install node['bento']['virtualbox']
vmware_desktop 'vmware' do
  version node['bento']['vmware']
  license node['bento']['vmware_key']
end
