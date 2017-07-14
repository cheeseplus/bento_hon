#
# Cookbook Name:: buildkite
# Attributes:: default
#
# Copyright 2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['bento'].tap do |v|
  v['chefdk'] = '1.5.0'
  v['packer'] = '1.0.2'
  v['parallels'] = '12.2.0-41591'
  v['vagrant'] = '1.9.7'
  v['virtualbox'] = '5.1.22-115126'
  v['vmware'] = case node['platform']
                when 'mac_os_x'
                  '8.5.8-5824040'
                else
                  '12.5.7-5813279'
                end
  v['vmware_key'] = nil
end
