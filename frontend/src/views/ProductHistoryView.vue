<!-- file: src/views/ProductHistoryView.vue -->
<template>
  <v-container>
    <v-card>
      <v-card-title class="pa-4">
        Riwayat Aktivitas Produk
      </v-card-title>
      <v-data-table
        :headers="headers"
        :items="history"
        :loading="loading"
        item-value="id"
        class="elevation-1"
      >
        <template v-slot:item.createdAt="{ item }">
          {{ formatDateTime(item.createdAt) }}
        </template>
        <template v-slot:item.action="{ item }">
          <v-chip :color="getActionColor(item.action)" class="text-uppercase" size="small">
            {{ item.action }}
          </v-chip>
        </template>
      </v-data-table>
    </v-card>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';

const history = ref([]);
const loading = ref(true);

const headers = [
  { title: 'Waktu', key: 'createdAt' },
  { title: 'Aksi', key: 'action' },
  { title: 'Nama Produk', key: 'productName' },
  { title: 'Dilakukan Oleh', key: 'userName' },
];

const formatDateTime = (value) => new Date(value).toLocaleString('id-ID');
const getActionColor = (action) => {
  if (action === 'created') return 'success';
  if (action === 'deleted') return 'error';
  if (action === 'updated') return 'info';
  return 'grey';
};

onMounted(async () => {
  loading.value = true;
  try {
    const { data } = await apiClient.get('/product-history');
    history.value = data;
  } catch (error) {
    Swal.fire('Error', 'Gagal memuat riwayat produk.', 'error');
  } finally {
    loading.value = false;
  }
});
</script>