# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

require 'spec_helper'

RSpec.describe Slack::Web::Api::Endpoints::AdminTeamsOwners do
  let(:client) { Slack::Web::Client.new }
  context 'admin.teams.owners_list' do
    it 'requires team_id' do
      expect { client.admin_teams_owners_list }.to raise_error ArgumentError, /Required arguments :team_id missing/
    end
  end
end
