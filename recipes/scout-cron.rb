# schedule scout agent to run via cron
  cron "scout_run" do
    user node[:scout][:user]
    command "#{scout_bin} #{node[:scout][:key]}#{name_attr}#{server_attr}#{roles_attr}#{http_proxy_attr}#{https_proxy_attr}#{environment_attr}"
    only_if do File.exist?(scout_bin) end
  end

  cron "scout_run" do
    user node[:scout][:user]
    action :delete
    only_if do "grep scout /var/spool/cron/crontabs/root"
  end

