<!-- file: src/views/DashboardView.vue -->
<template>
  <div>
    <!-- Tampilan untuk Admin & Manajer -->
    <div v-if="authStore.isAdmin || authStore.isManager">
      <v-row>
        <v-col cols="12" md="4" sm="6">
          <v-card class="pa-2" rounded="lg">
            <v-card-subtitle class="text-overline">Total Pendapatan</v-card-subtitle>
            <v-card-text>
              <div class="d-flex align-center">
                <span v-if="loadingStats" class="text-h4">...</span>
                <span v-else class="text-h4 font-weight-bold">{{ formatCurrency(stats.totalRevenue) }}</span>
              </div>
            </v-card-text>
          </v-card>
        </v-col>
        <!-- Kartu statistik lainnya -->
        <v-col cols="12" md="4" sm="6">
            <v-card class="pa-2" rounded="lg">
            <v-card-subtitle class="text-overline">Total Transaksi</v-card-subtitle>
            <v-card-text>
                <div class="d-flex align-center">
                <span v-if="loadingStats" class="text-h4">...</span>
                <span v-else class="text-h4 font-weight-bold">{{ stats.totalTransactions }}</span>
                </div>
            </v-card-text>
            </v-card>
        </v-col>
        <v-col cols="12" md="4" sm="6">
            <v-card class="pa-2" rounded="lg">
            <v-card-subtitle class="text-overline">Total Produk</v-card-subtitle>
            <v-card-text>
                <div class="d-flex align-center">
                <span v-if="loadingStats" class="text-h4">...</span>
                <span v-else class="text-h4 font-weight-bold">{{ stats.totalProducts }}</span>
                </div>
            </v-card-text>
            </v-card>
        </v-col>
      </v-row>
    </div>

    <!-- Tampilan untuk Kasir -->
    <div v-else>
      <v-card class="pa-4 text-center mb-6" rounded="lg">
        <h1 class="text-h4">Selamat Datang, {{ authStore.user?.name }}!</h1>
        <p class="mt-2">Berikut adalah riwayat transaksi terakhir Anda.</p>
      </v-card>

      <v-card>
        <v-card-title>Riwayat Transaksi Saya</v-card-title>
        <v-data-table
          :headers="historyHeaders"
          :items="myTransactions"
          :loading="loadingHistory"
          item-value="id"
          show-expand
        >
          <!-- Slot untuk menampilkan detail item saat baris diexpand -->
          <template v-slot:expanded-row="{ columns, item }">
            <tr>
              <td :colspan="columns.length" class="bg-surface">
                <v-card-text>
                  <strong>Detail Item:</strong>
                  <v-list density="compact">
                    <v-list-item v-for="detail in item.TransactionItems" :key="detail.id">
                      <v-list-item-title>
                        {{ detail.Product.name }} ({{ detail.quantity }} x {{ formatCurrency(detail.price) }})
                      </v-list-item-title>
                      <template v-slot:append>
                        <span class="font-weight-bold">{{ formatCurrency(detail.quantity * detail.price) }}</span>
                      </template>
                    </v-list-item>
                  </v-list>
                </v-card-text>
              </td>
            </tr>
          </template>

          <template v-slot:item.createdAt="{ item }">{{ formatDateTime(item.createdAt) }}</template>
          <template v-slot:item.totalItems="{ item }">{{ calculateTotalItems(item.TransactionItems) }}</template>
          <template v-slot:item.totalAmount="{ item }">{{ formatCurrency(item.totalAmount) }}</template>
        </v-data-table>
      </v-card>
    </div>
  </div>
</template>
    
<script setup>
import { ref, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth';
import apiClient from '@/api/axios';

const authStore = useAuthStore();

// State untuk Admin/Manajer
const loadingStats = ref(false);
const stats = ref({});

// State untuk Kasir
const loadingHistory = ref(false);
const myTransactions = ref([]);
const historyHeaders = [
  { title: 'Waktu Checkout', key: 'createdAt' },
  { title: 'Jumlah Item', key: 'totalItems', sortable: false },
  { title: 'Total Harga', key: 'totalAmount' },
  { title: '', key: 'data-table-expand' },
];

// Fungsi Helper
const formatCurrency = (value) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value || 0);
const formatDateTime = (value) => new Date(value).toLocaleString('id-ID', { dateStyle: 'short', timeStyle: 'short' });
const calculateTotalItems = (items) => items.reduce((acc, item) => acc + item.quantity, 0);

// Fungsi Fetching Data
const fetchDashboardData = async () => {
  if (authStore.isAdmin || authStore.isManager) {
    loadingStats.value = true;
    try {
      const { data } = await apiClient.get('/dashboard/stats');
      stats.value = data;
    } catch (error) { console.error("Gagal memuat statistik:", error); } 
    finally { loadingStats.value = false; }
  } else {
    // Jika bukan admin/manajer, maka dia kasir. Ambil riwayatnya.
    loadingHistory.value = true;
    try {
      const { data } = await apiClient.get('/transactions/my-history');
      myTransactions.value = data;
    } catch (error) { console.error("Gagal memuat riwayat transaksi:", error); }
    finally { loadingHistory.value = false; }
  }
};

onMounted(fetchDashboardData);
</script>