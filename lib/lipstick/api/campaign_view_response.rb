module Lipstick
  module Api
    class CampaignViewResponse < Response
      def initialize(fields)
        if fields[:response_code] == '100'
          [:product_id, :product_name, :is_upsell,
           :shipping_id, :shipping_name, :shipping_description,
           :shipping_recurring_price, :shipping_initial_price,
           :countries, :payment_name].each do |key|
            fields[key] = CSV.parse_line(fields[key])
          end
        end
        super fields
      end
    end
  end
end
