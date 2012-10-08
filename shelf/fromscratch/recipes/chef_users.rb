#
# Cookbook Name:: pantry
# Recipe:: users
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


chef_users = search(:chef_users, '*:*')

users_basedir = node['fromscratch']['chef_users_basedir']

if chef_users.length > 0
  directory users_basedir do
    recursive true
    mode '0700'
  end
end

chef_users.each do |user|
  user_validator_key_file = ::File.join(users_basedir,"#{user['id']}.pem")
  file user_validator_key_file do
    mode '0700'
    content user['private_key']
  end
end
