#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Recipe:: package
#
# Copyright 2011, Opscode, Inc.
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

pkgs = value_for_platform(
  %w(centos redhat scientific fedora) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => %w(php53 php53-devel php53-cli php-pear),
    'default' => %w(php php-devel php-cli php-pear)
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-cgi php5 php5-dev php5-cli php-pear php5-tidy php5-sqlite php5-pgsql php5-mcrypt php5-gmp php5-gd php5-curl}
  },
  "default" => %w{ php5-cgi php5 php5-dev php5-cli php-pear }
)

include_recipe "apt"

execute "add-apt-repository" do
    command "sudo apt-get install python-software-properties -y"
    action :run
end

execute "add-apt-repository" do
    command "sudo add-apt-repository ppa:ondrej/php5-oldstable && sudo apt-get update"
    action :run
end

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['php']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end