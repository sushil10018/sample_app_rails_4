require 'active_support/notifications'

# ActiveSupport::Notifications.subscribe 'my_instrument' do |*args|

# end

# ActiveSupport::Notifications.instrument 'my_instrument'

ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  Rails.logger.debug(["notification:", name, start, finish, id, payload].join(" "))
  Rails.logger.debug(payload)
end

ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  # Rails.logger.debug(["notification:", name, start, finish, id, payload].join(" "))
end

# notification: process_action.action_controller 2014-04-11 15:57:47 +0545 2014-04-11 15:57:48 +0545 3feff8a938c5d8e1a88b 
# {
# :controller=>"StaticPagesController", 
# :action=>"home", 
# :params=>{"controller"=>"static_pages", "action"=>"home"}, 
# :format=>:html, 
# :method=>"GET", 
# :path=>"/", 
# :status=>200, 
# :view_runtime=>719.66, 
# :db_runtime=>4.069999999999999
# }