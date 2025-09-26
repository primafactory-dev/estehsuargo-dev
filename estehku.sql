-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 26, 2025 at 07:32 AM
-- Server version: 8.0.30
-- PHP Version: 8.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `estehku`
--

-- --------------------------------------------------------

--
-- Table structure for table `producthistories`
--

CREATE TABLE `producthistories` (
  `id` int NOT NULL,
  `productId` int NOT NULL,
  `productName` varchar(255) NOT NULL,
  `action` enum('created','deleted','updated') NOT NULL,
  `userId` int NOT NULL,
  `userName` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `producthistories`
--

INSERT INTO `producthistories` (`id`, `productId`, `productName`, `action`, `userId`, `userName`, `createdAt`) VALUES
(40, 15, 'Es Teh Klasik dengan Irisan Lemon', 'created', 1, 'Admin Pusat', '2025-09-25 01:51:52'),
(41, 15, 'Es Teh Lemon', 'updated', 1, 'Admin Pusat', '2025-09-25 01:52:19'),
(42, 16, 'Es Teh Mint', 'created', 1, 'Admin Pusat', '2025-09-25 01:53:01'),
(43, 17, 'Es Teh Beri', 'created', 1, 'Admin Pusat', '2025-09-25 01:53:52'),
(44, 18, 'Es Teh Thailand', 'created', 3, 'Manager Teh', '2025-09-25 01:55:27'),
(45, 19, 'Es Teh Peach', 'created', 3, 'Manager Teh', '2025-09-25 01:56:36'),
(46, 20, 'Teh Botol', 'created', 3, 'Manager Teh', '2025-09-25 01:57:45'),
(47, 21, 'Es Teh Extra ', 'created', 3, 'Manager Teh', '2025-09-25 01:59:20'),
(48, 22, 'Es Teh Garnish', 'created', 3, 'Manager Teh', '2025-09-25 02:00:14'),
(49, 23, 'Es Teh Leci', 'created', 3, 'Manager Teh', '2025-09-25 02:01:31'),
(50, 24, 'Es Teh Boba', 'created', 3, 'Manager Teh', '2025-09-25 02:02:10'),
(51, 15, 'Es Teh Lemon', 'deleted', 1, 'Admin Pusat', '2025-09-25 06:28:42'),
(52, 16, 'Es Teh Mint', 'deleted', 3, 'Manager Teh', '2025-09-25 06:33:02'),
(53, 25, 'Es Teh Boba2', 'created', 4, 'Manager Teh 2', '2025-09-25 06:36:32'),
(54, 17, 'Es Teh Beri 3', 'updated', 1, 'Admin Pusat', '2025-09-25 06:38:50'),
(55, 17, 'Es Teh Beri 3', 'updated', 1, 'Admin Pusat', '2025-09-26 07:19:10'),
(56, 18, 'Es Teh Thailand', 'updated', 1, 'Admin Pusat', '2025-09-26 07:19:25'),
(57, 19, 'Es Teh Peach', 'updated', 1, 'Admin Pusat', '2025-09-26 07:19:32'),
(58, 20, 'Teh Botol', 'updated', 1, 'Admin Pusat', '2025-09-26 07:19:40'),
(59, 21, 'Es Teh Extra ', 'updated', 1, 'Admin Pusat', '2025-09-26 07:19:55'),
(60, 22, 'Es Teh Garnish', 'updated', 1, 'Admin Pusat', '2025-09-26 07:20:03'),
(61, 23, 'Es Teh Leci', 'updated', 1, 'Admin Pusat', '2025-09-26 07:20:13'),
(62, 24, 'Es Teh Boba', 'updated', 1, 'Admin Pusat', '2025-09-26 07:20:22'),
(63, 25, 'Es Teh Boba2', 'updated', 1, 'Admin Pusat', '2025-09-26 07:20:33');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `sku` varchar(255) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `stock`, `sku`, `imageUrl`, `createdAt`, `updatedAt`) VALUES
(17, 'Es Teh Beri 3', 'es teh dengan campuran buah beri seperti stroberi, rasberi, dan blueberry, serta daun mint', '13000.00', 7, 'ES-003', '/uploads/1758871150623.png', '2025-09-25 01:53:52', '2025-09-26 07:31:07'),
(18, 'Es Teh Thailand', 'es teh dengan warna oranye khas dan lapisan susu kental manis di atasnya', '13000.00', 9, 'ES-004', '/uploads/1758871165300.png', '2025-09-25 01:55:27', '2025-09-26 07:31:07'),
(19, 'Es Teh Peach', 'es teh dengan irisan buah peach segar dan es batu', '11000.00', 10, 'ES-005', '/uploads/1758871172485.png', '2025-09-25 01:56:36', '2025-09-26 07:31:07'),
(20, 'Teh Botol', 'es teh yang sudah dikemas dalam botol atau wadah siap minum', '10000.00', 11, 'ES-006', '/uploads/1758871180786.png', '2025-09-25 01:57:45', '2025-09-26 07:31:07'),
(21, 'Es Teh Extra ', 'extra teh', '14000.00', 8, 'ES-007', '/uploads/1758871195350.png', '2025-09-25 01:59:20', '2025-09-26 07:19:55'),
(22, 'Es Teh Garnish', 'es teh yang dipercantik dengan bunga yang bisa dimakan', '14000.00', 9, 'ES-008', '/uploads/1758871203268.png', '2025-09-25 02:00:14', '2025-09-26 07:20:03'),
(23, 'Es Teh Leci', 'es teh leci segar', '10000.00', 10, 'ES-009', '/uploads/1758871213744.png', '2025-09-25 02:01:31', '2025-09-26 07:20:13'),
(24, 'Es Teh Boba', 'es teh boba', '13000.00', 10, 'ES-010', '/uploads/1758871222092.png', '2025-09-25 02:02:10', '2025-09-26 07:20:22'),
(25, 'Es Teh Boba2', 'esss', '13000.00', 10, 'ES-0114', '/uploads/1758871233766.png', '2025-09-25 06:36:32', '2025-09-26 07:20:33');

-- --------------------------------------------------------

--
-- Table structure for table `transactionitems`
--

CREATE TABLE `transactionitems` (
  `id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `transactionId` int DEFAULT NULL,
  `productId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transactionitems`
--

INSERT INTO `transactionitems` (`id`, `quantity`, `price`, `createdAt`, `updatedAt`, `transactionId`, `productId`) VALUES
(16, 2, '12000.00', '2025-09-25 06:31:32', '2025-09-25 06:31:32', 7, NULL),
(17, 1, '13000.00', '2025-09-25 06:31:32', '2025-09-25 06:31:32', 7, 18),
(18, 1, '12000.00', '2025-09-25 06:32:17', '2025-09-25 06:32:17', 8, NULL),
(19, 1, '13000.00', '2025-09-25 06:32:17', '2025-09-25 06:32:17', 8, 17),
(20, 1, '14000.00', '2025-09-25 06:32:17', '2025-09-25 06:32:17', 8, 22),
(21, 1, '13000.00', '2025-09-25 06:40:27', '2025-09-25 06:40:27', 9, 17),
(22, 1, '13000.00', '2025-09-25 06:40:27', '2025-09-25 06:40:27', 9, 18),
(23, 1, '11000.00', '2025-09-25 06:40:27', '2025-09-25 06:40:27', 9, 19),
(24, 1, '13000.00', '2025-09-26 07:31:07', '2025-09-26 07:31:07', 10, 17),
(25, 1, '13000.00', '2025-09-26 07:31:07', '2025-09-26 07:31:07', 10, 18),
(26, 1, '11000.00', '2025-09-26 07:31:07', '2025-09-26 07:31:07', 10, 19),
(27, 1, '10000.00', '2025-09-26 07:31:07', '2025-09-26 07:31:07', 10, 20);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int NOT NULL,
  `totalAmount` decimal(10,2) NOT NULL,
  `paymentMethod` enum('qris','cash') NOT NULL DEFAULT 'cash',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `totalAmount`, `paymentMethod`, `createdAt`, `updatedAt`, `userId`) VALUES
(7, '37000.00', 'cash', '2025-09-25 06:31:32', '2025-09-25 06:31:32', 3),
(8, '39000.00', 'qris', '2025-09-25 06:32:17', '2025-09-25 06:32:17', 3),
(9, '37000.00', 'qris', '2025-09-25 06:40:27', '2025-09-25 06:40:27', 2),
(10, '47000.00', 'qris', '2025-09-26 07:31:07', '2025-09-26 07:31:07', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('administrator','manager','cashier') NOT NULL DEFAULT 'cashier',
  `imageUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `imageUrl`, `createdAt`, `updatedAt`) VALUES
(1, 'Admin Pusat', 'adminpusat@gmail.com', '$2b$10$N6Yz84vfJ.LlepSL3SelOO5KKC69dojiNskW9NL1Egq60R.A73bUG', 'administrator', 'http://192.168.0.115:3001/avatars/user-1-1758859437818.jpg', '2025-09-24 02:20:03', '2025-09-26 04:03:58'),
(2, 'Cashier Teh', 'cashier@gmail.com', '$2b$10$uhjJ0s6rx.bPUSodRgKJgOhX5c7kIby8Eg.WamynQfgodfmODL7De', 'cashier', '/avatars/user-2-1758735187495.png', '2025-09-24 03:16:43', '2025-09-24 17:33:07'),
(3, 'Manager Teh', 'manager@gmail.com', '$2b$10$Z7VaizBO2HpIU7LcMIbTt.yJMO4WwNBtowzRj/yBrQgWFm66j0DWO', 'manager', '/avatars/user-3-1758735043958.png', '2025-09-24 03:17:10', '2025-09-24 17:30:43'),
(4, 'Manager Teh 2', 'manager2@gmail.com', '$2b$10$Guh97EAFg.oqaPVUenXfFeWR3rC1FhWEuuYCCXRUmh3I9D01BfZNK', 'manager', NULL, '2025-09-25 06:34:46', '2025-09-25 06:34:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `producthistories`
--
ALTER TABLE `producthistories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD UNIQUE KEY `sku_2` (`sku`);

--
-- Indexes for table `transactionitems`
--
ALTER TABLE `transactionitems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactionId` (`transactionId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `producthistories`
--
ALTER TABLE `producthistories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `transactionitems`
--
ALTER TABLE `transactionitems`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transactionitems`
--
ALTER TABLE `transactionitems`
  ADD CONSTRAINT `transactionitems_ibfk_1` FOREIGN KEY (`transactionId`) REFERENCES `transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionitems_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionitems_ibfk_3` FOREIGN KEY (`transactionId`) REFERENCES `transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionitems_ibfk_4` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
