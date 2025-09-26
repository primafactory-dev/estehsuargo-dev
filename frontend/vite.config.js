// file: frontend/vite.config.js
import { fileURLToPath, URL } from 'node:url'; // <-- 1. PASTIKAN INI DIIMPOR
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vuetify from 'vite-plugin-vuetify';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    vue(),
    vuetify({ autoImport: true }),
    VitePWA({
      // ... (semua konfigurasi PWA Anda yang sudah ada)
      registerType: 'autoUpdate',
      injectRegister: 'auto',
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,json,vue,txt,woff2}'],
        cleanupOutdatedCaches: true,
      },
      manifest: {
        name: 'Es Teh Joss',
        short_name: 'Es Teh Joss',
        description: 'Teman Setia Disegala Cuaca',
        theme_color: '#9CCC65',
        background_color: '#000000ff',
        display: 'standalone',
        scope: '/',
        start_url: '/',
        orientation: 'portrait',
        icons: [
          { src: 'pwa-192x192.png', sizes: '192x192', type: 'image/png' },
          { src: 'pwa-512x512.png', sizes: '512x512', type: 'image/png' },
          { src: 'pwa-512x512.png', sizes: '512x512', type: 'image/png', purpose: 'any maskable' },
        ],
      },
    }),
  ],
  // 2. PASTIKAN BLOK RESOLVE INI ADA DAN SUDAH BENAR
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  }
});