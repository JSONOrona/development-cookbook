#
# Cookbook Name:: development-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
mysql_version = node['development']['mysql_version']

include_recipe 'yum::default'
include_recipe 'build-essential::default'
include_recipe 'virtualbox-guest-additions'
include_recipe 'git::default'
include_recipe 'development-cookbook::idea'
include_recipe "yum-mysql-community::#{mysql_version}"

=begin
directory '/opt/workspace' do
  owner 'vagrant'
  group 'vagrant'
  mode '0777'
  action :create
end

remote_file '/opt/workspace' do
  source node['development']['files_url']
  mode '0777'
  owner 'vagrant'
  action :create
end
=end
