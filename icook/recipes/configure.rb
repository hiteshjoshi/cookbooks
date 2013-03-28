#
# Cookbook Name:: icook
# Recipe:: configs
#
# Copyright 2012, Richard Lee
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/application.yml" do
  source "application.yml.erb"
  mode 0755
  group deploy[:group]
  owner deploy[:user]
  variables(
    "aws" => node[:aws],
    "facebook" => node[:facebook],
    "fog" => node[:fog],
    "sendy" => node[:sendy],
    "elasticsearch" => node[:elasticsearch]
  )
  end

  host = node[:opsworks][:layers][:redis][:instances][:redis1][:private_ip]

  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    mode 0755
    group deploy[:group]
    owner deploy[:user]
    variables(
      "host" => host
    )
  end

  template "#{deploy[:deploy_to]}/shared/config/librato.yml" do
      source "librato.yml.erb"
      mode 0755
      group deploy[:group]
      owner deploy[:user]
      variables(
        "librato" => node[:librato]
      )
  end
end