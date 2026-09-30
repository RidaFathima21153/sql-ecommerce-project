USE ecommerce_report;

INSERT INTO categories (category_name) VALUES
('Electronics'), ('Home Appliances'), ('Books'), ('Fashion'), ('Fitness');

INSERT INTO customers (first_name,last_name,email,phone,city,signup_date,loyalty_points,referred_by) VALUES
('Aarav','Sharma','aarav.sharma@example.com','9000000001','Bengaluru','2024-01-15',420,NULL),
('Diya','Nair','diya.nair@example.com','9000000002','Kochi','2024-02-02',180,1),
('Rohan','Mehta','rohan.mehta@example.com',NULL,'Mumbai','2024-02-19',760,1),
('Ananya','Rao','ananya.rao@example.com','9000000004','Hyderabad','2024-03-08',95,2),
('Kabir','Patel','kabir.patel@example.com','9000000005','Ahmedabad','2024-03-20',310,NULL),
('Meera','Iyer','meera.iyer@example.com',NULL,'Chennai','2024-04-11',560,3),
('Vikram','Singh','vikram.singh@example.com','9000000007','Delhi','2024-05-04',40,NULL),
('Sara','Khan','sara.khan@example.com','9000000008','Pune','2024-05-22',220,5),
('Arjun','Das','arjun.das@example.com','9000000009','Kolkata','2024-06-13',670,6),
('Ishita','Joshi','ishita.joshi@example.com',NULL,'Jaipur','2024-07-01',15,NULL),
('Neel','Verma','neel.verma@example.com','9000000011','Lucknow','2024-07-17',125,1),
('Tara','Menon','tara.menon@example.com','9000000012','Bengaluru','2024-08-03',880,3);

INSERT INTO addresses (customer_id,address_type,address_line,city,state,postal_code) VALUES
(1,'HOME','12 Lake View Road','Bengaluru','Karnataka','560001'),
(1,'WORK','44 MG Road','Bengaluru','Karnataka','560025'),
(2,'HOME','7 Marine Drive','Kochi','Kerala','682001'),
(3,'HOME','19 Hill Road','Mumbai','Maharashtra','400050'),
(4,'HOME','22 Banjara Hills','Hyderabad','Telangana','500034'),
(5,'HOME','9 Riverfront Lane','Ahmedabad','Gujarat','380001'),
(6,'HOME','18 Anna Salai','Chennai','Tamil Nadu','600002'),
(7,'HOME','3 Green Park','Delhi','Delhi','110016'),
(8,'HOME','55 FC Road','Pune','Maharashtra','411004'),
(9,'HOME','31 Park Street','Kolkata','West Bengal','700016'),
(10,'HOME','10 Pink City Road','Jaipur','Rajasthan','302001'),
(11,'HOME','8 Gomti Nagar','Lucknow','Uttar Pradesh','226010'),
(12,'HOME','71 Indiranagar','Bengaluru','Karnataka','560038');

INSERT INTO products (category_id,product_name,sku,price,stock_qty,rating,is_active) VALUES
(1,'Wireless Headphones','ELEC-001',2999.00,45,4.6,TRUE),
(1,'Mechanical Keyboard','ELEC-002',5499.00,30,4.7,TRUE),
(1,'4K Monitor','ELEC-003',18999.00,12,4.5,TRUE),
(1,'USB-C Hub','ELEC-004',1799.00,75,4.2,TRUE),
(2,'Air Fryer','HOME-001',6999.00,18,4.4,TRUE),
(2,'Robot Vacuum','HOME-002',22999.00,8,4.6,TRUE),
(2,'Electric Kettle','HOME-003',1499.00,50,NULL,TRUE),
(3,'Clean Code','BOOK-001',899.00,100,4.8,TRUE),
(3,'Designing Data-Intensive Applications','BOOK-002',1299.00,60,4.9,TRUE),
(3,'The Pragmatic Programmer','BOOK-003',999.00,85,4.7,TRUE),
(4,'Running Shoes','FASH-001',3499.00,40,4.3,TRUE),
(4,'Denim Jacket','FASH-002',2599.00,25,4.1,TRUE),
(4,'Backpack','FASH-003',1899.00,35,NULL,TRUE),
(5,'Yoga Mat','FIT-001',1299.00,70,4.5,TRUE),
(5,'Resistance Bands','FIT-002',799.00,90,4.4,TRUE),
(5,'Smart Scale','FIT-003',2499.00,20,4.0,FALSE);

INSERT INTO orders (customer_id,order_date,status,shipping_address_id,coupon_code,discount_amount) VALUES
(1,'2024-08-05 10:15:00','DELIVERED',1,'WELCOME10',300),
(2,'2024-08-07 13:40:00','DELIVERED',3,NULL,0),
(3,'2024-08-10 18:10:00','SHIPPED',4,'SAVE500',500),
(4,'2024-08-14 09:20:00','DELIVERED',5,NULL,0),
(5,'2024-08-20 16:05:00','CANCELLED',6,NULL,0),
(6,'2024-08-23 11:30:00','DELIVERED',7,NULL,250),
(7,'2024-09-01 12:15:00','PLACED',8,'FESTIVE',400),
(8,'2024-09-04 17:45:00','DELIVERED',9,NULL,0),
(9,'2024-09-07 14:30:00','DELIVERED',10,'BOOKLOVE',100),
(10,'2024-09-12 19:00:00','SHIPPED',11,NULL,0),
(11,'2024-09-15 08:50:00','DELIVERED',12,NULL,0),
(12,'2024-09-18 15:25:00','DELIVERED',13,'LOYALTY',500),
(1,'2024-09-20 20:10:00','DELIVERED',1,NULL,0),
(3,'2024-09-22 10:45:00','PLACED',4,NULL,0),
(6,'2024-09-25 18:20:00','DELIVERED',7,'FITNESS',100);

INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES
(1,1,1,2999),(1,4,1,1799),
(2,8,2,899),(2,14,1,1299),
(3,3,1,18999),(3,2,1,5499),
(4,5,1,6999),(4,15,2,799),
(5,6,1,22999),
(6,9,1,1299),(6,10,1,999),(6,13,1,1899),
(7,7,2,1499),(7,14,1,1299),
(8,11,1,3499),(8,12,1,2599),
(9,9,2,1299),(9,10,1,999),
(10,4,2,1799),(10,15,3,799),
(11,1,1,2999),(11,14,1,1299),
(12,6,1,22999),(12,5,1,6999),
(13,2,1,5499),(13,8,1,899),
(14,3,1,18999),(14,1,1,2999),
(15,14,2,1299),(15,15,2,799);

INSERT INTO payments (order_id,payment_method,amount,paid_at,payment_status,transaction_ref) VALUES
(1,'CARD',4498,'2024-08-05 10:16:00','PAID','TXN1001'),
(2,'UPI',3097,'2024-08-07 13:41:00','PAID','TXN1002'),
(3,'CARD',23998,'2024-08-10 18:11:00','PAID','TXN1003'),
(4,'COD',8597,'2024-08-14 09:21:00','PAID','TXN1004'),
(5,'CARD',22999,NULL,'REFUNDED','TXN1005'),
(6,'NET_BANKING',3947,'2024-08-23 11:31:00','PAID','TXN1006'),
(7,'UPI',3897,NULL,'PENDING',NULL),
(8,'CARD',6098,'2024-09-04 17:46:00','PAID','TXN1008'),
(9,'UPI',3497,'2024-09-07 14:31:00','PAID','TXN1009'),
(10,'CARD',5995,NULL,'PENDING',NULL),
(11,'WALLET',4298,'2024-09-15 08:51:00','PAID','TXN1011'),
(12,'CARD',29498,'2024-09-18 15:26:00','PAID','TXN1012'),
(13,'UPI',6398,'2024-09-20 20:11:00','PAID','TXN1013'),
(14,'CARD',21998,NULL,'PENDING',NULL),
(15,'UPI',4096,'2024-09-25 18:21:00','PAID','TXN1015');
