module Lipstick
  module Api
    class CampaignViewResponse < Response
      csv_field :product_id, :product_name, :is_upsell
      csv_field :shipping_id, :shipping_name, :shipping_description
      csv_field :shipping_recurring_price, :shipping_initial_price
      csv_field :countries, :payment_name
    end
  end
end
