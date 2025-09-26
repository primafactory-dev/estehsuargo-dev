// file: src/plugins/vuetify.js
import 'vuetify/styles';
import '@mdi/font/css/materialdesignicons.css';
import { createVuetify } from 'vuetify';

// Tema Terang (Light Mode)
const lightTheme = {
  dark: false,
  colors: {
    background: '#E6EBE4',      // Hijau sangat muda pudar
    surface: '#FFFFFF',           // Putih untuk kartu agar menonjol
    'surface-variant': '#D0DBCB',// Hijau muda pudar
    primary: '#B2C1AE',           // Hijau medium pudar untuk tombol/aksen
    'on-primary': '#FFFFFF',      // Teks di atas tombol primer (putih)
    secondary: '#869480',         // Hijau tua pudar untuk teks/header
    'on-secondary': '#FFFFFF',    // Teks di atas elemen sekunder
    'on-surface': '#2c3e50',      // Warna teks utama (abu-abu gelap agar mudah dibaca)
    'on-background': '#2c3e50',   // Warna teks di atas background
    // Warna lain bisa disesuaikan
    error: '#B00020',
    info: '#2196F3',
    success: '#32cb37ff',
    warning: '#FB8C00',
  }
};

// Tema Gelap (Dark Mode) - Sesuai dengan Desain Siohoma
const darkTheme = {
  dark: true,
  colors: {
    background: '#2E332A',      // Hijau sangat gelap
    surface: '#3C4238',           // Hijau gelap untuk kartu/sidebar
    primary: '#A27C5B',           // Coklat hangat untuk tombol/aksen
    'on-primary': '#FFFFFF',      // Teks di atas tombol primer (putih)
    secondary: '#DCD8CD',         // Krem/Beige untuk teks atau aksen sekunder
    'on-surface': '#FFFFFF',      // Warna font utama (Krem/Beige)
    'on-background': '#DCD8CD',   // Warna font di atas background
    'on-secondary': '#2E332A',    // Teks di atas elemen sekunder (hijau sangat gelap)
  }
};

export default createVuetify({
  theme: {
    defaultTheme: 'dark', // Langsung default ke tema gelap seperti di desain
    themes: {
      light: lightTheme,
      dark: darkTheme,
    }
  }
});