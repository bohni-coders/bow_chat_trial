<template>
  <div class="loader-container">
    <div class="w-full">
      <h4
        class="text-slate-700 dark:text-slate-200 block text-center w-full text-4xl font-thin mt-[30%]"
      >
        Generating QR Code
      </h4>
      <h6
        class="block text-slate-500 dark:text-slate-400 text-center my-4 w-full mx-auto"
      >
        This might take a while...
      </h6>
      <div class="loader">
        <div class="load-value" :style="{ width: progressBarWidth }" />
      </div>
    </div>
  </div>
</template>

<script>
import { io } from 'socket.io-client';
import axios from 'axios';
import 'highlight.js/styles/default.css';
import configMixin from 'shared/mixins/configMixin';

export default {
  mixins: [configMixin],
  props: {
    imageLoaded: { type: Boolean, default: false },
    imageSource: { type: String, default: '' },
    qrData: { type: Function, default: null },
  },
  data() {
    return {
      internalImageLoaded: this.imageLoaded,
      progress: 0,
      progressBarWidth: '0%',
      socket: null,
      socketState: 'connected',
    };
  },
  mounted() {
    // commented code is for socket
    // let url = 'http://0.0.0.0:3000'; // cross check with env

    // if (this.socket != null) this.socket.disconnect();

    // this.initSocket(url);

    // uncomment above code and comment below code if want to use socket

    const url = 'http://0.0.0.0:3000/get-qrcode'; // make it env variable

    setTimeout(this.updateProgress, 50);

    this.fetchSource(url);
  },
  methods: {
    changeImageSource(res) {
      let data = JSON.stringify(res);
      // comment out this line after testing
      this.$emit('update:imageSource', data.qrCode); // dummy .qrCode JSON.parse
      setTimeout(() => {
        this.progress = 100;
        this.progressBarWidth = this.progress + '%';
        this.$emit('update:imageLoaded', true);
      }, 3000);

      this.internalImageLoaded = data.qrCode !== '';
    },
    updateProgress() {
      if (this.progress <= 95) {
        this.progress += 2;
        this.progressBarWidth = this.progress + '%';

        setTimeout(this.updateProgress, 50);
      }
    },
    initSocket(url) {
      this.socket = io(url, {
        path: '/get-qrcode',
      });

      this.updateProgress();

      this.socket.on('dataEvent', data => {
        const route = data.route;

        switch (route) {
          case '/get-qrcode':
            this.$emit('update:imageSource', JSON.parse(data.data.data).qrCode); // check it
            setTimeout(() => {
              this.progress = 100;
              this.progressBarWidth = this.progress + '%';
              this.$emit('update:imageLoaded', true);
            }, 3000);

            this.internalImageLoaded = true;

            this.progress = 100;
            this.progressBarWidth = this.progress + '%';
            break;
          default:
          // Handle unknown or default route
        }
      });

      this.socket.on('connect_error', error => {
        bus.$emit('newToastMessage', error);
      });

      this.socket.on('disconnect', reason => {
        bus.$emit('newToastMessage', reason);
      });
    },
    fetchSource(url) {
      let config = {
        method: 'get',
        maxBodyLength: Infinity,
        url: url,
        headers: {},
        data: this.qrData,
      };

      axios
        .request(config)
        .then(res => {
          bus.$emit('newToastMessage', res);
          // this.changeImageSource(res.data);
        })
        .catch(error => {
          bus.$emit('newToastMessage', error);
        });
    },
  },
};
</script>

<style lang="scss" scoped>
.loader-container {
  position: relative;
  padding-top: 300px;

  .loader {
    margin-left: 15%;
    margin-right: 15%;
    top: 45%;
    width: 70%;
    height: 13.458px;
    flex-shrink: 0;
    border-radius: 16px;
    background: rgba(201, 215, 227, 1);
    align-items: start;

    .load-value {
      flex-shrink: 0;
      border-radius: 16px;
      height: 13.458px;
      background: rgba(55, 84, 109, 1);
    }

    @keyframes progress {
      0% {
        width: 0%;
      }

      100% {
        width: 100%;
      }
    }
  }
}
</style>
