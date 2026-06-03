package com.gym.controller;

import com.gym.entity.GymUser;
import com.gym.service.IGymUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

/**
 * 用户登录、注册控制器
 * 处理用户认证相关的请求
 */
@Controller
public class AuthController {

    @Autowired
    private IGymUserService userService;

    /**
     * 跳转到登录页面
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * 处理登录请求
     */
    @PostMapping("/login")
    public String login(@RequestParam String username,
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        // 验证用户名密码
        GymUser user = userService.login(username, password);
        
        if (user != null) {
            // 登录成功，将用户信息存储到session中
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            
            // 根据角色跳转到不同的首页
            if (user.getRole() == 0) {
                // 管理员跳转到管理员首页
                return "redirect:/admin/dashboard";
            } else {
                // 会员跳转到会员首页
                return "redirect:/member/index";
            }
        } else {
            // 登录失败，返回登录页面并显示错误信息
            model.addAttribute("error", "用户名或密码错误");
            return "login";
        }
    }

    /**
     * 跳转到注册页面
     */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    /**
     * 处理注册请求
     */
    @PostMapping("/register")
    public String register(@RequestParam String username,
                          @RequestParam String password,
                          @RequestParam String realName,
                          @RequestParam String phone,
                          Model model) {
        // 检查用户名是否已存在
        if (userService.getUserByUsername(username) != null) {
            model.addAttribute("error", "用户名已存在");
            return "register";
        }

        // 创建新用户
        GymUser user = new GymUser();
        user.setUsername(username);
        user.setPassword(password);
        user.setRealName(realName);
        user.setPhone(phone);

        if (userService.register(user)) {
            // 注册成功，跳转到登录页面
            model.addAttribute("success", "注册成功，请登录");
            return "login";
        } else {
            model.addAttribute("error", "注册失败，请重试");
            return "register";
        }
    }

    /**
     * 登出
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
