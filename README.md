# chef-scout

Installs the agent for [Pingdom server monitor](http://server.pingdom.com), a hosted server monitoring service. This recipe:

* Installs scoutd, the Scout monitoring daemon
* Runs scoutd

## Supported Platforms

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error:

* Ubuntu
* Debian
* Red Hat
* CentOS
* Fedora
* Scientific
* Amazon

## Recipes

* `scout` - The default recipe.

## Required Attributes

### [:scout][:account_key]

The agent requires a Scout account and the account's associated key. The key can be found in the account settings tab within the Scout UI or in the server setup instructions. The key looks like: `0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs`

Default value: `nil`

If the `[:scout][:account_key]` attribute is not provided the scout agent won't be installed but all other parts of the recipe will execute.

## Optional Attributes

### [:scout][:hostname]

Optional hostname to uniquely identify this host to Scout.

Default value: `nil`

### [:scout][:display_name]

Optional name to display for this node within the Scout UI.

Default value: `nil`

### [:scout][:roles]

An Array of roles for this node. Roles are defined through Scout's UI.

Default value: `nil`

### [:scout][:plugin_gems]

An Array of plugin gem dependencies to install. For example, you may want to install the `redis` gem if this node uses the redis plugin. Each entry in the array can be the name of a gem, or an array specifying the arguments required to install a specific version of a gem. For example, the following configuration will install the latest version of the `redis` gem: `node[:scout][:plugin_gems] = ['redis']` This configuration, on the other hand, will install version 3.2.1: `node[:scout][:plugin_gems] = [%w(redis --version 3.2.1)]`

Default value: `nil`

### [:scout][:ruby_path]

The full path to a ruby executable or rvm wrapper which will run the Scout Ruby code and where the gem dependencies will be installed. If installing under a user based RVM install, you should also set the `:user` and `:group` options in `:gem_shell_opts` (see below). Example: `:rvm_wrapper => "/home/vagrant/.rvm/wrappers/ruby-1.9.3-p547"`

Default value: `nil`

### [:scout][:gem_shell_opts]

A hash of valid [MixLib::ShellOut](https://github.com/opscode/mixlib-shellout) options. The recipe shells out to the `gem` command for installing gems. You can set things like the user/group to shell out as, shell environment variables such as $PATH, etc.

Default value: `nil`

### [:scout][:version]

Scout agent version to install. `nil` installs the latest release.

Default value: `nil`

### [:scout][:public_key]

If you use self-signed custom plugins, set this attribute to the public key value and it'll be installed on the node.

Default value: `nil`

### [:scout][:environment]

The environment you would like this server to belong to, if you use environments. Environments are defined through scoutapp.com's web UI.

Default value: `nil`

### [:scout][:plugin_properties]

Hash. Used to generate a plugins.properties file from string values or encrypted data bag items. For example, "haproxy.password" => "foobar" will create an entry "haproxy.password=foobar" in the plugins.properties file. Alternatively, "haproxy.password" => {"encrypted_data_bag" => "shared_passwords", "item" => "haproxy_stats", "key" => "password"} will create a plugins.properties entry with "haproxy.password=PASSWORD" where PASSWORD is an encrypted data bag item "haproxy_stats" in encrypted_data_bag "shared_passwords" with key "password".

Default value: `{}`

### [:scout][:delete_on_shutdown]

If true, will run a shutdown script to remove the server from Scout when the server is shutdown.

Default value: `nil`

### [:scout][:repo][:enable]

If true, will install the correct archive.scoutapp.com repository based on the hosts platform.  Only disable if you have the scoutd package hosted in a repository already installed on the host.

Default value: `true`

### [:scout][:key][:bag_name]

If speficied, the account_key will be loaded from the given encrypted data bag. (Note: must also specifiy `[:scout][:key][:item_name]`)

Default value: `nil`

### [:scout][:key][:item_name]

If speficied, the account_key will be loaded from the given encrypted data bag item under the `account_key` value in the bag. (Note: must also specifiy `[:scout][:key][:bag_name]`)

Default value: `nil`

## Questions?

Contact Scout (<support@server.pingdom.com>) with any questions, suggestions, bugs, etc.

## Authors and License

Additions, Modifications, & Updates:

Author: Derek Haynes (<support@scoutapp.com>)
Copyright: 2013, Scout
https://github.com/scoutapp/chef-scout

Author: Drew Blas (<drew.blas@gmail.com>)
Copyright: 2012, Drew Blas
https://github.com/drewblas/chef-scout_agent

Originally:

Author: Seth Chisamore (<schisamo@gmail.com>)
Copyright: 2010, Seth Chisamore
https://github.com/schisamo/chef_cookbooks

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
