package com.gym.config;

import com.gym.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web配置类
 * 注册拦截器和其他Web相关配置
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    /**
     * 注册拦截器
     * 指定拦截路径���放行路径
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                // 拦截所有请求
                .addPathPatterns("/**")
                // 放行的路径
                .excludePathPatterns(
                        "/",
                        "/login",
                        "/register",
                        "/static/**",
                        "/resources/**",
                        "/css/**",
                        "/js/**",
                        "/images/**"
                );
    }
}
