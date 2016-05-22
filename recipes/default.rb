#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


#execute "sudo yum install java-1.7.0-openjdk-devel"

package 'java-1.7.0-openjdk-devel'

#sudo grpupadd tomcat'

group 'tomcat'

#sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
user 'tomcat' do 
manage_home false
shell '/bin/nolgin'
group 'tomcat'
home  '/opt/tomcat'
end
# Download  file from sever

#wget http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz
remote_file 'apache-tomcat-8.0.33.tar.gz'  do 
source 'http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
not_if { File.exists?('apache-tomcat-8.0.33.tar.gz')}
end
directory '/opt/tomcat/' do
	action :create
	group 'tomcat'
end

#TODO :Not Desired State
#execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat  --strip-components=1'

execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat  --strip-components=1' 
#cwd '/opt/tomcat'
#not_if { File.exists?('tomcat')}




#TODo esired State
#excute 'chgrp -R tomcat conf' 

directory '/opt/tomcat/conf' do
	mode '0070'
end
#TODo Not Desired State
execute 'chgrp -R tomcat /opt/tomcat/conf'


#TODo Not Desired State

execute 'chmod g+r /opt/tomcat/conf/* '
#TODo Not Desired State
execute 'chown -R tomcat /opt/tomcat/webapps	/opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs'

#xecute 'chown -R tomcat webapps/ work/ temp/ logs/ '

template '/etc/systemd/system/tomcat.service' do
	source 'tomcat.service.erb'
end
##Todo :Not Desired State
execute 'systemctl daemon-reload'
service 'tomcat' do
	action [:start, :enable]
end

