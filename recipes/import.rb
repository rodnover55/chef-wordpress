unless node['wordpress']['new_host'].nil? || node['deploy-project']['db']['install'].nil?
  include_recipe 'deploy-project::mysql'

  execute "Import wordpress database: #{node['deploy-project']['db']['database']}" do
    cat = case ::File.extname(node['deploy-project']['db']['install'])
            when '.gz'
              'zcat'
            else
              'cat'
          end

    password =
        if node['deploy-project']['db']['password'].nil? || (node['deploy-project']['db']['password'] == '')
          ''
        else
          " -p#{node['deploy-project']['db']['password']}"
        end

    only_if "[ $(mysql --host='#{node['deploy-project']['db']['host']}' -u#{node['deploy-project']['db']['user']}#{password} -e 'show tables' #{node['deploy-project']['db']['database']} | wc -c) = '0' ]"

    command "#{cat} '#{node['deploy-project']['path']}/#{node['deploy-project']['db']['install']}' | sed 's##{node['wordpress']['origin_host']}##{node['wordpress']['new_host']}#g' | mysql --host='#{node['deploy-project']['db']['host']}' -u#{node['deploy-project']['db']['user']}#{password} #{node['deploy-project']['db']['database']}"
    cwd node['deploy-project']['path']
  end
end
