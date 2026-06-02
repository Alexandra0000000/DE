-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июн 01 2026 г., 22:23
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `furniture2026_pu`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(2, 'Диван'),
(3, 'Обувница'),
(5, 'Полка'),
(1, 'Прихожая'),
(4, 'Пуф'),
(6, 'Стул');

-- --------------------------------------------------------

--
-- Структура таблицы `manufacturers`
--

CREATE TABLE `manufacturers` (
  `manufacturer_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `manufacturers`
--

INSERT INTO `manufacturers` (`manufacturer_id`, `name`) VALUES
(4, 'RIDBERG'),
(1, 'SVМЕБЕЛЬ'),
(3, 'Инвуд'),
(2, 'Мебелони');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_number` int(10) UNSIGNED NOT NULL,
  `article_text` varchar(255) NOT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `pickup_point_id` int(10) UNSIGNED NOT NULL,
  `client_user_id` int(10) UNSIGNED DEFAULT NULL,
  `pickup_code` int(10) UNSIGNED NOT NULL,
  `status_id` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`order_id`, `order_number`, `article_text`, `order_date`, `delivery_date`, `pickup_point_id`, `client_user_id`, `pickup_code`, `status_id`) VALUES
(16, 1, 'А112Т4, 2, G843H5, 2', '2024-02-27', '2024-04-20', 1, 7, 901, 1),
(17, 5, 'G432G6, 20, H542F5, 20', '2024-03-17', '2024-04-24', 2, 7, 905, 2),
(18, 2, 'G843H5, 1, А112Т4, 1', '2024-09-28', '2024-04-21', 11, 8, 902, 1),
(19, 6, 'А112Т4, 2, G843H5, 2', '2024-03-01', '2024-04-25', 15, 8, 906, 2),
(20, 3, 'D325D4, 10, S432T5, 10', '2024-03-21', '2024-04-22', 2, 9, 903, 1),
(21, 7, 'G843H5, 1, А112Т4, 1', '0000-00-00', '2024-04-26', 3, 9, 907, 2),
(22, 9, 'F325D4, 5, D325D4, 4', '2024-04-02', '2024-04-28', 5, 9, 909, 1),
(23, 4, 'F325D4, 5, D325D4, 4', '2024-02-20', '2024-04-23', 11, 10, 904, 2),
(24, 8, 'D325D4, 10, S432T5, 19', '2024-03-31', '2024-04-27', 19, 10, 908, 1),
(25, 10, 'G432G6, 20, H542F5, 20', '2024-04-03', '2024-04-29', 28, 10, 910, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `orders_import_raw`
--

CREATE TABLE `orders_import_raw` (
  `raw_id` int(10) UNSIGNED NOT NULL,
  `order_number_text` varchar(40) DEFAULT NULL,
  `articles_text` varchar(255) DEFAULT NULL,
  `order_date_text` varchar(40) DEFAULT NULL,
  `delivery_date_text` varchar(40) DEFAULT NULL,
  `pickup_point_text` varchar(40) DEFAULT NULL,
  `client_fio_text` varchar(200) DEFAULT NULL,
  `pickup_code_text` varchar(40) DEFAULT NULL,
  `status_text` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders_import_raw`
--

INSERT INTO `orders_import_raw` (`raw_id`, `order_number_text`, `articles_text`, `order_date_text`, `delivery_date_text`, `pickup_point_text`, `client_fio_text`, `pickup_code_text`, `status_text`) VALUES
(1, '1', 'А112Т4, 2, G843H5, 2', '2024-02-27', '2024-04-20', '1', 'Степанов Михаил Артёмович', '901', 'Новый '),
(2, '2', 'G843H5, 1, А112Т4, 1', '2024-09-28', '2024-04-21', '11', 'Михайлюк Анна Вячеславовна', '902', 'Новый '),
(3, '3', 'D325D4, 10, S432T5, 10', '2024-03-21', '2024-04-22', '2', 'Ситдикова Елена Анатольевна', '903', 'Новый '),
(4, '4', 'F325D4, 5, D325D4, 4', '2024-02-20', '2024-04-23', '11', 'Ворсин Петр Евгеньевич', '904', 'Завершен'),
(5, '5', 'G432G6, 20, H542F5, 20', '2024-03-17', '2024-04-24', '2', 'Степанов Михаил Артёмович', '905', 'Завершен'),
(6, '6', 'А112Т4, 2, G843H5, 2', '2024-03-01', '2024-04-25', '15', 'Михайлюк Анна Вячеславовна', '906', 'Завершен'),
(7, '7', 'G843H5, 1, А112Т4, 1', '2024-02-30', '2024-04-26', '3', 'Ситдикова Елена Анатольевна', '907', 'Завершен'),
(8, '8', 'D325D4, 10, S432T5, 10', '2024-03-31', '2024-04-27', '19', 'Ворсин Петр Евгеньевич', '908', 'Новый '),
(9, '9', 'F325D4, 5, D325D4, 4', '2024-04-02', '2024-04-28', '5', 'Ситдикова Елена Анатольевна', '909', 'Новый '),
(10, '10', 'G432G6, 20, H542F5, 20', '2024-04-03', '2024-04-29', '19', 'Ворсин Петр Евгеньевич', '910', 'Новый ');

-- --------------------------------------------------------

--
-- Структура таблицы `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`) VALUES
(31, 16, 1, 2),
(32, 17, 6, 20),
(33, 18, 2, 1),
(34, 19, 1, 2),
(35, 20, 3, 10),
(36, 21, 2, 1),
(37, 22, 5, 5),
(38, 23, 5, 5),
(46, 16, 2, 2),
(47, 17, 7, 20),
(48, 18, 1, 1),
(49, 19, 2, 2),
(50, 20, 4, 10),
(51, 21, 1, 1),
(52, 22, 3, 4),
(53, 23, 3, 4),
(61, 25, 6, 20),
(62, 25, 7, 20),
(65, 24, 3, 10),
(66, 24, 4, 19);

-- --------------------------------------------------------

--
-- Структура таблицы `order_statuses`
--

CREATE TABLE `order_statuses` (
  `status_id` tinyint(3) UNSIGNED NOT NULL,
  `status_name` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_statuses`
--

INSERT INTO `order_statuses` (`status_id`, `status_name`) VALUES
(2, 'Завершен'),
(1, 'Новый');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points`
--

CREATE TABLE `pickup_points` (
  `pickup_point_id` int(10) UNSIGNED NOT NULL,
  `address_text` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points`
--

INSERT INTO `pickup_points` (`pickup_point_id`, `address_text`) VALUES
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(36, '190949, г. Лесной, ул. Мичурина, 26'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(27, '660540, г. Лесной, ул. Солнечная, 25');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points_import_raw`
--

CREATE TABLE `pickup_points_import_raw` (
  `raw_id` int(10) UNSIGNED NOT NULL,
  `address_text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points_import_raw`
--

INSERT INTO `pickup_points_import_raw` (`raw_id`, `address_text`) VALUES
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(27, '660540, г. Лесной, ул. Солнечная, 25'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(36, '190949, г. Лесной, ул. Мичурина, 26');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `article` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `unit_name` varchar(20) NOT NULL,
  `price` decimal(12,2) NOT NULL CHECK (`price` >= 0),
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `manufacturer_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL CHECK (`discount_percent` >= 0),
  `stock_quantity` int(11) NOT NULL CHECK (`stock_quantity` >= 0),
  `description_text` text DEFAULT NULL,
  `photo_file` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`product_id`, `article`, `name`, `unit_name`, `price`, `supplier_id`, `manufacturer_id`, `category_id`, `discount_percent`, `stock_quantity`, `description_text`, `photo_file`) VALUES
(1, 'А112Т4', 'Прихожая Фаворит 1 1420х2056х352ммм Дуб Делано/Цемент Светлый SV-М 1 шт', 'шт.', 9577.00, 1, 1, 1, 10.00, 0, 'Удивительно функциональная и практичная прихожая Фаворит 1, обладая характерными чертами Скандинавского стиля, выглядит эффектно и способна задать тон интерьеру дома, встречая вас и ваших гостей.', '1.jpg'),
(2, 'G843H5', 'Прихожая в коридор Твист с зеркалом мебель со шкафами, 120х37х202 см', 'шт.', 8803.00, 1, 2, 1, 25.00, 9, 'Этот стеллаж со шкафом в прихожую комнату станет отличным элементом для вашего интерьера. Мебель для дома обеспечивает удобное хранение перчаток, шапок, зонтов, сумок и других аксессуаров.', '2.jpg'),
(3, 'D325D4', 'Угловой диван Кромма Инвуд Лайт, серый двухместный диван, Velutto 32', 'шт.', 29125.00, 2, 3, 2, 5.00, 12, 'Угловой диван Инвуд Лайт 2 - стильный и комфортный диван подойдет для комнаты любого размера.', '3.jpg'),
(4, 'S432T5', 'Обувница RIDBERG, с вешалкой, стальная, 170x60x26 см, 5 полок, вместимость до 15 пар', 'шт.', 900.00, 2, 4, 3, 15.00, 15, 'Обувница Ridberg с 5 полками и вешалкой - идеальное решение для организации хранения обуви в прихожей или гардеробной.', '4.jpg'),
(5, 'F325D4', 'Диван, Прямой диван, Диван-кровать Сити темно-коричневый. Квест-33', 'шт.', 14322.00, 3, 3, 2, 18.00, 3, '\r\nПрямой диван-кровать Сити - это современное и функциональное решение для вашего дома.', '5.jpg'),
(6, 'G432G6', 'Пуф трансформер кровать раскладушка светло-коричневый велюр', 'шт.', 6149.00, 4, 3, 4, 22.00, 3, 'Пуф трансформер 5в1 представляет собой уникальное сочетание функций, выступая в качестве пуфика, столика, кресла, шезлонга и дополнительного спального места.', '6.jpg'),
(7, 'H542F5', 'Диван, Прямой диван, диван кровать, Рио симпл механизм Пантограф. Симпл-16', 'шт.', 20708.00, 3, 3, 2, 4.00, 5, 'Диван Рио симпл от \"Золотое Руно\" - это сочетание комфорта, функциональности и стильного дизайна.', '7.jpg'),
(8, 'C346F5', 'Полка настенная ромб Лофт, черная, 40 см', 'шт.', 2843.00, 4, 4, 5, 5.00, 4, 'Полочки для цветов в стиле лофт. Подойдут как для цветов, так и в качестве декоративного элемента. Полки подойдут для дома, офиса, кафе, ресторана. ​', '8.jpg'),
(9, 'F256G6', 'Стулья для кухни', 'шт.', 4760.00, 4, 4, 6, 6.00, 2, 'Набор из четырех стульев в лофт-дизайне станет любимой мебелью для отдыха и подойдет для взрослых и детей.', '9.jpg'),
(10, 'J532V5', 'Магнитная полка, для холодильника, металл, 3шт, универсальная, чёрная', 'шт.', 1500.00, 4, 4, 5, 8.00, 6, 'Магнитная полка для холодильника - это удобный и практичный аксессуар, который поможет организовать пространство в вашем доме.', '10.jpg');

-- --------------------------------------------------------

--
-- Структура таблицы `products_import_raw`
--

CREATE TABLE `products_import_raw` (
  `article_text` varchar(60) DEFAULT NULL,
  `name_text` varchar(200) DEFAULT NULL,
  `unit_text` varchar(20) DEFAULT NULL,
  `price_text` varchar(40) DEFAULT NULL,
  `supplier_text` varchar(120) DEFAULT NULL,
  `manufacturer_text` varchar(120) DEFAULT NULL,
  `category_text` varchar(120) DEFAULT NULL,
  `discount_text` varchar(40) DEFAULT NULL,
  `stock_text` varchar(40) DEFAULT NULL,
  `description_text` text DEFAULT NULL,
  `photo_text` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products_import_raw`
--

INSERT INTO `products_import_raw` (`article_text`, `name_text`, `unit_text`, `price_text`, `supplier_text`, `manufacturer_text`, `category_text`, `discount_text`, `stock_text`, `description_text`, `photo_text`) VALUES
('А112Т4', 'Прихожая Фаворит 1 1420х2056х352ммм Дуб Делано/Цемент Светлый SV-М 1 шт', 'шт.', '9577', 'Стройландия', 'SVМЕБЕЛЬ', 'Прихожая', '10', '0', 'Удивительно функциональная и практичная прихожая Фаворит 1, обладая характерными чертами Скандинавского стиля, выглядит эффектно и способна задать тон интерьеру дома, встречая вас и ваших гостей. ', '1.jpg'),
('G843H5', 'Прихожая в коридор Твист с зеркалом мебель со шкафами, 120х37х202 см', 'шт.', '8803', 'Стройландия', 'Мебелони', 'Прихожая', '25', '9', 'Этот стеллаж со шкафом в прихожую комнату станет отличным элементом для вашего интерьера. Мебель для дома обеспечивает удобное хранение перчаток, шапок, зонтов, сумок и других аксессуаров. ', '2.jpg'),
('D325D4', 'Угловой диван Кромма Инвуд Лайт, серый двухместный диван, Velutto 32', 'шт.', '29125', 'Кромма', 'Инвуд', 'Диван', '5', '12', 'Угловой диван Инвуд Лайт 2 - стильный и комфортный диван подойдет для комнаты любого размера.', '3.jpg'),
('S432T5', 'Обувница RIDBERG, с вешалкой, стальная, 170x60x26 см, 5 полок, вместимость до 15 пар', 'шт.', '885', 'Кромма', 'RIDBERG', 'Обувница', '15', '15', 'Обувница Ridberg с 5 полками и вешалкой - идеальное решение для организации хранения обуви в прихожей или гардеробной. ', '4.jpg'),
('F325D4', 'Диван, Прямой диван, Диван-кровать Сити темно-коричневый. Квест-33', 'шт.', '14322', 'ЗолотоеРуно', 'Инвуд', 'Диван', '18', '3', '\r\nПрямой диван-кровать Сити - это современное и функциональное решение для вашего дома.', '5.jpg'),
('G432G6', 'Пуф трансформер кровать раскладушка светло-коричневый велюр', 'шт.', '6149', 'KRYLOVMANUFACTURA', 'Инвуд', 'Пуф', '22', '3', 'Пуф трансформер 5в1 представляет собой уникальное сочетание функций, выступая в качестве пуфика, столика, кресла, шезлонга и дополнительного спального места. ', '6.jpg'),
('H542F5', 'Диван, Прямой диван, диван кровать, Рио симпл механизм Пантограф. Симпл-16', 'шт.', '20708', 'ЗолотоеРуно', 'Инвуд', 'Диван', '4', '5', 'Диван Рио симпл от \"Золотое Руно\" - это сочетание комфорта, функциональности и стильного дизайна.', '7.jpg'),
('C346F5', 'Полка настенная ромб Лофт, черная, 40 см', 'шт.', '2843', 'KRYLOVMANUFACTURA', 'RIDBERG', 'Полка', '5', '4', 'Полочки для цветов в стиле лофт. Подойдут как для цветов, так и в качестве декоративного элемента. Полки подойдут для дома, офиса, кафе, ресторана. ​', '8.jpg'),
('F256G6', 'Стулья для кухни', 'шт.', '4760', 'KRYLOVMANUFACTURA', 'RIDBERG', 'Стул', '6', '2', 'Набор из четырех стульев в лофт-дизайне станет любимой мебелью для отдыха и подойдет для взрослых и детей. ', '9.jpg'),
('J532V5', 'Магнитная полка, для холодильника, металл, 3шт, универсальная, чёрная', 'шт.', '1387', 'KRYLOVMANUFACTURA', 'RIDBERG', 'Полка', '8', '6', 'Магнитная полка для холодильника - это удобный и практичный аксессуар, который поможет организовать пространство в вашем доме.', '10.jpg');

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `role_id` tinyint(3) UNSIGNED NOT NULL,
  `role_name` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(2, 'Авторизированный клиент'),
(4, 'Администратор'),
(1, 'Гость'),
(3, 'Менеджер');

-- --------------------------------------------------------

--
-- Структура таблицы `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`) VALUES
(4, 'KRYLOVMANUFACTURA'),
(3, 'ЗолотоеРуно'),
(2, 'Кромма'),
(1, 'Стройландия');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` tinyint(3) UNSIGNED NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `login` varchar(120) NOT NULL,
  `password_plain` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `full_name`, `login`, `password_plain`) VALUES
(1, 4, 'Никифорова Анна Семеновна', '94d5ous@gmail.com', 'uzWC67'),
(2, 4, 'Стелина Евгения Петровна', 'uth4iz@mail.com', '2L6KZG'),
(3, 4, 'Никифорова Весения Николаевна', '5d4zbu@tutanota.com', 'rwVDh9'),
(4, 3, 'Сазонов Руслан Германович', 'ptec8ym@yahoo.com', 'LdNyos'),
(5, 3, 'Одинцов Серафим Артёмович', '1qz4kw@mail.com', 'gynQMT'),
(6, 3, 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr'),
(7, 2, 'Степанов Михаил Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
(8, 2, 'Михайлюк Анна Вячеславовна', '1diph5e@tutanota.com', '8ntwUp'),
(9, 2, 'Ситдикова Елена Анатольевна', 'tjde7c@yahoo.com', 'YOyhfR'),
(10, 2, 'Ворсин Петр Евгеньевич', 'wpmrc3do@tutanota.com', 'RSbvHv');

-- --------------------------------------------------------

--
-- Структура таблицы `users_import_raw`
--

CREATE TABLE `users_import_raw` (
  `role_name` varchar(100) DEFAULT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  `login_text` varchar(120) DEFAULT NULL,
  `password_text` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users_import_raw`
--

INSERT INTO `users_import_raw` (`role_name`, `full_name`, `login_text`, `password_text`) VALUES
('Администратор', 'Никифорова Анна Семеновна', '94d5ous@gmail.com', 'uzWC67'),
('Администратор', 'Стелина Евгения Петровна', 'uth4iz@mail.com', '2L6KZG'),
('Администратор', 'Никифорова Весения Николаевна', '5d4zbu@tutanota.com', 'rwVDh9'),
('Менеджер', 'Сазонов Руслан Германович', 'ptec8ym@yahoo.com', 'LdNyos'),
('Менеджер', 'Одинцов Серафим Артёмович', '1qz4kw@mail.com', 'gynQMT'),
('Менеджер', 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr'),
('Авторизированный клиент', 'Степанов Михаил Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
('Авторизированный клиент', 'Михайлюк Анна Вячеславовна', '1diph5e@tutanota.com', '8ntwUp'),
('Авторизированный клиент', 'Ситдикова Елена Анатольевна', 'tjde7c@yahoo.com', 'YOyhfR'),
('Авторизированный клиент', 'Ворсин Петр Евгеньевич', 'wpmrc3do@tutanota.com', 'RSbvHv');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  ADD PRIMARY KEY (`manufacturer_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `fk_orders_pickup_points` (`pickup_point_id`),
  ADD KEY `fk_orders_users` (`client_user_id`),
  ADD KEY `idx_orders_status` (`status_id`);

--
-- Индексы таблицы `orders_import_raw`
--
ALTER TABLE `orders_import_raw`
  ADD PRIMARY KEY (`raw_id`);

--
-- Индексы таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD UNIQUE KEY `uk_order_product` (`order_id`,`product_id`),
  ADD KEY `idx_order_items_product` (`product_id`);

--
-- Индексы таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `status_name` (`status_name`);

--
-- Индексы таблицы `pickup_points`
--
ALTER TABLE `pickup_points`
  ADD PRIMARY KEY (`pickup_point_id`),
  ADD UNIQUE KEY `address_text` (`address_text`);

--
-- Индексы таблицы `pickup_points_import_raw`
--
ALTER TABLE `pickup_points_import_raw`
  ADD PRIMARY KEY (`raw_id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `article` (`article`),
  ADD KEY `fk_products_manufacturers` (`manufacturer_id`),
  ADD KEY `idx_products_supplier` (`supplier_id`),
  ADD KEY `idx_products_category` (`category_id`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Индексы таблицы `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `fk_users_roles` (`role_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  MODIFY `manufacturer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT для таблицы `orders_import_raw`
--
ALTER TABLE `orders_import_raw`
  MODIFY `raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT для таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  MODIFY `status_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `pickup_points_import_raw`
--
ALTER TABLE `pickup_points_import_raw`
  MODIFY `raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_pickup_points` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_points` (`pickup_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_statuses` FOREIGN KEY (`status_id`) REFERENCES `order_statuses` (`status_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_products_manufacturers` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`manufacturer_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_products_suppliers` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
