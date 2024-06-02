<template>
  <div class="main">
    <div class="title">Verifier</div>
    <div v-if="allowScan" class="qr-container">
      <QrcodeStream @detect="onDecode">
      </QrcodeStream>
    </div>
    <div v-else>
      <CButton color="primary" @click="scan">Scan QR Code on Certificate</CButton>
    </div>
    <div v-if="verifyStatus !== ''" style="width: 300px">
      <Vue3Lottie
        :animationData="verifyStatus === 'YES' ? yesAnimation : noAnimation"
        :loop="false"
      />
    </div>
  </div>
</template>

<script>
import { QrcodeStream } from 'vue-qrcode-reader'
import { CButton } from '@coreui/vue';
import axios from 'axios';
import YESAnimation from '../assets/yes.json'
import NOAnimation from '../assets/no.json'


export default {
  name: 'Verifier',
  components: { QrcodeStream, CButton },
  data() {
    return {
      allowScan: false,
      verifyStatus: "",
      recipientName: "",
      yesAnimation: YESAnimation,
      noAnimation: NOAnimation
    }
  },
  methods: {
    scan() {
      this.allowScan = true;
      this.verifyStatus = "";
      this.recipientName = "";
    },
    async onDecode(data) {
      try {
        if (data !== "") {
          console.log(data);
          this.allowScan = false;
          let value = data[0].rawValue;
          const response = await axios.get('https://certify-68856-default-rtdb.firebaseio.com/tickets.json');
          const jsonData = response.data;

          let recipientName = null;
          let details = null;

          for (const key in jsonData) {
            if (jsonData.hasOwnProperty(key)) {
              const ticketId = jsonData[key].ticket;
              if (ticketId === value) {
                recipientName = jsonData[key].recipient;
                details = jsonData[key].details;
                break; // Exit loop since we found the target ticket
              }
            }
          }
          if (recipientName) {
             alert(`Recipient for Certificate: ${recipientName} \n Got for: ${details}`);
          } else {
            alert(`Certificate not found.`);
          }
          this.verifyStatus = "YES"; // Assume validation is successful for now
        }
      } catch (err) {
        console.error('Error decoding QR code:', err);
      }
    },
  }
}
</script>

<style>
  .qrcode-stream-wrapper {
    display: flex;
  }
  .qrcode-stream-camera {
    max-width: 100% !important;
  }
</style>

<style scoped>
  .main {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 20px;
  }

  .qr-container {
    display: flex;
    margin-top: 20px;
  }
</style>
