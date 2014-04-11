require 'active_support/notifications'

# ActiveSupport::Notifications.subscribe 'my_instrument' do |*args|

# end

# ActiveSupport::Notifications.instrument 'my_instrument'

# ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
#   # Rails.logger.debug(["notification:", name, start, finish, id, payload].join(" "))
#   Rails.logger.debug(payload)
# end

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

ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  if Rails.env.production? || Rails.env.development?
    client = TempoDB::Client.new("91afc86b2e83445198ce1511676dcca2", "151cdae2f03c4dfcbffb51d2f1244b98")
    params = payload[:params]

    base_key = "#{Rails.env}.#{params["controller"]}.#{params["action"]}"

    status_key = "#{base_key}.status.#{payload[:status]}"

    client.increment_key(status_key, [TempoDB::DataPoint.new(Time.now.utc, 1)]) unless payload[:status].nil?

    if payload[:status] == 200

      db_runtime_key = "#{base_key}.db_runtime"
      view_runtime_key = "#{base_key}.view_runtime"

      db_value = payload[:db_runtime]
      view_value = payload[:view_runtime]

      client.write_key(db_runtime_key, [TempoDB::DataPoint.new(Time.now.utc, db_value)]) if db_value.present?
      client.write_key(view_runtime_key, [TempoDB::DataPoint.new(Time.now.utc, view_value)])

    end
  end
end