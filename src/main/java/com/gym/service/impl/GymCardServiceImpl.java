package com.gym.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.GymCard;
import com.gym.mapper.GymCardMapper;
import com.gym.service.IGymCardService;
import org.springframework.stereotype.Service;

/**
 * 会员卡业务实现类
 * 实现会员卡相关的业务逻辑
 */
@Service
public class GymCardServiceImpl extends ServiceImpl<GymCardMapper, GymCard> implements IGymCardService {

    @Override
    public GymCard getCardByUserId(Long userId) {
        // 根据用户ID查询会员卡
        QueryWrapper<GymCard> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        return baseMapper.selectOne(queryWrapper);
    }
}
