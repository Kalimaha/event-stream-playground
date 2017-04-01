require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Dashboard
  class Application < Rails::Application
    config.after_initialize do
      Thread.new do
        EventStreamRepository.listen
      end
    end
  end
end
