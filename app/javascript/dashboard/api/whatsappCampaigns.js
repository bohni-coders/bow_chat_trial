import ApiClient from './ApiClient';

class WhatsappCampaignsAPI extends ApiClient {
  constructor() {
    super('whatsapp_campaigns', { accountScoped: true });
  }
}

export default new WhatsappCampaignsAPI();
