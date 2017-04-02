class EventStreamRepository
  class << self
    def publish(order:)
      message = create_message(order)

      RabbitmqClient.publish(message: message)
    end

    private

    def create_message(order)
      message = order.attributes

      message.delete('id')
      message.delete('customer_credit_card_number')

      message.to_json
    end
  end
end
