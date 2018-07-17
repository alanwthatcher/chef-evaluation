# Removing host entries for ease of use
if node['use_hosts_entries'].eql? 'yes'
  delete_lines 'Remove A2 from hosts: automate-deployment.test' do
    pattern "#{node['a2_ip']}  automate-deployment.test"
    path '/etc/hosts'
  end

  delete_lines 'Remove Chef Server from hosts: chef-server.test' do
    pattern "#{node['server_ip']}  chef-server.test"
    path '/etc/hosts'
  end

  delete_lines 'Remove Hab Builder from hosts: builder.test' do
    pattern "#{node['builder_ip']}  builder.test"
    path '/etc/hosts'
  end

  delete_lines 'Remove Workstation from hosts: workstation.test' do
    pattern "#{node['workstation_ip']}  workstation.test"
    path '/etc/hosts'
  end

  # Loop through and add all nodes: ugly-ish, but least chance of making trouble
  (0..9).each do |i|
    delete_lines "Remove node1#{i} from hosts: node1#{i}.test" do
      pattern "#{node['node_ip_base']}#{i}  node1#{i}.test"
      path '/etc/hosts'
    end
  end
end