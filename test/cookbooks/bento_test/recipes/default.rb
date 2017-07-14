
include_recipe 'bento'

bento_dir = "#{Chef::Config[:file_cache_path]}/bento"

git bento_dir do
  repository 'git://github.com/chef/bento.git'
end

execute 'run packer build' do
  command <<-EOH
  cd #{bento_dir} && \
  packer build -only=virtualbox-iso -var headless=true ubuntu-16.04-amd64.json
  EOH
  live_stream true
end
