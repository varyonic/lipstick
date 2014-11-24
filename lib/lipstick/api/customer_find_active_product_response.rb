module Lipstick
  module Api
    class CustomerFindActiveProductResponse < Response
      int_csv_field :product_ids
    end
  end
end
