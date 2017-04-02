class EventStreamRepository
  class << self
    def listen
      RabbitmqClient.listen(message2order: message2order)
    end

    def sync
      puts "SYNC STARTED (Use Ctrl+C to stop)"
      puts "---------------------------------"

      RabbitmqClient.sync(message2order: message2order)
    end

    private

    def message2order
      Proc.new do |json|
        {
          external_id: json['external_id'],
          name: json['name'],
          price: json['price'],
          order_date: json['order_date'],
          delivery_date: json['delivery_date'],
          customer_name: json['customer_name'],
        }
      end
    end
  end
end
