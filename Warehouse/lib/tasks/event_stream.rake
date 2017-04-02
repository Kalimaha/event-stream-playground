namespace :event_stream do
  desc 'Synchronize the DB with the event stream history.'
  task sync_history: :environment do
    EventStreamRepository.sync
  end
end
