package com.gym.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录拦截器
 * 拦截未登录用户访问受限资源
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {

    /**
     * 预处理请求
     * 检查用户是否已登录
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取请求的URI
        String uri = request.getRequestURI();

        // 不需要拦截的路径
        if (uri.equals("/") || uri.equals("/login") || uri.equals("/register") || 
            uri.startsWith("/static/") || uri.startsWith("/resources/")) {
            return true;
        }

        // 获取session中的用户信息
        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");

        if (user == null) {
            // 未登录，重定向到登录页面
            response.sendRedirect("/login");
            return false;
        }

        // 已登录，继续处理请求
        return true;
    }
}
