#
# Cookbook Name:: from_scratch
# Recipe:: knife
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# The default setting for each is *

aws_account       = search(:aws_accounts,       "id:#{node['fromscratch']['aws_account']}").first
chef_organization = search(:chef_organizations, "id:#{node['fromscratch']['chef_organization']}").first
chef_user         = search(:chef_users,         "id:#{node['fromscratch']['aws_account']}").first

template node['fromscratch']['knife_config'] do
  source 'knife.rb.erb'
  variables({
      :aws => aws_account,
      :chef_organization => chef_organization,
      :chef_user => chef_user
    })
end



