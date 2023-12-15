class CreateWhatsappCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :whatsapp_campaigns, force: :cascade do |t|
      t.integer "display_id", null: false
      t.text "message", null: false
      t.jsonb "message_template"
      t.integer "sender_id"
      t.boolean "enabled", default: true
      t.bigint "account_id", null: false
      t.bigint "inbox_id", null: false
      t.integer "campaign_status", default: 0, null: false
      t.jsonb "contacts", default: []

      t.timestamps
    end
  end
end
