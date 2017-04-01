require 'bunny'

class EventStreamRepository
  class << self
    RABBITMQ_IP   = '192.168.1.245'
    RABBITMQ_USR  = 'kalimarabbit'
    RABBITMQ_PWD  = '123456'

    def publish(order:)
      connection  = open_connection
      channel     = connection.create_channel
      exchange    = channel.fanout('orders', :durable => true)
      message     = create_message(order)

      exchange.publish(message, :persistent => true)

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
