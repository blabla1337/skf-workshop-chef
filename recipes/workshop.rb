#
# Cookbook Name:: skf-workshop-chef
# Recipe:: workshop
#
# Copyright 2015, Glenn ten Cate
#
# All rights reserved - Do Not Redistribute
#
#

# install dep
bash 'install owasp-skf dep' do
  not_if { ::File.exists? '/home/vagrant/skf-workshop/first-run.txt'}
  code <<-EOH

    apt-get update
    apt-get install python-software-properties  -y --force-yes
    add-apt-repository ppa:mapnik/boost
    add-apt-repository ppa:nginx/stable
    wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
    echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
    apt-get update
    apt-get install nginx -y --force-yes
    apt-get install hhvm -y --force-yes
    apt-get install git -y --force-yes

    apt-get install screen vim -y --force-yes
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
    apt-get install mysql-server -y --force-yes
    apt-get update

    sudo rm /etc/nginx/sites-enabled/default
    sudo ln -s /etc/nginx/sites-available/nginx-fastcgi /etc/nginx/sites-enabled/nginx-fastcgi

    EOH
end

#apply hdf conf
template 'config.hdf' do
  path '/etc/hhvm/my-config.hdf'
  source 'config.hdf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

#apply php conf
template 'php.ini' do
  path '/etc/hhvm/my-php.ini'
  source 'php.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

#apply nginx-fastcgi conf
template 'nginx-fastcgi' do
  path '/etc/nginx/sites-available/nginx-fastcgi'
  source 'nginx-fastcgi.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# setup owasp-skf workshop
bash 'setup owasp-skf workshop' do
  not_if { ::File.exists? '/vagrant/www/skf-workshop/first-run.txt'}
  code <<-EOH
    mkdir /vagrant
    mkdir /vagrant/www
    cd /vagrant/www; git clone https://github.com/blabla1337/skf-workshop.git
    EOH
end

#apply nginx-fastcgi conf
template 'xhp.php' do
  path '/vagrant/www/skf-workshop/xhp.php'
  source 'xhp.php.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# setup xhp lib
bash 'setup xhp lib' do
  not_if { ::File.exists? '/vagrant/www/skf-workshop/first-run.txt'}
  code <<-EOH
    cd /vagrant/www;  git clone https://github.com/facebook/xhp-lib.git
    EOH
end

# start server
bash 'start owasp-skf workshop' do
  not_if { ::File.exists? '/vagrant/www/skf-workshop/first-run.txt'}
  code <<-EOH
    service nginx restart
    service mysqld start
    echo "create database test" | mysql -u root -proot
    mysql -u root -proot  < /vagrant/www/skf-workshop/demo.sql
    cd /vagrant/www/skf-workshop; hhvm -m daemon -c /etc/hhvm/my-php.ini -v Eval.EnableXHP=1 -v Eval.EnableHipHopSyntax=true &
    EOH
end

# set flag install server
bash 'start owasp-skf flag' do
  code <<-EOH
    echo "1"  >> /vagrant/www/skf-workshop/first-run.txt
    chmod 777 -R  /vagrant/www/
    EOH
end
