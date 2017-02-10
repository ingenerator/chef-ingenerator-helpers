service 'apache2' do
  action :nothing
end

notification_trigger 'Reload apache' do
  notifies :reload, 'service[apache2]', :delayed
end
