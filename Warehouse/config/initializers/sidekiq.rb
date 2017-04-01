unless ( File.basename($0) == 'rake')
  Sidekiq.configure_client do |config|
    Rails.application.config.after_initialize do
      EventStreamRepository.listen
    end
  end
end
