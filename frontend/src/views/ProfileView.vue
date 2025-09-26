<!-- file: src/views/ProfileView.vue -->
<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="4">
        <v-card>
          <v-card-text class="text-center">
            <v-avatar size="150" class="mb-4" :key="profile.imageUrl">
            <v-img :src="getFullAvatarUrl(profile.imageUrl)" cover alt="Avatar"></v-img>
            </v-avatar>
            <h2 class="text-h5">{{ profile.name }}</h2>
            <p class="text-medium-emphasis">{{ profile.email }}</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="8">
        <v-card>
          <v-tabs v-model="tab" bg-color="primary">
            <v-tab value="info">Edit Profil</v-tab>
            <v-tab value="password">Ganti Password</v-tab>
          </v-tabs>
          <v-card-text>
            <v-window v-model="tab">
              <v-window-item value="info">
                <v-form @submit.prevent="updateProfile">
                  <label class="v-label v-label--active theme--light mb-2">Ganti Foto Profil (Avatar) </label>
                  <input type="file"@change="handleAvatarChange"accept="image/*" class="mb-4">
                  <v-text-field v-model="profile.name" label="Nama Pengguna"></v-text-field>
                  <v-text-field v-model="profile.email" label="Email" type="email"></v-text-field>
                  <v-btn type="submit" color="primary">Simpan Perubahan</v-btn>
                </v-form>
              </v-window-item>
              <v-window-item value="password">
                <v-form @submit.prevent="changePassword">
                  <v-text-field v-model="passwords.currentPassword" label="Password Saat Ini" type="password"></v-text-field>
                  <v-text-field v-model="passwords.newPassword" label="Password Baru" type="password"></v-text-field>
                  <v-btn type="submit" color="primary">Ubah Password</v-btn>
                </v-form>
              </v-window-item>
            </v-window>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

// file: src/views/ProfileView.vue

<script setup>
import { ref, onMounted } from 'vue';
import apiClient from '@/api/axios';
import Swal from 'sweetalert2';
import { useAuthStore } from '@/stores/auth';

// --- BAGIAN YANG DIPERBAIKI (1/4): Tambahkan konstanta dan state yang benar ---
const backendUrl = 'http://localhost:3001';
const authStore = useAuthStore();
const profile = ref({ name: '', email: '', role: '', imageUrl: null });
const avatarFile = ref(null); // Diubah dari array ke null
const passwords = ref({ currentPassword: '', newPassword: '' });
const tab = ref('info');
const defaultAvatar = 'https://cdn.vuetifyjs.com/images/avatars/avatar-1.png';

// --- BAGIAN YANG DIPERBAIKI (2/4): Tambahkan fungsi untuk URL lengkap ---
function getFullAvatarUrl(imageUrl) {
  if (imageUrl) {
    return `${backendUrl}${imageUrl}`;
  }
  return defaultAvatar;
}

async function fetchProfile() {
  try {
    const { data } = await apiClient.get('/profile');
    profile.value = data;
  } catch (error) {
    Swal.fire('Error', 'Gagal memuat data profil.', 'error');
  }
}

onMounted(fetchProfile);

// --- BAGIAN YANG DIPERBAIKI (3/4): Tambahkan handler untuk input file native ---
function handleAvatarChange(event) {
  const file = event.target.files[0];
  if (file) {
    avatarFile.value = file;
  } else {
    avatarFile.value = null;
  }
}

async function updateProfile() {
  const formData = new FormData();
  formData.append('name', profile.value.name);
  formData.append('email', profile.value.email);
  
  // Periksa state 'avatarFile' yang sudah benar
  if (avatarFile.value) {
    // Gunakan nama field 'avatar' sesuai logika lama Anda
    formData.append('avatar', avatarFile.value);
  }

  try {
    const { data } = await apiClient.put('/profile', formData);
    profile.value = data;
    authStore.updateProfile(data); // Update state global juga
    avatarFile.value = null; // Reset state file
    Swal.fire('Sukses', 'Profil berhasil diperbarui.', 'success');
  } catch (error) {
    Swal.fire('Error', error.response?.data?.msg || 'Gagal memperbarui profil.', 'error');
  }
}

async function changePassword() {
  if (!passwords.value.currentPassword || !passwords.value.newPassword) {
    Swal.fire('Perhatian', 'Harap isi semua kolom password.', 'warning');
    return;
  }
  try {
    const { data } = await apiClient.put('/profile/change-password', passwords.value);
    Swal.fire('Sukses', data.msg, 'success');
    passwords.value = { currentPassword: '', newPassword: '' };
  } catch (error) {
    Swal.fire('Error', error.response?.data?.msg || 'Gagal mengubah password.', 'error');
  }
}
</script>