package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Message;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.print.attribute.standard.Media;
import java.util.List;

/**
 * @author xinhaojie
 * @create 2021-04-04-17:22
 * 处理员工crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**为了有更好的扩展性，服务器返回的数据采用json格式，可以再客户端，网页端，移动端等等平台都可以解析
     * 添加jackson依赖，添加@ResponseBody注解，从而返回的不是list.jsp跳转网页资源。而是json格式数据字符串
     * */
    @RequestMapping("/emps")
    @ResponseBody
    public Message getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        //这不是一个分页查询，需要每次传入页码
        //所以直接引入第三方PageHelper分页插件，并在mybatis里面配置
        //在查询之前只需要调用startPage方法就可以
        PageHelper.startPage(pn, 5);
        //后面紧跟的mybatis查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //得到页面的信息
        //用PageInfo对结果进行包装,再将pageIndo交给页面就可以，封装了分页信息和查询信息
        //连续显示的页数的构造器5
        PageInfo page = new PageInfo(emps, 5);
        return Message.success().add("pageInfo",page);
    }


    /**
     * 该方法查询所有的数据并展示(分页查询)
     */
    //这里注解内容就是处理的请求路径
//    @RequestMapping("/emps")
//    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
//        //这不是一个分页查询，需要每次传入页码
//        //所以直接引入第三方PageHelper分页插件，并在mybatis里面配置
//        //在查询之前只需要调用startPage方法就可以
//        PageHelper.startPage(pn, 5);
//        //后面紧跟的mybatis查询就是一个分页查询
//        List<Employee> emps = employeeService.getAll();
//        //得到页面的信息
//        //用PageInfo对结果进行包装,再将pageIndo交给页面就可以，封装了分页信息和查询信息
//        //连续显示的页数的构造器5
//        PageInfo page = new PageInfo(emps, 5);
//        //model中添加信息
//        model.addAttribute("pageInfo", page);
//
//        //先测试数据，再直接转到页面,返回值就是views文件夹中jsp文件的名称，一定得一一对应相同
//        return "list";
//    }
}
