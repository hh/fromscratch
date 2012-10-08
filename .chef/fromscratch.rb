require 'fileutils'
current_dir = ::File.dirname(::File.absolute_path(__FILE__))
cookbook_path "#{current_dir}/../shelf"
data_bag_path "#{current_dir}/../ingredients"
file_cache_path "#{current_dir}/../.cache"
cache_options({ :path => "#{current_dir}/../.cache/checksums", :skip_expires => true })
knife[:from_scatch_knife_config] = "#{current_dir}/knife.rb"

# A data bag secret lets us use secret ingredients
encrypted_data_bag_secret_file = "#{current_dir}/encrypted_data_bag_secret"
if not ::File.exists? encrypted_data_bag_secret_file
  open(encrypted_data_bag_secret_file,'w') do |secretkeyfile|
    secretkeyfile.write(OpenSSL::PKey::RSA.new(512).to_pem.lines.to_a[1..-2].join)
  end
end
encrypted_data_bag_secret = encrypted_data_bag_secret_file


solo_json_file = "#{current_dir}/fromscratch.json"
default_solo_json_file = "#{current_dir}/../.cache/fromscratch.json"
FileUtils.mkdir_p "#{current_dir}/../.cache"
open(default_solo_json_file,'w+') do |f|
  f.write(
    {
      "run_list" => [
        "recipe[fromscratch]"
        ]
    }.to_json
    )
end

if not ::File.exists? solo_json_file
  json_attribs "#{default_solo_json_file}"
else
  json_attribs "#{solo_json_file}"
end
