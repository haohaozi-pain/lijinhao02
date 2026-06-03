package com.gym;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 健身房管理系统启动类
 * 应用入口，配置 MyBatis-Plus mapper 扫描
 */
@SpringBootApplication
@MapperScan("com.gym.mapper")
public class GymManagementApplication {

    public static void main(String[] args) {
        SpringApplication.run(GymManagementApplication.class, args);
        System.out.println("\n\n" +
                "========================================\n" +
                "  健身房管理系统启动成功！\n" +
                "  访问地址: http://localhost:8080\n" +
                "========================================\n");
    }
}
