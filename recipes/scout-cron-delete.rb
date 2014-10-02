  cron "scout_run" do
    user node[:scout][:user]
    action :delete
    only_if do "grep scout /var/spool/cron/crontabs/root" end
  end
