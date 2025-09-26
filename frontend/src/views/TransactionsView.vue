<!-- file: src/views/TransactionsView.vue -->
<template>
  <v-container>
    <v-card>
      <v-card-title class="pa-4">
        Laporan Transaksi
      </v-card-title>
      <v-data-table
        :headers="headers"
        :items="transactions"
        :loading="loading"
        item-value="id"
        show-expand
        class="elevation-1"
      >
        <!-- Slot untuk menampilkan detail item saat baris diexpand -->
        <template v-slot:expanded-row="{ columns, item }">
          <tr>
            <td :colspan="columns.length" class="bg-surface">
              <v-card-text>
                <strong>Detail Item:</strong>
                <v-list density="compact">
                  <v-list-item
                    v-for="detail in item.TransactionItems"
                    :key="detail.id"
                  >
                    <v-list-item-title>
                      {{ detail.Product.name }} ({{ detail.quantity }} x {{ formatCurrency(detail.price) }})
                    </v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-card-text>
            </td>
          </tr>
        </template>

        <!-- Slot untuk format kolom Tanggal -->
        <template v-slot:item.createdAt="{ item }">
          {{ formatDateTime(item.createdAt) }}
        </template>
        
        <template v-slot:item.paymentMethod="{ item }">
          <v-chip :color="getPaymentMethodColor(item.paymentMethod)" size="small" class="text-uppercase">
            {{ item.paymentMethod }}
          </v-chip>
        </template>

        <!-- Slot untuk format kolom Total -->
        <template v-slot:item.totalAmount="{ item }">
          {{ formatCurrency(item.totalAmount) }}
        </template>
        
        <!-- Slot untuk nama Kasir -->
        <template v-slot:item.User.name="{ item }">
          {{ item.User?.name || 'N/A' }}
        </template>

      </v-data-table>
    </v-card>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';

const transactions = ref([]);
const loading = ref(true);

const headers = [
  { title: 'ID Transaksi', key: 'id' },
  { title: 'Tanggal', key: 'createdAt' },
  { title: 'Nama Kasir', key: 'User.name' },
  { title: 'Metode Bayar', key: 'paymentMethod', sortable: false },
  { title: 'Total', key: 'totalAmount' },
  { title: '', key: 'data-table-expand' }, // Kolom untuk tombol expand
];

const formatCurrency = (value) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value || 0);
const formatDateTime = (value) => new Date(value).toLocaleString('id-ID');
const getPaymentMethodColor = (method) => {
  return method === 'qris' ? 'purple' : 'teal';
};

onMounted(async () => {
  loading.value = true;
  try {
    const { data } = await apiClient.get('/transactions');
    transactions.value = data;
  } catch (error) {
    Swal.fire('Error', 'Gagal memuat riwayat transaksi.', 'error');
  } finally {
    loading.value = false;
  }
});
</script>