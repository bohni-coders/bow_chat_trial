<template>
  <div class="flex-shrink-0 flex-grow-0 w-[100%] h-full">
    <div v-if="imageLoaded" class="qr-code--container">
      <h3
        v-if="title"
        class="text-slate-700 dark:text-slate-200 block w-full text-4xl font-thin"
      >
        {{ title }}
      </h3>
      <p
        v-if="message"
        class="block text-slate-500 dark:text-slate-400 my-4 w-full mx-auto"
      >
        {{ message }}
      </p>
      <div class="code--codeopen-form w-full">
        <div class="qr-code--image">
          <img
            class="display-code"
            :src="imageSource"
            @image-source-change="handleInputChange"
          />
        </div>
        <div class="vertical-line" />
        <div class="qr-summary">
          <ol class="qr-instructions">
            <li class="qr-instruction">
              Open the WhatsApp number that you would like to connect with Boni
              Chat
            </li>
            <li class="qr-instruction">
              Open Settings
            </li>
            <li class="qr-instruction">
              Select the QR icon beside the profile name
            </li>
            <li class="qr-instruction">
              can the code displayed on the screen
            </li>
          </ol>
        </div>
      </div>
      <div
        v-if="imageLoaded"
        class="router flex w-full justify-center gap-2 mt-4"
      >
        <router-link
          class="button hollow primary"
          :to="{
            name: 'settings_inbox_show',
            params: { inboxId: this.inboxId },
          }"
        >
          {{ $t('INBOX_MGMT.FINISH.MORE_SETTINGS') }}
        </router-link>
        <router-link
          class="button success"
          :to="{
            name: 'inbox_dashboard',
            params: { inboxId: this.inboxId },
          }"
        >
          {{ $t('INBOX_MGMT.FINISH.BUTTON_TEXT') }}
        </router-link>
      </div>
    </div>

    <q-r-loader
      v-else
      class="loader-container w-full h-full p-8 flex flex-col items-center justify-items-center"
      :image-loaded="imageLoaded"
      :image-source="imageSource"
      :qr-data="getData"
      @update:imageLoaded="updateImageLoaded"
      @update:imageSource="updateImageSource"
    />
  </div>
</template>

<script>
import 'highlight.js/styles/default.css';
import './QRLoader.vue';
import QRLoader from './QRLoader.vue';
import configMixin from 'shared/mixins/configMixin';

export default {
  components: { QRLoader },
  mixins: [configMixin],
  props: {
    title: { type: String, default: '' },
    message: { type: String, default: '' },
    qrData: { type: Object, default: null },
    inboxId: { type: Number, default: null },
  },
  data() {
    return {
      imageLoaded: false,
      imageSource: '',
    };
  },
  mounted() {},
  methods: {
    updateImageLoaded(newValue) {
      this.imageLoaded = newValue;
    },
    updateImageSource(newValue) {
      this.imageSource = newValue;
    },
    getData() {
      return this.qrData;
    },
  },
};
</script>

<style lang="scss" scoped>
.qr-code--container {
  position: relative;
  text-align: left;
  overflow: auto;

  .code--codeopen-form {
    display: flex;
    height: 590px;
    width: 920px;
    top: 5727.6357421875px;
    left: 5792.65234375px;
    border-radius: 30px;
    background-color: rgba(223, 235, 247, 1);

    .qr-code--image {
      display: flex;
      width: 531.9px;
      justify-content: center;
      align-items: center;

      .display-code {
        width: 355px;
        height: 355px;
        background-color: rgba(223, 235, 247, 1);
        mix-blend-mode: multiply;
      }
    }

    .vertical-line {
      top: 34.75px;
      position: relative;
      width: 0;
      height: 90%;
      border-left: 1px solid rgba(144, 144, 144, 1);
      display: inline-block;
    }

    .qr-summary {
      display: flex;
      justify-content: center;
      width: 531.9px;
      align-items: center;

      .qr-instructions {
        color: rgba(111, 119, 131, 1);
        width: 379.49951171875px;

        .qr-instruction {
          margin-bottom: 20px;
          font-size: 25px;
          font-weight: 500;
          line-height: 30px;
          letter-spacing: -0.03em;
          text-align: left;
        }
      }
    }
  }
}
.router {
  text-align: center;
  margin: 10px;
}
</style>
