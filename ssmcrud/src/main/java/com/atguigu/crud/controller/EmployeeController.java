package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Message;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.print.attribute.standard.Media;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;

/**
 * @author xinhaojie
 * @create 2021-04-04-17:22
 * 处理员工crud请求
 * * 约定请求方式
 * * /emp/{id} GET 查询
 * * /emp/{id} PUT 修改
 * * /emp/{id} DELETE 删除
 * * /emp POST 保存
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 校验新增员工是否重
     * */
    @RequestMapping(value = "/checkUser")
    @ResponseBody
    public Message checkEmpName(@RequestParam(value = "empName") String empName){
        //后端校验格式,前端可以完成，但是有的情景会禁用js，所以前后端节后稳妥没问题
        String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]+$)";
        if(!empName.matches(regex)){
            return Message.failure().add("user_validate_msg","6-16位数字 英文 — _组合,或者2-5位中文");
        }

        //数据库用户名查询是否重复
        boolean doesNotExist = employeeService.checkUser(empName);
        if(doesNotExist){
            return Message.success();
        }else{
            return Message.failure().add("user_validate_msg","用户名不可用");
        }
    }

    /**
     * 员工保存/emp POST
     * JSR直接注解添加校验，在bean对象上面添加Pattern，在这里的参数结合@Valid从而校验
     * 校验的结果，紧跟在后面BindingResult，可用于判断
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Message saveEmp(@Valid Employee employee, BindingResult result) {
        if(result.hasErrors()){
            HashMap<String, Object> errorMap = new HashMap<>();
            //校验失败，返回失败并在静态模态框中显示校验信息
            List<FieldError> fieldErrors = result.getFieldErrors();
            for(FieldError error : fieldErrors){
                errorMap.put(error.getField(),error.getDefaultMessage());
            }
            return Message.failure().add("errorFields",errorMap);
        }else{
            //新增的表单数据与employee对象属性对应，所以参数只需要Employee
            employeeService.saveEmployee(employee);
            return Message.success();
        }
    }


    /**
     * 为了有更好的扩展性，服务器返回的数据采用json格式，可以再客户端，网页端，移动端等等平台都可以解析
     * 添加jackson依赖，添加@ResponseBody注解，从而返回的不是list.jsp跳转网页资源。而是json格式数据字符串
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Message getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
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
        //第一个参数key，就是封装的数据，在js中可以根据这个key拿到响应的查询结果
        return Message.success().add("pageInfo", page);
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
