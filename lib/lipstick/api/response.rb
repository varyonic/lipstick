module Lipstick
  module Api
    class Response
      CODES = {
        100 => 'Success',
        200 => 'Invalid login credentials',
        320 => 'Invalid Product Id',
        321 => 'Existing Product Category Id Not Found',
        322 => 'Invalid Category Id',
        323 => 'Digital Delivery and Digital URL must be paired together and digital URL must be a valid URL',
        324 => 'Invalid rebill_product or rebill_days value',
        325 => 'Length Does Not Meet Minimum',
        326 => 'URL is invalid',
        327 => 'Payment Type Invalid',
        328 => 'Expiration Date Invalid (Must be in the format of MMYY with no special characters)',
        329 => 'Credit card must be either 15 or 16 digits numeric only',
        330 => 'No Status Passed',
        331 => 'Invalid Criteria',
        332 => 'Start and end date are required',
        333 => 'No Orders Found',
        334 => 'Invalid Start Date format',
        335 => 'Invalid End Date format',
        336 => 'Wild Card Unsupported for this search criteria',
        337 => 'Last 4 or First 4 must be 4 characters exactly',
        338 => 'Timestamp invalid',
        339 => 'Total Amount must be numeric and non-negative',
        340 => 'Invalid country code',
        341 => 'Invalid state code',
        342 => 'Invalid Email Address',
        343 => 'Data Element Has Same Value As Value Passed No Update done (Information ONLY, but still a success)',
        344 => 'Invalid Number Format',
        345 => 'Must be a 1 or 0.  "1" being "On" or true. "0" being "Off" or false.',
        346 => 'Invalid date format. Use mm/dd/yyyy',
        347 => 'Invalid RMA reason',
        348 => 'Order is already flagged as RMA',
        349 => 'Order is not flagged as RMA',
        350 => 'Invalid order Id supplied',
        351 => 'Invalid status or action supplied',
        352 => 'Uneven Order/Status/Action Pairing',
        353 => 'Cannot stop recurring',
        354 => 'Cannot reset recurring',
        355 => 'Cannot start recurring',
        356 => 'Credit card has expired',
        360 => 'Cannot stop upsell recurring',
        370 => 'Invalid amount supplied',
        371 => 'Invalid keep recurring flag supplied',
        372 => 'Refund amount exceeds current order total',
        373 => 'Cannot void a fully refunded order',
        374 => 'Cannot reprocess non-declined orders',
        375 => 'Cannot blacklist test payment method',
        376 => 'Invalid tracking number',
        377 => 'Cannot ship pending orders',
        378 => 'Order already shipped',
        379 => 'Order is fully refunded/voided',
        380 => 'Order is not valid for force bill',
        381 => 'Customer is blacklisted',
        382 => 'Invalid US state',
        383 => 'All military states must have a city of either "APO", "FPO". or "DPO"',
        384 => 'Invalid date mode',
        385 => 'Invalid billing cycle filter',
        386 => 'Order has already been returned',
        387 => 'Invalid return reason',
        388 => 'Rebill discount exceeds maximum for product',
        389 => 'Refund  amount must be greater than 0',
        390 => 'Invalid number of days supplied',
        400 => 'Invalid campaign Id supplied',
        401 => 'Invalid subscription type',
        402 => 'Subscription type 3 requires subscription week and subscription day values',
        403 => 'Invalid subscription week value',
        404 => 'Invalid subscription day value',
        405 => 'Subscription type 3 required for subscription week and subscription day values',
        406 => 'Rebill days must be a value between 1 and 31 for subscription type 2',
        407 => 'Rebill days must be greater than 0 if subscription type is 1 or 2',
        408 => 'Rebill days is invalid unless type is 1 or 2',
        409 => 'Subscription type 0, other subscription fields invalid',
        410 => 'API user: (api_username) has reached the limit of requests per minute: (limit) for method: (method_name)',
        411 => 'Invalid subscription field',
        412 => 'Missing subscription field',
        413 => 'Product is not subscription based',
        415 => 'Invalid subscription value',
        420 => 'Campaign does not have fulfillment provider attached',
        421 => 'This order was placed on hold',
        422 => 'This order has not been sent to fulfillment yet',
        423 => 'Invalid SKU',
        424 => 'Fulfillment Error, provider did not specify',
        425 => 'This order has been sent to fulfillment but has not been shipped',
        500 => 'Invalid customer Id supplied',
        600 => 'Invalid product Id supplied',
        601 => 'Invalid prospect Id supplied',
        602 => 'No prospects found',
        603 => 'Invalid customer Id supplied',
        604 => 'No customers found',
        700 => 'Invalid method supplied',
        701 => 'Action not permitted by gateway',
        702 => 'Invalid gateway Id',
        800 => 'Transaction was declined',
        901 => 'Invalid return URL',
        902 => 'Invalid cancel URL',
        903 => 'Error retrieving alternative provider data',
        904 => 'Campaign does not support an alternative payment provider',
        905 => 'Product quantity/dynamic price does not match',
        906 => 'Invalid quantity',
        907 => 'Invalid shipping Id',
        908 => 'Payment was already approved',
        1000 => 'SSL is required'
      }
      attr_reader :code, :message

      class << self
        def csv_field(*args)
          @csv_fields ||= []
          @csv_fields = @csv_fields + args
        end
      end

      def initialize(resp)
        @code = resp.delete(:response_code).to_i
        @message = CODES[@code]

        if @code == 100
          self.class.csv_field.each do |key|
            resp[key] = CSV.parse_line(resp[key])
          end
        end

        if !resp.empty?
          resp.each do |att, val|
            self.class.__send__(:attr_accessor, att)
            self.__send__("#{att}=", val)
          end
        end
      end
    end
  end
end
