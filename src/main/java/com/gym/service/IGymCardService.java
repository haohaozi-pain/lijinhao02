package com.gym.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.gym.entity.GymCard;

/**
 * 会员卡业务接口
 */
public interface IGymCardService extends IService<GymCard> {
    /**
     * 根据用户ID查询会员卡
     * @param userId 用户ID
     * @return 会员卡对象
     */
    GymCard getCardByUserId(Long userId);
}
