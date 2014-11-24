module Lipstick
  module Api
    class OrderFindUpdatedResponse < Response
      int_csv_field :order_ids
    end
  end
end
