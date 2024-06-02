<template>
  <div class="main">
    <div v-if="!certificateGenerated" class="form-section">
      <h2>Create a Certificate</h2>
      <form @submit.prevent="generateCertificate" class="certificate-form">
        <div class="form-group">
          <label for="recipientName">Recipient's Name:</label>
          <input v-model="recipientName" id="recipientName" required />
        </div>
        <div class="form-group">
          <label for="certificateDetails">Certificate Details:</label>
          <textarea v-model="certificateDetails" id="certificateDetails" rows="4" required></textarea>
        </div>
        <button type="submit">Save the Details</button>
      </form>
    </div>
    <div v-else>
      <div class="qr-section">
        <CButton color="success" :disabled="purchasing" @click="purchaseTicket">{{ purchaseButtonTitle }}</CButton>
        <div v-if="hasTicket && !purchasing" ref="qrContainer" class="qr-container">
          <div class="ticket-with-qr">
            <img class="ticket-image" src="~/assets/certi.png" />
            <div class="certificate-text">
              <p>{{ recipientName }}</p>
            </div>
            <qrcode-vue class="qr-code" render-as="svg" background="none" :value="ticket" :size="50" level="H" />
          </div>
        </div>
        <CButton class="download-button" color="primary" size="sm" @click="downloadAsPNG">Download Certificate</CButton>
        <div v-if="purchasing" class="loading-section">
          <CSpinner style="width: 50px; height: 50px" color="warning" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import QrcodeVue from 'qrcode.vue';
import { CButton, CSpinner } from '@coreui/vue';
import html2canvas from 'html2canvas';
import axios from 'axios'; // Import axios

export default {
  name: 'Generator',
  components: { QrcodeVue, CButton, CSpinner },
  data() {
    return {
      recipientName: '',
      certificateDetails: '',
      certificateGenerated: false,
      purchasing: false,
      ticketData: '',
      ticket: ''
    };
  },
  computed: {
    hasTicket() {
      return this.ticket !== '' && this.ticket !== undefined;
    },
    purchaseButtonTitle() {
      return this.purchasing ? 'Please wait...' : !this.hasTicket ? 'Generate Certificate' : 'Refresh QR';
    },
  },
  methods: {
    async generateCertificate() {
      try {
        // Generate a random ticket ID
        const ticketId = Math.random().toString(36).substr(2, 9);

        // Save the details to the Realtime Database using the REST API
        const response = await axios.post('https://certify-68856-default-rtdb.firebaseio.com/tickets.json', {
          recipientName: this.recipientName,
          certificateDetails: this.certificateDetails,
          ticketId: ticketId
        });

        if (response.status === 200) {
          this.ticket = ticketId; // Set the generated ticket ID
          this.certificateGenerated = true; // Update state to show the QR code section
        } else {
          console.error('Error generating certificate:', response.statusText);
        }
      } catch (error) {
        console.error('Error generating certificate:', error);
      }
    },
    async downloadAsPNG() {
      alert('Your Browser Does Not Support This Feature... Please Take A Screenshot Of The Certificate');
    },
    async purchaseTicket() {
      try {
        this.purchasing = true;
        const encodedData = await axios.get('https://certify-68856-default-rtdb.firebaseio.com/tickets.json');
        if (encodedData.status !== 200) {
          console.log(`Failed to get data from service: ${encodedData.status} ${encodedData.statusText}`);
          return;
        }
        this.ticketData = encodedData.data;
        window.localStorage.setItem('MyTicket', this.ticketData);
        this.$emit('gotKey', this.ticketData);
      } catch (err) {
        console.log(err);
      }
    }
  }
};
</script>

<style scoped>
.main {
  display: flex;
  margin-top: 2px;
  min-height: 100vh;
  background-color: #f0f0f0;
  font-family: Arial, sans-serif;
}

.form-section,
.qr-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 20px;
  text-align: center;
}

.certificate-form {
  max-width: 400px;
  width: 100%;
  margin-top: 1px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  font-weight: bold;
}

input,
textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 3px;
}

button {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 8px 12px;
  border-radius: 3px;
  cursor: pointer;
}

.qr-container {
  position: relative;
  text-align: center;
  margin-top: 20px;
}

.download-button {
  margin-top: 10px;
}

.ticket-with-qr {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.ticket-image {
  width: auto;
  height: auto;
  max-width: 100%;
}

.qr-code {
  width: 20%;
  height: auto;
  position: absolute;
  bottom: 0;
  left: 0;
  margin-bottom: 5.5%;
  margin-left: 1.8%;
  transform: translate(10px, 10px);
}

.certificate-text p {
  margin: 0;
  font-size: 40px;
  font-weight: bold;
  color: #000;
  text-align: center;
}

.certificate {
  position: relative;
  display: flex;
  align-items: flex-end;
  margin-bottom: 20px;
}

.certificate-text {
  position: absolute;
  top: 55%;
  left: 50%;
  transform: translate(-50%, -50%);
  padding: 10px;
  background-color: rgba(255, 255, 255, 0.8);
  text-align: center;
}

.loading-section {
  margin-top: 60px;
}
</style>
