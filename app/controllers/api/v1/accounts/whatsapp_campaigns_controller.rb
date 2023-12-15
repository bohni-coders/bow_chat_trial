class Api::V1::Accounts::WhatsappCampaignsController < Api::V1::Accounts::BaseController
    before_action :campaign, except: [:index, :create]
    before_action :check_authorization
  
    def index
      @whatsapp_campaigns = Current.account.whatsapp_campaigns
    end
  
    def show; end
  
    def create
      @whatsapp_campaign = Current.account.whatsapp_campaigns.new(campaign_params)
      if @whatsapp_campaign.save
        CampaignConversationWorker.perform_async(@whatsapp_campaign.id)
      end
      head :ok
    end
  
    def update
      @whatsapp_campaign.update!(campaign_params)
    end
  
    def destroy
      @whatsapp_campaign.destroy!
      head :ok
    end
  
    private
  
    def campaign
      @whatsapp_campaign ||= Current.account.whatsapp_campaigns.find_by(display_id: params[:id])
    end
  
    def campaign_params
      params.require(:whatsapp_campaign).permit(:message, :enabled, :inbox_id, :sender_id, :message_template => {}, 
        :contacts => [:availability_status, :email, :id, :name, :phone_number, :identifier, :thumbnail, :conversations_count, :last_activity_at, :created_at, :additional_attributes => {}, :custom_attributes => {}]
      )
    end

  end
  