class Api::OneOffApiCampaignService
  pattr_initialize [:campaign!]

  def perform
    raise "Invalid campaign #{campaign.id}" if campaign.inbox.inbox_type != 'API' || !campaign.one_off?
    raise 'Completed Campaign' if campaign.completed?

    # marks campaign completed so that other jobs won't pick it up
    campaign.completed!

    audience_label_ids = campaign.audience.select { |audience| audience['type'] == 'Label' }.pluck('id')
    audience_labels = campaign.account.labels.where(id: audience_label_ids).pluck(:title)
    process_audience(audience_labels)
  end

  private

  delegate :inbox, to: :campaign
  delegate :channel, to: :inbox

  def process_audience(audience_labels)
    campaign.account.contacts.tagged_with(audience_labels, any: true).each do |contact|
      next if contact.phone_number.blank? && contact.identifier.blank?

      contact_inbox = ContactInboxBuilder.new(contact: contact, inbox: inbox, source_id: nil, hmac_verified: false).perform
      next if contact_inbox.blank?

      conversation = find_conversation(contact.id)
      conversation = create_conversation(contact, contact_inbox.id) if conversation.blank?
      next unless conversation.persisted?

      blob_ids = campaign.attachments.map(&:deep_symbolize_keys).pluck(:resource).pluck(:id)

      blobs = ActiveStorage::Blob.where(id: blob_ids)


      puts "--------------------------------------------------------------------------------------------------------------"

      puts "Hello there"

      puts "--------------------------------------------------------------------------------------------------------------"

      message = {content: campaign.message, attachments: blobs}.with_indifferent_access
      Messages::MessageBuilder.new(nil, conversation, message).perform
    end
  end

  def find_conversation(contact_id)
    Conversation.find_by(inbox_id: inbox.id, contact_id: contact_id, account_id: campaign.account_id)
  end

  def create_conversation(contact, contact_inbox_id)
    Conversation.create({
      account_id: campaign.account_id,
      inbox_id: campaign.inbox_id,
      contact_id: contact.id,
      contact_inbox_id: contact_inbox_id
    })
  end

end
