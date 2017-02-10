if defined?(ChefSpec)
  def queue_notification_trigger(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:notification_trigger, :queue, resource_name)
  end
end
