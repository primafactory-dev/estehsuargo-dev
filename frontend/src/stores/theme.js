// file: src/stores/theme.js

import { defineStore } from 'pinia';

export const useThemeStore = defineStore('theme', {
  state: () => ({
    // Ambil tema dari localStorage, atau default ke 'light'
    currentTheme: localStorage.getItem('theme') || 'light',
  }),
  actions: {
    toggleTheme() {
      this.currentTheme = this.currentTheme === 'light' ? 'dark' : 'light';
      // Simpan pilihan tema ke localStorage
      localStorage.setItem('theme', this.currentTheme);
    },
  },
});