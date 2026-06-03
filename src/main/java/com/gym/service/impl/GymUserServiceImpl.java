package com.gym.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.GymUser;
import com.gym.mapper.GymUserMapper;
import com.gym.service.IGymUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 用户业务实现类
 * 实现用户相关的业务逻辑
 */
@Service
public class GymUserServiceImpl extends ServiceImpl<GymUserMapper, GymUser> implements IGymUserService {

    @Autowired
    private GymUserMapper userMapper;

    /**
     * MD5密码加密
     * @param password 明文密码
     * @return 加密后的密码
     */
    private String md5Encode(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }

    @Override
    public GymUser login(String username, String password) {
        // 根据用户名查询用户
        QueryWrapper<GymUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        queryWrapper.eq("status", 1); // 只查询正常状态的用户
        GymUser user = userMapper.selectOne(queryWrapper);

        // 验证密码
        if (user != null && user.getPassword().equals(md5Encode(password))) {
            return user;
        }
        return null;
    }

    @Override
    public boolean register(GymUser user) {
        // 检查用户名是否已存在
        QueryWrapper<GymUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", user.getUsername());
        if (userMapper.selectOne(queryWrapper) != null) {
            return false; // 用户名已存在
        }

        // 密码加密
        user.setPassword(md5Encode(user.getPassword()));
        // 设���默认角色为会员（1）
        user.setRole(1);
        // 设置默认状态为正常（1）
        user.setStatus(1);
        // 设置默认积分为0
        user.setPoints(0);

        return save(user);
    }

    @Override
    public GymUser getUserByUsername(String username) {
        QueryWrapper<GymUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        return userMapper.selectOne(queryWrapper);
    }
}
