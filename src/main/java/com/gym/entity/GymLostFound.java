package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 失物招领实体类
 * 用于发布和管理失物招领信息
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("gym_lost_found")
public class GymLostFound {
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 发布者ID
     */
    private Long userId;

    /**
     * 类型: 0-失物, 1-寻物
     */
    private Integer itemType;

    /**
     * 物的名称
     */
    private String itemName;

    /**
     * 物的描述
     */
    private String itemDesc;

    /**
     * 找到位置
     */
    private String findLocation;

    /**
     * 物的图片URL
     */
    private String itemImage;

    /**
     * 联系电话
     */
    private String contactPhone;

    /**
     * 发布状态: 0-已解决, 1-未解决
     */
    private Integer postStatus;

    /**
     * 发布时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
