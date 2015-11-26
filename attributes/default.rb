#
# Cookbook Name:: skf-workshop-chef
# Attributes:: default
#
# Copyright 2015, Glenn ten Cate
#
# All rights reserved - Do Not Redistribute
#
#

#default['skf-workshop-chef']['mysql']['use_ha'] = false
# TO DO

default[:hhvm][:installation_type]  = "package"
default[:hhvm][:setup_centos_epel_repo]  = "true"

