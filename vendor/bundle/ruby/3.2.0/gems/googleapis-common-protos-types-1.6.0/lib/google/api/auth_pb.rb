# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/api/auth.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("google/api/auth.proto", :syntax => :proto3) do
    add_message "google.api.Authentication" do
      repeated :rules, :message, 3, "google.api.AuthenticationRule"
      repeated :providers, :message, 4, "google.api.AuthProvider"
    end
    add_message "google.api.AuthenticationRule" do
      optional :selector, :string, 1
      optional :oauth, :message, 2, "google.api.OAuthRequirements"
      optional :allow_without_credential, :bool, 5
      repeated :requirements, :message, 7, "google.api.AuthRequirement"
    end
    add_message "google.api.JwtLocation" do
      optional :value_prefix, :string, 3
      oneof :in do
        optional :header, :string, 1
        optional :query, :string, 2
        optional :cookie, :string, 4
      end
    end
    add_message "google.api.AuthProvider" do
      optional :id, :string, 1
      optional :issuer, :string, 2
      optional :jwks_uri, :string, 3
      optional :audiences, :string, 4
      optional :authorization_url, :string, 5
      repeated :jwt_locations, :message, 6, "google.api.JwtLocation"
    end
    add_message "google.api.OAuthRequirements" do
      optional :canonical_scopes, :string, 1
    end
    add_message "google.api.AuthRequirement" do
      optional :provider_id, :string, 1
      optional :audiences, :string, 2
    end
  end
end

module Google
  module Api
    Authentication = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.Authentication").msgclass
    AuthenticationRule = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.AuthenticationRule").msgclass
    JwtLocation = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.JwtLocation").msgclass
    AuthProvider = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.AuthProvider").msgclass
    OAuthRequirements = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.OAuthRequirements").msgclass
    AuthRequirement = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.AuthRequirement").msgclass
  end
end
