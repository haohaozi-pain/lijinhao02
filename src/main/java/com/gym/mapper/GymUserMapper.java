package com.gym.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gym.entity.GymUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户 Mapper 接口
 * MyBatis-Plus BaseMapper 提供基础 CRUD 操作
 */
@Mapper
public interface GymUserMapper extends BaseMapper<GymUser> {
    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户对象
     */
    GymUser selectByUsername(String username);
}
