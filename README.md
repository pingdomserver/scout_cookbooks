# chef-scout

Installs the agent for [Scout](http://scoutapp.com), a hosted server monitoring service. This recipe:

* Installs the [Scout Ruby gem](https://rubygems.org/gems/scout)
* Configures a Cron job to run the monitoring agent

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

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="width:15%">[:scout][:key]</td>
      <td>
        The agent requires a Scout account and the account's associated key. The key can be found in the account settings tab within the Scout UI or in the server setup instructions. The key looks like:
          <code>0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs</code> 
      </td>
      <td style="width:15%"><code>nil</code></td>
    </tr>
  </tbody>
</table>

If the <code>[:scout][:key]</code> attribute is not provided or the scout executable is not found, the Cron job won't be installed but all other parts of the recipe will execute. 

## Optional Attributes

<table>
  <thead>
    <tr>
      <th style="width:20%">Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>[:scout][:user]</td>
      <td>User to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>[:scout][:group]</td>
      <td>User group to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>[:scout][:name]</td>
      <td>Optional name to display for this node within the Scout UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:roles]</td>
      <td>An Array of roles for this node. Roles are defined through Scout's UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:plugin_gems]</td>
      <td>An Array of plugin gem dependencies to install. For example, you may want to install the <code>redis</code> gem if this node uses the redis plugin.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:rvm_wrapper]</td>
      <td>The full path to an rvm wrapper where the scout gem and binary will be installed. Overrides <code>[:scout][:bin]</code>. If installing under a user based RVM install, you should also set the <code>:user</code> and <code>:group</code> options in <code>:gem_shell_opts</code> (see below). Example: <code>:rvm_wrapper => "/home/vagrant/.rvm/wrappers/ruby-1.9.3-p547"</code></td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:gem_shell_opts]</td>
      <td>A hash of valid <a href="https://github.com/opscode/mixlib-shellout">Mixlib::ShellOut</a> options. The recipe shells out to the <code>gem</code> command for installing gems. You can set things like the user/group to shell out as, shell environment variables such as $PATH, etc.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:bin]</td>
      <td>The full path to the scout gem executable. When <code>nil</code>, checks <code>Gem::bindir</code>via invoking the first ruby found in <code>$PATH</code> (see <code>:gem_shell_opts</code>), or if no ruby is found, the Chef internal ruby. This value is ignored when <code>[:scout][:rvm_wrapper]</code> is set.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:version]</td>
      <td>Gem version to install. <code>nil</code> installs the latest release.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:public_key]</td>
      <td>If you use self-signed custom plugins, set this attribute to the public key value and it'll be installed on the node.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:environment]</td>
      <td>The environment you would like this server to belong to, if you use environments. Environments are defined through scoutapp.com's web UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>[:scout][:plugin_properties]</td>
      <td>Hash. Used to generate a plugins.properties file from encrypted data bags for secure lookups. E.g. "haproxy.password" => {"encrypted_data_bag" => "shared_passwords", "item" => "haproxy_stats", "key" => "password"} will create a plugins.properties entry with "haproxy.password=PASSWORD" where PASSWORD is an encrypted data bag item "haproxy_stats" in encrypted_data_bag "shared_passwords" with key "password".</td>
      <td><code>{}</code></td>
    </tr>
    <tr>
      <td>[:scout][:cron_enabled]</td>
      <td>Boolean attribute to enable or disable scout_run in crontab.</td>
      <td><code>true</code></td>
  </tbody>
</table>

## Questions?

Contact Scout (<support@scoutapp.com>) with any questions, suggestions, bugs, etc.

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
