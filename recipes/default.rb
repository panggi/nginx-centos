# Add the stable nginx repo
# see : http://wiki.nginx.org/Install

# create nginx repo
template "/etc/yum.repos.d/nginx.repo" do
  owner "root"
  group "root"
  more "0644"
  source "nginx.repo.erb"
end

bash 'adding stable nginx repo' do
  user 'root'
  code <<-EOC
    yum update
  EOC
end

# install nginx
package "nginx"

# create the new main nginx config file
template "/etc/nginx/nginx.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "nginx.conf.erb"
  notifies :run, "execute[restart-nginx]", :immediately
end

execute "restart-nginx" do
  command "/etc/init.d/nginx restart"
  action :nothing
end
