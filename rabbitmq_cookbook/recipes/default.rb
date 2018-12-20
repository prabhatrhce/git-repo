#
# Cookbook:: rabbitmq_cookbook
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
puts "Installing Erlang"
    remote_file "/tmp/erlang-21.2-1.el7.centos.x86_64.rpm" do
    source "https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/7/x86_64/erlang-21.2-1.el7.centos.x86_64.rpm"
    owner "root"
    group "root"
    mode 00644
    action :nothing
  end

  http_request "HEAD https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/7/x86_64/erlang-21.2-1.el7.centos.x86_64.rpm" do
    message ""
    url "https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/7/x86_64/erlang-21.2-1.el7.centos.x86_64.rpm"
    action :head
      if File.exists?("/tmp/erlang-21.2-1.el7.centos.x86_64.rpm")
        headers "If-Modified-Since" => File.mtime("/tmp/erlang-21.2-1.el7.centos.x86_64.rpm").httpdate
      end
    notifies :create, "remote_file[/tmp/erlang-21.2-1.el7.centos.x86_64.rpm]", :immediately
  end
  
  package "erlang" do
   action :install
   source "/tmp/erlang-21.2-1.el7.centos.x86_64.rpm"
   provider Chef::Provider::Package::Rpm
  end
 
  execute "wget https://forensics.cert.org/centos/cert/7/x86_64/socat-1.7.3.2-1.1.el7.x86_64.rpm" do
   cwd '/tmp'
  end

  package "socat" do
   action :install
   source "/tmp/socat-1.7.3.2-1.1.el7.x86_64.rpm"
   provider Chef::Provider::Package::Rpm
  end

  execute "wget http://mirror.centos.org/centos/7/os/x86_64/Packages/logrotate-3.8.6-17.el7.x86_64.rpm" do
   cwd '/tmp'
  end
  package "logrotate" do
   action :install
   source "/tmp/logrotate-3.8.6-17.el7.x86_64.rpm"
   provider Chef::Provider::Package::Rpm
  end

  execute "wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.9/rabbitmq-server-3.7.9-1.el7.noarch.rpm" do
   cwd '/tmp'
  end  
  package "rabbitmq" do
   action :install
   source "/tmp/rabbitmq-server-3.7.9-1.el7.noarch.rpm"
   provider Chef::Provider::Package::Rpm
  end

  execute "chkconfig rabbitmq-server on" do
   cwd '/tmp'
  end

  execute "rabbitmq-plugins enable rabbitmq_management" do
   cwd '/tmp'
  end

  execute "/sbin/service rabbitmq-server start" do
   cwd '/tmp'
  end
