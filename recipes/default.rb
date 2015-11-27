#
# Cookbook Name:: skf-workshop-chef
# Recipe:: default
#
# Copyright 2015, Glenn ten Cate
#
# All rights reserved - Do Not Redistribute
#
#

# install mod_security
include_recipe 'hhvm::default'

# install owasp-skf workshop
include_recipe 'skf-workshop-chef::workshop'

