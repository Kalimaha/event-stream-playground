class Order < ActiveRecord::Base
  def find_by_external_id(external_id)
    Order.where(external_id: external_id).first
  end
end
