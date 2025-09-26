<!-- file: src/views/ProductsView.vue -->
<template>
  <v-container>
    <v-card>
      <v-card-title class="d-flex align-center pa-4">
        Manajemen Produk
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="openDialog()" v-if="authStore.isAdmin || authStore.isManager">
          <v-icon left>mdi-plus</v-icon>Tambah Produk
        </v-btn>
      </v-card-title>
      <v-data-table :headers="headers" :items="products" :loading="loading">
        <template v-slot:item.imageUrl="{ item }">
          <v-avatar class="ma-2" rounded="lg">
    <!-- GANTI ':src' UNTUK MEMANGGIL FUNGSI BARU KITA -->
          <v-img :src="getFullImageUrl(item.imageUrl)" cover alt="Gambar Produk"></v-img>
          </v-avatar>
        </template>
        <template v-slot:item.price="{ item }">{{ formatCurrency(item.price) }}</template>
        <template v-slot:item.actions="{ item }">
          <div v-if="authStore.isAdmin || authStore.isManager">
            <v-icon class="me-2" @click="openDialog(item)">mdi-pencil</v-icon>
            <v-icon @click="deleteProduct(item)">mdi-delete</v-icon>
          </div>
        </template>
      </v-data-table>
    </v-card>
  </v-container>

  <v-dialog v-model="dialog" max-width="600px" persistent>
    <v-card>
      <v-card-title><span class="text-h5">{{ formTitle }}</span></v-card-title>
      <v-card-text>
        <v-form ref="formRef">
          <!-- <p style="color: yellow; font-family: monospace;">Debug State: {{ imageFile }}</p> -->
          <label class="v-label v-label--active theme--light mb-2">Gambar Produk</label>
          <input 
            type="file" 
            @change="handleNativeFileChange" 
            accept="image/*" 
            class="mb-4"
          >
          <v-text-field v-model="editedItem.name" label="Nama Produk" variant="outlined" :rules="[rules.required]"></v-text-field>
          <v-text-field v-model.number="editedItem.price" label="Harga" type="number" prefix="Rp" variant="outlined" :rules="[rules.required]"></v-text-field>
          <v-text-field v-model.number="editedItem.stock" label="Stok" type="number" variant="outlined" :rules="[rules.required]"></v-text-field>
          <v-text-field v-model="editedItem.sku" label="SKU" variant="outlined"></v-text-field>
          <v-textarea v-model="editedItem.description" label="Deskripsi" rows="2" variant="outlined"></v-textarea>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn text @click="closeDialog">Batal</v-btn>
        <v-btn color="primary" @click="saveProduct">Simpan</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';
import { useAuthStore } from '@/stores/auth';

const backendUrl = 'http://localhost:3001';
const authStore = useAuthStore();
const products = ref([]);
const loading = ref(false);
const dialog = ref(false);
const formRef = ref(null);
const editedItem = ref({});
const imageFile = ref(null); 

const defaultImage = 'data:image/svg+xml;...'; // (Biarkan kode SVG Anda di sini)
const rules = { required: v => !!v || 'Wajib diisi.' };

const headers = [
  { title: 'Gambar', key: 'imageUrl', sortable: false, align: 'center' },
  { title: 'SKU', key: 'sku' },
  { title: 'Nama Produk', key: 'name' },
  { title: 'Harga', key: 'price' },
  { title: 'Stok', key: 'stock' },
  { title: 'Aksi', key: 'actions', sortable: false, align: 'end' },
];

const formTitle = computed(() => (editedItem.value.id ? 'Edit Produk' : 'Tambah Produk Baru'));

const formatCurrency = (value) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value || 0);

function getFullImageUrl(imageUrl) {
  if (imageUrl) return `${backendUrl}${imageUrl}`;
  return defaultImage;
}

onMounted(fetchProducts);

async function fetchProducts() {
  loading.value = true;
  try {
    const { data } = await apiClient.get('/products');
    products.value = data;
  } catch (e) { Swal.fire('Error', 'Gagal memuat produk.', 'error'); }
  finally { loading.value = false; }
}

function openDialog(item = {}) {
  editedItem.value = item.id ? { ...item } : { name: '', price: null, stock: null, sku: '', description: '' };
  dialog.value = true;
}

function closeDialog() {
  dialog.value = false;
  setTimeout(() => {
    editedItem.value = {};
    imageFile.value = null;
    formRef.value?.resetValidation();
  }, 300);
}

function handleNativeFileChange(event) {
  console.log('Fungsi handleNativeFileChange dipanggil.');
  const file = event.target.files[0];
  if (file) {
    imageFile.value = file;
    console.log('State imageFile BERHASIL diisi via input native:', imageFile.value);
  } else {
    imageFile.value = null;
    console.log('State imageFile dikosongkan.');
  }
}

async function saveProduct() {
  const { valid } = await formRef.value.validate();
  if (!valid) return;

  // --- DEBUGGING PALING PENTING DIMULAI DI SINI ---
  console.log('--- MEMULAI PROSES SIMPAN ---');
  console.log('1. Nilai `imageFile` TEPAT SEBELUM membuat FormData:', imageFile.value);

  const formData = new FormData();
  Object.keys(editedItem.value).forEach(key => {
    if (key !== 'id' && key !== 'imageUrl' && editedItem.value[key] !== null) {
      formData.append(key, editedItem.value[key]);
    }
  });

  if (imageFile.value) {
    console.log('2. Kondisi `if (imageFile.value)` BERNILAI TRUE. Mencoba menambahkan file ke FormData.');
    formData.append('image', imageFile.value);
  } else {
    console.log('2. Kondisi `if (imageFile.value)` BERNILAI FALSE. File tidak akan ditambahkan.');
  }

  console.log('3. Isi akhir dari FormData SEBELUM dikirim:');
  for (let pair of formData.entries()) {
    console.log(`   -> ${pair[0]}:`, pair[1]);
  }
  console.log('--- SELESAI DEBUG, MENGIRIM REQUEST ---');
  // --- DEBUGGING SELESAI ---

  try {
    if (editedItem.value.id) {
      await apiClient.put(`/products/${editedItem.value.id}`, formData);
    } else {
      await apiClient.post('/products', formData);
    }
    Swal.fire('Sukses!', 'Data produk berhasil disimpan.', 'success');
    fetchProducts();
    closeDialog();
  } catch (e) {
    console.error('Error saat menyimpan produk:', e);
    Swal.fire('Error', 'Gagal menyimpan data.', 'error');
  }
}


function deleteProduct(item) {
  Swal.fire({
    title: 'Anda yakin?',
    text: `Produk "${item.name}" akan dihapus!`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Ya, hapus!',
    cancelButtonText: 'Batal'
  }).then(async ({ isConfirmed }) => {
    if (isConfirmed) {
      try {
        await apiClient.delete(`/products/${item.id}`);
        Swal.fire('Dihapus!', 'Produk telah dihapus.', 'success');
        fetchProducts();
      } catch (e) {
        Swal.fire('Error', 'Gagal menghapus produk.', 'error');
      }
    }
  });
}
</script>