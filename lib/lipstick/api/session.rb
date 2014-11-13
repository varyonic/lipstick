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

      def shipping_method_find(params = {})
        call_api(:shipping_method_find, campaign_id: 'all')
      end

      def validate_credentials
        call_api(:validate_credentials)
      end

      protected
      def call_api(method, params = {})
        params = params.merge(method: method)
        logger.info "request = #{params.inspect}"
        response = post_form(uri_for(method), params.merge(credentials))
        logger.info "response = #{response.inspect}"
        api_response = parse_response(response)
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

      def parse_response(response)
        params = if response.body.include?(?=)
          CGI::unescape(response.body).split('&').inject({}) do |h,kv|
            k,v = kv.split('=')
            k = k.to_sym if k.match(/\w/)
            h.merge( k => v )
          end
        else
          { response_code: response.body }
        end
        Lipstick::Api::Response.new(params)
      end
    end
  end
end
