-- สคริปต์สร้างฐานข้อมูลระบบจัดการแปลงเกษตรอัจฉริยะ (Smart Farm Database)
CREATE DATABASE IF NOT EXISTS `smart_farm_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `smart_farm_db`;
 
-- 1. ตารางผู้ใช้งาน
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `fullname` VARCHAR(100) NOT NULL COMMENT 'ชื่อ-นามสกุล',
  `phone` VARCHAR(20) NOT NULL UNIQUE COMMENT 'เบอร์โทรศัพท์',
  `password` VARCHAR(255) NOT NULL COMMENT 'รหัสผ่าน',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- 2. ตารางแปลงเกษตร
CREATE TABLE IF NOT EXISTS `plots` (
  `plot_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL COMMENT 'เจ้าของแปลง',
  `plot_name` VARCHAR(100) NOT NULL COMMENT 'ชื่อแปลงเกษตร',
  `area_size` DECIMAL(5,2) NOT NULL COMMENT 'ขนาดพื้นที่ (ไร่)',
  `crop_type` VARCHAR(100) DEFAULT NULL COMMENT 'ชนิดพืชที่ปลูก',
  `status` ENUM('PLANTING', 'EMPTY') DEFAULT 'EMPTY' COMMENT 'สถานะแปลง',
  `plant_date` DATE DEFAULT NULL COMMENT 'วันที่เริ่มปลูก',
  `harvest_date` DATE DEFAULT NULL COMMENT 'วันคาดว่าจะเก็บเกี่ยว',
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- 3. ตารางประวัติกิจกรรมประจำวัน
CREATE TABLE IF NOT EXISTS `activities` (
  `activity_id` INT AUTO_INCREMENT PRIMARY KEY,
  `plot_id` INT NOT NULL COMMENT 'อ้างอิงแปลงเกษตร',
  `activity_type` VARCHAR(50) NOT NULL COMMENT 'กิจกรรมที่ทำ',
  `activity_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'เวลาที่บันทึก',
  FOREIGN KEY (`plot_id`) REFERENCES `plots`(`plot_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- 4. ตารางบันทึกการเงิน (รายรับ-รายจ่าย)
CREATE TABLE IF NOT EXISTS `finances` (
  `finance_id` INT AUTO_INCREMENT PRIMARY KEY,
  `plot_id` INT NOT NULL COMMENT 'อ้างอิงแปลงเกษตร',
  `type` ENUM('INCOME', 'EXPENSE') NOT NULL COMMENT 'ประเภทรายการ',
  `amount` DECIMAL(10,2) NOT NULL COMMENT 'จำนวนเงิน (บาท)',
  `description` VARCHAR(255) NOT NULL COMMENT 'รายละเอียด',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`plot_id`) REFERENCES `plots`(`plot_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- ตัวอย่างข้อมูลเริ่มต้น (Mock Data)
INSERT INTO `users` (`user_id`, `fullname`, `phone`, `password`) VALUES
(1, 'คุณอติวิชญ์ & คุณอรัญญาพร', '0812345678', '1234');
 
INSERT INTO `plots` (`plot_id`, `user_id`, `plot_name`, `area_size`, `crop_type`, `status`, `plant_date`, `harvest_date`) VALUES
(1, 1, 'แปลงนาหนองบัว', 5.00, 'ข้าวหอมมะลิ 105', 'PLANTING', '2026-05-01', '2026-09-15'),
(2, 1, 'แปลง A2 (หลังบ้าน)', 2.00, NULL, 'EMPTY', NULL, NULL);
 
INSERT INTO `finances` (`plot_id`, `type`, `amount`, `description`) VALUES
(1, 'INCOME', 48000.00, 'ขายผลผลิตรอบก่อน'),
(1, 'EXPENSE', 8800.00, 'ค่าปุ๋ยและน้ำมัน');
 
INSERT INTO `activities` (`plot_id`, `activity_type`) VALUES
(1, '💧 สูบน้ำ / รดน้ำ'),
(1, '🧪 ใส่ปุ๋ยบำรุง')