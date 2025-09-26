<!-- file: src/views/UsersView.vue -->
<template>
  <v-container>
    <v-card>
      <v-card-title class="d-flex align-center pa-4">
        Manajemen Pengguna
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="openDialog('add')">
          <v-icon left>mdi-plus</v-icon>Tambah Pengguna
        </v-btn>
      </v-card-title>
      <v-data-table
        :headers="headers"
        :items="users"
        :loading="loading"
        class="elevation-1"
      >
        <template v-slot:item.actions="{ item }">
          <v-icon class="me-2" @click="openDialog('edit', item)">mdi-pencil</v-icon>
          <v-icon @click="deleteUser(item)">mdi-delete</v-icon>
        </template>
      </v-data-table>
    </v-card>
  </v-container>

  <!-- Dialog untuk Tambah/Edit Pengguna -->
  <v-dialog v-model="dialog" max-width="500px">
    <v-card>
      <v-card-title>
        <span class="text-h5">{{ formTitle }}</span>
      </v-card-title>
      <v-card-text>
        <v-form ref="form">
          <v-text-field v-model="editedItem.name" label="Nama"></v-text-field>
          <v-text-field v-model="editedItem.email" label="Email"></v-text-field>
          <v-text-field v-if="editedIndex === -1" v-model="editedItem.password" label="Password" type="password"></v-text-field>
          <v-select v-model="editedItem.role" :items="['administrator', 'manager', 'cashier']" label="Peran"></v-select>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="blue-darken-1" text @click="closeDialog">Batal</v-btn>
        <v-btn color="blue-darken-1" text @click="saveUser">Simpan</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';

const users = ref([]);
const loading = ref(true);
const dialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({ name: '', email: '', password: '', role: 'cashier' });
const defaultItem = { name: '', email: '', password: '', role: 'cashier' };

const headers = [
  { title: 'Nama', key: 'name' },
  { title: 'Email', key: 'email' },
  { title: 'Peran', key: 'role' },
  { title: 'Aksi', key: 'actions', sortable: false },
];

const formTitle = computed(() => (editedIndex.value === -1 ? 'Tambah Pengguna Baru' : 'Edit Pengguna'));

const fetchUsers = async () => {
  loading.value = true;
  try {
    const response = await apiClient.get('/users');
    users.value = response.data;
  } catch (error) {
    Swal.fire('Error!', 'Gagal memuat data pengguna.', 'error');
  } finally {
    loading.value = false;
  }
};

onMounted(fetchUsers);

const openDialog = (mode, item = null) => {
  if (mode === 'edit') {
    editedIndex.value = users.value.indexOf(item);
    editedItem.value = { ...item };
  } else {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
  }
  dialog.value = true;
};

const closeDialog = () => {
  dialog.value = false;
};

const saveUser = async () => {
  try {
    if (editedIndex.value > -1) { // Edit mode
      await apiClient.put(`/users/${editedItem.value.id}`, editedItem.value);
    } else { // Add mode
      await apiClient.post('/users', editedItem.value);
    }
    Swal.fire('Sukses!', 'Data pengguna berhasil disimpan.', 'success');
    fetchUsers(); // Muat ulang data
    closeDialog();
  } catch (error) {
    const msg = error.response?.data?.msg || 'Gagal menyimpan data.';
    Swal.fire('Error!', msg, 'error');
  }
};

const deleteUser = (item) => {
  Swal.fire({
    title: 'Anda yakin?',
    text: `Pengguna "${item.name}" akan dihapus permanen!`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Ya, hapus!',
    cancelButtonText: 'Batal',
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        await apiClient.delete(`/users/${item.id}`);
        Swal.fire('Dihapus!', 'Pengguna telah dihapus.', 'success');
        fetchUsers(); // Muat ulang data
      } catch (error) {
        Swal.fire('Error!', 'Gagal menghapus pengguna.', 'error');
      }
    }
  });
};
</script>