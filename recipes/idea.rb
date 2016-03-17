include_recipe 'java'

user = node['idea']['user']
group = node['idea']['group'] || user

edition = node['idea']['edition']
version = node['idea']['version']

setup_dir = node['idea']['setup_dir']
ide_dir = node['idea']['ide_dir'] || "idea-I#{edition}-#{version}"

install_path = File.join(setup_dir, ide_dir)
archive_path = File.join("#{Chef::Config[:file_cache_path]}", "ideaI#{edition}-#{version}.tar.gz")

if !::File.exists?("#{install_path}")

  # Download IDEA archive
  remote_file archive_path do
    source "https://download.jetbrains.com/idea/ideaI#{edition}-#{version}.tar.gz"
  end

  # Extract archive
  execute 'extract archive' do
    command "tar xf #{archive_path} -C #{Chef::Config[:file_cache_path]}/; mv #{Chef::Config[:file_cache_path]}/idea-I#{edition}-* #{install_path}; chown -R #{user}:#{group} #{install_path}"
    action :run
  end

  # vmoptions config
  template File.join("#{install_path}", "bin", "idea64.vmoptions") do
    source "idea64.vmoptions.erb"
    variables(
      :xms => node['idea']['64bits']['Xms'],
      :xmx => node['idea']['64bits']['Xmx']
    )
    owner user
    group group
    mode 0644
    action :create
  end

  # Delete archive
  file "#{archive_path}" do
    action :delete
  end

end
