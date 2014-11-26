require 'helper'

describe 'Lipstick::Api::OrderViewResponse' do
  describe 'initialize' do
    it 'parses the fields' do
      fields = {
        :response_code=>"100",
        :ancestor_id=>"581006",
        :customer_id=>"30346",
        :parent_id=>"2081410",
        :child_id=>nil,
        :order_status=>"11",
        :is_recurring=>"0",
        :first_name=>"Jim",
        :last_name=>"Smith",
        :shipping_first_name=>"Jim",
        :shipping_last_name=>"Smith",
        :shipping_street_address=>"1234 My Street",
        :shipping_street_address2=>"Apt 1",
        :shipping_city=>"Ottawa",
        :shipping_state=>"ON",
        :shipping_state_id=>"ON",
        :shipping_postcode=>"K1C2N6",
        :shipping_country=>"CA",
        :billing_first_name=>"Jim",
        :billing_last_name=>"Smith",
        :billing_street_address=>"1234 My Street",
        :billing_street_address2=>"Apt 1",
        :billing_city=>"Ottawa",
        :billing_state=>"ON",
        :billing_state_id=>"ON",
        :billing_postcode=>"K1C2N6",
        :billing_country=>"CA",
        :customers_telephone=>"(555)555-5555",
        :time_stamp=>"2014-11-26 16:34:33",
        :recurring_date=>"0000-00-00",
        :retry_date=>"N/A",
        :cc_type=>"offline",
        :cc_number=>"2822", # "N/A",
        :check_account_last_4=>"N/A",
        :check_routing_last_4=>"N/A",
        :check_ssn_last_4=>"N/A",
        :cc_expires=>"1219",
        :prepaid_match=>"N/A",
        :main_product_id=>"17",
        :main_product_quantity=>"1",
        :upsell_product_quantity=>nil,
        :upsell_product_id=>nil,
        :shipping_id=>"1",
        :shipping_method_name=>"USPS",
        :order_total=>"4.25",
        :transaction_id=>"5804215901", # "Not Available",
        :auth_id=>"02553Z", # "Not Available",
        :tracking_number=>nil,
        :on_hold=>"0",
        :on_hold_by=>nil,
        :hold_date=>nil,
        :shipping_date=>"Not Shipped",
        :email_address=>"test@test.com",
        :gateway_id=>"1",
        :preserve_gateway=>"0",
        :amount_refunded_to_date=>"0.00",
        :order_confirmed=>"NO_STATUS",
        :order_confirmed_date=>nil,
        :is_chargeback=>"0",
        :is_fraud=>"0",
        :is_rma=>"0",
        :rma_number=>nil,
        :rma_reason=>nil,
        :ip_address=>"127.0.0.1",
        :affiliate=>nil,
        :sub_affiliate=>nil,
        :decline_reason=>"N/A",
        :campaign_id=>"23",
        :order_sales_tax=>"0.00",
        :order_sales_tax_amount=>"0.00",
        :processor_id=>nil,
        :created_by_user_name=>nil,
        :created_by_employee_name=>nil,
        :billing_cycle=>"0",
        :click_id=>nil,
        :product_qty_17=>"1",
        :"products[0][product_id]"=>"1",
        :"products[0][sku]"=>"094922807700",
        :"products[0][price]"=>"0.00",
        :"products[0][name]"=>"Lipstick",
        :"products[0][on_hold]"=>"0",
        :"products[0][is_recurring]"=>"1",
        :"products[0][recurring_date]"=>"2014-12-26",
        :"products[0][product_qty]"=>"1",
        :"products[0][subscription_id]"=>"653cfc05e89438543a943731bbe6dbce",
        :"products[0][subscription_type]"=>"Bill by cycle",
        :"products[0][subscription_desc]"=>"Bills every 30 days"
      }
      response = Lipstick::Api::OrderViewResponse.new(fields)
      customer = response.customer
      assert_equal customer.id, 30346
      assert_equal customer.first_name, "Jim"
      assert_equal customer.last_name, "Smith"
      assert_equal customer.telephone, "(555)555-5555"
      assert_equal customer.email_address, "test@test.com"
      
      order = response.order
      assert_equal order.ancestor_id, 581006
      # assert_equal order.customer.id, 30346
      assert_equal order.parent_id, 2081410
      assert_equal order.status, 11

      assert_equal order.shipping.first_name, "Jim"
      assert_equal order.shipping.last_name, "Smith"
      assert_equal order.shipping.street_address, "1234 My Street"
      assert_equal order.shipping.street_address2, "Apt 1"
      assert_equal order.shipping.postcode, "K1C2N6"
      assert_equal order.shipping.country, "CA"
      assert_equal order.billing.marshal_dump, order.shipping.marshal_dump
      assert_equal order.created_at, DateTime.new(2014,11,26,16,34,33)
      assert_equal order.cc_number, "2822"

      assert_equal order.cc_expires, "1219"
      assert_equal order.shipping_method_name, "USPS"
      assert_equal order.order_total, BigDecimal.new('4.25')
      assert_equal order.transaction_id, '5804215901'
      assert_equal order.auth_id, '02553Z'
      assert_equal order.campaign_id, 23
    end
  end
end