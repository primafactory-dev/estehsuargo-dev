// file: src/stores/auth.js

import { defineStore } from 'pinia';
import apiClient from '@/api/axios';
import { showErrorAlert } from '@/utils/alerts'; // Pastikan ini diimpor
import { jwtDecode } from 'jwt-decode';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: {},
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,
    getUserRole: (state) => state.user?.role || null,
    isAdmin: (state) => state.user?.role === 'administrator',
    isManager: (state) => state.user?.role === 'manager',
    userNameInitial: (state) => state.user?.name?.charAt(0).toUpperCase() || '?',
    userAvatarUrl: (state) => state.user?.imageUrl || null,
  },

  actions: {
    async login(credentials) {
      try {
        const response = await apiClient.post('/auth/login', credentials);
        const token = response.data.token;
        this.token = token;
        localStorage.setItem('token', token);

        await this.fetchUserProfile();
        return true;
      } catch (error) {
        // --- INI ADALAH LOGIKA PENTINGNYA ---

        // 1. Tangkap error dari backend.
        console.error("Login Gagal:", error.response || error);
        
        // 2. Ambil pesan error spesifik dari respons JSON backend.
        // Jika tidak ada, gunakan pesan default.
        const errorMessage = error.response?.data?.msg || 'Terjadi kesalahan saat mencoba login.';
        
        // 3. Tampilkan pesan error tersebut menggunakan SweetAlert.
        showErrorAlert(errorMessage);
        
        return false; // Beri tahu komponen bahwa login gagal.
      }
    },

    logout() {
      this.token = null;
      this.user = {};
      localStorage.removeItem('token');
      window.location.href = '/login';
    },
    
    updateProfile(updatedUserData) {
      if (this.user) {
        this.user.name = updatedUserData.name;
        this.user.imageUrl = updatedUserData.imageUrl;
      }
    },

    async fetchUserProfile() {
      if (!this.token) return;
      try {
        const { data } = await apiClient.get('/profile');
        this.user = data;
      } catch (error) {
        this.logout();
      }
    },

    async attemptLogin() {
      if (this.token) {
        try {
          jwtDecode(this.token);
          await this.fetchUserProfile();
        } catch (e) {
          this.logout();
        }
      }
    },
  },
});