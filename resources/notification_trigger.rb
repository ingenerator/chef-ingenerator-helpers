# notification_trigger is a no-op resource that just provides a place to manually
# queue delayed notifications, for example for a service that should always be
# reloaded after a provisioning run.
#
# Use it like:
#
#   notification_trigger 'Flush opcode cache' do
#     notifies :reload, 'service[apache2]', :delayed
#   end
#
resource_name :notification_trigger

property :name, String, name_property: true

default_action :queue

action :queue do
  converge_by 'trigger notification' do
    # Literally all we have to do is pretend this resource did something so chef
    # triggers its notifications
  end
end
