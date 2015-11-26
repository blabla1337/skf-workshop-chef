#
# Cookbook Name:: skf-workshop-chef
# Recipe:: workshop
#
# Copyright 2015, Glenn ten Cate
#
# All rights reserved - Do Not Redistribute
#
#

# install dependancies 
%w(gcc.x86_64 git  mysql-server).each do |pkg|
  package pkg
end


# setup owasp-skf workshop
bash 'setup owasp-skf workshop' do
  not_if { ::File.exists? '/home/vagrant/skf-workshop'}
  code <<-EOH
    cd /home/vagrant; git clone https://github.com/blabla1337/skf-workshop.git
    EOH
end


# start server
bash 'start owasp-skf workshop' do
  not_if { ::File.exists? '/home/vagrant/skf-workshop/first-run.txt'}
  code <<-EOH
    apachectl restart
    service mysqld start
    mysql -u root  < /home/vagrant/skf-workshop/demo.sql
    mysqladmin -u root  password root
    cd /home/vagrant/skf-workshop; hhvm -m server &
    EOH
end

# set flag install server
bash 'start owasp-skf flag' do
  code <<-EOH
    echo "1"  >> /home/vagrant/skf-workshop/first-run.txt
    EOH
end
