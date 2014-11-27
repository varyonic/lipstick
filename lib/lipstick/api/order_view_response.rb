require 'pp'
require 'bigdecimal'
require 'ostruct'

module Lipstick
  module Api
    class OrderViewResponse < Response
      def initialize(fields)
        fields.keys.each do |key|
          fields[underscore(key.to_s).to_sym] = fields.delete(key)
        end
        fields[:customer] = OpenStruct.new(
          id:          fields.delete(:customer_id).to_i,
          first_name:  fields.delete(:first_name),
          last_name:   fields.delete(:last_name),
          telephone:   fields.delete(:customers_telephone),
          email_address: fields.delete(:email_address)
        )
        fields[:shipping] = OpenStruct.new(
          first_name:      fields.delete(:shipping_first_name),
          last_name:       fields.delete(:shipping_last_name),
          street_address:  fields.delete(:shipping_street_address),
          street_address2: fields.delete(:shipping_street_address2),
          city:            fields.delete(:shipping_city),
          state:           fields.delete(:shipping_state),
          state_id:        fields.delete(:shipping_state_id),
          postcode:        fields.delete(:shipping_postcode),
          country:         fields.delete(:shipping_country),
        )
        fields[:billing] = OpenStruct.new(
          first_name:      fields.delete(:billing_first_name),
          last_name:       fields.delete(:billing_last_name),
          street_address:  fields.delete(:billing_street_address),
          street_address2: fields.delete(:billing_street_address2),
          city:            fields.delete(:billing_city),
          state:           fields.delete(:billing_state),
          state_id:        fields.delete(:billing_state_id),
          postcode:        fields.delete(:billing_postcode),
          country:         fields.delete(:billing_country),
        )
        fields[:order] = OpenStruct.new(
          customer:        fields[:customer],
          ancestor_id:     fields.delete(:ancestor_id).to_i,
          child_id:        fields.delete(:child_id).to_i,
          status:          fields.delete(:order_status).to_i,
          is_recurring:    fields.delete(:is_recurring)=='1',
          shipping:        fields[:shipping],
          shipping_method_name: fields.delete(:shipping_method_name),
          billing:         fields[:billing],
          created_at:      DateTime.strptime(fields.delete(:time_stamp),'%Y-%m-%d %H:%M:%S'),
          cc_number:       fields.delete(:cc_number),
          cc_expires:      fields.delete(:cc_expires),
          campaign_id:     fields.delete(:campaign_id).to_i,

          order_total:     BigDecimal.new(fields.delete(:order_total)),
          parent_id:       fields.delete(:parent_id).to_i,
          transaction_id:  fields.delete(:transaction_id),
          auth_id:         fields.delete(:auth_id),
        )
      	# PP.pp fields # TODO: parse remaining fields
        super
      end
    end
  end
end
