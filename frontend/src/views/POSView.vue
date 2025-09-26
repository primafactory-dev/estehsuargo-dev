<template>
  <v-row no-gutters>
    <!-- Kolom Kiri: Daftar Produk -->
    <v-col cols="12" md="7" class="pa-4">
      <v-text-field
        v-model="searchTerm"
        label="Cari Produk..."
        prepend-inner-icon="mdi-magnify"
        variant="solo"
        clearable
        hide-details
        class="mb-4"
      ></v-text-field>
      
      <v-progress-linear v-if="loading" indeterminate color="primary"></v-progress-linear>

      <v-row v-else-if="filteredProducts.length > 0">
        <v-col v-for="product in filteredProducts" :key="product.id" cols="6" sm="4" lg="3">
          <v-card @click="cartStore.addItem(product)" hover class="fill-height">
            <v-img :src="getFullImageUrl(product.imageUrl)" height="150px" cover></v-img>
            <v-card-title class="text-subtitle-2 pt-2">{{ product.name }}</v-card-title>
            <v-card-text class="pb-2">
              <div class="font-weight-bold text-primary">{{ formatCurrency(product.price) }}</div>
              <div>Stok: {{ product.stock }}</div>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
      
      <div v-else class="text-center mt-10">
        <p>Produk tidak ditemukan atau belum ada data.</p>
      </div>
    </v-col>

    <!-- Kolom Kanan: Ringkasan Pesanan -->
    <v-col cols="12" md="5" class="pa-4 bg-surface" style="height: calc(100vh - 64px); overflow-y: auto;">
      <h2 class="mb-4">Pesanan</h2>
      <div v-if="cartStore.items.length > 0">
        <v-list lines="two">
          <v-list-item v-for="item in cartStore.items" :key="item.id">
            <v-list-item-title>{{ item.name }}</v-list-item-title>
            <v-list-item-subtitle>{{ formatCurrency(item.price) }}</v-list-item-subtitle>
            <template v-slot:append>
              <v-btn @click="cartStore.decrementQuantity(item.id)" size="x-small" icon="mdi-minus"></v-btn>
              <span class="mx-3 font-weight-bold">{{ item.quantity }}</span>
              <v-btn @click="cartStore.incrementQuantity(item.id)" size="x-small" icon="mdi-plus"></v-btn>
            </template>
          </v-list-item>
        </v-list>
        <v-divider class="my-4"></v-divider>
        <div class="d-flex justify-space-between text-h6 px-4">
          <span>Total:</span>
          <span>{{ formatCurrency(cartStore.totalPrice) }}</span>
        </div>
        <v-btn @click="paymentDialog = true" color="success" block size="large" class="mt-6">Lanjutkan ke Pembayaran</v-btn>
      </div>
      <div v-else class="text-center mt-16">
        <v-icon size="64" color="grey">mdi-cart-outline</v-icon>
        <p class="mt-4">Keranjang masih kosong</p>
      </div>
    </v-col>
  </v-row>

  <!-- ▼▼▼ DIALOG PEMBAYARAN BARU DITAMBAHKAN ▼▼▼ -->
  <v-dialog v-model="paymentDialog" max-width="400" persistent>
    <v-card>
      <v-card-title class="text-h5">Pilih Metode Pembayaran</v-card-title>
      <v-card-text>
        Total yang harus dibayar:
        <div class="text-h4 font-weight-bold text-success">{{ formatCurrency(cartStore.totalPrice) }}</div>
      </v-card-text>
      <v-card-actions class="d-flex flex-column pa-4">
        <v-btn @click="processPayment('qris')" color="purple" block size="large" class="mb-3" prepend-icon="mdi-qrcode">
          Bayar dengan QRIS
        </v-btn>
        <v-btn @click="processPayment('cash')" color="teal" block size="large" prepend-icon="mdi-cash">
          Bayar Tunai (Cash)
        </v-btn>
        <v-btn @click="paymentDialog = false" text block class="mt-4">
          Batal
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import apiClient from '@/api/axios';
import { useCartStore } from '@/stores/cart';
import Swal from 'sweetalert2';

const backendUrl = 'http://localhost:3001';

const cartStore = useCartStore();
const products = ref([]);
const loading = ref(false); // State untuk loading
const searchTerm = ref('');
const paymentDialog = ref(false);
const defaultImage = 'data:image/svg+xml;...'; // SVG placeholder Anda

const getFullImageUrl = (imageUrl) => {
  if (imageUrl) {
    // Jika imageUrl ada, gabungkan dengan alamat backend
    return `${backendUrl}${imageUrl}`;
  }
  // Jika tidak, kembalikan gambar default
  return defaultImage;
};

const filteredProducts = computed(() => {
  if (!searchTerm.value) return products.value;
  return products.value.filter(p => p.name.toLowerCase().includes(searchTerm.value.toLowerCase()));
});

const formatCurrency = (value) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value || 0);

const fetchProducts = async () => {
  loading.value = true;
  try {
    const { data } = await apiClient.get('/products');
    products.value = data;
  } catch (error) {
    Swal.fire('Error!', 'Gagal memuat produk.', 'error');
  } finally {
    loading.value = false;
  }
};

onMounted(fetchProducts);

const processPayment = async (paymentMethod) => {
  paymentDialog.value = false;
  try {
    const payload = {
      items: cartStore.items.map(i => ({ id: i.id, quantity: i.quantity, price: i.price })),
      paymentMethod: paymentMethod
    };
    await apiClient.post('/transactions', payload);
    Swal.fire('Berhasil!', 'Transaksi berhasil disimpan.', 'success');
    cartStore.clearCart();
    fetchProducts();
  } catch (error) {
    const msg = error.response?.data?.msg || 'Gagal memproses transaksi.';
    Swal.fire('Error!', msg, 'error');
  }
};
</script>