#
# Cookbook Name:: fromscratch
# Recipe:: aws
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

chef_gem 'knife-ec2'

aws_accounts = search(:aws_accounts, '*:*')

aws_basedir = node['fromscratch']['aws_basedir']

if aws_accounts.length > 0
  directory aws_basedir do
    recursive true
    mode '0700'
  end
end

aws_accounts.each do |aws|
  aws_dir= ::File.join(aws_basedir,aws['id'])
  aws_private_key_file = ::File.join(aws_dir,'priv.pem') 
  aws_certificate_file = ::File.join(aws_dir,'cert.pem') 
  directory aws_dir do
    recursive true
    mode '0700'
  end
  file aws_private_key_file do
    mode '0700'
    content aws['aws_private_key']
  end
  file aws_certificate_file do
    mode '0700'
    content aws['aws_certificate']
  end
  template ::File.join(aws_dir,'ec2-env.sh') do
    source 'ec2-env.sh.erb'
    variables(aws.to_hash.merge({
        :aws_private_key_file => aws_private_key_file,
        :aws_certificate_file => aws_certificate_file
      }))
  end
  template ::File.join(aws_dir,'ec2-knife.rb') do
    source 'ec2-knife.rb.erb'
    variables(aws.to_hash)
  end
end
