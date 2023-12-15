##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /
#
# frozen_string_literal: true

module Twilio
  module REST
    class Oauth
      class V1 < Version
        ##
        # Initialize the V1 version of Oauth
        def initialize(domain)
          super
          @version = 'v1'
          @oauth = nil
          @device_code = nil
          @openid_discovery = nil
          @token = nil
          @user_info = nil
        end

        ##
        # @return [Twilio::REST::Oauth::V1::OauthContext]
        def oauth
          @oauth ||= OauthContext.new self
        end

        ##
        # @return [Twilio::REST::Oauth::V1::DeviceCodeContext]
        def device_code
          @device_code ||= DeviceCodeList.new self
        end

        ##
        # @return [Twilio::REST::Oauth::V1::OpenidDiscoveryContext]
        def openid_discovery
          @openid_discovery ||= OpenidDiscoveryContext.new self
        end

        ##
        # @return [Twilio::REST::Oauth::V1::TokenContext]
        def token
          @token ||= TokenList.new self
        end

        ##
        # @return [Twilio::REST::Oauth::V1::UserInfoContext]
        def user_info
          @user_info ||= UserInfoContext.new self
        end

        ##
        # Provide a user friendly representation
        def to_s
          '<Twilio::REST::Oauth::V1>'
        end
      end
    end
  end
end