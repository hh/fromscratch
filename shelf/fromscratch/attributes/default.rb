# This is a search of the databags, defaults to search(:databagname,id:*).first
default['fromscratch']['aws_account'] = '*'
default['fromscratch']['chef_organization'] = '*'
default['fromscratch']['chef_user'] = '*'
# intermediate config files
default['fromscratch']['aws_basedir'] = ::File.join(Chef::Config['file_cache_path'],'fromscratch','aws')
default['fromscratch']['chef_orgs_basedir'] = ::File.join(Chef::Config['file_cache_path'],'fromscratch','organizations')
default['fromscratch']['chef_users_basedir'] = ::File.join(Chef::Config['file_cache_path'],'fromscratch','chef_users')
# target knife config, comes from chef-solo
default['fromscratch']['knife_config'] = Chef::Config[:knife][:from_scatch_knife_config]
