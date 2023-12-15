class CampaignConversationWorker
  include Sidekiq::Worker
  
  def perform(whatsapp_campaign_id)
    @whatsapp_campaign = WhatsappCampaign.find_by(id: whatsapp_campaign_id)
    return if @whatsapp_campaign.blank?

    message = @whatsapp_campaign.message_template.with_indifferent_access
    contacts = @whatsapp_campaign.contacts
    contacts.each do |contact_attr|
      contact = Contact.find_by(id: contact_attr['id'])
      next if contact.blank?

      contact_inbox = ContactInboxBuilder.new(contact: contact, inbox: @whatsapp_campaign.inbox, source_id: nil, hmac_verified: false).perform
      next if contact_inbox.blank?

      conversation = find_conversation(contact_attr['id'])
      conversation = create_conversation(contact_attr, contact_inbox.id) if conversation.blank?
      next unless conversation.persisted?

      Messages::MessageBuilder.new(nil, conversation, message).perform
      sleep(2)
    end
  end

  private

  def find_conversation(contact_id)
    Conversation.find_by(inbox_id: @whatsapp_campaign.inbox_id, contact_id: contact_id, account_id: @whatsapp_campaign.account_id)
  end

  def create_conversation(contact_attr, contact_inbox_id)
    Conversation.create({
      account_id: @whatsapp_campaign.account_id,
      inbox_id: @whatsapp_campaign.inbox_id,
      contact_id: contact_attr['id'],
      contact_inbox_id: contact_inbox_id,
      additional_attributes: contact_attr['additional_attributes'],
      custom_attributes: contact_attr['custom_attributes']
    })
  end

end