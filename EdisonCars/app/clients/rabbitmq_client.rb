class RabbitmqClient
  class << self
    def publish(message:)
      connection  = open_connection
      channel     = connection.create_channel
      exchange    = channel.fanout('orders', :durable => true)
      queue       = channel.queue('history', :auto_delete => false)

      exchange.publish(message, :persistent => true)
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
        :host => ENV['RABBITMQ_IP'],
        :user => ENV['RABBITMQ_USR'],
        :pass => ENV['RABBITMQ_PWD']
      }
    end
  end
end
