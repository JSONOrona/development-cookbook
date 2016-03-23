include_recipe 'yumgroup'

yumgroup 'GNOME Desktop' do
  action :install
end

execute 'graphical target' do
  command 'systemctl set-default graphical.target && systemctl default'
end

yumgroup 'Graphical Administration Tools' do
  action :install
  #notifies :reboot_now, 'reboot[now]', :immediately
end

include_recipe 'development-cookbook::vnc'
# remove "rpm -e initial-setup initial-setup-gui". Thankfully these are not dependencies for anything.
# 4) Reboot: sync; echo 1 > /proc/sys/kernel/sysrq; echo b > /proc/sysrq-trigger
# Install tiger vnc
# http://www.krizna.com/centos/install-vnc-server-centos-7/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-remote-access-for-the-gnome-desktop-on-centos-7

=begin
reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 1
end
=end
