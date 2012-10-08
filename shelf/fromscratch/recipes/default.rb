#
# Cookbook Name:: fromscratch
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'fromscratch::aws'
include_recipe 'fromscratch::chef_orgs'
include_recipe 'fromscratch::chef_users'
include_recipe 'fromscratch::knife'
