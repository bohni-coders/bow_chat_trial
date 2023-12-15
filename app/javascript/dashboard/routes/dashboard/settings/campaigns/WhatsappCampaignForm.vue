<template>
  <form class="conversation--form" @submit.prevent="onFormSubmit">
    <div v-if="showNoInboxAlert" class="callout warning">
      <p>
        {{ $t('NEW_CONVERSATION.NO_INBOX') }}
      </p>
    </div>
    <div v-else>
      <div class="row gutter-small">
        <div class="columns">
          <label>
            {{ $t('NEW_CONVERSATION.FORM.INBOX.LABEL') }}
          </label>
          <div class="multiselect-wrap--small">
            <multiselect
              v-model="targetInbox"
              track-by="id"
              label="name"
              :placeholder="$t('FORMS.MULTISELECT.SELECT')"
              selected-label=""
              select-label=""
              deselect-label=""
              :max-height="160"
              :close-on-select="true"
              :options="[...inboxes]"
            >
              <template slot="singleLabel" slot-scope="{ option }">
                <inbox-dropdown-item
                  v-if="option.name"
                  :name="option.name"
                  :inbox-identifier="computedInboxSource(option)"
                  :channel-type="option.channel_type"
                />
                <span v-else>
                  {{ $t('NEW_CONVERSATION.FORM.INBOX.PLACEHOLDER') }}
                </span>
              </template>
              <template slot="option" slot-scope="{ option }">
                <inbox-dropdown-item
                  :name="option.name"
                  :inbox-identifier="computedInboxSource(option)"
                  :channel-type="option.channel_type"
                />
              </template>
            </multiselect>
          </div>
          <label :class="{ error: $v.targetInbox.$error }">
            <span v-if="$v.targetInbox.$error" class="message">
              {{ $t('NEW_CONVERSATION.FORM.INBOX.ERROR') }}
            </span>
          </label>
        </div>
        <div class="columns">
          <label>
            {{ $t('NEW_CONVERSATION.FORM.TO.LABEL') }}
          </label>
          <div v-if="contacts" class="multiselect-wrap--small">
            <multiselect
              v-model="selectedContacts"
              track-by="id"
              label="name"
              :placeholder="$t('FORMS.MULTISELECT.SELECT')"
              selected-label=""
              select-label=""
              deselect-label=""
              :max-height="160"
              :close-on-select="true"
              :options="[...contacts]"
              :multiple="true"
            >
              <template slot="singleLabel" slot-scope="{ option, values }">
                <contact-dropdown-item
                  v-if="option.name"
                  :name="option.name"
                  :phone-number="option.phone_number"
                />
                <span v-else>
                  {{ values.length }} contacts selected
                </span>
              </template>
              <template slot="option" slot-scope="{ option }">
                <contact-dropdown-item
                  :name="option.name"
                  :phone-number="option.phone_number"
                />
              </template>
            </multiselect>
          </div>
          <label :class="{ error: $v.selectedContacts.$error }">
            <span v-if="$v.selectedContacts.$error" class="message">
              {{ $t('NEW_CONVERSATION.FORM.INBOX.ERROR') }}
            </span>
          </label>
        </div>
      </div>
      <div v-if="isAnEmailInbox" class="row">
        <div class="columns">
          <label :class="{ error: $v.subject.$error }">
            {{ $t('NEW_CONVERSATION.FORM.SUBJECT.LABEL') }}
            <input
              v-model="subject"
              type="text"
              :placeholder="$t('NEW_CONVERSATION.FORM.SUBJECT.PLACEHOLDER')"
              @input="$v.subject.$touch"
            />
            <span v-if="$v.subject.$error" class="message">
              {{ $t('NEW_CONVERSATION.FORM.SUBJECT.ERROR') }}
            </span>
          </label>
        </div>
      </div>
      <div class="row">
        <div class="columns">
          <div class="canned-response">
            <canned-response
              v-if="showCannedResponseMenu && hasSlashCommand"
              :search-key="cannedResponseSearchKey"
              @click="replaceTextWithCannedResponse"
            />
          </div>
          <div v-if="isEmailOrWebWidgetInbox">
            <label>
              {{ $t('NEW_CONVERSATION.FORM.MESSAGE.LABEL') }}
              <reply-email-head
                v-if="isAnEmailInbox"
                :cc-emails.sync="ccEmails"
                :bcc-emails.sync="bccEmails"
              />
              <label class="editor-wrap">
                <woot-message-editor
                  v-model="message"
                  class="message-editor"
                  :class="{ editor_warning: $v.message.$error }"
                  :enable-variables="true"
                  :placeholder="$t('NEW_CONVERSATION.FORM.MESSAGE.PLACEHOLDER')"
                  @toggle-canned-menu="toggleCannedMenu"
                  @blur="$v.message.$touch"
                />
                <span v-if="$v.message.$error" class="editor-warning__message">
                  {{ $t('NEW_CONVERSATION.FORM.MESSAGE.ERROR') }}
                </span>
              </label>
            </label>
          </div>
          <whatsapp-templates
            v-else-if="hasWhatsappTemplates"
            :inbox-id="targetInbox.id"
            @on-select-template="toggleWaTemplate"
            @on-send="onSendWhatsAppReply"
          />
          <label v-else :class="{ error: $v.message.$error }">
            {{ $t('NEW_CONVERSATION.FORM.MESSAGE.LABEL') }}
            <textarea
              v-model="message"
              class="message-input"
              type="text"
              :placeholder="$t('NEW_CONVERSATION.FORM.MESSAGE.PLACEHOLDER')"
              @input="$v.message.$touch"
            />
            <span v-if="$v.message.$error" class="message">
              {{ $t('NEW_CONVERSATION.FORM.MESSAGE.ERROR') }}
            </span>
          </label>
        </div>
      </div>
    </div>
    <div v-if="!hasWhatsappTemplates" class="modal-footer">
      <button class="button clear" @click.prevent="onCancel">
        {{ $t('NEW_CONVERSATION.FORM.CANCEL') }}
      </button>
      <woot-button type="submit" :is-loading="conversationsUiFlags.isCreating">
        {{ $t('NEW_CONVERSATION.FORM.SUBMIT') }}
      </woot-button>
    </div>
  </form>
</template>

<script>
import { mapGetters } from 'vuex';
import Thumbnail from 'dashboard/components/widgets/Thumbnail';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor';
import ReplyEmailHead from 'dashboard/components/widgets/conversation/ReplyEmailHead';
import CannedResponse from 'dashboard/components/widgets/conversation/CannedResponse.vue';
import InboxDropdownItem from 'dashboard/components/widgets/InboxDropdownItem';
import WhatsappTemplates from 'dashboard/routes/dashboard/conversation/contact/WhatsappTemplates.vue';
import alertMixin from 'shared/mixins/alertMixin';
import { INBOX_TYPES } from 'shared/mixins/inboxMixin';
import { ExceptionWithMessage } from 'shared/helpers/CustomErrors';
import { getInboxSource } from 'dashboard/helper/inbox';
import { required, requiredIf } from 'vuelidate/lib/validators';
import ContactAPI from 'dashboard/api/contacts';
import WhatsappCampaignsAPI from 'dashboard/api/whatsappCampaigns';
import ConversationApi from 'dashboard/api/conversations'
import ContactDropdownItem from 'dashboard/modules/contact/components/ContactDropdownItem.vue'

export default {
  components: {
    Thumbnail,
    WootMessageEditor,
    ReplyEmailHead,
    CannedResponse,
    WhatsappTemplates,
    InboxDropdownItem,
    ContactDropdownItem,
  },
  mixins: [alertMixin],
  props: {},
  data() {
    return {
      name: '',
      subject: '',
      message: '',
      showCannedResponseMenu: false,
      cannedResponseSearchKey: '',
      bccEmails: '',
      ccEmails: '',
      targetInbox: {},
      selectedContacts: [],
      contacts: [],
      whatsappTemplateSelected: false,
    };
  },
  validations: {
    subject: {
      required: requiredIf('isAnEmailInbox'),
    },
    message: {
      required,
    },
    targetInbox: {
      required,
    },
    selectedContacts: {
      required,
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'contacts/getUIFlags',
      conversationsUiFlags: 'contactConversations/getUIFlags',
      currentUser: 'getCurrentUser',
      contactList: 'contacts/getContacts',
      inboxList: 'inboxes/getWhatsAppInboxes',
    }),
    emailMessagePayload() {
      const payload = this.selectedContacts.map(contact => 
      {
        return {
          inbox_id: this.targetInbox.id,
          source_id: this.targetInbox.sourceId,
          contact_id: contact.id,
          mail_subject: this.subject,
          message: { content, template_params: templateParams },
          assignee_id: this.currentUser.id,
        };
      });
      if (this.ccEmails) {
        payload.message.cc_emails = this.ccEmails;
      }

      if (this.bccEmails) {
        payload.message.bcc_emails = this.bccEmails;
      }
      return payload;
    },
    showNoInboxAlert() {
      if (!this.contacts) {
        return false;
      }
      return this.inboxes.length === 0 && !this.uiFlags.isFetchingInboxes;
    },
    inboxes() {
      return this.inboxList.map(inbox => ({
        ...inbox,
        sourceId: inbox.channel_id,
      }));
    },
    isAnEmailInbox() {
      return (
        this.targetInbox &&
        this.targetInbox.channel_type === INBOX_TYPES.EMAIL
      );
    },
    isAnWebWidgetInbox() {
      return (
        this.targetInbox &&
        this.targetInbox.channel_type === INBOX_TYPES.WEB
      );
    },
    isEmailOrWebWidgetInbox() {
      return this.isAnEmailInbox || this.isAnWebWidgetInbox;
    },
    hasWhatsappTemplates() {
      return !!this.targetInbox?.message_templates;
    },
  },
  mounted() {
    this.contactsfun()
    .then(res => {
      this.contacts = res;
    }).catch(e => {
      this.showAlert(e.data);
    });

  },
  watch: {
    message(value) {
      this.hasSlashCommand = value[0] === '/' && !this.isEmailOrWebWidgetInbox;
      const hasNextWord = value.includes(' ');
      const isShortCodeActive = this.hasSlashCommand && !hasNextWord;
      if (isShortCodeActive) {
        this.cannedResponseSearchKey = value.substring(1);
        this.showCannedResponseMenu = true;
      } else {
        this.cannedResponseSearchKey = '';
        this.showCannedResponseMenu = false;
      }
    },
  },
  methods: {
    onCancel() {
      this.$emit('cancel');
    },
    onSuccess() {
      this.$emit('success');
    },
    replaceTextWithCannedResponse(message) {
      this.message = message;
    },
    toggleCannedMenu(value) {
      this.showCannedMenu = value;
    },
    prepareWhatsAppMessagePayload({ message: content, templateParams }) {
      const payload = this.selectedContacts.map(contact => 
      {
        return {
          inbox_id: this.targetInbox.id,
          source_id: this.targetInbox.sourceId,
          contact_id: contact.id,
          message: { content, template_params: templateParams },
          assignee_id: this.currentUser.id,
        };
      });

      return payload;
    },
    onFormSubmit() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        return;
      }
      this.createConversation(this.emailMessagePayload);
    },
    async createConversation(payload) {
      try {
        const data = await this.onSubmit(payload);
        const action = {
          type: 'link',
          to: `/app/accounts/${data.account_id}/conversations/${data.id}`,
          message: this.$t('NEW_CONVERSATION.FORM.GO_TO_CONVERSATION'),
        };
        this.onSuccess();
        this.showAlert(
          this.$t('NEW_CONVERSATION.FORM.SUCCESS_MESSAGE'),
          action
        );
      } catch (error) {
        if (error instanceof ExceptionWithMessage) {
          this.showAlert(error.data);
        } else {
          this.showAlert(this.$t('NEW_CONVERSATION.FORM.ERROR_MESSAGE'));
        }
      }
    },
    async onSubmit(contactItems) {
      let data = {}

      for(const item of contactItems){
        ConversationApi
        .create(item)
        .then(res => {
          data = res;
        }).catch(e => {
          this.showAlert(e.data)
        });


        // this.$store.dispatch(
        //   'contactConversations/create',
        //   item
        // ).then(res => {
        //   data = res;
        // }).catch(e => {
        //   this.showAlert(e.data)
        // });
      }

      const campaignDetails = {
        message: this.message,
        enabled: true,
        inbox_id: this.targetInbox.id,
        sender_id: this.currentUser.id,
        contacts: this.selectedContacts,
        message_template: contactItems[0].message
      }

      await WhatsappCampaignsAPI.create(campaignDetails);

      return data;
    },
    async contactsfun() {
      const res = await ContactAPI.get()

      const ct = res.data.payload;

      return ct;
    },
    runCreateConversation(){

    },
    toggleWaTemplate(val) {
      this.whatsappTemplateSelected = val;
    },
    async onSendWhatsAppReply(messagePayload) {
      const payload = this.prepareWhatsAppMessagePayload(messagePayload);
      await this.createConversation(payload);
    },
    inboxReadableIdentifier(inbox) {
      return `${inbox.name} (${inbox.channel_type})`;
    },
    computedInboxSource(inbox) {
      if (!inbox.channel_type) return '';
      const classByType = getInboxSource(
        inbox.channel_type,
        inbox.phone_number,
        inbox
      );

      return classByType;
    },
  },
};
</script>

<style scoped lang="scss">
.conversation--form {
  padding: var(--space-normal) var(--space-large) var(--space-large);
}

.canned-response {
  position: relative;
}

.input-group-label {
  font-size: var(--font-size-small);
}

.contact-input {
  display: flex;
  align-items: center;
  height: 3.9rem;
  background: var(--color-background-light);
  border: 1px solid var(--color-border);
  padding: var(--space-smaller) var(--space-small);
  border-radius: var(--border-radius-small);

  .contact-name {
    margin: 0;
    margin-left: var(--space-small);
    margin-right: var(--space-small);
  }
}

.message-input {
  min-height: 8rem;
}

.row.gutter-small {
  gap: var(--space-small);
}

::v-deep {
  .mention--box {
    left: 0;
    margin: auto;
    right: 0;
    top: unset;
    height: fit-content;
  }

  /* TODO: Remove when have standardized a component out of multiselect  */
  .multiselect .multiselect__content .multiselect__option span {
    display: inline-flex;
    width: var(--space-medium);
    color: var(--s-600);
  }
  .multiselect .multiselect__content .multiselect__option {
    padding: var(--space-micro) var(--space-smaller);
  }
}

</style>
