require 'logger'

module Lipstick
  module Api
  class Session
    attr_reader :base_url, :username, :password, :logger

      # Public: Initialize session.
    #
    # params - Hash
    # * +:url+ - API endpoint, eg. https://example.com/membership.php
    # * +:username+
    # * +:password+
    # * +:logger+
    def initialize(params)
        @base_url = params[:url] || raise("url not defined.")
        @username = params[:username] or raise("username missing")
        @password = params[:password] or raise("password missing")
        @logger   = params[:logger] || Logger.new(STDOUT)

        @uri = URI.parse(@base_url)
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
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

        request = Net::HTTP::Post.new(@uri.request_uri)
        request.set_form_data(params)

        response = @http.request(request)
        logger.info "response = #{response.inspect}"
        response
      end
    end
  end
end

