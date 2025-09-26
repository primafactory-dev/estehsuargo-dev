<!-- file: src/App.vue -->
<template>
  <v-app :theme="themeStore.currentTheme">
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script setup>
import { useThemeStore } from '@/stores/theme';
const themeStore = useThemeStore();
</script>