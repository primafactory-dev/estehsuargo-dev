<!-- file: src/layouts/AppLayout.vue -->
<template>
  <v-app>
    <!-- Sidebar / Navigation Drawer -->
    <v-navigation-drawer
      v-model="drawer"
      app
      class="bg-surface"
      width="280"
    >
      <template v-slot:prepend>
        <v-list-item
        lines="two"
        :prepend-avatar="fullAvatarUrl"
        :title="authStore.user?.name || 'Nama Pengguna'"
        :subtitle="authStore.user?.email || 'email@pengguna.com'"
        class="pa-4"
      ></v-list-item>
      </template>
      <v-divider></v-divider>
      <v-list nav>
  <!-- Menu yang terlihat oleh semua peran -->
  <v-list-item-title class="text-overline ml-4">Menu</v-list-item-title>
  <v-list-item prepend-icon="mdi-view-dashboard-outline" title="Overview" to="/app/dashboard"></v-list-item>
  <v-list-item prepend-icon="mdi-point-of-sale" title="Kasir" to="/app/pos"></v-list-item>

  <!-- Menu yang terlihat oleh Manajer & Admin -->
      <div v-if="authStore.isAdmin || authStore.isManager">
        <v-list-item prepend-icon="mdi-chart-line" title="Laporan Transaksi" to="/app/transactions"></v-list-item>
        <v-list-item prepend-icon="mdi-package-variant-closed" title="Produk" to="/app/products"></v-list-item>
      </div>
      
      <!-- Menu yang HANYA terlihat oleh Admin -->
      <div v-if="authStore.isAdmin">
          <v-list-item-title class="text-overline ml-4 mt-4">Administrasi</v-list-item-title>
          <v-list-item prepend-icon="mdi-history" title="Riwayat Produk" to="/app/product-history"></v-list-item>
          <v-list-item prepend-icon="mdi-account-group-outline" title="Pengguna" to="/app/users"></v-list-item>
      </div>

      <!-- Menu General (semua peran) -->
      <v-list-item-title class="text-overline ml-4 mt-4">General</v-list-item-title>
      <v-list-item prepend-icon="mdi-cog-outline" title="Profil Saya" to="/app/profile"></v-list-item>
    </v-list>
      <template v-slot:append>
        <div class="pa-2">
          <v-btn block @click="handleLogout">
            <v-icon left>mdi-logout</v-icon>
            Logout
          </v-btn>
        </div>
      </template>
    </v-navigation-drawer>

    <!-- Header / App Bar -->
    <v-app-bar app flat class="bg-surface">
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
  
  <v-toolbar-title class="font-weight-bold">
    {{ $route.name?.toString().replace(/-/g, ' ') || 'Dashboard' }}
  </v-toolbar-title>
  <v-spacer></v-spacer>
  <!-- ▼▼▼ TAMBAHKAN KEMBALI TOMBOL INI ▼▼▼ -->
  <v-btn icon @click="themeStore.toggleTheme">
    <v-icon>{{ themeStore.currentTheme === 'light' ? 'mdi-weather-night' : 'mdi-weather-sunny' }}</v-icon>
  </v-btn>
    </v-app-bar>

    <!-- Konten Utama Halaman -->
    <v-main class="bg-background">
      <v-container fluid class="pa-6">
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useThemeStore } from '@/stores/theme';
import { useAuthStore } from '@/stores/auth';
import Swal from 'sweetalert2';

const backendUrl = 'http://localhost:3001';
const drawer = ref(true);
const themeStore = useThemeStore();
const authStore = useAuthStore();
const router = useRouter();

const fullAvatarUrl = computed(() => {
  const defaultAvatar = 'https://cdn.vuetifyjs.com/images/avatars/avatar-1.png';
  const imageUrl = authStore.user?.imageUrl; // Ambil imageUrl dari state pengguna

  if (imageUrl) {
    // Jika ada, gabungkan dengan alamat backend
    return `${backendUrl}${imageUrl}`;
  }
  
  // Jika tidak, kembalikan avatar default
  return defaultAvatar;
});

console.log('User state saat AppLayout dibuat:', authStore.user);
console.log('Peran User:', authStore.user?.role);
console.log('Apakah Admin?', authStore.isAdmin);

watch(() => authStore.user, (newUser) => {
  console.log('User state BERUBAH menjadi:', newUser);
  console.log('Peran User baru:', newUser?.role);
  console.log('Apakah sekarang Admin?', authStore.isAdmin);
}, { deep: true });

const handleLogout = () => {
  Swal.fire({
    title: 'Anda yakin ingin logout?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Ya, Logout!',
    cancelButtonText: 'Batal',
  }).then((result) => {
    if (result.isConfirmed) {
      authStore.logout();
      // Redirect akan ditangani oleh window.location.href di dalam store
    }
  });
};
</script>

<style scoped>
.v-toolbar-title {
  text-transform: capitalize;
  font-size: 1.5rem !important;
}
</style>