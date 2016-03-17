include_recipe 'yumgroup'

=begin
link '/lib/systemd/system/runlevel5.target' do
  to '/etc/systemd/system/default.target'
  link_type :symbolic
end
=end

yumgroup 'GNOME Desktop' do
  action :install
end

execute 'graphical target' do
  command 'systemctl set-default graphical.target && systemctl default'
end

yumgroup 'Graphical Administration Tools' do
  action :install
  notifies :reboot_now, 'reboot[now]', :immediately
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 1
end
