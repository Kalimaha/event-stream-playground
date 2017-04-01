class OrdersController < ApplicationController
  def index
    orders = Order.all

    respond_to do |format|
      format.json { render(json: orders ) }
    end
  end

  def create
    model = nil

    case params['model'].upcase
    when 'P'
      model = OrdersHelper.model_p
    when 'H'
      model = OrdersHelper.model_h
    else
      model = OrdersHelper.model_f
    end

    order = Order.new(model)

    respond_to do |format|
      if order.save
        format.json { render(json: order ) }
      else
        format.json { render json: order.errors, status: :unprocessable_entity }
      end
    end
  end
end
