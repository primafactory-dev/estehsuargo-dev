<!-- file: src/views/LoginView.vue -->
<template>
  <div class="background-container d-flex justify-center align-center pa-4">
    <v-card
      width="900"
      elevation="10"
      class="rounded-xl overflow-hidden"
    >
      <v-row no-gutters>
        <!-- Kolom Kiri: Form Login -->
        <v-col cols="12" md="6" class="login-form-panel pa-8 pa-md-12">
          <h2 class="text-h4 font-weight-bold mb-2">Welcome Back!</h2>
          <p class="text-medium-emphasis mb-8">Please enter your details below</p>

          <v-form @submit.prevent="handleLogin">
            <v-text-field
              v-model="email"
              label="Email"
              type="email"
              variant="outlined"
              required
              class="mb-4"
            ></v-text-field>
            <v-text-field
              v-model="password"
              label="Password"
              type="password"
              variant="outlined"
              required
            ></v-text-field>
            <v-btn type="submit" color="primary" block size="x-large" class="mt-4">
              Sign In
            </v-btn>
          </v-form>
          
          <!-- <div class="text-center mt-6">
            <span class="text-medium-emphasis">Don't have an account?</span>
            <router-link to="/register" class="text-primary font-weight-bold ml-2" style="text-decoration: none;">
              Sign Up
            </router-link>
          </div> -->
        </v-col>
        
        <!-- Kolom Kanan: Branding & Logo -->
        <v-col
          cols="12"
          md="6"
          class="branding-panel d-flex flex-column justify-center align-center pa-8 text-center"
        >
          <img 
          v-if="themeStore.currentTheme === 'dark'"
          src="@/assets/logo-white.png" 
          alt="Logo Estehku Dark" 
          style="height: 250px; margin-bottom: 20px;" 
        />
        <!-- Jika tidak, tampilkan logo standar (untuk mode terang) -->
        <img 
          v-else
          src="@/assets/logo.png" 
          alt="Logo Estehku" 
          style="height: 250px; margin-bottom: 20px;" 
/>
          <h1 class="text-h4 font-weight-bold mb-1">Your Business, Served Fresh</h1>
          <p class="text-body-1">
            Manage your sales, products, and staff anywhere, anytime.
          </p>
        </v-col>
      </v-row>
    </v-card>

    <v-btn
      @click="themeStore.toggleTheme"
      :icon="themeStore.currentTheme === 'light' ? 'mdi-weather-night' : 'mdi-weather-sunny'"
      variant="text"
      class="theme-toggle-btn"
    ></v-btn>
  </div>
</template>

<script setup>
// Bagian script tidak berubah, Anda bisa gunakan yang lama
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useThemeStore } from '@/stores/theme';
import { useAuthStore } from '@/stores/auth';
import { showSuccessAlert } from '@/utils/alerts';

const themeStore = useThemeStore();
const authStore = useAuthStore();
const router = useRouter();

const email = ref('admin@estehjoss.com');
const password = ref('password123');

const handleLogin = async () => {
  const success = await authStore.login({
    email: email.value,
    password: password.value,
  });
  if (success) {
    showSuccessAlert('Login Berhasil!');
    router.push('/app/dashboard');
  }
};
</script>

<style scoped>
/* Aturan Default untuk Light Mode */
.background-container {
  min-height: 100vh;
}
.theme-toggle-btn {
  position: absolute;
  top: 16px;
  right: 16px;
}
</style>