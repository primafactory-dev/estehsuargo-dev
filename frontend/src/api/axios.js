// file: src/api/axios.js
// VERSI YANG SUDAH DIPERBAIKI UNTUK MENDUKUNG UPLOAD FILE

import axios from 'axios';
import { useAuthStore } from '@/stores/auth';

const apiClient = axios.create({
  baseURL: 'http://localhost:3001/api',
  // HAPUS header Content-Type default dari sini.
  // Ini memungkinkan Axios/browser untuk secara otomatis mengatur header
  // yang benar (application/json ATAU multipart/form-data)
  // tergantung pada jenis data yang dikirim.
});

// --- Request Interceptor ---
// Menempelkan token ke setiap request yang keluar
apiClient.interceptors.request.use(config => {
  const authStore = useAuthStore();
  const token = authStore.token;
  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`;
  }

  // Penting: JANGAN set Content-Type di sini, biarkan otomatis.
  // Jika config.data adalah FormData, Axios akan menanganinya.
  
  return config;
}, error => {
  return Promise.reject(error);
});

// --- Response Interceptor ---
// Menangani error global, terutama token kedaluwarsa (kode ini sudah bagus)
apiClient.interceptors.response.use(
  response => response, // Jika sukses, langsung kembalikan response
  error => {
    // Cek jika errornya adalah 401 Unauthorized (biasanya karena token salah/kedaluwarsa)
    // dan bukan dari endpoint login (untuk menghindari loop redirect)
    if (error.response && error.response.status === 401 && error.config.url !== '/auth/login') {
      const authStore = useAuthStore();
      console.error("Token tidak valid atau kedaluwarsa. Melakukan logout...");
      
      // Panggil aksi logout hanya jika user masih dianggap login di frontend
      if (authStore.isAuthenticated) {
        authStore.logout();
        // Arahkan ke halaman login.
        window.location.href = '/login';
      }
    }
    return Promise.reject(error); // Kembalikan error agar bisa ditangani lebih lanjut di komponen
  }
);

export default apiClient;