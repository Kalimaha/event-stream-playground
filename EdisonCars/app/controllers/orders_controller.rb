class OrdersController < ApplicationController
  def index
    orders = Order.all

    respond_to do |format|
      format.json { render(json: orders ) }
    end
  end

  def create
    order = CreateOrderService.call(model: params['model'])

    respond_to do |format|
      format.json { render(json: order ) }
    end
  end
end
