module Lipstick
  module Api
    class NewOrderResponse < Response
      def initialize(fields)
        fields.keys.each do |key|
          fields[underscore(key.to_s).to_sym] = fields.delete(key)
        end
        if fields[:response_code] == '100'
          fields[:test] = (fields[:test] == '1')
          fields[:customer_id] = fields.delete(:customer_id).to_i
          fields[:order_id] = fields.delete(:order_id).to_i
        end
	    super(fields)
      end
    end
  end
end
