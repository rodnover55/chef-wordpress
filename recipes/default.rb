template "#{node['deploy-project']['path']}/wp-config.php" do
  source 'wp-config.php.erb'
  owner node['apache']['user']
  group node['apache']['group']
end