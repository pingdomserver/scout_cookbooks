if node[:scout][:key]
  scout_bin = Scout.scout_binary(node)
  name_attr = node[:scout][:name] ? %{ --name "#{node[:scout][:name]}"} : ""
  server_attr = node[:scout][:server] ? %{ --server "#{node[:scout][:server]}"} : ""
  roles_attr = node[:scout][:roles] ? %{ --roles "#{node[:scout][:roles].map(&:to_s).join(',')}"} : ""
  http_proxy_attr = node[:scout][:http_proxy] ? %{ --http-proxy "#{node[:scout][:http_proxy]}"} : ""
  https_proxy_attr = node[:scout][:https_proxy] ? %{ --https-proxy "#{node[:scout][:https_proxy]}"} : ""
  environment_attr = node[:scout][:environment] ? %{ --environment "#{node[:scout][:environment]}"} : ""

  cron "scout_run" do
    command "#{scout_bin} #{node[:scout][:key]}#{name_attr}#{server_attr}#{roles_attr}#{http_proxy_attr}#{https_proxy_attr}#{environment_attr}"
    action node[:scout][:cron_enabled] ? :create : :delete
    user node[:scout][:user]
  end
else
  Chef::Log.warn "The agent will not report to scoutapp.com as a key wasn't provided. Provide a [:scout][:key] attribute to complete the install."
end
