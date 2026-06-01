Лабораторная работа (Вариант 5): C# + WPF (.NET Framework 4.8) + MySQL (Visual Studio Community 2026)


# Шаг 1. Создайте рабочую структуру проекта

Создайте папку проекта и подкаталоги для ресурсов и документов.

Команды/код
cmd
cd C:\
mkdir furniture_store_2026_pu
cd furniture_store_2026_pu
mkdir resources
mkdir resources\photos
mkdir docs
mkdir sql
mkdir screenshots
Скопируйте из папки с заданием в C:\furniture_store_2026_pu\resources:

Tovar.xlsx
user_import.xlsx
Пункты выдачи_import.xlsx
Заказ_import.xlsx
изображения 1.jpg ... 10.jpg (в папку resources\photos)

Примечание по изображениям: если некоторые файлы изображений отсутствуют, при импорте в БД для них будет установлен NULL, а в приложении будет использоваться picture.png (заглушка). 
Заглушку picture.png нужно создать самостоятельно или взять из ресурсов примера.


# Шаг 2. Поднимите MySQL + phpMyAdmin через XAMPP (или Docker)

Используем XAMPP (как указано в вашем задании)

Команды/код
Вариант А: XAMPP

Запустите панель управления XAMPP

Нажмите Start для MySQL (и, если нужно, для Apache для phpMyAdmin)

Откройте браузер и перейдите по адресу http://localhost/phpmyadmin


# Шаг 3. Создайте схему БД (модули 1–4)

Создайте рабочие таблицы, связи и raw-таблицы для импорта.

Команды/код
Если используете XAMPP, откройте http://localhost/phpmyadmin.

Нажмите Создать БД → имя furniture2026_pu → utf8mb4_unicode_ci → Создать.

Выберите БД furniture2026_pu.

Откройте вкладку SQL и выполните:

sql
USE furniture2026_pu;

SET NAMES utf8mb4;

-- Таблица ролей
CREATE TABLE roles (
    role_id TINYINT UNSIGNED PRIMARY KEY,
    role_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица пользователей
CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id TINYINT UNSIGNED NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    login VARCHAR(120) NOT NULL UNIQUE,
    password_plain VARCHAR(120) NOT NULL,
    CONSTRAINT fk_users_roles
        FOREIGN KEY (role_id) REFERENCES roles(role_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица категорий товаров
CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица производителей
CREATE TABLE manufacturers (
    manufacturer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица поставщиков
CREATE TABLE suppliers (
    supplier_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица товаров
CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    article VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    unit_name VARCHAR(20) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
    supplier_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL CHECK (discount_percent >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    description_text TEXT NULL,
    photo_file VARCHAR(255) NULL,
    CONSTRAINT fk_products_suppliers
        FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_products_manufacturers
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица пунктов выдачи
CREATE TABLE pickup_points (
    pickup_point_id INT UNSIGNED PRIMARY KEY,
    address_text VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица статусов заказов
CREATE TABLE order_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица заказов
CREATE TABLE orders (
    order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number INT UNSIGNED NOT NULL UNIQUE,
    article_text VARCHAR(255) NOT NULL,
    order_date DATE NULL,
    delivery_date DATE NULL,
    pickup_point_id INT UNSIGNED NOT NULL,
    client_user_id INT UNSIGNED NULL,
    pickup_code INT UNSIGNED NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL,
    CONSTRAINT fk_orders_pickup_points
        FOREIGN KEY (pickup_point_id) REFERENCES pickup_points(pickup_point_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_users
        FOREIGN KEY (client_user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_orders_statuses
        FOREIGN KEY (status_id) REFERENCES order_statuses(status_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица позиций заказа
CREATE TABLE order_items (
    order_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uk_order_product UNIQUE (order_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Индексы для производительности
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_status ON orders(status_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Raw-таблицы для импорта
CREATE TABLE users_import_raw (
    role_name VARCHAR(100),
    full_name VARCHAR(200),
    login_text VARCHAR(120),
    password_text VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products_import_raw (
    article_text VARCHAR(60),
    name_text VARCHAR(200),
    unit_text VARCHAR(20),
    price_text VARCHAR(40),
    supplier_text VARCHAR(120),
    manufacturer_text VARCHAR(120),
    category_text VARCHAR(120),
    discount_text VARCHAR(40),
    stock_text VARCHAR(40),
    description_text TEXT,
    photo_text VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pickup_points_import_raw (
    raw_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address_text VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders_import_raw (
    raw_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number_text VARCHAR(40),
    articles_text VARCHAR(255),
    order_date_text VARCHAR(40),
    delivery_date_text VARCHAR(40),
    pickup_point_text VARCHAR(40),
    client_fio_text VARCHAR(200),
    pickup_code_text VARCHAR(40),
    status_text VARCHAR(80)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


# Шаг 4. Подготовьте CSV из исходных XLSX (через Excel)

Откройте каждый xlsx в Excel, подготовьте строки и сохраните CSV UTF-8.

Команды/код
Подготовка файлов:

users_import.xlsx → удалите первую строку с заголовками → сохраните как users_import.csv (UTF-8)

Tovar.xlsx → удалите первую строку с заголовками → сохраните как Tovar.csv (UTF-8)

Пункты выдачи_import.xlsx → первую строку НЕ удаляйте (это данные) → сохраните как pickup_points_import.csv (UTF-8)

Заказ_import.xlsx → удалите пустые столбцы (если есть) и первую строку с заголовками → сохраните как orders_import.csv (UTF-8)

Примечание по датам в Заказ_import.csv:
Строка 7 содержит некорректную дату 30.02.2024. При импорте это значение станет NULL, что допустимо.

Проверка разделителя:
Откройте каждый csv в Блокноте и определите, какой символ используется как разделитель (; или ,). В Excel при сохранении CSV с региональными настройками России часто 
используется ;. Запомните этот символ — он понадобится при импорте.


# Шаг 5. Импортируйте данные через UI phpMyAdmin

Импортируйте CSV в raw-таблицы.

Команды/код
В phpMyAdmin выполните импорты (для каждого выставляйте Формат = CSV и  разделитель полей ";"):

1. Таблица users_import_raw

Файл: users_import.csv

Названия столбцов: role_name,full_name,login_text,password_text

2. Таблица products_import_raw

Файл: Tovar.csv

Названия столбцов: article_text,name_text,unit_text,price_text,supplier_text,manufacturer_text,category_text,discount_text,stock_text,description_text,photo_text

3. Таблица pickup_points_import_raw

Файл: Пункты выдачи_import.csv

Названия столбцов: address_text

4. Таблица orders_import_raw

Файл: Заказ_import.csv

Названия столбцов: order_number_text,articles_text,order_date_text,delivery_date_text,pickup_point_text,client_fio_text,pickup_code_text,status_text


# Шаг 5.1. Перенесите данные из raw в боевые таблицы

Заполните рабочие таблицы и связи.

Команды/код
Во вкладке SQL выполните:

sql
USE furniture2026_pu;

-- 1. Заполнение ролей
INSERT INTO roles (role_id, role_name) VALUES
(1, 'Гость'),
(2, 'Авторизированный клиент'),
(3, 'Менеджер'),
(4, 'Администратор');

-- 2. Заполнение пользователей
INSERT INTO users (role_id, full_name, login, password_plain)
SELECT
    CASE
        WHEN role_name LIKE '%Администратор%' THEN 4
        WHEN role_name LIKE '%Менеджер%' THEN 3
        ELSE 2
    END AS role_id,
    TRIM(full_name),
    TRIM(login_text),
    TRIM(REPLACE(password_text, '\r', ''))
FROM users_import_raw
WHERE TRIM(login_text) <> '';

-- 3. Заполнение категорий
INSERT INTO categories (name)
SELECT DISTINCT TRIM(category_text)
FROM products_import_raw
WHERE TRIM(category_text) <> '';

-- 4. Заполнение производителей
INSERT INTO manufacturers (name)
SELECT DISTINCT TRIM(manufacturer_text)
FROM products_import_raw
WHERE TRIM(manufacturer_text) <> '';

-- 5. Заполнение поставщиков
INSERT INTO suppliers (name)
SELECT DISTINCT TRIM(supplier_text)
FROM products_import_raw
WHERE TRIM(supplier_text) <> '';

-- 6. Заполнение товаров
INSERT INTO products (
    article, name, unit_name, price,
    supplier_id, manufacturer_id, category_id,
    discount_percent, stock_quantity, description_text, photo_file
)
SELECT
    TRIM(p.article_text),
    TRIM(p.name_text),
    TRIM(p.unit_text),
    CAST(REPLACE(TRIM(p.price_text), ',', '.') AS DECIMAL(12,2)),
    s.supplier_id,
    m.manufacturer_id,
    c.category_id,
    CAST(REPLACE(TRIM(p.discount_text), ',', '.') AS DECIMAL(5,2)),
    CAST(TRIM(p.stock_text) AS UNSIGNED),
    NULLIF(TRIM(p.description_text), ''),
    NULLIF(TRIM(REPLACE(p.photo_text, '\r', '')), '')
FROM products_import_raw p
JOIN suppliers s ON s.name = TRIM(p.supplier_text)
JOIN manufacturers m ON m.name = TRIM(p.manufacturer_text)
JOIN categories c ON c.name = TRIM(p.category_text)
WHERE TRIM(p.article_text) <> '';

-- 7. Заполнение пунктов выдачи
INSERT INTO pickup_points (pickup_point_id, address_text)
SELECT raw_id, TRIM(REPLACE(address_text, '\r', ''))
FROM pickup_points_import_raw
WHERE TRIM(REPLACE(address_text, '\r', '')) <> ''
ORDER BY raw_id;

-- 8. Заполнение статусов заказов
INSERT INTO order_statuses (status_name)
SELECT DISTINCT TRIM(REPLACE(status_text, '\r', ''))
FROM orders_import_raw
WHERE TRIM(REPLACE(status_text, '\r', '')) <> '';

-- 9. Заполнение заказов
INSERT INTO orders (
    order_number, article_text, order_date, delivery_date,
    pickup_point_id, client_user_id, pickup_code, status_id
)
SELECT
    CAST(TRIM(o.order_number_text) AS UNSIGNED),
    TRIM(o.articles_text),
    CASE
        WHEN STR_TO_DATE(TRIM(o.order_date_text), '%d.%m.%Y') IS NOT NULL
            THEN STR_TO_DATE(TRIM(o.order_date_text), '%d.%m.%Y')
        ELSE NULL
    END,
    CASE
        WHEN STR_TO_DATE(TRIM(o.delivery_date_text), '%d.%m.%Y') IS NOT NULL
            THEN STR_TO_DATE(TRIM(o.delivery_date_text), '%d.%m.%Y')
        ELSE NULL
    END,
    CAST(TRIM(o.pickup_point_text) AS UNSIGNED),
    u.user_id,
    CAST(TRIM(o.pickup_code_text) AS UNSIGNED),
    st.status_id
FROM orders_import_raw o
LEFT JOIN users u
    ON u.full_name = TRIM(o.client_fio_text)
JOIN order_statuses st
    ON st.status_name = REPLACE(TRIM(o.status_text), '\r', '')
WHERE TRIM(o.order_number_text) <> '';

-- 10. Заполнение позиций заказа
INSERT INTO order_items (order_id, product_id, quantity)
SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 2), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(o.article_text, ',', 1))
WHERE TRIM(o.article_text) <> ''

UNION ALL

SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 4), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 3), ',', -1))
WHERE TRIM(o.article_text) <> '';


!!!ЕСЛИ ЮНИОН ОЛЛ КРАСНОЕ,ТО
-- 10. Заполнение позиций заказа (альтернативный вариант — два отдельных INSERT)
-- Первая позиция каждого заказа
INSERT INTO order_items (order_id, product_id, quantity)
SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 2), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(o.article_text, ',', 1))
WHERE TRIM(o.article_text) <> '';

-- Вторая позиция каждого заказа
INSERT INTO order_items (order_id, product_id, quantity)
SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 4), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 3), ',', -1))
WHERE TRIM(o.article_text) <> '';
!!!!!!!!


!!!!!ЕСЛИ ФОРМАТ ДАТ НЕ ТОТ
-- 9. Заполнение заказов (упрощённый вариант для формата ГГГГ-ММ-ДД)
INSERT INTO orders (
    order_number, article_text, order_date, delivery_date,
    pickup_point_id, client_user_id, pickup_code, status_id
)
SELECT
    CAST(TRIM(o.order_number_text) AS UNSIGNED),
    TRIM(o.articles_text),
    NULLIF(TRIM(o.order_date_text), ''),      -- MySQL сам распознает ГГГГ-ММ-ДД
    NULLIF(TRIM(o.delivery_date_text), ''),
    CAST(TRIM(o.pickup_point_text) AS UNSIGNED),
    u.user_id,
    CAST(TRIM(o.pickup_code_text) AS UNSIGNED),
    st.status_id
FROM orders_import_raw o
LEFT JOIN users u
    ON u.full_name = TRIM(o.client_fio_text)
JOIN order_statuses st
    ON st.status_name = REPLACE(TRIM(o.status_text), '\r', '')
WHERE TRIM(o.order_number_text) <> '';
!!!!!!!!!!!!!!!!!!!!


!!ЕСЛИ ОРДЕР ИТЕМС НЕ ЗАПОЛНЕН, ТО!!!
-- 10. Заполнение позиций заказа (исправленная версия)
-- Первая позиция: артикул и количество
INSERT INTO order_items (order_id, product_id, quantity)
SELECT 
    o.order_id,
    pr.product_id,
    CAST(TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 2), ',', -1), ' ', '')) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr 
    ON pr.article = TRIM(SUBSTRING_INDEX(o.article_text, ',', 1))
WHERE TRIM(o.article_text) <> ''
  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 2), ',', -1)) != '';

-- Вторая позиция: артикул и количество
INSERT INTO order_items (order_id, product_id, quantity)
SELECT 
    o.order_id,
    pr.product_id,
    CAST(TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 4), ',', -1), ' ', '')) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr 
    ON pr.article = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 3), ',', -1))
WHERE TRIM(o.article_text) <> ''
  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 4), ',', -1)) != '';

  !!!!!!!


# Шаг 6. Выполните контрольные SQL-проверки

Проверьте, что данные загружены полностью.

Команды/код
sql
USE furniture2026_pu;

SELECT 'roles' AS table_name, COUNT(*) AS cnt FROM roles
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'manufacturers', COUNT(*) FROM manufacturers
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'pickup_points', COUNT(*) FROM pickup_points
UNION ALL SELECT 'order_statuses', COUNT(*) FROM order_statuses
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;



Ожидаемые результаты:

roles = 4
users = 10
categories = количество уникальных категорий из Tovar.xlsx (Прихожая, Диван, Обувница, Пуф, Полка, Стул → 6)
manufacturers = количество уникальных производителей (SVМЕБЕЛЬ, Мебелони, Инвуд, RIDBERG → 4)
suppliers = количество уникальных поставщиков (Стройландия, Кромма, ЗолотоеРуно, KRYLOVMANUFACTURA → 4)
products = 10
pickup_points = 36
order_statuses = 2 (Новый, Завершен)
orders = 10
order_items = 20

Проверка данных для входа:

sql
SELECT
    u.login,
    TRIM(REPLACE(u.password_plain, CHAR(13), '')) AS password_plain,
    u.full_name,
    r.role_name
FROM users u
JOIN roles r ON r.role_id = u.role_id
ORDER BY r.role_id, u.full_name;


# Шаг 7. Создайте WPF-проект, установите пакет MySQL и добавьте ресурсы

Создайте проект в Visual Studio Community 2026, подключите MySql.Data и добавьте файлы ресурсов.

Команды/код
Откройте Visual Studio Community 2026

Нажмите Создать проект
Выберите шаблон Приложение WPF (.NET Framework)
Имя проекта: FurnitureStoreApp
Путь: C:\furniture_store_2026_pu
Framework: .NET Framework 4.8
Нажмите Создать

Установите NuGet-пакет:
Меню Проект → Управление пакетами NuGet...
Вкладка Обзор → найдите MySql.Data
Установите версию 8.4.0

Скопируйте ресурсы в папку проекта:

Из C:\furniture_store_2026_pu\resources\photos скопируйте все .jpg в C:\furniture_store_2026_pu\FurnitureStoreApp\FurnitureStoreApp\resources\photos

Если нет папки picture.png, создайте простую заглушку или скопируйте из примера

В Обозревателе решений нажмите Показать все файлы
Для папки resources и всех файлов: ПКМ → Включить в проект
Для каждого .jpg и picture.png в свойствах (F4) установите:
Действие при сборке = Resource


# Шаг 8. Создайте Db.cs и проверьте подключение к MySQL

Вынесите строку подключения в отдельный класс и проверьте соединение через код.

Команды/код
Создайте файл Db.cs:

Обозреватель решений → ПКМ по проекту → Добавить → Класс... → имя Db.cs

csharp
using MySql.Data.MySqlClient;

namespace FurnitureStoreApp
{
    internal static class Db
    {
        // Для XAMPP (стандартные настройки: root, пустой пароль)
        public const string ConnectionString =
            "Server=127.0.0.1;Port=3306;Database=furniture2026_pu;Uid=root;Pwd=;Charset=utf8mb4;Allow Zero Datetime=True;Convert Zero Datetime=True;";

        // Для Docker (если используете Docker)
        // public const string ConnectionString =
        //     "Server=127.0.0.1;Port=3306;Database=furniture2026_pu;Uid=demo;Pwd=demo;Charset=utf8mb4;Allow Zero Datetime=True;Convert Zero Datetime=True;";

        public static MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
    }
}
Временно проверьте подключение — откройте App.xaml.cs и замените содержимое:

csharp
using System.Windows;

namespace FurnitureStoreApp
{
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            try
            {
                using (var conn = Db.GetConnection())
                {
                    conn.Open();
                }
                MessageBox.Show("OK: подключение к MySQL успешно.", "Проверка БД",
                    MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show("Ошибка подключения к MySQL:\n" + ex.Message, "Проверка БД",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
Запустите F5. После проверки верните App.xaml.cs в исходное состояние.


# Шаг 9. Создайте Models.cs

Создайте модели для ролей, товаров и заказов.

Команды/код
Создайте файл Models.cs:

csharp
using System;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace FurnitureStoreApp
{
    public class UserInfo
    {
        public int? UserId { get; set; }
        public string FullName { get; set; }
        public string RoleName { get; set; }
    }

    public class LookupItem
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public override string ToString()
        {
            return Name;
        }
    }

    public class ProductRow
    {
        public int ProductId { get; set; }
        public string Article { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string Manufacturer { get; set; }
        public string Supplier { get; set; }
        public decimal Price { get; set; }
        public decimal DiscountPercent { get; set; }
        public decimal FinalPrice { get; set; }
        public string UnitName { get; set; }
        public int StockQuantity { get; set; }
        public bool HasDiscount { get; set; }
        public string PhotoFile { get; set; }
        public BitmapImage PhotoImage { get; set; }

        // Цвет фона строки в зависимости от условий
        public Brush RowBrush
        {
            get
            {
                // Если товара нет на складе — серый цвет
                if (StockQuantity == 0)
                    return new SolidColorBrush((Color)ColorConverter.ConvertFromString("#D3D3D3"));
                // Если скидка > 15% — цвет #008080 (согласно руководству по стилю)
                if (DiscountPercent > 15m)
                    return new SolidColorBrush((Color)ColorConverter.ConvertFromString("#008080"));
                // Иначе — основной фон #FFFFFF
                return new SolidColorBrush((Color)ColorConverter.ConvertFromString("#FFFFFF"));
            }
        }

        public Brush RowForeground
        {
            get
            {
                return new SolidColorBrush((Color)ColorConverter.ConvertFromString("#000000"));
            }
        }
    }

    public class ProductEditModel
    {
        public int? ProductId { get; set; }
        public string Article { get; set; }
        public string Name { get; set; }
        public int CategoryId { get; set; }
        public string Description { get; set; }
        public int ManufacturerId { get; set; }
        public string SupplierName { get; set; }
        public decimal Price { get; set; }
        public string UnitName { get; set; }
        public int StockQuantity { get; set; }
        public decimal DiscountPercent { get; set; }
        public string PhotoFile { get; set; }
    }

    public class OrderRow
    {
        public int OrderId { get; set; }
        public int OrderNumber { get; set; }
        public string ArticlesText { get; set; }
        public string StatusName { get; set; }
        public string PickupAddress { get; set; }
        public DateTime? OrderDate { get; set; }
        public DateTime? DeliveryDate { get; set; }
    }

    public class OrderEditModel
    {
        public int? OrderId { get; set; }
        public int OrderNumber { get; set; }
        public string ArticlesText { get; set; }
        public int StatusId { get; set; }
        public int PickupPointId { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public int PickupCode { get; set; }
    }
}


# Шаг 10. Создайте DataService.cs

Создайте единый слой доступа к БД для модулей 2–4.

Команды/код
Создайте файл DataService.cs:

csharp
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Windows.Media.Imaging;

namespace FurnitureStoreApp
{
    internal static class DataService
    {
        // Авторизация пользователя
        public static UserInfo Auth(string login, string password)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT u.user_id, u.full_name, r.role_name
                        FROM users u
                        JOIN roles r ON r.role_id = u.role_id
                        WHERE u.login = @login AND u.password_plain = @password";
                    cmd.Parameters.AddWithValue("@login", login);
                    cmd.Parameters.AddWithValue("@password", password);

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new UserInfo
                        {
                            UserId = rd.GetInt32("user_id"),
                            FullName = rd.GetString("full_name"),
                            RoleName = rd.GetString("role_name")
                        };
                    }
                }
            }
        }

        // Получение списка товаров
        public static List<ProductRow> GetProducts()
        {
            var result = new List<ProductRow>();

            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            p.product_id,
                            p.article,
                            p.name,
                            c.name AS category_name,
                            p.description_text,
                            m.name AS manufacturer_name,
                            s.name AS supplier_name,
                            p.price,
                            p.discount_percent,
                            p.unit_name,
                            p.stock_quantity,
                            p.photo_file
                        FROM products p
                        JOIN categories c ON c.category_id = p.category_id
                        JOIN manufacturers m ON m.manufacturer_id = p.manufacturer_id
                        JOIN suppliers s ON s.supplier_id = p.supplier_id
                        ORDER BY p.product_id";

                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            var price = ParseDecimal(rd["price"]);
                            var discount = ParseDecimal(rd["discount_percent"]);
                            var finalPrice = Math.Round(price * (100m - discount) / 100m, 2);

                            var photoFile = rd["photo_file"] == DBNull.Value ? "" : rd["photo_file"].ToString();
                            result.Add(new ProductRow
                            {
                                ProductId = Convert.ToInt32(rd["product_id"]),
                                Article = rd["article"].ToString(),
                                Name = rd["name"].ToString(),
                                Category = rd["category_name"].ToString(),
                                Description = rd["description_text"] == DBNull.Value ? "" : rd["description_text"].ToString(),
                                Manufacturer = rd["manufacturer_name"].ToString(),
                                Supplier = rd["supplier_name"].ToString(),
                                Price = price,
                                DiscountPercent = discount,
                                FinalPrice = finalPrice,
                                UnitName = rd["unit_name"].ToString(),
                                StockQuantity = Convert.ToInt32(rd["stock_quantity"]),
                                HasDiscount = discount > 0m,
                                PhotoFile = photoFile,
                                PhotoImage = LoadPhoto(photoFile)
                            });
                        }
                    }
                }
            }
            return result;
        }

        // Получение списка поставщиков для фильтра
        public static List<string> GetSupplierNames()
        {
            var result = new List<string>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT name FROM suppliers ORDER BY name";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                            result.Add(rd.GetString("name"));
                    }
                }
            }
            return result;
        }

        // Получение списка категорий
        public static List<LookupItem> GetCategories()
        {
            return GetLookup("SELECT category_id AS id, name FROM categories ORDER BY name");
        }

        // Получение списка производителей
        public static List<LookupItem> GetManufacturers()
        {
            return GetLookup("SELECT manufacturer_id AS id, name FROM manufacturers ORDER BY name");
        }

        // Получение списка статусов заказов
        public static List<LookupItem> GetStatuses()
        {
            return GetLookup("SELECT status_id AS id, status_name AS name FROM order_statuses ORDER BY status_name");
        }

        // Получение списка пунктов выдачи
        public static List<LookupItem> GetPickupPoints()
        {
            var result = new List<LookupItem>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT pickup_point_id, address_text FROM pickup_points ORDER BY pickup_point_id";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            result.Add(new LookupItem
                            {
                                Id = Convert.ToInt32(rd["pickup_point_id"]),
                                Name = rd["pickup_point_id"] + ". " + rd["address_text"]
                            });
                        }
                    }
                }
            }
            return result;
        }

        // Получение товара по ID для редактирования
        public static ProductEditModel GetProductById(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            p.product_id,
                            p.article,
                            p.name,
                            p.category_id,
                            p.description_text,
                            p.manufacturer_id,
                            s.name AS supplier_name,
                            p.price,
                            p.unit_name,
                            p.stock_quantity,
                            p.discount_percent,
                            p.photo_file
                        FROM products p
                        JOIN suppliers s ON s.supplier_id = p.supplier_id
                        WHERE p.product_id = @id";
                    cmd.Parameters.AddWithValue("@id", productId);
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new ProductEditModel
                        {
                            ProductId = Convert.ToInt32(rd["product_id"]),
                            Article = rd["article"].ToString(),
                            Name = rd["name"].ToString(),
                            CategoryId = Convert.ToInt32(rd["category_id"]),
                            Description = rd["description_text"] == DBNull.Value ? "" : rd["description_text"].ToString(),
                            ManufacturerId = Convert.ToInt32(rd["manufacturer_id"]),
                            SupplierName = rd["supplier_name"].ToString(),
                            Price = ParseDecimal(rd["price"]),
                            UnitName = rd["unit_name"].ToString(),
                            StockQuantity = Convert.ToInt32(rd["stock_quantity"]),
                            DiscountPercent = ParseDecimal(rd["discount_percent"]),
                            PhotoFile = rd["photo_file"] == DBNull.Value ? "" : rd["photo_file"].ToString()
                        };
                    }
                }
            }
        }

        // Сохранение товара (добавление или редактирование)
        public static void SaveProduct(ProductEditModel model)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        var supplierId = EnsureSupplier(conn, tx, model.SupplierName);

                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            if (model.ProductId.HasValue)
                            {
                                cmd.CommandText = @"
                                    UPDATE products
                                    SET
                                        article = @article,
                                        name = @name,
                                        category_id = @categoryId,
                                        description_text = @description,
                                        manufacturer_id = @manufacturerId,
                                        supplier_id = @supplierId,
                                        price = @price,
                                        unit_name = @unitName,
                                        stock_quantity = @stock,
                                        discount_percent = @discount,
                                        photo_file = @photo
                                    WHERE product_id = @id";
                                cmd.Parameters.AddWithValue("@id", model.ProductId.Value);
                            }
                            else
                            {
                                cmd.CommandText = @"
                                    INSERT INTO products(
                                        article, name, category_id, description_text, manufacturer_id,
                                        supplier_id, price, unit_name, stock_quantity, discount_percent, photo_file
                                    )
                                    VALUES(
                                        @article, @name, @categoryId, @description, @manufacturerId,
                                        @supplierId, @price, @unitName, @stock, @discount, @photo
                                    )";
                            }

                            cmd.Parameters.AddWithValue("@article", model.Article);
                            cmd.Parameters.AddWithValue("@name", model.Name);
                            cmd.Parameters.AddWithValue("@categoryId", model.CategoryId);
                            cmd.Parameters.AddWithValue("@description", string.IsNullOrWhiteSpace(model.Description) ? (object)DBNull.Value : model.Description);
                            cmd.Parameters.AddWithValue("@manufacturerId", model.ManufacturerId);
                            cmd.Parameters.AddWithValue("@supplierId", supplierId);
                            cmd.Parameters.AddWithValue("@price", model.Price);
                            cmd.Parameters.AddWithValue("@unitName", model.UnitName);
                            cmd.Parameters.AddWithValue("@stock", model.StockQuantity);
                            cmd.Parameters.AddWithValue("@discount", model.DiscountPercent);
                            cmd.Parameters.AddWithValue("@photo", string.IsNullOrWhiteSpace(model.PhotoFile) ? (object)DBNull.Value : model.PhotoFile);
                            cmd.ExecuteNonQuery();
                        }
                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        // Проверка, используется ли товар в заказах
        public static bool ProductExistsInOrders(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COUNT(*) FROM order_items WHERE product_id = @id";
                    cmd.Parameters.AddWithValue("@id", productId);
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        // Удаление товара
        public static void DeleteProduct(int productId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "DELETE FROM products WHERE product_id = @id";
                    cmd.Parameters.AddWithValue("@id", productId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Получение списка заказов
        public static List<OrderRow> GetOrders()
        {
            var result = new List<OrderRow>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            o.order_id,
                            o.order_number,
                            o.article_text,
                            os.status_name,
                            pp.address_text,
                            DATE_FORMAT(NULLIF(o.order_date, '0000-00-00'), '%Y-%m-%d') AS order_date_text,
                            DATE_FORMAT(NULLIF(o.delivery_date, '0000-00-00'), '%Y-%m-%d') AS delivery_date_text
                        FROM orders o
                        JOIN order_statuses os ON os.status_id = o.status_id
                        JOIN pickup_points pp ON pp.pickup_point_id = o.pickup_point_id
                        ORDER BY o.order_number";
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            result.Add(new OrderRow
                            {
                                OrderId = Convert.ToInt32(rd["order_id"]),
                                OrderNumber = Convert.ToInt32(rd["order_number"]),
                                ArticlesText = rd["article_text"].ToString(),
                                StatusName = rd["status_name"].ToString(),
                                PickupAddress = rd["address_text"].ToString(),
                                OrderDate = ParseNullableDate(rd["order_date_text"]),
                                DeliveryDate = ParseNullableDate(rd["delivery_date_text"])
                            });
                        }
                    }
                }
            }
            return result;
        }

        // Получение заказа по ID для редактирования
        public static OrderEditModel GetOrderById(int orderId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT
                            order_id, order_number, article_text, status_id,
                            pickup_point_id,
                            DATE_FORMAT(NULLIF(order_date, '0000-00-00'), '%Y-%m-%d') AS order_date_text,
                            DATE_FORMAT(NULLIF(delivery_date, '0000-00-00'), '%Y-%m-%d') AS delivery_date_text,
                            pickup_code
                        FROM orders
                        WHERE order_id = @id";
                    cmd.Parameters.AddWithValue("@id", orderId);
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read()) return null;
                        return new OrderEditModel
                        {
                            OrderId = Convert.ToInt32(rd["order_id"]),
                            OrderNumber = Convert.ToInt32(rd["order_number"]),
                            ArticlesText = rd["article_text"].ToString(),
                            StatusId = Convert.ToInt32(rd["status_id"]),
                            PickupPointId = Convert.ToInt32(rd["pickup_point_id"]),
                            OrderDate = ParseNullableDate(rd["order_date_text"]) ?? DateTime.Today,
                            DeliveryDate = ParseNullableDate(rd["delivery_date_text"]) ?? DateTime.Today,
                            PickupCode = Convert.ToInt32(rd["pickup_code"])
                        };
                    }
                }
            }
        }

        // Получение следующего номера заказа
        public static int GetNextOrderNumber()
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COALESCE(MAX(order_number), 0) + 1 FROM orders";
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        // Получение следующего кода получения
        public static int GetNextPickupCode()
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COALESCE(MAX(pickup_code), 900) + 1 FROM orders";
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        // Сохранение заказа
        public static void SaveOrder(OrderEditModel model)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        var pairs = ParseOrderArticles(model.ArticlesText);
                        var articleMap = ResolveArticleMap(conn, tx, pairs);

                        int orderId = model.OrderId ?? 0;
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            if (model.OrderId.HasValue)
                            {
                                cmd.CommandText = @"
                                    UPDATE orders
                                    SET
                                        article_text = @articles,
                                        status_id = @statusId,
                                        pickup_point_id = @pickupId,
                                        order_date = @orderDate,
                                        delivery_date = @deliveryDate
                                    WHERE order_id = @id";
                                cmd.Parameters.AddWithValue("@id", model.OrderId.Value);
                            }
                            else
                            {
                                cmd.CommandText = @"
                                    INSERT INTO orders(
                                        order_number, article_text, order_date, delivery_date,
                                        pickup_point_id, client_user_id, pickup_code, status_id
                                    )
                                    VALUES(
                                        @orderNumber, @articles, @orderDate, @deliveryDate,
                                        @pickupId, NULL, @pickupCode, @statusId
                                    )";
                                cmd.Parameters.AddWithValue("@orderNumber", model.OrderNumber);
                                cmd.Parameters.AddWithValue("@pickupCode", model.PickupCode);
                            }

                            cmd.Parameters.AddWithValue("@articles", model.ArticlesText);
                            cmd.Parameters.AddWithValue("@statusId", model.StatusId);
                            cmd.Parameters.AddWithValue("@pickupId", model.PickupPointId);
                            cmd.Parameters.AddWithValue("@orderDate", model.OrderDate.Date);
                            cmd.Parameters.AddWithValue("@deliveryDate", model.DeliveryDate.Date);
                            cmd.ExecuteNonQuery();

                            if (!model.OrderId.HasValue)
                                orderId = (int)cmd.LastInsertedId;
                        }

                        // Удаляем старые позиции
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = "DELETE FROM order_items WHERE order_id = @orderId";
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            cmd.ExecuteNonQuery();
                        }

                        // Вставляем новые позиции
                        foreach (var p in pairs)
                        {
                            using (var cmd = conn.CreateCommand())
                            {
                                cmd.Transaction = tx;
                                cmd.CommandText = "INSERT INTO order_items(order_id, product_id, quantity) VALUES(@orderId, @productId, @qty)";
                                cmd.Parameters.AddWithValue("@orderId", orderId);
                                cmd.Parameters.AddWithValue("@productId", articleMap[p.Article]);
                                cmd.Parameters.AddWithValue("@qty", p.Quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        // Удаление заказа
        public static void DeleteOrder(int orderId)
        {
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "DELETE FROM orders WHERE order_id = @id";
                    cmd.Parameters.AddWithValue("@id", orderId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Вспомогательные методы

        private static List<OrderArticlePair> ParseOrderArticles(string text)
        {
            var tokens = (text ?? "")
                .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim())
                .Where(x => x.Length > 0)
                .ToList();

            if (tokens.Count < 2 || tokens.Count % 2 != 0)
                throw new Exception("Поле артикулов задается парами: артикул, количество.");

            var result = new List<OrderArticlePair>();
            for (int i = 0; i < tokens.Count; i += 2)
            {
                if (!int.TryParse(tokens[i + 1], out int qty))
                    throw new Exception("Количество в паре артикулов должно быть целым числом.");
                if (qty <= 0)
                    throw new Exception("Количество в паре артикулов должно быть больше 0.");

                result.Add(new OrderArticlePair
                {
                    Article = tokens[i],
                    Quantity = qty
                });
            }
            return result;
        }

        private static Dictionary<string, int> ResolveArticleMap(MySqlConnection conn, MySqlTransaction tx, List<OrderArticlePair> pairs)
        {
            var uniqueArticles = pairs.Select(x => x.Article).Distinct().ToList();
            var result = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                var paramNames = new List<string>();
                for (int i = 0; i < uniqueArticles.Count; i++)
                {
                    var p = "@a" + i;
                    paramNames.Add(p);
                    cmd.Parameters.AddWithValue(p, uniqueArticles[i]);
                }
                cmd.CommandText = "SELECT article, product_id FROM products WHERE article IN (" + string.Join(",", paramNames) + ")";
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                        result[rd["article"].ToString()] = Convert.ToInt32(rd["product_id"]);
                }
            }

            var missing = uniqueArticles.Where(x => !result.ContainsKey(x)).ToList();
            if (missing.Count > 0)
                throw new Exception("В таблице products не найдены артикулы: " + string.Join(", ", missing));

            return result;
        }

        private static int EnsureSupplier(MySqlConnection conn, MySqlTransaction tx, string supplierName)
        {
            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                cmd.CommandText = "SELECT supplier_id FROM suppliers WHERE name = @name";
                cmd.Parameters.AddWithValue("@name", supplierName);
                var exists = cmd.ExecuteScalar();
                if (exists != null && exists != DBNull.Value)
                    return Convert.ToInt32(exists);
            }

            using (var cmd = conn.CreateCommand())
            {
                cmd.Transaction = tx;
                cmd.CommandText = "INSERT INTO suppliers(name) VALUES(@name)";
                cmd.Parameters.AddWithValue("@name", supplierName);
                cmd.ExecuteNonQuery();
                return (int)cmd.LastInsertedId;
            }
        }

        private static List<LookupItem> GetLookup(string sql)
        {
            var result = new List<LookupItem>();
            using (var conn = Db.GetConnection())
            {
                conn.Open();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            result.Add(new LookupItem
                            {
                                Id = Convert.ToInt32(rd["id"]),
                                Name = rd["name"].ToString()
                            });
                        }
                    }
                }
            }
            return result;
        }

        private static decimal ParseDecimal(object value)
        {
            if (value == null || value == DBNull.Value) return 0m;
            return Convert.ToDecimal(value, CultureInfo.InvariantCulture);
        }

        private static DateTime? ParseNullableDate(object value)
        {
            if (value == null || value == DBNull.Value) return null;
            var text = value.ToString();
            if (string.IsNullOrWhiteSpace(text)) return null;

            if (DateTime.TryParse(text, out DateTime date))
                return date.Date;

            return null;
        }

        private static BitmapImage LoadPhoto(string fileName)
        {
            // Заглушка по умолчанию
            var defaultUri = new Uri("pack://application:,,,/resources/picture.png", UriKind.Absolute);

            if (!string.IsNullOrWhiteSpace(fileName))
            {
                var cleanName = Path.GetFileName(fileName.Trim());
                var runtimePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "resources", "photos", cleanName);
                if (File.Exists(runtimePath))
                {
                    return LoadBitmap(new Uri(runtimePath, UriKind.Absolute));
                }

                var packPhoto = $"pack://application:,,,/resources/photos/{cleanName}";
                try
                {
                    return LoadBitmap(new Uri(packPhoto, UriKind.Absolute));
                }
                catch
                {
                    // Если фото не загрузилось — используем заглушку
                }
            }
            return LoadBitmap(defaultUri);
        }

        private static BitmapImage LoadBitmap(Uri uri)
        {
            try
            {
                var image = new BitmapImage();
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.UriSource = uri;
                image.EndInit();
                image.Freeze();
                return image;
            }
            catch
            {
                // Если не удалось загрузить — возвращаем null, в XAML будет пусто
                return null;
            }
        }

        private class OrderArticlePair
        {
            public string Article { get; set; }
            public int Quantity { get; set; }
        }
    }
}


# Шаг 11. Создайте LoginWindow и настройте старт приложения

Сделайте окно входа (логин/пароль + гость) и назначьте его стартовым.

Команды/код
Создайте окно LoginWindow.xaml:

xml
<Window x:Class="FurnitureStoreApp.LoginWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Вход в систему"
        Height="350"
        Width="550"
        FontFamily="Calibri"
        Background="#FFFFFF"
        WindowStartupLocation="CenterScreen">
    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TextBlock Text="Логин" FontSize="18" Margin="0,0,0,8"/>
        <TextBox x:Name="LoginTextBox" Grid.Row="1" Height="36" FontSize="16" Margin="0,0,0,16"/>

        <TextBlock Text="Пароль" Grid.Row="2" FontSize="18" Margin="0,0,0,8"/>
        <PasswordBox x:Name="PasswordTextBox" Grid.Row="3" Height="36" FontSize="16" Margin="0,0,0,16"/>

        <StackPanel Grid.Row="4" Orientation="Horizontal" HorizontalAlignment="Right">
            <Button Content="Войти" Width="140" Height="40" Margin="0,0,12,0" 
                    Background="#0000FF" Foreground="White" Click="Login_Click"/>
            <Button Content="Войти как гость" Width="160" Height="40" 
                    Background="#00FFFF" Click="Guest_Click"/>
        </StackPanel>
    </Grid>
</Window>


LoginWindow.xaml.cs:

csharp
using System;
using System.Windows;

namespace FurnitureStoreApp
{
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var login = LoginTextBox.Text.Trim();
            var password = PasswordTextBox.Password.Trim();

            if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Введите логин и пароль.", "Ошибка входа",
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                var user = DataService.Auth(login, password);
                if (user == null)
                {
                    MessageBox.Show("Неверный логин или пароль.", "Ошибка входа",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                OpenMain(user);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка подключения к базе данных:\n{ex.Message}",
                    "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Guest_Click(object sender, RoutedEventArgs e)
        {
            var guest = new UserInfo
            {
                UserId = null,
                FullName = "Гость",
                RoleName = "Гость"
            };
            OpenMain(guest);
        }

        private void OpenMain(UserInfo user)
        {
            var mainWindow = new MainWindow(user);
            mainWindow.Show();
            Close();
        }
    }
}
Обновите App.xaml:

xml
<Application x:Class="FurnitureStoreApp.App"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             StartupUri="LoginWindow.xaml">
    <Application.Resources>
    </Application.Resources>
</Application>


# Шаг 12. Создайте окно ProductFormWindow (добавление/редактирование товара)

Сделайте форму добавления/редактирования товара с выбором фото до 300x200 пикселей.

Команды/код
ProductFormWindow.xaml:

xml
<Window x:Class="FurnitureStoreApp.ProductFormWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Добавление/редактирование товара"
        Height="800"
        Width="1000"
        FontFamily="Calibri"
        Background="#FFFFFF"
        WindowStartupLocation="CenterOwner">
    <Grid Margin="16">
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Grid Grid.Row="0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="1*"/>
            </Grid.ColumnDefinitions>

            <!-- Левая панель с полями -->
            <Grid Grid.Column="0" Margin="0,0,16,0">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="180"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <TextBlock x:Name="IdLabel" Text="ID товара:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="IdTextBox" Grid.Column="1" IsReadOnly="True" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="1" Text="Артикул:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="ArticleTextBox" Grid.Row="1" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="2" Text="Наименование:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="NameTextBox" Grid.Row="2" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="3" Text="Категория:" VerticalAlignment="Center" FontSize="16"/>
                <ComboBox x:Name="CategoryComboBox" Grid.Row="3" Grid.Column="1" Margin="0,0,0,8" Height="30"/>

                <TextBlock Grid.Row="4" Text="Описание:" VerticalAlignment="Top" FontSize="16"/>
                <TextBox x:Name="DescriptionTextBox" Grid.Row="4" Grid.Column="1" Height="80" 
                         TextWrapping="Wrap" AcceptsReturn="True" Margin="0,0,0,8" FontSize="14"/>

                <TextBlock Grid.Row="5" Text="Производитель:" VerticalAlignment="Center" FontSize="16"/>
                <ComboBox x:Name="ManufacturerComboBox" Grid.Row="5" Grid.Column="1" Margin="0,0,0,8" Height="30"/>

                <TextBlock Grid.Row="6" Text="Поставщик:" VerticalAlignment="Center" FontSize="16"/>
                <ComboBox x:Name="SupplierComboBox" Grid.Row="6" Grid.Column="1" Margin="0,0,0,8" Height="30"
                          IsEditable="True" Text=""/>

                <TextBlock Grid.Row="7" Text="Цена:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="PriceTextBox" Grid.Row="7" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="8" Text="Единица измерения:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="UnitTextBox" Grid.Row="8" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="9" Text="Кол-во на складе:" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="StockTextBox" Grid.Row="9" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>

                <TextBlock Grid.Row="10" Text="Скидка (%):" VerticalAlignment="Center" FontSize="16"/>
                <TextBox x:Name="DiscountTextBox" Grid.Row="10" Grid.Column="1" Margin="0,0,0,8" FontSize="14" Height="30"/>
            </Grid>

            <!-- Правая панель с фото -->
            <StackPanel Grid.Column="1">
                <TextBlock Text="Фото товара" FontSize="16" Margin="0,0,0,8"/>
                <Border BorderBrush="#0000FF" BorderThickness="2" Width="320" Height="220">
                    <Image x:Name="PhotoImage" Stretch="Uniform"/>
                </Border>
                <Button Content="Выбрать фото" Width="180" Height="36" Margin="0,12,0,0" 
                        Background="#0000FF" Foreground="White" Click="ChoosePhoto_Click"/>
                <TextBlock Text="* Размер фото не более 300x200" FontSize="12" Foreground="Gray" Margin="0,8,0,0"/>
            </StackPanel>
        </Grid>

        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,16,0,0">
            <Button Content="Сохранить" Width="160" Height="40" Margin="0,0,12,0" 
                    Background="#0000FF" Foreground="White" Click="Save_Click"/>
            <Button Content="Назад" Width="160" Height="40" 
                    Background="#00FFFF" Click="Back_Click"/>
        </StackPanel>
    </Grid>
</Window>


ProductFormWindow.xaml.cs:

csharp
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Media.Imaging;

namespace FurnitureStoreApp
{
    public partial class ProductFormWindow : Window
    {
        private readonly int? _productId;
        private string _oldPhotoFile = "";
        private string _selectedPhotoPath = "";
        private List<LookupItem> _suppliers;

        public ProductFormWindow(int? productId = null)
        {
            InitializeComponent();
            _productId = productId;
            LoadLookups();

            if (_productId.HasValue)
            {
                LoadProduct(_productId.Value);
            }
            else
            {
                IdLabel.Visibility = Visibility.Collapsed;
                IdTextBox.Visibility = Visibility.Collapsed;
                SetPreviewFromPack("pack://application:,,,/resources/picture.png");
            }
        }

        private void LoadLookups()
        {
            // Загрузка категорий
            CategoryComboBox.DisplayMemberPath = "Name";
            CategoryComboBox.SelectedValuePath = "Id";
            CategoryComboBox.ItemsSource = DataService.GetCategories();

            // Загрузка производителей
            ManufacturerComboBox.DisplayMemberPath = "Name";
            ManufacturerComboBox.SelectedValuePath = "Id";
            ManufacturerComboBox.ItemsSource = DataService.GetManufacturers();

            // Загрузка поставщиков для выпадающего списка
            _suppliers = DataService.GetSupplierNames().Select(s => new LookupItem { Id = 0, Name = s }).ToList();
            SupplierComboBox.DisplayMemberPath = "Name";
            SupplierComboBox.SelectedValuePath = "Name";
            SupplierComboBox.ItemsSource = _suppliers;
        }

        private void LoadProduct(int productId)
        {
            var row = DataService.GetProductById(productId);
            if (row == null)
            {
                MessageBox.Show("Товар не найден.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                Close();
                return;
            }

            IdTextBox.Text = row.ProductId.Value.ToString();
            ArticleTextBox.Text = row.Article;
            NameTextBox.Text = row.Name;
            DescriptionTextBox.Text = row.Description;
            PriceTextBox.Text = row.Price.ToString("0.##", CultureInfo.InvariantCulture);
            UnitTextBox.Text = row.UnitName;
            StockTextBox.Text = row.StockQuantity.ToString();
            DiscountTextBox.Text = row.DiscountPercent.ToString("0.##", CultureInfo.InvariantCulture);

            CategoryComboBox.SelectedValue = row.CategoryId;
            ManufacturerComboBox.SelectedValue = row.ManufacturerId;

            // Выбор поставщика в выпадающем списке
            var supplierItem = _suppliers.FirstOrDefault(s => s.Name == row.SupplierName);
            if (supplierItem != null)
                SupplierComboBox.SelectedItem = supplierItem;
            else
                SupplierComboBox.Text = row.SupplierName;

            _oldPhotoFile = row.PhotoFile ?? "";
            if (!string.IsNullOrWhiteSpace(_oldPhotoFile))
            {
                var fileName = Path.GetFileName(_oldPhotoFile);
                var runtimePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "resources", "photos", fileName);
                if (File.Exists(runtimePath))
                {
                    PhotoImage.Source = LoadBitmap(runtimePath);
                }
                else
                {
                    SetPreviewFromPack($"pack://application:,,,/resources/photos/{fileName}");
                }
            }
            else
            {
                SetPreviewFromPack("pack://application:,,,/resources/picture.png");
            }
        }

        private void ChoosePhoto_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new OpenFileDialog
            {
                Filter = "Изображения|*.png;*.jpg;*.jpeg;*.bmp"
            };
            if (dialog.ShowDialog() != true) return;

            var bitmap = LoadBitmap(dialog.FileName);
            if (bitmap == null)
            {
                MessageBox.Show("Не удалось прочитать изображение.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // Проверка размера 300x200
            if (bitmap.PixelWidth > 300 || bitmap.PixelHeight > 200)
            {
                MessageBox.Show("Размер фото не должен превышать 300x200 пикселей.", 
                    "Ограничение", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            _selectedPhotoPath = dialog.FileName;
            PhotoImage.Source = bitmap;
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            // Валидация
            var article = ArticleTextBox.Text.Trim();
            var name = NameTextBox.Text.Trim();
            var unit = UnitTextBox.Text.Trim();

            if (string.IsNullOrWhiteSpace(article) || string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(unit))
            {
                MessageBox.Show("Заполните обязательные поля: артикул, наименование, единица измерения.",
                    "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (CategoryComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите категорию товара.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (ManufacturerComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите производителя.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var supplierName = SupplierComboBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(supplierName))
            {
                MessageBox.Show("Введите или выберите поставщика.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!TryParseDecimal(PriceTextBox.Text, out var price) || price < 0)
            {
                MessageBox.Show("Цена должна быть положительным числом.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!int.TryParse(StockTextBox.Text.Trim(), out var stock) || stock < 0)
            {
                MessageBox.Show("Количество на складе должно быть целым неотрицательным числом.", 
                    "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!TryParseDecimal(DiscountTextBox.Text, out var discount) || discount < 0 || discount > 100)
            {
                MessageBox.Show("Скидка должна быть числом от 0 до 100.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var category = (LookupItem)CategoryComboBox.SelectedItem;
            var manufacturer = (LookupItem)ManufacturerComboBox.SelectedItem;

            // Обработка фото
            var photoFile = _oldPhotoFile;
            if (!string.IsNullOrWhiteSpace(_selectedPhotoPath))
            {
                var copied = CopyPhotoToProject(_selectedPhotoPath);
                if (string.IsNullOrWhiteSpace(copied))
                {
                    MessageBox.Show("Не удалось сохранить изображение.", "Ошибка", 
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (!string.IsNullOrWhiteSpace(_oldPhotoFile))
                {
                    DeleteOldPhoto(_oldPhotoFile);
                }
                photoFile = copied;
            }

            var model = new ProductEditModel
            {
                ProductId = _productId,
                Article = article,
                Name = name,
                CategoryId = category.Id,
                Description = DescriptionTextBox.Text.Trim(),
                ManufacturerId = manufacturer.Id,
                SupplierName = supplierName,
                Price = price,
                UnitName = unit,
                StockQuantity = stock,
                DiscountPercent = discount,
                PhotoFile = photoFile
            };

            try
            {
                DataService.SaveProduct(model);
                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка сохранения:\n{ex.Message}", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private bool TryParseDecimal(string text, out decimal value)
        {
            text = (text ?? "").Trim().Replace(',', '.');
            return decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out value);
        }

        private string CopyPhotoToProject(string sourcePath)
        {
            try
            {
                var ext = Path.GetExtension(sourcePath);
                if (string.IsNullOrWhiteSpace(ext)) ext = ".png";
                var fileName = "photo_" + DateTime.Now.Ticks + ext.ToLowerInvariant();

                var baseDir = AppDomain.CurrentDomain.BaseDirectory;
                var targetDir = Path.Combine(baseDir, "resources", "photos");
                if (!Directory.Exists(targetDir))
                    Directory.CreateDirectory(targetDir);

                var targetPath = Path.Combine(targetDir, fileName);
                File.Copy(sourcePath, targetPath, true);
                return "resources/photos/" + fileName;
            }
            catch
            {
                return "";
            }
        }

        private void DeleteOldPhoto(string oldPhotoFile)
        {
            try
            {
                var name = Path.GetFileName(oldPhotoFile);
                if (string.IsNullOrWhiteSpace(name)) return;

                var baseDir = AppDomain.CurrentDomain.BaseDirectory;
                var path = Path.Combine(baseDir, "resources", "photos", name);
                if (File.Exists(path))
                    File.Delete(path);
            }
            catch { }
        }

        private void SetPreviewFromPack(string packUri)
        {
            try
            {
                PhotoImage.Source = new BitmapImage(new Uri(packUri, UriKind.Absolute));
            }
            catch
            {
                PhotoImage.Source = null;
            }
        }

        private BitmapImage LoadBitmap(string filePath)
        {
            try
            {
                var image = new BitmapImage();
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.UriSource = new Uri(filePath, UriKind.Absolute);
                image.EndInit();
                image.Freeze();
                return image;
            }
            catch
            {
                return null;
            }
        }
    }
}


# Шаг 13. Создайте окно OrdersWindow (список заказов)

Сделайте окно списка заказов для менеджера и администратора.

Команды/код
OrdersWindow.xaml:

xml
<Window x:Class="FurnitureStoreApp.OrdersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Заказы"
        Height="700"
        Width="1200"
        FontFamily="Calibri"
        Background="#FFFFFF"
        WindowStartupLocation="CenterOwner">
    <Grid Margin="16">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <StackPanel Orientation="Horizontal" Margin="0,0,0,12">
            <TextBlock Text="Список заказов" FontSize="28" FontWeight="Bold" VerticalAlignment="Center"/>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="20,0,0,0">
                <Button x:Name="AddOrderButton" Content="Добавить заказ" Width="160" Height="38" 
                        Margin="0,0,8,0" Background="#0000FF" Foreground="White" Click="AddOrder_Click"/>
                <Button x:Name="EditOrderButton" Content="Редактировать заказ" Width="180" Height="38" 
                        Margin="0,0,8,0" Background="#00FFFF" Click="EditOrder_Click"/>
                <Button x:Name="DeleteOrderButton" Content="Удалить заказ" Width="160" Height="38" 
                        Margin="0,0,8,0" Background="#00FFFF" Click="DeleteOrder_Click"/>
                <Button Content="Назад" Width="120" Height="38" 
                        Background="#00FFFF" Click="Back_Click"/>
            </StackPanel>
        </StackPanel>

        <DataGrid Grid.Row="1"
                  x:Name="OrdersGrid"
                  AutoGenerateColumns="False"
                  IsReadOnly="True"
                  HeadersVisibility="Column"
                  MouseDoubleClick="OrdersGrid_MouseDoubleClick">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Номер заказа" Binding="{Binding OrderNumber}" Width="120"/>
                <DataGridTextColumn Header="Артикулы (кол-во)" Binding="{Binding ArticlesText}" Width="280"/>
                <DataGridTextColumn Header="Статус" Binding="{Binding StatusName}" Width="150"/>
                <DataGridTextColumn Header="Пункт выдачи" Binding="{Binding PickupAddress}" Width="300"/>
                <DataGridTextColumn Header="Дата заказа" Binding="{Binding OrderDate, StringFormat={}{0:yyyy-MM-dd}}" Width="130"/>
                <DataGridTextColumn Header="Дата выдачи" Binding="{Binding DeliveryDate, StringFormat={}{0:yyyy-MM-dd}}" Width="130"/>
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>


OrdersWindow.xaml.cs:

csharp
using System;
using System.Windows;

namespace FurnitureStoreApp
{
    public partial class OrdersWindow : Window
    {
        private readonly UserInfo _currentUser;

        public OrdersWindow(UserInfo currentUser)
        {
            InitializeComponent();
            _currentUser = currentUser;

            var isAdmin = string.Equals(_currentUser.RoleName, "Администратор", StringComparison.OrdinalIgnoreCase);
            AddOrderButton.Visibility = isAdmin ? Visibility.Visible : Visibility.Collapsed;
            EditOrderButton.Visibility = isAdmin ? Visibility.Visible : Visibility.Collapsed;
            DeleteOrderButton.Visibility = isAdmin ? Visibility.Visible : Visibility.Collapsed;

            LoadOrders();
        }

        private void LoadOrders()
        {
            try
            {
                OrdersGrid.ItemsSource = DataService.GetOrders();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка загрузки заказов:\n{ex.Message}", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private bool IsAdmin()
        {
            return string.Equals(_currentUser.RoleName, "Администратор", StringComparison.OrdinalIgnoreCase);
        }

        private void AddOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;
            var wnd = new OrderFormWindow(null) { Owner = this };
            if (wnd.ShowDialog() == true)
                LoadOrders();
        }

        private void EditOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;

            var row = OrdersGrid.SelectedItem as OrderRow;
            if (row == null)
            {
                MessageBox.Show("Выберите заказ для редактирования.", "Информация", 
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var wnd = new OrderFormWindow(row.OrderId) { Owner = this };
            if (wnd.ShowDialog() == true)
                LoadOrders();
        }

        private void OrdersGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (IsAdmin())
                EditOrder_Click(sender, e);
        }

        private void DeleteOrder_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin()) return;

            var row = OrdersGrid.SelectedItem as OrderRow;
            if (row == null)
            {
                MessageBox.Show("Выберите заказ для удаления.", "Информация", 
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var confirm = MessageBox.Show($"Удалить заказ №{row.OrderNumber}?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (confirm != MessageBoxResult.Yes) return;

            try
            {
                DataService.DeleteOrder(row.OrderId);
                LoadOrders();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка удаления:\n{ex.Message}", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}


# Шаг 14. Создайте окно OrderFormWindow (добавление/редактирование заказа)

Сделайте форму добавления/редактирования заказа.

Команды/код
OrderFormWindow.xaml:

xml
<Window x:Class="FurnitureStoreApp.OrderFormWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Добавление/редактирование заказа"
        Height="500"
        Width="800"
        FontFamily="Calibri"
        Background="#FFFFFF"
        WindowStartupLocation="CenterOwner">
    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="180"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <TextBlock Grid.Row="0" Text="Номер заказа:" VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <TextBox x:Name="OrderNumberTextBox" Grid.Row="0" Grid.Column="1" IsReadOnly="True" 
                     Margin="0,0,0,12" Height="32" FontSize="14"/>

            <TextBlock Grid.Row="1" Text="Артикулы (артикул,кол-во):" 
                       VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <TextBox x:Name="ArticlesTextBox" Grid.Row="1" Grid.Column="1" 
                     Margin="0,0,0,12" Height="60" TextWrapping="Wrap" FontSize="14"/>

            <TextBlock Grid.Row="2" Text="Статус заказа:" VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <ComboBox x:Name="StatusComboBox" Grid.Row="2" Grid.Column="1" Margin="0,0,0,12" Height="32"/>

            <TextBlock Grid.Row="3" Text="Пункт выдачи:" VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <ComboBox x:Name="PickupComboBox" Grid.Row="3" Grid.Column="1" Margin="0,0,0,12" Height="32"/>

            <TextBlock Grid.Row="4" Text="Дата заказа:" VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <DatePicker x:Name="OrderDatePicker" Grid.Row="4" Grid.Column="1" Margin="0,0,0,12" Height="32"/>

            <TextBlock Grid.Row="5" Text="Дата выдачи:" VerticalAlignment="Center" FontSize="16" Margin="0,0,0,12"/>
            <DatePicker x:Name="DeliveryDatePicker" Grid.Row="5" Grid.Column="1" Margin="0,0,0,12" Height="32"/>
        </Grid>

        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,20,0,0">
            <Button Content="Сохранить" Width="160" Height="40" Margin="0,0,12,0" 
                    Background="#0000FF" Foreground="White" Click="Save_Click"/>
            <Button Content="Назад" Width="160" Height="40" 
                    Background="#00FFFF" Click="Back_Click"/>
        </StackPanel>
    </Grid>
</Window>


OrderFormWindow.xaml.cs:

csharp
using System;
using System.Windows;

namespace FurnitureStoreApp
{
    public partial class OrderFormWindow : Window
    {
        private readonly int? _orderId;
        private int _pickupCode;

        public OrderFormWindow(int? orderId = null)
        {
            InitializeComponent();
            _orderId = orderId;

            LoadLookups();

            if (_orderId.HasValue)
            {
                LoadOrder(_orderId.Value);
            }
            else
            {
                OrderNumberTextBox.Text = DataService.GetNextOrderNumber().ToString();
                _pickupCode = DataService.GetNextPickupCode();
                OrderDatePicker.SelectedDate = DateTime.Today;
                DeliveryDatePicker.SelectedDate = DateTime.Today.AddDays(7);
            }
        }

        private void LoadLookups()
        {
            StatusComboBox.DisplayMemberPath = "Name";
            StatusComboBox.SelectedValuePath = "Id";
            StatusComboBox.ItemsSource = DataService.GetStatuses();

            PickupComboBox.DisplayMemberPath = "Name";
            PickupComboBox.SelectedValuePath = "Id";
            PickupComboBox.ItemsSource = DataService.GetPickupPoints();
        }

        private void LoadOrder(int orderId)
        {
            var order = DataService.GetOrderById(orderId);
            if (order == null)
            {
                MessageBox.Show("Заказ не найден.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                Close();
                return;
            }

            OrderNumberTextBox.Text = order.OrderNumber.ToString();
            ArticlesTextBox.Text = order.ArticlesText;
            StatusComboBox.SelectedValue = order.StatusId;
            PickupComboBox.SelectedValue = order.PickupPointId;
            OrderDatePicker.SelectedDate = order.OrderDate;
            DeliveryDatePicker.SelectedDate = order.DeliveryDate;
            _pickupCode = order.PickupCode;
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            var articles = ArticlesTextBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(articles))
            {
                MessageBox.Show("Введите артикулы заказа в формате: артикул,количество,артикул,количество",
                    "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (StatusComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите статус заказа.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (PickupComboBox.SelectedItem == null)
            {
                MessageBox.Show("Выберите пункт выдачи.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!OrderDatePicker.SelectedDate.HasValue || !DeliveryDatePicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Укажите дату заказа и дату выдачи.", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var status = (LookupItem)StatusComboBox.SelectedItem;
            var pickup = (LookupItem)PickupComboBox.SelectedItem;

            var model = new OrderEditModel
            {
                OrderId = _orderId,
                OrderNumber = int.Parse(OrderNumberTextBox.Text),
                ArticlesText = articles,
                StatusId = status.Id,
                PickupPointId = pickup.Id,
                OrderDate = OrderDatePicker.SelectedDate.Value.Date,
                DeliveryDate = DeliveryDatePicker.SelectedDate.Value.Date,
                PickupCode = _pickupCode
            };

            try
            {
                DataService.SaveOrder(model);
                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка сохранения заказа:\n{ex.Message}", "Ошибка", 
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}


# Шаг 15. Создайте MainWindow (главное окно со списком товаров)

Сделайте главное окно со списком товаров, ролями и переходом к заказам.

Команды/код
MainWindow.xaml:

xml
<Window x:Class="FurnitureStoreApp.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ООО «МебельОрг» — Список товаров"
        Height="850"
        Width="1500"
        FontFamily="Calibri"
        Background="#FFFFFF"
        WindowStartupLocation="CenterScreen">
    <Grid Margin="12">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <!-- Верхняя панель с логотипом и информацией о пользователе -->
        <Grid Grid.Row="0" Margin="0,0,0,12">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

                            <Image Source="resources/photos/Icon.png" Width="80" Height="60" Stretch="Uniform" Margin="0,0,12,0"/>


            <TextBlock Grid.Column="1"
                       Text="ООО «МебельОрг» — Список товаров"
                       VerticalAlignment="Center"
                       FontSize="28"
                       FontWeight="Bold"/>

            <StackPanel Grid.Column="2" HorizontalAlignment="Right">
                <TextBlock x:Name="RoleTextBlock" FontSize="16" TextAlignment="Right"/>
                <TextBlock x:Name="UserTextBlock" FontSize="16" TextAlignment="Right" Margin="0,4,0,8"/>
                <Button x:Name="OrdersButton" Content="Заказы" Width="120" Height="36" 
                        Margin="0,0,0,8" Background="#00FFFF" Click="Orders_Click"/>
                <Button Content="Выход" Width="120" Height="36" 
                        Background="#0000FF" Foreground="White" Click="Logout_Click"/>
            </StackPanel>
        </Grid>

        <!-- Панель поиска, фильтрации и сортировки (только для менеджера и администратора) -->
        <StackPanel x:Name="FilterPanel" Grid.Row="1" Orientation="Horizontal" Margin="0,0,0,12">
            <TextBlock Text="Поиск:" VerticalAlignment="Center" FontSize="16" Margin="0,0,8,0"/>
            <TextBox x:Name="SearchTextBox" Width="320" Height="32" Margin="0,0,16,0" 
                     TextChanged="SearchTextBox_TextChanged"/>

            <TextBlock Text="Поставщик:" VerticalAlignment="Center" FontSize="16" Margin="0,0,8,0"/>
            <ComboBox x:Name="SupplierComboBox" Width="240" Height="32" Margin="0,0,16,0" 
                      SelectionChanged="SupplierComboBox_SelectionChanged"/>

            <TextBlock Text="Скидка:" VerticalAlignment="Center" FontSize="16" Margin="0,0,8,0"/>
            <ComboBox x:Name="DiscountFilterComboBox" Width="160" Height="32" Margin="0,0,16,0" 
                      SelectionChanged="DiscountFilterComboBox_SelectionChanged">
                <ComboBoxItem Content="Все скидки" IsSelected="True"/>
                <ComboBoxItem Content="0-10,99%"/>
                <ComboBoxItem Content="11-14,99%"/>
                <ComboBoxItem Content="15% и более"/>
            </ComboBox>

            <TextBlock Text="Сортировка:" VerticalAlignment="Center" FontSize="16" Margin="0,0,8,0"/>
            <ComboBox x:Name="SortComboBox" Width="200" Height="32" 
                      SelectionChanged="SortComboBox_SelectionChanged">
                <ComboBoxItem Content="Без сортировки" IsSelected="True"/>
                <ComboBoxItem Content="Цена (по возрастанию)"/>
                <ComboBoxItem Content="Цена (по убыванию)"/>
                <ComboBoxItem Content="Остаток (по возрастанию)"/>
                <ComboBoxItem Content="Остаток (по убыванию)"/>
            </ComboBox>
        </StackPanel>

        <!-- Панель администратора (добавление/редактирование/удаление) -->
        <StackPanel x:Name="AdminPanel" Grid.Row="2" Orientation="Horizontal" Margin="0,0,0,12">
            <Button Content="Добавить товар" Width="160" Height="36" Margin="0,0,12,0" 
                    Background="#0000FF" Foreground="White" Click="Add_Click"/>
            <Button Content="Редактировать товар" Width="180" Height="36" Margin="0,0,12,0" 
                    Background="#00FFFF" Click="Edit_Click"/>
            <Button Content="Удалить товар" Width="160" Height="36" 
                    Background="#00FFFF" Click="Delete_Click"/>
        </StackPanel>

        <!-- Таблица товаров -->
        <DataGrid Grid.Row="3"
                  x:Name="ProductsGrid"
                  AutoGenerateColumns="False"
                  IsReadOnly="True"
                  HeadersVisibility="Column"
                  GridLinesVisibility="Horizontal"
                  RowHeight="70"
                  MouseDoubleClick="ProductsGrid_MouseDoubleClick">
            <DataGrid.RowStyle>
                <Style TargetType="DataGridRow">
                    <Setter Property="Background" Value="{Binding RowBrush}"/>
                    <Setter Property="Foreground" Value="{Binding RowForeground}"/>
                </Style>
            </DataGrid.RowStyle>

            <DataGrid.Columns>
                <!-- Фото -->
                <DataGridTemplateColumn Header="Фото" Width="100">
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <Image Source="{Binding PhotoImage}" Width="90" Height="60" Stretch="Uniform"/>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>

                <DataGridTextColumn Header="Артикул" Binding="{Binding Article}" Width="100"/>
                <DataGridTextColumn Header="Наименование" Binding="{Binding Name}" Width="180"/>
                <DataGridTextColumn Header="Категория" Binding="{Binding Category}" Width="120"/>
                <DataGridTextColumn Header="Описание" Binding="{Binding Description}" Width="200"/>
                <DataGridTextColumn Header="Производитель" Binding="{Binding Manufacturer}" Width="130"/>
                <DataGridTextColumn Header="Поставщик" Binding="{Binding Supplier}" Width="130"/>

                <!-- Цена со скидкой (зачеркивание) -->
                <DataGridTemplateColumn Header="Цена" Width="100">
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBlock Text="{Binding Price, StringFormat={}{0:N2}}">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Foreground" Value="Black"/>
                                        <Setter Property="TextDecorations" Value="{x:Null}"/>
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding HasDiscount}" Value="True">
                                                <Setter Property="Foreground" Value="Red"/>
                                                <Setter Property="TextDecorations" Value="Strikethrough"/>
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>

                <DataGridTextColumn Header="Цена со скидкой" Binding="{Binding FinalPrice, StringFormat={}{0:N2}}" Width="110"/>
                <DataGridTextColumn Header="Ед.изм." Binding="{Binding UnitName}" Width="80"/>
                <DataGridTextColumn Header="Остаток" Binding="{Binding StockQuantity}" Width="80"/>
                <DataGridTextColumn Header="Скидка %" Binding="{Binding DiscountPercent}" Width="80"/>
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>


MainWindow.xaml.cs:

csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;

namespace FurnitureStoreApp
{
    public partial class MainWindow : Window
    {
        private readonly UserInfo _currentUser;
        private List<ProductRow> _allProducts = new List<ProductRow>();
        private ProductFormWindow _openedEditor;
        private bool _uiReady;

        public MainWindow(UserInfo user)
        {
            InitializeComponent();
            _currentUser = user ?? new UserInfo
            {
                UserId = null,
                FullName = "Гость",
                RoleName = "Гость"
            };

            if (string.IsNullOrWhiteSpace(_currentUser.RoleName))
                _currentUser.RoleName = "Гость";
            if (string.IsNullOrWhiteSpace(_currentUser.FullName))
                _currentUser.FullName = "Гость";

            RoleTextBlock.Text = "Роль: " + GetRoleCaption(_currentUser.RoleName);
            UserTextBlock.Text = "Пользователь: " + _currentUser.FullName;

            // Настройка видимости элементов в зависимости от роли
            OrdersButton.Visibility = IsManagerOrAdmin() ? Visibility.Visible : Visibility.Collapsed;
            FilterPanel.Visibility = IsManagerOrAdmin() ? Visibility.Visible : Visibility.Collapsed;
            AdminPanel.Visibility = IsAdmin() ? Visibility.Visible : Visibility.Collapsed;

            if (IsManagerOrAdmin())
                LoadSuppliersForFilter();

            _uiReady = true;
            LoadProducts();
        }

        private void LoadProducts()
        {
            try
            {
                _allProducts = DataService.GetProducts();
                ApplyFiltersAndSorting();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка загрузки товаров:\n{ex.Message}", "Ошибка БД",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void LoadSuppliersForFilter()
        {
            SupplierComboBox.Items.Clear();
            SupplierComboBox.Items.Add("Все поставщики");
            foreach (var s in DataService.GetSupplierNames())
                SupplierComboBox.Items.Add(s);
            SupplierComboBox.SelectedIndex = 0;
        }

        private void ApplyFiltersAndSorting()
        {
            if (!_uiReady || ProductsGrid == null)
                return;

            IEnumerable<ProductRow> query = _allProducts;

            if (IsManagerOrAdmin())
            {
                var search = (SearchTextBox.Text ?? "").Trim().ToLowerInvariant();
                var supplier = SupplierComboBox.SelectedItem?.ToString() ?? "Все поставщики";
                var discountFilter = (DiscountFilterComboBox.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Все скидки";
                var sort = (SortComboBox.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Без сортировки";

                // Фильтр по поставщику
                if (supplier != "Все поставщики")
                    query = query.Where(x => string.Equals(x.Supplier, supplier, StringComparison.OrdinalIgnoreCase));

                // Фильтр по скидке
                if (discountFilter == "0-10,99%")
                    query = query.Where(x => x.DiscountPercent >= 0 && x.DiscountPercent <= 10.99m);
                else if (discountFilter == "11-14,99%")
                    query = query.Where(x => x.DiscountPercent >= 11 && x.DiscountPercent <= 14.99m);
                else if (discountFilter == "15% и более")
                    query = query.Where(x => x.DiscountPercent >= 15);

                // Поиск по текстовым полям
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query = query.Where(x =>
                        (x.Article ?? "").ToLowerInvariant().Contains(search) ||
                        (x.Name ?? "").ToLowerInvariant().Contains(search) ||
                        (x.Category ?? "").ToLowerInvariant().Contains(search) ||
                        (x.Description ?? "").ToLowerInvariant().Contains(search) ||
                        (x.Manufacturer ?? "").ToLowerInvariant().Contains(search) ||
                        (x.Supplier ?? "").ToLowerInvariant().Contains(search) ||
                        (x.UnitName ?? "").ToLowerInvariant().Contains(search));
                }

                // Сортировка
                if (sort == "Цена (по возрастанию)")
                    query = query.OrderBy(x => x.Price);
                else if (sort == "Цена (по убыванию)")
                    query = query.OrderByDescending(x => x.Price);
                else if (sort == "Остаток (по возрастанию)")
                    query = query.OrderBy(x => x.StockQuantity);
                else if (sort == "Остаток (по убыванию)")
                    query = query.OrderByDescending(x => x.StockQuantity);
            }

            ProductsGrid.ItemsSource = query.ToList();
        }

        private void SearchTextBox_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }

        private void SupplierComboBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }

        private void DiscountFilterComboBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }

        private void SortComboBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if (!_uiReady) return;
            ApplyFiltersAndSorting();
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            OpenEditor(null);
        }

        private void Edit_Click(object sender, RoutedEventArgs e)
        {
            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected == null)
            {
                MessageBox.Show("Выберите товар для редактирования.", "Информация",
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            OpenEditor(selected.ProductId);
        }

        private void ProductsGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (!IsAdmin()) return;
            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected != null)
                OpenEditor(selected.ProductId);
        }

        private void OpenEditor(int? productId)
        {
            if (!IsAdmin())
            {
                MessageBox.Show("Добавлять и редактировать товары может только администратор.",
                    "Доступ запрещен", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // Блокировка открытия нескольких окон
            if (_openedEditor != null && _openedEditor.IsVisible)
            {
                MessageBox.Show("Окно редактирования уже открыто.", "Информация",
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            _openedEditor = new ProductFormWindow(productId) { Owner = this };
            var result = _openedEditor.ShowDialog();
            _openedEditor = null;

            if (result == true)
            {
                LoadSuppliersForFilter();
                LoadProducts();
            }
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            if (!IsAdmin())
            {
                MessageBox.Show("Удалять товары может только администратор.",
                    "Доступ запрещен", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var selected = ProductsGrid.SelectedItem as ProductRow;
            if (selected == null)
            {
                MessageBox.Show("Выберите товар для удаления.", "Информация",
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var confirm = MessageBox.Show($"Удалить товар \"{selected.Name}\"?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (confirm != MessageBoxResult.Yes) return;

            try
            {
                if (DataService.ProductExistsInOrders(selected.ProductId))
                {
                    MessageBox.Show("Товар присутствует в заказах. Удаление невозможно.",
                        "Удаление запрещено", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                DataService.DeleteProduct(selected.ProductId);
                LoadSuppliersForFilter();
                LoadProducts();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка удаления:\n{ex.Message}", "Ошибка",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Orders_Click(object sender, RoutedEventArgs e)
        {
            if (!IsManagerOrAdmin()) return;
            var wnd = new OrdersWindow(_currentUser) { Owner = this };
            wnd.ShowDialog();
        }

        private void Logout_Click(object sender, RoutedEventArgs e)
        {
            var loginWindow = new LoginWindow();
            loginWindow.Show();
            Close();
        }

        private bool IsAdmin()
        {
            return string.Equals(_currentUser?.RoleName, "Администратор", StringComparison.OrdinalIgnoreCase);
        }

        private bool IsManagerOrAdmin()
        {
            return string.Equals(_currentUser?.RoleName, "Менеджер", StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(_currentUser?.RoleName, "Администратор", StringComparison.OrdinalIgnoreCase);
        }

        private string GetRoleCaption(string role)
        {
            if (role == "Авторизированный клиент") return "Клиент";
            if (role == "Администратор") return "Администратор";
            if (role == "Менеджер") return "Менеджер";
            return "Гость";
        }
    }
}


# Шаг 16. Запустите приложение и проверьте модули 2-4

Проверьте роли, список товаров, CRUD товаров и работу заказов.

Команды/код
Запустите проект: Отладка → Начать отладку (F5)

Проверьте роли:

Гость: только просмотр товаров, нет панели поиска/фильтра/сортировки
Авторизованный клиент: вход по логину/паролю из БД, просмотр товаров
Менеджер: есть поиск, фильтр по поставщику и скидке, сортировка, кнопка "Заказы"
Администратор: всё как у менеджера + кнопки "Добавить/Редактировать/Удалить товар", редактирование заказов

Проверьте подсветку строк:

Скидка > 15% → фон #008080
Товара нет на складе (остаток = 0) → серый фон #D3D3D3
Если есть скидка → основная цена красная и зачеркнутая
Проверьте CRUD товаров (администратор):
Добавление нового товара
Редактирование существующего (двойной клик или кнопка)
Удаление (только если товар не в заказах)
Загрузка фото с проверкой размера 300x200
Проверьте заказы (менеджер/администратор):
Просмотр списка заказов
Добавление нового заказа
Редактирование существующего
Удаление


# Шаг 16.1. Зафиксируйте локальный git-коммит (модули 2-4)

Сделайте локальный коммит после реализации функционала модулей 2–4.

Команды/код
cmd
cd C:\furniture_store_2026_pu\FurnitureStoreApp
git init
git add .
git commit -m "Реализованы модули 2-4 (C#, Вариант 5 2026)"

........

ЕСЛИ НЕ РАБОТАЕТ ТО

cd C:\furniture_store_2026_pu\FurnitureStoreApp
echo .vs/ > .gitignore
echo bin/ >> .gitignore
echo obj/ >> .gitignore
type .gitignore

Что вы увидите:
text
.vs/
bin/
obj/

rmdir /s /q .git
git init
git add .
git commit -m "Первый коммит"


# Шаг 17. Подготовьте документы SQL/ER и финальный набор файлов
Что делаем
Соберите обязательные документы, экспорт БД, итоговые файлы проекта.

Команды/код
1. Блок-схема алгоритма (ГОСТ 19.701-90)

Используйте draw.io (diagrams.net)

Создайте схему с блоками: Начало → Ввод логина/пароля → Проверка авторизации → Определение роли → Просмотр товаров → Поиск/фильтр/сортировка (для менеджера/админа) → CRUD (для админа) → Заказы → Выход

Сохраните как C:\furniture_store_2026_pu\docs\algorithm_gost.drawio

Экспортируйте в PDF: C:\furniture_store_2026_pu\docs\algorithm_gost.pdf

2. Скриншоты работы приложения

Создайте C:\furniture_store_2026_pu\docs\report_screenshots.docx

Добавьте скриншоты:

Окно входа
Вход как гость
Вход под менеджером
Вход под администратором
Список товаров с подсветкой
Поиск/фильтрация/сортировка
Добавление/редактирование товара
Окно заказов
Добавление/редактирование заказа

3. Экспорт БД

В phpMyAdmin выберите БД furniture2026_pu

Вкладка Экспорт → SQL

Сохраните как C:\furniture_store_2026_pu\sql\furniture2026_pu.sql

4. ER-диаграмма

В phpMyAdmin → Ещё → Дизайнер

Экспортируйте схему в PDF

Сохраните как C:\furniture_store_2026_pu\sql\furniture2026_pu_er.pdf

5. Сборка Release

В Visual Studio переключите конфигурацию на Release

Меню Сборка → Собрать решение

Проверьте папку C:\furniture_store_2026_pu\FurnitureStoreApp\FurnitureStoreApp\bin\Release\

6. Финальный git-коммит

cmd
cd C:\furniture_store_2026_pu\FurnitureStoreApp
git add .
git commit -m "Финальная версия проекта (C#, Вариант 5 2026)"
Шаг 18. Финальная структура проекта
text
C:\furniture_store_2026_pu\
│
├── FurnitureStoreApp\              # Проект Visual Studio
│   ├── FurnitureStoreApp.csproj
│   ├── App.xaml
│   ├── App.xaml.cs
│   ├── Db.cs
│   ├── Models.cs
│   ├── DataService.cs
│   ├── LoginWindow.xaml
│   ├── LoginWindow.xaml.cs
│   ├── MainWindow.xaml
│   ├── MainWindow.xaml.cs
│   ├── ProductFormWindow.xaml
│   ├── ProductFormWindow.xaml.cs
│   ├── OrdersWindow.xaml
│   ├── OrdersWindow.xaml.cs
│   ├── OrderFormWindow.xaml
│   ├── OrderFormWindow.xaml.cs
│   ├── resources\
│   │   ├── photos\
│   │   │   ├── 1.jpg
│   │   │   ├── 2.jpg
│   │   │   ├── ...
│   │   │   └── picture.png
│   │   └── Icon.ico (если есть)
│   └── bin\Release\               # Исполняемые файлы
│
├── docs\
│   ├── algorithm_gost.pdf
│   └── report_screenshots.docx
│
├── sql\
│   ├── furniture2026_pu.sql
│   └── furniture2026_pu_er.pdf
│
└── docker-compose.yml (опционально)