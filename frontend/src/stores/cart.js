// file: src/stores/cart.js
import { defineStore } from 'pinia';
import { showErrorAlert } from '@/utils/alerts'; // Kita butuh helper alert

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [], // Array berisi { id, name, price, stock, imageUrl, quantity }
  }),
  getters: {
    itemCount: (state) => state.items.reduce((total, item) => total + item.quantity, 0),
    totalPrice: (state) => state.items.reduce((total, item) => total + (item.price * item.quantity), 0),
  },
  actions: {
    addItem(product) {
      if (product.stock <= 0) {
        showErrorAlert('Stok produk ini telah habis!');
        return;
      }

      const existingItem = this.items.find(item => item.id === product.id);
      if (existingItem) {
        // Cek apakah penambahan akan melebihi stok
        if (existingItem.quantity >= product.stock) {
          showErrorAlert(`Stok untuk "${product.name}" tidak mencukupi!`);
          return;
        }
        existingItem.quantity++;
      } else {
        this.items.push({ ...product, quantity: 1 });
      }
    },
    removeItem(productId) {
      this.items = this.items.filter(item => item.id !== productId);
    },
    incrementQuantity(productId) {
      const item = this.items.find(item => item.id === productId);
      if (item) {
        // Cek stok sebelum menambah
        if (item.quantity >= item.stock) {
          showErrorAlert(`Stok untuk "${item.name}" tidak mencukupi!`);
          return;
        }
        item.quantity++;
      }
    },
    decrementQuantity(productId) {
      const item = this.items.find(item => item.id === productId);
      if (item && item.quantity > 1) {
        item.quantity--;
      } else if (item && item.quantity === 1) {
        this.removeItem(productId);
      }
    },
    clearCart() {
      this.items = [];
    },
  },
});