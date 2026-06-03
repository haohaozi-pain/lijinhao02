package com.gym.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gym.entity.GymCourseBooking;
import org.apache.ibatis.annotations.Mapper;

/**
 * 课程预约 Mapper 接口
 * MyBatis-Plus BaseMapper 提供基础 CRUD 操作
 */
@Mapper
public interface GymCourseBookingMapper extends BaseMapper<GymCourseBooking> {
}
