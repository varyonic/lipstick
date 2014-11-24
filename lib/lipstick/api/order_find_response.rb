module Lipstick
  module Api
    class OrderFindResponse < Response
      int_csv_field :order_ids
    end
  end
end
