-- 健身房管理系统数据库脚本
-- 作者: 李金浩
-- 日期: 2026-06-03

-- 创建数据库
DROP DATABASE IF EXISTS gym_management;
CREATE DATABASE IF NOT EXISTS gym_management
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE gym_management;

-- 用户表 (gym_user)
CREATE TABLE gym_user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  password VARCHAR(100) NOT NULL COMMENT '密码',
  real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
  gender INT DEFAULT 0 COMMENT '性别: 0-未指定, 1-男, 2-女',
  phone VARCHAR(20) COMMENT '电话号码',
  email VARCHAR(100) COMMENT '邮箱',
  role INT DEFAULT 1 COMMENT '角色: 0-管理员, 1-会员',
  points INT DEFAULT 0 COMMENT '会员积分',
  status INT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_username (username),
  INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 会员卡类型表 (gym_card_type)
CREATE TABLE gym_card_type (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  card_type_name VARCHAR(50) NOT NULL UNIQUE COMMENT '卡类型名称',
  valid_days INT NOT NULL COMMENT '有效天数',
  price DECIMAL(10, 2) NOT NULL COMMENT '价格',
  description VARCHAR(200) COMMENT '描述',
  status INT DEFAULT 1 COMMENT '状态: 0-停止使用, 1-正常使用',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='卡类型表';

-- 会员卡信息表 (gym_card)
CREATE TABLE gym_card (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  user_id BIGINT NOT NULL UNIQUE COMMENT '会员ID',
  card_no VARCHAR(50) NOT NULL UNIQUE COMMENT '卡号',
  card_type_id BIGINT NOT NULL COMMENT '卡类型 ID',
  start_date DATE NOT NULL COMMENT '开卡日期',
  end_date DATE NOT NULL COMMENT '到期日期',
  balance DECIMAL(10, 2) DEFAULT 0 COMMENT '卡余额',
  status INT DEFAULT 1 COMMENT '卡状态: 0-已退卡, 1-正常, 2-已过期',
  freeze_reason VARCHAR(200) COMMENT '冻结原因',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  FOREIGN KEY (card_type_id) REFERENCES gym_card_type(id),
  INDEX idx_user_id (user_id),
  INDEX idx_end_date (end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员卡表';

-- 课程表 (gym_course)
CREATE TABLE gym_course (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
  course_desc VARCHAR(500) COMMENT '课程描述',
  trainer_id BIGINT NOT NULL COMMENT '教练 ID',
  max_capacity INT DEFAULT 20 COMMENT '最大容纳人数',
  course_level INT DEFAULT 1 COMMENT '水平: 1-简单, 2-中级, 3-高级',
  status INT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (trainer_id) REFERENCES gym_user(id),
  INDEX idx_trainer_id (trainer_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程表';

-- 课程日程表 (gym_course_schedule)
CREATE TABLE gym_course_schedule (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  course_id BIGINT NOT NULL COMMENT '课程 ID',
  schedule_date DATE NOT NULL COMMENT '上课日期',
  start_time TIME NOT NULL COMMENT '开始时间',
  end_time TIME NOT NULL COMMENT '结束时间',
  room_location VARCHAR(100) COMMENT '上课位置',
  current_count INT DEFAULT 0 COMMENT '当前报名人数',
  status INT DEFAULT 1 COMMENT '状态: 0-已取消, 1-正常',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (course_id) REFERENCES gym_course(id) ON DELETE CASCADE,
  INDEX idx_course_id (course_id),
  INDEX idx_schedule_date (schedule_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程日程表';

-- 课程预约表 (gym_course_booking)
CREATE TABLE gym_course_booking (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  schedule_id BIGINT NOT NULL COMMENT '课程日程 ID',
  user_id BIGINT NOT NULL COMMENT '会员 ID',
  booking_status INT DEFAULT 1 COMMENT '预约状态: 0-已取消, 1-待参加, 2-已参加, 3-未参加',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预约时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (schedule_id) REFERENCES gym_course_schedule(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  UNIQUE KEY uk_schedule_user (schedule_id, user_id),
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程预约表';

-- 签到打卡表 (gym_sign_in)
CREATE TABLE gym_sign_in (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  user_id BIGINT NOT NULL COMMENT '会员 ID',
  sign_in_date DATE NOT NULL COMMENT '签到日期',
  sign_in_time TIME NOT NULL COMMENT '签到时间',
  sign_out_time TIME COMMENT '签出时间',
  duration INT COMMENT '停留时间（分钟）',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_sign_in_date (sign_in_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到打卡表';

-- 礼品表 (gym_gift)
CREATE TABLE gym_gift (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  gift_name VARCHAR(100) NOT NULL COMMENT '礼品名称',
  gift_desc VARCHAR(500) COMMENT '礼品描述',
  points_required INT NOT NULL COMMENT '需要积分数',
  stock INT DEFAULT 0 COMMENT '库存数量',
  status INT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='礼品表';

-- 礼品兑换表 (gym_gift_exchange)
CREATE TABLE gym_gift_exchange (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  user_id BIGINT NOT NULL COMMENT '会员 ID',
  gift_id BIGINT NOT NULL COMMENT '礼品 ID',
  exchange_status INT DEFAULT 0 COMMENT '兑换状态: 0-待审核, 1-已审核, 2-已拒绝',
  exchange_time DATETIME COMMENT '兑换时间',
  audit_time DATETIME COMMENT '审核时间',
  audit_remark VARCHAR(200) COMMENT '审核备注',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  FOREIGN KEY (gift_id) REFERENCES gym_gift(id),
  INDEX idx_user_id (user_id),
  INDEX idx_exchange_status (exchange_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='礼品兑换表';

-- 失物招领表 (gym_lost_found)
CREATE TABLE gym_lost_found (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  user_id BIGINT NOT NULL COMMENT '发布者 ID',
  item_type INT NOT NULL COMMENT '类型: 0-失物, 1-寻物',
  item_name VARCHAR(100) NOT NULL COMMENT '物的名称',
  item_desc VARCHAR(500) COMMENT '物的描述',
  find_location VARCHAR(100) COMMENT '找到位置',
  item_image VARCHAR(500) COMMENT '物的图片 URL',
  contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  post_status INT DEFAULT 1 COMMENT '发布状态: 0-已解决, 1-未解决',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_post_status (post_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='失物招领表';

-- 失物旁记表 (gym_lost_found_comment)
CREATE TABLE gym_lost_found_comment (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  lost_found_id BIGINT NOT NULL COMMENT '失物招领 ID',
  user_id BIGINT NOT NULL COMMENT '评论人 ID',
  comment_content VARCHAR(500) NOT NULL COMMENT '评论内容',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  FOREIGN KEY (lost_found_id) REFERENCES gym_lost_found(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES gym_user(id) ON DELETE CASCADE,
  INDEX idx_lost_found_id (lost_found_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='失物旁记表';

-- 插入测试数据

-- 插入管理员账户
INSERT INTO gym_user (username, password, real_name, gender, phone, email, role, points, status)
VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', 1, '18800001111', 'admin@gym.com', 0, 0, 1);

-- 插入测试会员账户
INSERT INTO gym_user (username, password, real_name, gender, phone, email, role, points, status)
VALUES 
('member01', 'e10adc3949ba59abbe56e057f20f883e', '王奥', 1, '13800001111', 'member01@gym.com', 1, 1000, 1),
('member02', 'e10adc3949ba59abbe56e057f20f883e', '李丝', 2, '13800002222', 'member02@gym.com', 1, 2000, 1),
('member03', 'e10adc3949ba59abbe56e057f20f883e', '张三', 1, '13800003333', 'member03@gym.com', 1, 1500, 1);

-- 插入会员卡类型
INSERT INTO gym_card_type (card_type_name, valid_days, price, description, status)
VALUES 
('月卡', 30, 199.00, '优惠价月卡', 1),
('季卡', 90, 499.00, '优惠价季卡', 1),
('年卡', 365, 1999.00, '分期购课程', 1);

-- 插入课程
INSERT INTO gym_course (course_name, course_desc, trainer_id, max_capacity, course_level, status)
VALUES 
('瑜伽有氧操', '预热身体，改善浅束也。', 1, 20, 1, 1),
('踏氧操', '锻炼大腿肌肉，增强心肖七。', 1, 15, 2, 1),
('踏氧操宝', '提升氧血侣输输量。', 1, 25, 1, 1);

-- 插入课程日程
INSERT INTO gym_course_schedule (course_id, schedule_date, start_time, end_time, room_location, current_count, status)
VALUES 
(1, '2026-06-04', '08:00:00', '09:00:00', 'A 摩得客室', 5, 1),
(1, '2026-06-05', '09:00:00', '10:00:00', 'A 摩得客室', 3, 1),
(2, '2026-06-04', '18:00:00', '19:00:00', 'B 散打室', 12, 1),
(3, '2026-06-06', '10:00:00', '11:00:00', 'A 摩得客室', 8, 1);

-- 插入礼品
INSERT INTO gym_gift (gift_name, gift_desc, points_required, stock, status)
VALUES 
('100元全馆券', '100元全馆消费券', 500, 10, 1),
('段练毛巾', '高级段练毛巾一条', 200, 20, 1),
('基管不亦水材', '丰富的水和电解质', 300, 15, 1);

-- 插入测试签到打卡记录
INSERT INTO gym_sign_in (user_id, sign_in_date, sign_in_time, sign_out_time, duration)
VALUES 
(2, '2026-06-01', '07:00:00', '08:30:00', 90),
(2, '2026-06-02', '08:00:00', '09:15:00', 75),
(3, '2026-06-01', '18:00:00', '19:45:00', 105);
