require 'active_support/notifications'
require "uri"
require "net/http"
ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  if Rails.env.production? || Rails.env.development?
    binding.pry
    USER_TOKEN = "0adc0060aa3dd9c"
    PROJECT_TOKEN = "7eeaa672e213267"
    API_URL = "http://localhost:3000/api/metrics"
    x = Net::HTTP.post_form(URI.parse("#{API_URL}?user_token=#{USER_TOKEN}&project_token=#{PROJECT_TOKEN}"), payload)
  end
end