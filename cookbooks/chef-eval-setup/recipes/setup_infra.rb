#
# Cookbook:: chef-eval-setup
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Vagrantfile for VM creation
template "#{node['base_dir']}/Vagrantfile" do
  source 'Vagrantfile.erb'
  owner node['run_user']
  group node['run_group']
  variables 'a2_ip': node['a2_ip'],
    'server_ip': node['server_ip'],
    'node_ip_base': node['node_ip_base'],
    'builder_ip': node['builder_ip'],
    'workstation_ip': node['workstation_ip']
end

# Scripts for VM configuration
directory "#{node['base_dir']}/scripts" do
  owner node['run_user']
  group node['run_group']
end

%w(setup_automate.sh setup_builder.sh setup_node.sh setup_server.sh setup_workstation.sh).each do |basename|
  template "#{node['base_dir']}/scripts/#{basename}" do
    source "#{basename}.erb"
    owner node['run_user']
    group node['run_group']
    mode '0755'
  end
end

# Built in roles
directory "#{node['base_dir']}/roles" do
  owner node['run_user']
  group node['run_group']
end

%w(base).each do |rolename|
  template "#{node['base_dir']}/roles/#{rolename}.rb" do
    source "#{rolename}_role.rb.erb"
    owner node['run_user']
    group node['run_broup']
  end
end

# Knife setup
directory "#{node['base_dir']}/.chef" do
  owner node['run_user']
  group node['run_group']
end

template "#{node['base_dir']}/.chef/knife.rb" do
  source 'knife.rb.erb'
  owner node['run_user']
  group node['run_group']
end

# Some other directories
directory "#{node['base_dir']}/tmp" do
  owner node['run_user']
  group node['run_group']
end

directory "#{node['base_dir']}/logs" do
  owner node['run_user']
  group node['run_group']
end

# Adding host entries for ease of use
if node['use_hosts_entries'].eql? 'yes'
  append_if_no_line 'Add A2 to hosts: automate-deployment.test' do
    line "#{node['a2_ip']}  automate-deployment.test"
    path '/etc/hosts'
  end

  append_if_no_line 'Add Chef Server to hosts: chef-server.test' do
    line "#{node['server_ip']}  chef-server.test"
    path '/etc/hosts'
  end

  append_if_no_line 'Add Hab Builder to hosts: builder.test' do
    line "#{node['builder_ip']}  builder.test"
    path '/etc/hosts'
  end

  append_if_no_line 'Add Workstation to hosts: workstation.test' do
    line "#{node['workstation_ip']}  workstation.test"
    path '/etc/hosts'
  end

  # Loop through and add all nodes: ugly-ish, but least chance of making trouble
  (0..9).each do |i|
    append_if_no_line "Add node1#{i} to hosts: node1#{i}.test" do
      line "#{node['node_ip_base']}#{i}  node1#{i}.test"
      path '/etc/hosts'
    end
  end
end
