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
  v['user'] = 'build'
  v['chefdk'] = '2.4.17'
  v['packer'] = '1.1.3'
  v['parallels'] = '13.2.0-43213'
  v['vagrant'] = '2.0.1'
  v['virtualbox'] = '5.2.4-119785'
  v['ext_pack_license'] = '56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb'
  v['vmware'] = case node['platform']
                when 'mac_os_x'
                  '10.1.0-7370838'
                else
                  '12.5.7-5813279'
                end
  v['vmware_key'] = nil
end
