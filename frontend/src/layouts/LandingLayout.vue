<!-- file: src/layouts/LandingLayout.vue -->
<template>
  <v-app>
    <!-- Header Landing Page -->
    <v-app-bar app color="transparent" flat class="px-4">
      <v-toolbar-title class="font-weight-bold text-h5">
        Es Teh Joss
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn to="/login" color="primary" variant="elevated">
        Login
      </v-btn>
    </v-app-bar>

    <!-- Konten Utama -->
    <v-main class="bg-surface">
      <router-view />
    </v-main>

    <!-- Footer Sederhana -->
    <v-footer class="bg-surface">
      <v-row justify="center" no-gutters>
        <v-col class="text-center" cols="12">
          © Copyright {{ new Date().getFullYear() }} <strong>Es Teh Joss</strong>
        </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>

<script setup>
// Tidak perlu script khusus untuk layout ini
</script>