instance_name = 'vncserver@:1'
account_username = node['vnc']['account_username'];
account_password = node['vnc']['account_password'];
account_home     = "/home/#{account_username}";
password_file    = "#{account_home}/.vnc/passwd";

# Ensure user exists
user "Create user #{account_username} to be used for running VNC and the desktop" do
  action :create
  shell "/bin/bash"
  home "#{account_home}"
  supports :manage_home => true
  username "#{account_username}"
end

# Add user to the sudo group.
group "sudo" do
  members "#{account_username}"
  action :create
  append true
end

directory "Create user's .vnc directory" do
  user "#{account_username}"
  group "#{account_username}"
  action :create
  recursive true
  path "#{account_home}/.vnc"
end

package 'tigervnc-server' do
  action :install
end

template "/lib/systemd/system/#{instance_name}.service" do
  source 'vncserver.service.erb'
  variables(
    :instance_name => instance_name,
    :user => account_username
  )
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'reload daemon' do
  command 'systemctl daemon-reload'
end

execute 'enable vncservice' do
  command 'systemctl enable vncserver@:1.service && systemctl start vncserver@:1.service'
end

# execute 'firewall policy' do
  # command 'firewall-cmd --permanent --add-service vnc-server && systemctl restart firewalld.service'
# end

#Create VNC password file for the user.
#Currently done manually after this recipe is complete when starting the vncserver service
execute "Create VNC password file" do
  user "#{account_username}"
  command "echo #{account_password} | vncpasswd -f > #{password_file}"
end

# Ensure ownership of the passwd file
execute "Ensure ownership of the passwd file" do
  user "root"
  command "chown #{account_username}:#{account_username} #{password_file} && chmod 0600 #{password_file}"
end

execute 'restart vncservice' do
  command 'systemctl restart vncserver@:1.service'
end

log "Finished configuring VNC server. VNC is now listening on port 5901." do
  level :info
end
