// file: src/utils/alerts.js

import Swal from 'sweetalert2';

export const showSuccessAlert = (title) => {
  Swal.fire({
    title: title,
    icon: 'success',
    timer: 2000,
    showConfirmButton: false,
  });
};

export const showErrorAlert = (text) => {
  Swal.fire({
    title: 'Oops...',
    text: text,
    icon: 'error',
  });
};