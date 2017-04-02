class EventStreamRepository
  class << self
    RABBITMQ_IP   = ENV['RABBITMQ_IP']
    RABBITMQ_USR  = ENV['RABBITMQ_USR']
    RABBITMQ_PWD  = ENV['RABBITMQ_PWD']

    def publish(order:)
      connection  = open_connection
      channel     = connection.create_channel
      exchange    = channel.fanout('orders', :durable => true)
      message     = create_message(order)

      exchange.publish(message, :persistent => true)

      queue       = channel.queue('history', :auto_delete => false)
      queue.bind(exchange)

      connection.close
    end

    private

    def open_connection
      connection = Bunny.new(connection_parameters)
      connection.start

      connection
    end

    def connection_parameters
      {
        :host => RABBITMQ_IP,
        :user => RABBITMQ_USR,
        :pass => RABBITMQ_PWD
      }
    end

    def create_message(order)
      message = order.attributes

      message.delete('id')
      message.delete('customer_credit_card_number')

      message.to_json
    end
  end
end
