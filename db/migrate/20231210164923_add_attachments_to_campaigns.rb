class AddAttachmentsToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :attachments, :jsonb
  end
end
