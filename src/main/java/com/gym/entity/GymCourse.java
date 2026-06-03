package com.gym.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 课程实体类
 * 用于管理健身房课程信息
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("gym_course")
public class GymCourse {
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 课程名称
     */
    private String courseName;

    /**
     * 课程描述
     */
    private String courseDesc;

    /**
     * 教练ID
     */
    private Long trainerId;

    /**
     * 最大容纳人数
     */
    private Integer maxCapacity;

    /**
     * 水平: 1-简单, 2-中级, 3-高级
     */
    private Integer courseLevel;

    /**
     * 状态: 0-下架, 1-上架
     */
    private Integer status;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
