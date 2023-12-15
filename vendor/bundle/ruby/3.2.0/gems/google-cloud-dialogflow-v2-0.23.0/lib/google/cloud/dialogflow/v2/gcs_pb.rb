# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/cloud/dialogflow/v2/gcs.proto

require 'google/protobuf'

require 'google/api/field_behavior_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("google/cloud/dialogflow/v2/gcs.proto", :syntax => :proto3) do
    add_message "google.cloud.dialogflow.v2.GcsSources" do
      repeated :uris, :string, 2
    end
    add_message "google.cloud.dialogflow.v2.GcsDestination" do
      optional :uri, :string, 1
    end
  end
end

module Google
  module Cloud
    module Dialogflow
      module V2
        GcsSources = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.cloud.dialogflow.v2.GcsSources").msgclass
        GcsDestination = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.cloud.dialogflow.v2.GcsDestination").msgclass
      end
    end
  end
end