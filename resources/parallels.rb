resource_name :parallels_install

default_action :install

property :version, String, name_property: true

action :install do
  case node['platform']
  when 'mac_os_x'
    semver = new_resource.version.split('-').first
    majver = semver.split('.')[0]
    app_path = '/Applications/Parallels Desktop.app'

    base_url = "http://download.parallels.com/desktop/v#{majver}/#{new_resource.version}"
    pkg_name = "ParallelsDesktop-#{new_resource.version}.dmg"
    sdk_name = "ParallelsVirtualizationSDK-#{new_resource.version}-mac.dmg"

    [pkg_name, sdk_name].each do |f|
      remote_file f do
        path File.join(Chef::Config[:file_cache_path], f)
        source "#{base_url}/#{f}"
        action :create_if_missing
        notifies :run, 'execute[Mount Parallels .dmg package]', :immediately
      end
    end

    execute 'Mount Parallels .dmg package' do
      command "hdiutil attach '#{pkg_path}'"
      not_if "hdiutil info | grep -q 'image-path.*#{pkg_path}'"
      not_if { ::File.exist?(app_path) }
    end
    execute 'Run Parallels installer' do
      init = ::File.join("/Volumes/Parallels Desktop #{majver}",
                         ::File.basename(app_path),
                         'Contents/MacOS/inittool').gsub(' ', '\\ ')
      command "#{init} install -t '#{app_path}' -s"
      creates app_path
    end
    execute 'Unmount Parallels .dmg package' do
      command "hdiutil detach '/Volumes/Parallels Desktop #{majver}' || " \
              "hdiutil detach '/Volumes/Parallels Desktop #{majver}' " \
              '-force'
      only_if "hdiutil info | grep -q 'image-path.*#{pkg_path}'"
    end
  else
    Chef::Log.info('Parallels can only be installed on macOS operating systems')
  end
end
