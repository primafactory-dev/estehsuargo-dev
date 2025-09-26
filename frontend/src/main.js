// file: src/main.js
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import { useAuthStore } from './stores/auth'

import './assets/main.css'

// Fungsi inisialisasi asinkron
async function initializeApp() {
  const app = createApp(App)
  app.use(createPinia())

  // PENTING: Panggil attemptLogin dan TUNGGU sampai selesai
  const authStore = useAuthStore()
  await authStore.attemptLogin()

  app.use(router)
  app.use(vuetify)
  app.mount('#app')
}

// Jalankan fungsi inisialisasi
initializeApp()