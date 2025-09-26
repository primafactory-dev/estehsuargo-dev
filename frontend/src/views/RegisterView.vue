<!-- file: src/views/RegisterView.vue -->
<template>
  <v-container class="fill-height d-flex justify-center align-center">
    <v-card width="400" elevation="5">
      <v-card-title class="text-center text-h5 py-4">
        Buat Akun Administrator
      </v-card-title>
      <v-card-text>
        <v-form @submit.prevent="handleRegister">
          <v-text-field
            v-model="formData.name"
            label="Nama Lengkap"
            prepend-inner-icon="mdi-account-outline"
            variant="outlined"
            required
          ></v-text-field>

          <v-text-field
            v-model="formData.email"
            label="Email"
            type="email"
            prepend-inner-icon="mdi-email-outline"
            variant="outlined"
            required
          ></v-text-field>
          
          <v-text-field
            v-model="formData.password"
            label="Password"
            type="password"
            prepend-inner-icon="mdi-lock-outline"
            variant="outlined"
            required
          ></v-text-field>

          <v-select
            v-model="formData.role"
            :items="['administrator', 'manager', 'cashier']"
            label="Peran"
            prepend-inner-icon="mdi-account-supervisor-outline"
            variant="outlined"
            required
          ></v-select>

          <v-btn type="submit" color="primary" block size="large" class="mt-2">Daftar</v-btn>
        </v-form>

        <div class="text-center mt-4">
          <router-link to="/login">Sudah punya akun? Kembali ke Login</router-link>
        </div>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';

const router = useRouter();
const formData = ref({
  name: '',
  email: '',
  password: '',
  role: 'administrator', // Langsung default ke administrator
});

const handleRegister = async () => {
  if (!formData.value.name || !formData.value.email || !formData.value.password) {
    Swal.fire('Perhatian!', 'Harap isi semua kolom.', 'warning');
    return;
  }

  try {
    Swal.fire({ title: 'Mendaftarkan...', text: 'Harap tunggu', didOpen: () => Swal.showLoading(), allowOutsideClick: false });

    // Kirim POST request ke backend
    const response = await apiClient.post('/auth/register', formData.value);
    
    Swal.close();
    await Swal.fire('Sukses!', response.data.msg, 'success');
    
    router.push('/login');

  } catch (error) {
    Swal.close();
    const errorMessage = error.response?.data?.msg || 'Terjadi kesalahan saat registrasi.';
    Swal.fire('Error!', errorMessage, 'error');
  }
};
</script>