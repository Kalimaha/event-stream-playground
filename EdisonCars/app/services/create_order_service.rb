class CreateOrderService
  class << self
    def call(model:)
      order = OrdersRepository.create(order_data: order_data(model))
      EventStreamRepository.publish(order: order)

      order
    end

    private

    def order_data(model)
      case model.upcase
      when 'P'
        OrdersHelper.model_p
      when 'H'
        OrdersHelper.model_h
      else
        OrdersHelper.model_f
      end
    end
  end
end
