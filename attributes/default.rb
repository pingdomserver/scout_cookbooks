#
# See the README for a description of each attribute.
#

# required
default[:scout][:account_key] = nil

# optional
default[:scout][:hostname] = nil
default[:scout][:display_name] = nil
default[:scout][:log_file] = nil
default[:scout][:ruby_path] = nil
default[:scout][:environment] = nil
default[:scout][:roles] = nil
default[:scout][:agent_data_file] = nil
default[:scout][:version] = nil
default[:scout][:public_key] = nil
default[:scout][:http_proxy] = nil
default[:scout][:https_proxy] = nil
default[:scout][:delete_on_shutdown] = false	# create rc.d script to remove the server from scout on shutdown
default[:scout][:plugin_gems] = []   # list of gems to install to support plugins for role
default[:scout][:plugin_properties] = {}
default[:scout][:groups] = [] # list of groups to add the scoutd user to
default[:scout][:repo][:enable] = true # create the apt/yum repo files for the scoutd repo. Only disable if you have the scoutd package hosted in a repository already installed on the host

default[:scout][:key][:bag_name] = nil
default[:scout][:key][:item_name] = nil

default[:scout][:statsd][:addr] = nil
