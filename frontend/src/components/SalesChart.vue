<!-- file: src/components/SalesChart.vue -->
<template>
  <Bar :chart-data="chartData" :chart-options="chartOptions" :height="250" />
</template>

<script setup>
import { Bar } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

defineProps({ chartData: { type: Object, required: true } });

const chartOptions = { /* ... (Opsi tidak berubah) ... */ };
</script>