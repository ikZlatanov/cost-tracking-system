require "simplecov"

SimpleCov.start "rails" do
  add_filter "/app/helpers/"
  add_filter "/app/channels/"
  add_filter "/app/mailers/"
  add_filter "/app/jobs/"

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Policies", "app/policies"
  add_group "Services", "app/services"
end

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_helper"

class ActiveSupport::TestCase
  parallelize(workers: 1)
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include SessionHelper
end