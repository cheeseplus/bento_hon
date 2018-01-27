name             'bento'
maintainer       'Seth Thomas'
maintainer_email 'sthomas@chef.io'
license          'Apache-2.0'
description      'Sets up a bento builder'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'
chef_version     '>= 13'

issues_url       'https://github.com/cheeseplus/bento_hon'
source_url       'https://github.com/cheeseplus/bento_hon/issues'

%w(mac_os_x debian ubuntu).each do |os|
  supports os
end

depends 'chef-ingredient'
depends 'vagrant', '>= 0.7.1'
