// file: src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

// --- 1. Impor Semua Komponen & Layout ---
// Layouts
import AppLayout from '@/layouts/AppLayout.vue';
import LandingLayout from '@/layouts/LandingLayout.vue';

// Views
import LandingView from '../views/LandingView.vue';
import LoginView from '../views/LoginView.vue';
import DashboardView from '../views/DashboardView.vue';
import POSView from '../views/POSView.vue';
import TransactionsView from '../views/TransactionsView.vue';
import ProductsView from '../views/ProductsView.vue';
import ProductHistoryView from '../views/ProductHistoryView.vue';
import UsersView from '../views/UsersView.vue';
import ProfileView from '../views/ProfileView.vue';

// --- 2. Definisikan Struktur Rute ---
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // --- Rute Publik (Menggunakan LandingLayout) ---
    {
      path: '/',
      component: LandingLayout,
      meta: { requiresGuest: true }, // Tandai rute ini untuk tamu
      children: [
        {
          path: '', // Alamat root (http://localhost:5173/)
          name: 'landing',
          component: LandingView,
        },
      ]
    },

    // --- Rute Login (Tanpa Layout Khusus) ---
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { requiresGuest: true }, // Tandai rute ini untuk tamu
    },

    // --- Rute Internal/Terlindungi (Menggunakan AppLayout) ---
    // Semua URL di dalam sini akan diawali dengan /app/...
    {
      path: '/app',
      component: AppLayout,
      meta: { requiresAuth: true }, // Tandai semua rute ini butuh login
      redirect: '/app/dashboard', // Jika akses /app, arahkan ke dashboard
      children: [
        {
          path: 'dashboard',
          name: 'dashboard',
          component: DashboardView,
        },
        {
          path: 'pos',
          name: 'transaksi', // Ingat, kita ubah ini untuk judul header
          component: POSView,
        },
        {
          path: 'transactions',
          name: 'laporan-transaksi',
          component: TransactionsView,
          meta: { roles: ['administrator', 'manager'] }
        },
        {
          path: 'products',
          name: 'produk',
          component: ProductsView,
          meta: { roles: ['administrator', 'manager'] }
        },
        {
          path: 'product-history',
          name: 'riwayat-produk',
          component: ProductHistoryView,
          meta: { roles: ['administrator'] }
        },
        {
          path: 'users',
          name: 'pengguna',
          component: UsersView,
          meta: { roles: ['administrator'] }
        },
        {
          path: 'profile',
          name: 'profil-saya',
          component: ProfileView,
        },
      ]
    },
    
    // --- Rute "Catch All" untuk 404 ---
    // Jika ada rute lama yang di-bookmark, arahkan ke yang baru
    { path: '/dashboard', redirect: '/app/dashboard' },
    { path: '/pos', redirect: '/app/pos' },
    // Anda bisa tambahkan redirect lain jika perlu

  ],
});

// --- 3. Navigation Guard yang Sudah Disempurnakan ---
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();

  // Jalankan attemptLogin HANYA jika status login belum diperiksa
  // Ini mencegah panggilan API berulang di setiap navigasi
  if (!authStore.user.id && localStorage.getItem('token')) {
      await authStore.attemptLogin();
  }

  const isAuthenticated = authStore.isAuthenticated;
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  const requiresGuest = to.matched.some(record => record.meta.requiresGuest);
  const requiredRoles = to.meta.roles;

  if (requiresAuth && !isAuthenticated) {
    // Jika butuh login tapi tidak login, arahkan ke login
    next({ name: 'login' });
  } else if (requiresGuest && isAuthenticated) {
    // Jika sudah login tapi akses landing/login page, arahkan ke dashboard
    next({ name: 'dashboard' });
  } else if (requiredRoles && !requiredRoles.includes(authStore.getUserRole)) {
    // Jika butuh peran khusus tapi peran user tidak cocok, arahkan ke dashboard
    next({ name: 'dashboard' });
  } else {
    // Jika semua kondisi aman, izinkan navigasi
    next();
  }
});

export default router;