Description
===========

To start using a Chef server with Amazon EC2 requires a bit of
configuration.  You need all your ec2 credentials, pem files,
environment vars, then you need your chef organization and a chef
user. I wanted to make it easier to share these credentials as a
single data_bag each.

This is a base repo that uses contains no cookbooks, roles, or
data_bags. However it does contain a chef-solo config in
.chef/fromscratch.rb that will setup the ec2, ssh, chef-organization,
and chef-user credentials for the workstation.

It uses an ingredients folder instead of the data_bag folder for the chef-solo run.

* aws_accounts
* chef_organizations
* chef_users

It uses the shelf folder instead of the cookbooks folder to contain the 'fromscratch' recipe.

```chef-solo -c .chef/fromscratch.rb``` is run to generate your ```.chef/knife.rb```, including everything needed to use ```knife ec2 server create``` and ```spiceweasel infrastructure.yml```

Requirements
============

Ruby and bundler. (needs testing on windows)

Data Bags / Ingredients
=======================

The ```.chef/fromscratch.rb``` config uses the ingredients folder as it's databag source. The 'fromscratch' recipe includes a 'library/search.rb' which allows for searching these data bags from chef-solo.

There should be one file in each of the igredients folders.
They are data bags that will drive the creation of the various chef/ec2 environment, pem and knife.rb files.

To store CERTIFICATES and RSA/PRIVATE KEYS, you need to put them in a string format:

```
$ ruby -e "puts open('path/to/aws_cert.pem').read.inspect"
"-----BEGIN CERTIFICATE-----\n7BOm5NuhFxcYClSX6BDx\nTMokSkfpZlazw1taiu3s0hvcATbwRqtUm+iaD5kZlc5o/H4HrpfQQS+NSnh7oET7\nvvnm38h+UYxhgcLVBIYyWfZLvo0o2ir9/xmIhCjIlpcW9yPPx4cgyu9ICmDAiew8\nKTvUTv81spOC+QIDAQo8qv5OZ9wQmJ3IrzgNa5ABo1cwVTAOBgNVHQ8BAf8EBAMCBaAwFgYDVR0lAQH/BAww\nCgYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUyGa6KfSA1RR1kbAB\n3B9zbWuk9KIwDQYJKoZIhvcNAQEFBQADgYEAi0slT2Eik298lweEsDkz5irDLu2E\nUSJ+yO50gDAN5sNSoMNRuQu147SDhiNVW7Ev8aodJlivRyJ0KYHucaACrASLx0Na\nrl9QD20fbGvHqG3e8yLGHYfqJ1Sg4LzZHfyzQ2bmLvCI\nXSdH/GvDdWEE9xE=r0cVvmMA0GCSqGSIb3DQMIICdzCCAeCgAwIBAgIGAPEBBQUAMFMxCzAJBgNVBAYT\nAlVTMRMwEQYDVQQKEwpBbWF6b24uY29tMQwwCgYDVQQLEwNBV1MxITAfBgNVBAMT\nGEFXUyBMaW1pdGVkLUFzc3VyYW5jZSBDQTAeFw0xMTA0MDIxMzE3MzRaFw0xMjA0\nMDExMzE3MzRaMFIxCzAJBgNVBAYTAlVTMRMwEQYDVQQKEwpBbWF6b24uY29tMRcw\nFQYDVQQLEw5BV1MtRGV2ZWxvcGVyczEVMBMGA1UEAxMMeTJlNm5lczZ3Y3VvMIGf\nMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCDeYryRZNi\n-----END CERTIFICATE-----\n"
```

Cut and paste the output as the values to keys needing them.

aws_accounts
============


```javascript
{
    "id": "myaccount",
    "username": "myaccount@mycompany.com",
    "password": "aeteewiengahghohngiunaifooceunub",
    "aws_account_id": "3839299583892910",
    "aws_access_key_id": "GAHGHOHNGIUNAIFOOCEUNUB",
    "aws_secret_access_key": "anongahquaedooyuoheetheithiedoht",
    "aws_ssh_key_id": "myaccount",
    "aws_ssh_private_key": "-----BEGIN RSA PRIVATE KEY-----\r\nsufZWfZst....\r\n-----END RSA PRIVATE KEY-----",
    "aws_private_key": "-----BEGIN PRIVATE KEY-----\r\nsufZWfZst....\r\n-----END PRIVATE KEY-----",
    "aws_certificate": "-----BEGIN CERTIFICATE-----\r\nsufZWfZst....\r\n-----END CERTIFICATE-----"
}
```


chef_organizations
==================

```javascript
{ 
  "id": "myorg",
  "chef_server": "https://api.opscode.com/organizations/myorg",
  "validation_client_name": "myorg-validator",
  "validation_key": "-----BEGIN RSA PRIVATE KEY-----\n\nsufZWfZst....\r\n-----END RSA PRIVATE KEY-----"
}
```

chef_users
==================

```javascript
{ 
  "id": "myuser",
  "private_key": "-----BEGIN RSA PRIVATE KEY-----\nMfWfZst....\r\n-----END RSA PRIVATE KEY-----"
}
```


Attributes
==========

If you have more than one aws_account, chef_organization, or
chef_user, the first one returned from a search will be the one used.

```ruby
node['fromscratch']['aws_account'] = '*'
node['fromscratch']['chef_organization'] = '*'
node['fromscratch']['chef_user'] = '*'
```

```ruby
search(:aws_account,"id:#{node['fromscratch']['aws_account']}")
```

To override this, put a fromscratch.json in your .chef dir that sets which one you'd like to use:

```javascript
{
    "fromscratch":{
        "chef_organization": "org-number3",
        "chef_user": "user-number2",
        "aws_account": "aws-account-number4"
    },
    "run_list":[
        "recipe[fromscratch]"
    ]
}
```


Usage
=====

Fork and clone this repo as a starting point.

Populate ingredients/*/*json but do not upload them anywhere, they will contain all your secrets.

```
bundle install
bundle exec chef-solo -c .chef/fromscratch.rb
bundle exec knife cookbook upload -a
```