<!-- file: src/views/LandingView.vue -->
<template>
  <div>
    <!-- Bagian Hero -->
    <v-container class="py-16">
      <v-row align="center">
        <v-col cols="12" md="6">
          <h1 class="text-h2 font-weight-bold mb-4">
            Kelola Bisnis Minuman Anda Dengan Mudah
          </h1>
          <p class="text-h6 text-medium-emphasis mb-8">
            Aplikasi Point of Sale modern yang dirancang untuk kecepatan, kemudahan, dan kontrol penuh atas bisnis Anda.
          </p>
          <v-btn to="/login" color="primary" size="x-large" variant="elevated">
            Mulai Kelola Sekarang
          </v-btn>
        </v-col>
        <v-col cols="12" md="6">
          <v-img
            src="https://images.unsplash.com/photo-1579887829283-a916b3f715b1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"
            class="rounded-xl"
            height="400"
            cover
          ></v-img>
        </v-col>
      </v-row>
    </v-container>

    <!-- Bagian Fitur -->
    <v-sheet color="surface-variant" class="py-16">
      <v-container>
        <h2 class="text-h3 font-weight-bold text-center mb-10">Fitur Unggulan</h2>
        <v-row>
          <v-col v-for="feature in features" :key="feature.title" cols="12" md="4">
            <v-card class="pa-4 text-center fill-height" flat>
              <v-icon :icon="feature.icon" color="primary" size="64" class="mb-4"></v-icon>
              <h3 class="text-h5 font-weight-bold mb-2">{{ feature.title }}</h3>
              <p class="text-medium-emphasis">{{ feature.description }}</p>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-sheet>
  </div>
</template>

<script setup>
const features = [
  {
    icon: 'mdi-account-group-outline',
    title: 'Manajemen Multi-User',
    description: 'Atur peran dan hak akses untuk Administrator, Manajer, dan Kasir dengan mudah dan aman.'
  },
  {
    icon: 'mdi-point-of-sale',
    title: 'Transaksi Cepat',
    description: 'Antarmuka kasir yang intuitif memungkinkan proses penjualan yang cepat dan efisien.'
  },
  {
    icon: 'mdi-chart-line',
    title: 'Laporan Lengkap',
    description: 'Pantau performa bisnis Anda dengan laporan transaksi dan riwayat produk yang detail.'
  }
];
</script>