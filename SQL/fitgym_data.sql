-- =============================================================
-- FitGym Pro · Day12 课堂数据脚本
-- 用途：跟练① 末尾全班一键导入，为下午的 JOIN 与查询闯关备数据
-- 用法：在 IDEA Database 控制台或 mysql 命令行中整文件执行
--   mysql> source D:/AI_fullStack/doc/Java基础课件3/fitgym_data.sql
-- ⚠️ 注意：本脚本会【重建四张表】——members 用统一数据覆盖上午的
--    练习数据，目的是下午全班数据一致、闯关答案可对齐。
--    上午手写的建表 SQL 请已存进自己的 .sql 文件（晚自习要提交）。
-- 数据设计（讲师备课用，分布故意不均）：
--   会员 12 人：等级 A×3 / B×5 / C×4；入会日期跨 06~09 月；
--               1 人 phone 为 NULL（练 IS NULL）；3 人零约课（沉睡会员）
--   教练 6 人：赵六、钱七各 0 门课（LEFT JOIN 对比用）；钱七用默认 specialty
--   课程 6 门：普拉提 0 约课；约课人次 6/5/4/2/1/0 拉开梯度
--   约课 18 条：时间跨 8 月与 9 月（练 WHERE 月份过滤）；张三 3 条
-- =============================================================

USE fitgym;
SET NAMES utf8mb4;

-- ① 按外键依赖的逆序清场（先删"引用别人的"，再删"被引用的"）
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS coaches;

-- ② 建表（被引用的先建：coaches、members → courses → bookings）

CREATE TABLE coaches (
    id        INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(50) NOT NULL,
    specialty VARCHAR(50) NOT NULL DEFAULT 'general'
);

CREATE TABLE members (
    card_id   INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(50) NOT NULL,
    phone     VARCHAR(20) UNIQUE,
    level     VARCHAR(10) NOT NULL DEFAULT 'C',
    join_date DATE NOT NULL
);

CREATE TABLE courses (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    title    VARCHAR(50) NOT NULL,
    price    DECIMAL(8,2) NOT NULL,
    coach_id INT NOT NULL,
    FOREIGN KEY (coach_id) REFERENCES coaches(id)
);

CREATE TABLE bookings (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    card_id      INT NOT NULL,
    course_id    INT NOT NULL,
    booking_time DATETIME NOT NULL,
    FOREIGN KEY (card_id)   REFERENCES members(card_id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- ③ 灌数据

-- 教练 5 人（赵六 0 门课；钱七 用默认 specialty 'general'）
INSERT INTO coaches (name, specialty) VALUES
('王铁牛', 'yoga'),
('刘飞燕', 'cycling'),
('陈浪',   'swimming'),
('孙力行', 'strength'),
('赵六',   'boxing');        -- ← 零课程教练
INSERT INTO coaches (name) VALUES ('钱七');  -- ← 观察 DEFAULT 'general' 生效

-- 会员 12 人（A×3 B×5 C×4；日期跨 06~09 月；周小雨 phone 为 NULL）
INSERT INTO members (name, phone, level, join_date) VALUES
('张三',   '13800000001', 'A', '2026-06-05'),
('李四',   '13800000002', 'B', '2026-06-18'),
('王五',   '13800000003', 'C', '2026-07-02'),
('赵小花', '13800000004', 'A', '2026-07-15'),
('陈大强', '13800000005', 'B', '2026-07-28'),
('刘萌萌', '13800000006', 'C', '2026-08-03'),
('孙浩然', '13800000007', 'B', '2026-08-11'),
('周小雨', NULL,          'C', '2026-08-19'),   -- ← IS NULL 练习对象
('吴俊杰', '13800000009', 'A', '2026-08-25'),
('郑雅婷', '13800000010', 'B', '2026-09-01'),
('冯建军', '13800000011', 'B', '2026-06-22'),
('何丽丽', '13800000012', 'C', '2026-07-09');
-- 沉睡会员（零约课）：郑雅婷(10)、冯建军(11)、何丽丽(12)

-- 课程 6 门（普拉提零约课；教练分布 2/2/1/1/0/0）
INSERT INTO courses (title, price, coach_id) VALUES
('瑜伽基础',   59.00,  1),
('高温瑜伽',   79.00,  1),
('动感单车',   49.00,  2),
('公路骑行课', 69.00,  2),
('游泳私教',  199.00,  3),
('普拉提',     89.00,  4);   -- ← 零约课课程

-- 约课 18 条（人次：瑜伽6 单车5 游泳4 搏击…见下；时间跨 8/9 月）
-- 课程1 瑜伽基础 ×6
INSERT INTO bookings (card_id, course_id, booking_time) VALUES
(1, 1, '2026-08-02 09:00:00'),
(2, 1, '2026-08-05 09:00:00'),
(3, 1, '2026-08-09 19:00:00'),
(4, 1, '2026-08-16 09:00:00'),
(5, 1, '2026-08-23 19:00:00'),
(6, 1, '2026-09-01 09:00:00'),
-- 课程3 动感单车 ×5
(1, 3, '2026-08-03 18:30:00'),
(2, 3, '2026-08-10 18:30:00'),
(3, 3, '2026-08-17 18:30:00'),
(7, 3, '2026-08-24 18:30:00'),
(8, 3, '2026-09-01 18:30:00'),
-- 课程5 游泳私教 ×4
(1, 5, '2026-08-06 10:00:00'),
(4, 5, '2026-08-13 10:00:00'),
(5, 5, '2026-08-20 10:00:00'),
(9, 5, '2026-08-27 10:00:00'),
-- 课程2 高温瑜伽 ×2
(2, 2, '2026-08-08 20:00:00'),
(6, 2, '2026-08-29 20:00:00'),
-- 课程4 公路骑行课 ×1
(7, 4, '2026-08-31 07:00:00');
-- 课程6 普拉提 ×0（故意不插，LEFT JOIN / HAVING 对比用）
-- 张三(card_id=1) 共 4 条约课：课程 1/3/5 各至少一条 → 闯关第 4 关答案非空

-- ④ 导入自检（执行完应看到：coaches 6、members 12、courses 6、bookings 18）
SELECT 'coaches' AS tbl, COUNT(*) AS cnt FROM coaches
UNION ALL SELECT 'members',  COUNT(*) FROM members
UNION ALL SELECT 'courses',  COUNT(*) FROM courses
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings;
