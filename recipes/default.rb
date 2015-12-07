#
# Cookbook Name:: scout
# Recipe:: default

Chef::Log.info "Loading: #{cookbook_name}::#{recipe_name}"

case node[:platform]
when 'ubuntu'
  apt_repository "scout" do
    key "https://archive.scoutapp.com/scout-archive.key"
    uri "http://archive.scoutapp.com"
    components ["ubuntu", "main"]
    only_if { node[:scout][:repo][:enable] }
  end
when 'debian'
  apt_repository "scout" do
    key "https://archive.scoutapp.com/scout-archive.key"
    uri "http://archive.scoutapp.com"
    components [node[:lsb][:codename], "main"]
    only_if { node[:scout][:repo][:enable] }
  end
when 'redhat', 'centos'
  yum_repository "scout" do
    description "Scout server monitoring - scoutapp.com"
    baseurl "http://archive.scoutapp.com/rhel/$releasever/main/$basearch/"
    gpgkey "https://archive.scoutapp.com/RPM-GPG-KEY-scout"
    action :create
    only_if { node[:scout][:repo][:enable] }
  end
when 'fedora'
  yum_repository "scout" do
    description "Scout server monitoring - scoutapp.com"
    baseurl "http://archive.scoutapp.com/fedora/$releasever/main/$basearch/"
    gpgkey "https://archive.scoutapp.com/RPM-GPG-KEY-scout"
    action :create
    only_if { node[:scout][:repo][:enable] }
  end
end
when 'amazon'
  yum_repository "scout" do
    description "Scout server monitoring - scoutapp.com"
    baseurl "http://archive.scoutapp.com/amazon/$releasever/main/$basearch/"
    gpgkey "https://archive.scoutapp.com/RPM-GPG-KEY-scout"
    action :create
    only_if { node[:scout][:repo][:enable] }
  end
end

account_key = Scout.account_key(node)

if account_key
  ENV['SCOUT_KEY'] = node[:scout][:account_key]
  ENV['SCOUT_HOSTNAME'] = node[:scout][:hostname]
  ENV['SCOUT_DISPLAY_NAME'] = node[:scout][:display_name]
  ENV['SCOUT_LOG_FILE'] = node[:scout][:log_file]
  ENV['SCOUT_RUBY_PATH'] = node[:scout][:ruby_path]
  ENV['SCOUT_ENVIRONMENT'] = node[:scout][:environment]
  ENV['SCOUT_ROLES'] = node[:scout][:roles]
  ENV['SCOUT_AGENT_DATA_FILE'] = node[:scout][:agent_data_file]
  ENV['SCOUT_HTTP_PROXY'] = node[:scout][:http_proxy]
  ENV['SCOUT_HTTPS_PROXY'] = node[:scout][:https_proxy]

  package "scoutd" do
    action :install
    version node[:scout][:version]
  end

  Array(node[:scout][:groups]).each do |os_group|
    group os_group do
      action  :modify
      append  true
      members 'scoutd'
      system  true
      notifies :restart, 'service[scout]', :delayed
    end
  end

  # We only need the scout service definition so that we can
  # restart scout after we configure scoutd.yml
  service "scout" do
    action :nothing
    supports :restart => true
    restart_command "scoutctl restart"
  end

  template "/etc/scout/scoutd.yml" do
    source "scoutd.yml.erb"
    owner "scoutd"
    group "scoutd"
    variables :options => {
      :account_key => account_key,
      :hostname => node[:scout][:hostname],
      :display_name => node[:scout][:display_name],
      :log_file => node[:scout][:log_file],
      :ruby_path => node[:scout][:ruby_path],
      :environment => node[:scout][:environment],
      :roles => node[:scout][:roles],
      :agent_data_file => node[:scout][:agent_data_file],
      :http_proxy => node[:scout][:http_proxy],
      :https_proxy => node[:scout][:https_proxy]
    }
    action :create
    sensitive true
    notifies :restart, 'service[scout]', :delayed
  end
else
  Chef::Application.fatal! "The agent will not report to scoutapp.com as a key wasn't provided. Provide a [:scout][:account_key] or [:scout][:key][:bag_name] and [:scout][:key][:item_name] attribute to complete the install."
end

directory "/var/lib/scoutd/.scout" do
  owner "scoutd"
  group "scoutd"
  mode "0700"
  recursive true
end

if node[:scout][:public_key]
  template "/var/lib/scoutd/.scout/scout_rsa.pub" do
    source "scout_rsa.pub.erb"
    mode 0440
    owner "scoutd"
    group "scoutd"
    action :create
  end
end

if node[:scout][:delete_on_shutdown]
  template "/etc/rc0.d/scout_shutdown" do
    source "scout_shutdown.erb"
    owner "root"
    group "root"
    mode 0755
  end
else
  bash "delete_scout_shutdown" do
    user "root"
    code "rm -f /etc/rc0.d/scout_shutdown"
    only_if { File.exists?("/etc/rc0.d/scout_shutdown") }
  end
end

Array(node[:scout][:plugin_gems]).each do |gemname|
  # wrap calls to the Scout library in ruby_block
  ruby_block "install a gem" do
    block do
      Scout.install_gem(node, Array(gemname))
    end
  end
end

# Create plugin lookup properties
template "/var/lib/scoutd/.scout/plugins.properties" do
  source "plugins.properties.erb"
  mode 0664
  owner "scoutd"
  group "scoutd"
  variables lazy {
    plugin_properties = {}
    node['scout']['plugin_properties'].each do |property, value|
      if value.instance_of?(String)
        plugin_properties[property] = value
      else
        plugin_properties[property] = Chef::EncryptedDataBagItem.load(value[:encrypted_data_bag], value[:item])[value[:key]]
      end
    end
    {
      :plugin_properties => plugin_properties
    }
  }
  action :create
end
