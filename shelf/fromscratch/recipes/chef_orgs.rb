#
# Cookbook Name:: fromscratch
# Recipe:: chef_orgs
#
# Copyright 2012, HippieHacker
#
# Apache License
#


chef_organizations = search(:chef_organizations, '*:*')

orgs_basedir = node['fromscratch']['chef_orgs_basedir']

if chef_organizations.length > 0
  directory orgs_basedir do
    recursive true
    mode '0700'
  end
end

chef_organizations.each do |org|
  org_dir= ::File.join(orgs_basedir,org['id'])
  org_validator_key_file = ::File.join(org_dir,'validator.pem') 
  directory org_dir do
    recursive true
    mode '0700'
  end
  file org_validator_key_file do
    mode '0700'
    content org['validation_key']
  end
  template ::File.join(org_dir,'org-knife.rb') do
    source 'org-knife.rb.erb'
    variables(org.to_hash.merge({
        :org_validator_key_file => org_validator_key_file
      }))
  end
end
