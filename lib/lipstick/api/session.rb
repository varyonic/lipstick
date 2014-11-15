require 'csv'

module Lipstick
  module Api
    class Session
      # API endpoint, eg. {https://example.com/admin}[https://example.com/admin]
      attr_reader :base_url

      # Hash containing :username, :password
      attr_reader :credentials

      # Used for logging request and response info.
      attr_reader :logger

      # Public: Initialize session.
      #
      # params - Hash
      # * +:url+ - API endpoint, eg. {https://example.com/admin}[https://example.com/admin]
      # * +:username+
      # * +:password+
      # * +:logger+ - Used for logging request and response info.
      def initialize(params)
        @base_url = params[:url] || raise("url not defined.")
        raise("username missing") unless params[:username]
        raise("password missing") unless params[:password]
        @credentials = { username: params[:username], password: params[:password] }
        @logger   = params[:logger] || Logger.new('/dev/null')
      end

      # Find all active campaigns.
      def campaign_find_active
        call_api(:campaign_find_active) do |fields|
          fields[:response_code] = fields[:response]
          if fields[:response_code] == '100'
            [:campaign_id, :campaign_name].each do |key|
              fields[key] = CSV.parse_line(fields[key])
            end
          end
        end
      end

      # Fetch details for a given campaign.
      def campaign_view(campaign_id)
        call_api(:campaign_view, campaign_id: campaign_id) do |fields|
          if fields[:response_code] == '100'
            [:product_id, :product_name, :is_upsell,
             :shipping_id, :shipping_name, :shipping_description,
             :shipping_recurring_price, :shipping_initial_price,
             :countries, :payment_name].each do |key|
              fields[key] = CSV.parse_line(fields[key])
            end
          end
        end
      end

      def customer_find_active_product(customer_id, campaign_id = nil)
        params = { customer_id: customer_id }
        params.merge!(campaign_id: campaign_id) if campaign_id
        call_api(:customer_find_active_product, params) do |fields|
          if fields[:response_code] == '100'
            [:product_ids].each do |key|
              fields[key] = CSV.parse_line(fields[key]).map(&:to_i)
            end
          end
        end
      end

      # Create order for new customer
      def new_order(params)
        camelcase_params!(params)

        call_api('NewOrder', params) do |fields|
          fields.keys.each do |key|
            fields[underscore(key.to_s).to_sym] = fields.delete(key)
          end
          if fields[:response_code] == '100'
            fields[:test] = (fields[:test] == '1')
            fields[:customer_id] = fields.delete(:customer_id).to_i
            fields[:order_id] = fields.delete(:order_id).to_i
          end
        end
      end

      def order_refund(order_id, amount, keep_recurring = true)
        call_api(:order_refund,
                 order_id: order_id,
                 amount: amount.to_s,
                 keep_recurring: keep_recurring ? '1' : '0')
      end

      def order_void(order_id)
        call_api(:order_void, order_id: order_id)
      end

      def shipping_method_find(campaign_id = 'all')
        call_api(:shipping_method_find, campaign_id: campaign_id) do |fields|
          if fields[:response_code] == '100'
            [:shipping_ids].each do |key|
              fields[key] = CSV.parse_line(fields[key]).map(&:to_i)
            end
          end
        end
      end

      def validate_credentials
        call_api(:validate_credentials)
      end

      # partly copied from activesupport/inflector
      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.tr!("[", "_")
        word.tr!("]", "")
        word.downcase!
        word
      end

      protected
      # Munge params into style accepted by transaction API.
      def camelcase_params!(params)
        params.keys.select {|key| key.is_a?(Symbol) && key.to_s.include?(?_) }.each do |key|
          camelcase_key = key.to_s.split("_").each {|s| s.capitalize! }.join('')
          camelcase_key[0] = camelcase_key[0].chr.downcase
          params[camelcase_key] = params.delete(key)
        end
      end

      def call_api(method, params = {}, &block)
        params = params.merge(method: method)
        logger.info "request = #{params.inspect}"
        response = post_form(uri_for(method), params.merge(credentials))
        logger.info "response = #{response.inspect}"
        logger.debug "response.body = #{response.body}"
        api_response = parse_response(response, &block)
        logger.info "API response = #{api_response.inspect}"
        api_response
      end

      def uri_for(method)
        api = ['NewOrder'].include?(method) ? 'transact' : 'membership'
        URI.parse("#{base_url}/#{api}.php")
      end

      def post_form(uri, params)
        post = Net::HTTP::Post.new(uri.request_uri)
        post.set_form_data(params)
        request(uri, post)
      end

      def request(uri, request)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.request(request)
      end

      def parse_response(response, &block)
        fields = if response.body.include?(?=)
          CGI::unescape(response.body).split('&').inject({}) do |h,kv|
            k,v = kv.split('=')
            k = k.to_sym if k.match(/\w/)
            h.merge( k => v )
          end
        else
          { response_code: response.body }
        end
        yield fields if block_given?
        Lipstick::Api::Response.new(fields)
      end
    end
  end
end
