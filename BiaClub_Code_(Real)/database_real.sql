-- Bảng account
create database app1
use app1
CREATE TABLE account (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    phone NVARCHAR(15) NOT NULL
);

-- Bảng ban
CREATE TABLE ban (
    id_ban INT IDENTITY(1,1) PRIMARY KEY,
    id_account INT,
    ten_ban NVARCHAR(100) NOT NULL,
    tinh_trang NVARCHAR(20) ,
    FOREIGN KEY (id_account) REFERENCES account(id)
);

-- Bảng san_pham
CREATE TABLE san_pham (
    id_san_pham INT IDENTITY(1,1) PRIMARY KEY,
    id_account INT,
    ten_san_pham NVARCHAR(100) NOT NULL,
    so_luong INT NOT NULL,
    gia DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_account) REFERENCES account(id)
);

-- Bảng khach_hang
CREATE TABLE khach_hang (
    id_khach_hang INT IDENTITY(1,1) PRIMARY KEY,
    id_account INT,
    ten_khach NVARCHAR(100) NOT NULL,
    so_dien_thoai NVARCHAR(15) NOT NULL,
    dia_chi NVARCHAR(255),
    FOREIGN KEY (id_account) REFERENCES account(id)
);

CREATE TABLE chitiethoadon (
    id_chitiet INT PRIMARY KEY IDENTITY(1,1),
    id_ban INT NOT NULL,
    id_sanpham INT NOT NULL,
    id_account INT NOT NULL,
    so_luong INT NOT NULL,
    tong_gia DECIMAL(18, 2) NOT NULL,
    ngay_order DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_ban) REFERENCES ban(id_ban),
    FOREIGN KEY (id_account) REFERENCES account(id),
	FOREIGN KEY (id_sanpham) REFERENCES san_pham(id_san_pham)
);
------------
CREATE TABLE thoigianchoi (
    id_thoigian INT IDENTITY(1,1) PRIMARY KEY,
    id_ban INT NOT NULL,
    id_account INT NOT NULL,
    thoi_gian_bat_dau DATETIME NOT NULL,
    thoi_gian_ket_thuc DATETIME,
    tong_thoi_gian INT, -- in minutes
    FOREIGN KEY (id_ban) REFERENCES ban(id_ban),
    FOREIGN KEY (id_account) REFERENCES account(id)
);
-------------
CREATE TABLE hoadon (
    id_hoadon INT IDENTITY(1,1) PRIMARY KEY,
    id_thoigian INT NOT NULL,
    id_account INT NOT NULL,
    tong_tien_thoigian DECIMAL(18, 2) NOT NULL,
    tong_tien_sanpham DECIMAL(18, 2) NOT NULL,
    tong_tien DECIMAL(18, 2) NOT NULL,
    ngay_lap DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_thoigian) REFERENCES thoigianchoi(id_thoigian),
    FOREIGN KEY (id_account) REFERENCES account(id)
);

-- Thêm 4 tài khoản vào bảng account
INSERT INTO account (username, password, name, date, phone) VALUES
(N'user1', N'password1', N'Nguyen Van A', '1990-01-01', N'0912345678'),
(N'user2', N'password2', N'Tran Thi B', '1985-05-15', N'0923456789'),
(N'user3', N'password3', N'Le Van C', '1992-09-20', N'0934567890'),
(N'user4', N'password4', N'Pham Thi D', '1988-12-30', N'0945678901');

-- Thêm 3 dòng dữ liệu cho mỗi tài khoản trong bảng ban
INSERT INTO ban (id_account, ten_ban, tinh_trang) VALUES
(1, N'Bàn 1A', N'Trống'),
(1, N'Bàn 1B', N'Có khách'),
(1, N'Bàn 1C', N'Trống'),
(2, N'Bàn 2A', N'Có khách'),
(2, N'Bàn 2B', N'Trống'),
(2, N'Bàn 2C', N'Có khách'),
(3, N'Bàn 3A', N'Trống'),
(3, N'Bàn 3B', N'Có khách'),
(3, N'Bàn 3C', N'Trống'),
(4, N'Bàn 4A', N'Có khách'),
(4, N'Bàn 4B', N'Trống'),
(4, N'Bàn 4C', N'Có khách');


-- Thêm 3 dòng dữ liệu cho mỗi tài khoản trong bảng san_pham
INSERT INTO san_pham (id_account, ten_san_pham, so_luong, gia) VALUES
(1, N'Sản phẩm A', 10, 100.00),
(1, N'Sản phẩm B', 20, 150.00),
(1, N'Sản phẩm C', 15, 200.00),
(2, N'Sản phẩm D', 25, 250.00),
(2, N'Sản phẩm E', 30, 300.00),
(2, N'Sản phẩm F', 35, 350.00),
(3, N'Sản phẩm G', 40, 400.00),
(3, N'Sản phẩm H', 45, 450.00),
(3, N'Sản phẩm I', 50, 500.00),
(4, N'Sản phẩm J', 55, 550.00),
(4, N'Sản phẩm K', 60, 600.00),
(4, N'Sản phẩm L', 65, 650.00);

-- Thêm 3 dòng dữ liệu cho mỗi tài khoản trong bảng khach_hang
INSERT INTO khach_hang (id_account, ten_khach, so_dien_thoai, dia_chi) VALUES
(1, N'Khach Hang A1', N'0987654321', N'Dia chi 1A'),
(1, N'Khach Hang A2', N'0976543210', N'Dia chi 1B'),
(1, N'Khach Hang A3', N'0965432109', N'Dia chi 1C'),
(2, N'Khach Hang B1', N'0954321098', N'Dia chi 2A'),
(2, N'Khach Hang B2', N'0943210987', N'Dia chi 2B'),
(2, N'Khach Hang B3', N'0932109876', N'Dia chi 2C'),
(3, N'Khach Hang C1', N'0921098765', N'Dia chi 3A'),
(3, N'Khach Hang C2', N'0910987654', N'Dia chi 3B'),
(3, N'Khach Hang C3', N'0909876543', N'Dia chi 3C'),
(4, N'Khach Hang D1', N'0898765432', N'Dia chi 4A'),
(4, N'Khach Hang D2', N'0887654321', N'Dia chi 4B'),
(4, N'Khach Hang D3', N'0876543210', N'Dia chi 4C');
--account 1 đăng nhập và chọn xem danh sách bàn
SELECT * FROM ban
WHERE id_account = 1;
--account 2 đăng nhập và chọn xem danh sách bàn
SELECT * FROM ban
WHERE id_account = 2;
--account 2 đăng nhập và chọn xem danh sách sản phẩm
SELECT * FROM san_pham
WHERE id_account = 2;
--account 2 đăng nhập và chọn xem danh sách khách hàng
SELECT * FROM khach_hang
WHERE id_account = 2;
--------- account 1 đăng nhập, vào bàn 1a và chọn 3 sản phẩm của account đó vào bàn
INSERT INTO chitiethoadon (id_ban, id_sanpham, id_account, so_luong, tong_gia)
VALUES
(1, 1, 1, 1, 100.00),  -- "Sản phẩm A" ordered with a quantity of 1
(1, 2, 1, 2, 300.00),  -- "Sản phẩm B" ordered with a quantity of 2
(1, 3, 1, 1, 200.00);  -- "Sản phẩm C" ordered with a quantity of 1
SELECT * FROM chitiethoadon
WHERE id_account = 1;
------
--bàn 1 của id1 bắt đầu lúc 14h (Khi ấn bắt đầu bàn thì sẽ insert)
INSERT INTO thoigianchoi (id_ban, id_account, thoi_gian_bat_dau)
VALUES (1, 1, '2024-09-09 14:00:00');

-- kết thúc lúc 16h
UPDATE thoigianchoi
SET thoi_gian_ket_thuc = '2024-09-09 16:00:00',
    tong_thoi_gian = DATEDIFF(MINUTE, thoi_gian_bat_dau, '2024-09-09 16:00:00')
WHERE id_thoigian = 1;
--------------Khi bàn 1 của account 1 kết thúc thì sẽ chuyển đến trang thanh toán
--tổng tiền mà bàn 1 phải trả và các dịch vụ đã dùng
-- Calculate total amount for a play session
DECLARE @id_thoigian INT = 1; 
DECLARE @price_per_minute DECIMAL(18, 2) = 10.00;
DECLARE @tong_tien_thoigian DECIMAL(18, 2);

SELECT @tong_tien_thoigian = tong_thoi_gian * @price_per_minute
FROM thoigianchoi
WHERE id_thoigian = @id_thoigian;

-- Calculate total amount for ordered products
DECLARE @tong_tien_sanpham DECIMAL(18, 2);

SELECT @tong_tien_sanpham = SUM(ct.so_luong * sp.gia)
FROM chitiethoadon ct
JOIN san_pham sp ON ct.id_sanpham = sp.id_san_pham
WHERE ct.id_ban = (SELECT id_ban FROM thoigianchoi WHERE id_thoigian = @id_thoigian);

-- Insert the invoice
INSERT INTO hoadon (id_thoigian, id_account, tong_tien_thoigian, tong_tien_sanpham, tong_tien)
VALUES (@id_thoigian, 1, @tong_tien_thoigian, @tong_tien_sanpham, @tong_tien_thoigian + @tong_tien_sanpham);
---------
-- Select details for invoice 1
SELECT
    hd.id_hoadon AS [Invoice ID],
    tc.thoi_gian_bat_dau AS [Start Time],
    tc.thoi_gian_ket_thuc AS [End Time],
    hd.tong_tien_thoigian AS [Total Time Cost],
    hd.tong_tien_sanpham AS [Total Product Cost],
    hd.tong_tien AS [Total Invoice Amount],
    sp.ten_san_pham AS [Product Name],
    ct.so_luong AS [Quantity],
    (ct.so_luong * sp.gia) AS [Product Total Cost]
FROM
    hoadon hd
JOIN
    thoigianchoi tc ON hd.id_thoigian = tc.id_thoigian
LEFT JOIN
    chitiethoadon ct ON tc.id_ban = ct.id_ban
LEFT JOIN
    san_pham sp ON ct.id_sanpham = sp.id_san_pham
WHERE
    hd.id_hoadon = 1;
--tổng quan: thêm sửa , xóa bàn
--thêm sửa xóa sản phẩm
--order đồ vào bàn,
--bấm bắt đầu thời gian của bàn
--tính tiền khi kết thúc và in hóa đơn
--xem lại hóa đơn và chi tiết
