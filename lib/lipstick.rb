require 'logger'

module Lipstick
  module Api
  class Session
    attr_reader :base_url, :username, :password, :logger

      # Public: Initialize session.
    #
    # params - Hash
    # * +:url+ - API endpoint, eg. https://example.com/admin
    # * +:username+
    # * +:password+
    # * +:logger+
    def initialize(params)
        @base_url = params[:url] || raise("url not defined.")
        @username = params[:username] or raise("username missing")
        @password = params[:password] or raise("password missing")
        @logger   = params[:logger] || Logger.new(STDOUT)
      end

      def validate_credentials
        response = call(:validate_credentials, username: username, password: password)
        response.body == '100'
      end

      protected
      def call(method, params = {})
        params = params.merge(method: method)
        logger.info "request = #{params.inspect}"

        params.merge!(username: username, password: password)

        uri = uri_for(method)
        response = post_form(uri, params)

        logger.info "response = #{response.inspect}"
        response
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
    end
  end
end

