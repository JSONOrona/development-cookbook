#
# Cookbook Name:: development-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

include_recipe 'yum::default'
include_recipe 'virtualbox-guest-additions'
include_recipe 'build-essential::default'
include_recipe 'git::default'
include_recipe 'yum-mysql-community::mysql56'
include_recipe 'development-cookbook::idea'
