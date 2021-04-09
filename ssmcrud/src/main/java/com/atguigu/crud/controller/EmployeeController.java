package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.Message;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.print.attribute.standard.Media;
import javax.validation.Valid;
import java.util.ArrayList;
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
 *
 * 在controller里面的方法返回都是封装好的Message对象，不管是否查询，最后至少应该返回success 或者failure中的信息
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 删除批量和单个二合一
     * 约定多个时，id格式1-2-3
     * 单个就是1
     * @param ids
     * @return
     */
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Message deleteEmp(@PathVariable("ids") String ids){
        if(ids.contains("-")){
            //如果有-，将每个id解析到list中作为参数传给方法
            List<Integer> idList = new ArrayList<>();
            String[] idArray = ids.split("-");
            for(String id : idArray){
                idList.add(Integer.valueOf(id));
            }
            employeeService.deleteEmpByIds(idList);
        }else {
            Integer id = Integer.valueOf(ids);
            employeeService.deleteEmpById(id);
        }
        return Message.success();
    }


    /**
     * 1.员工更新方法，根据id来更新员工信息
     * 但是注意虽然路径上有id但是不会封装到参数中，因为empId id不相同
     * 所以如果想让路径上的数据给到参数中employee，需要将名字一致
     * ===================================================================================================
     * 原生的javaweb项目中，我们要想把页面的请求参数封装的实体当中，
     * 常用的简便方式是在servlet中用request.getParameterMap()获得一个map，然
     * 后用commons-beanutils包中的CommonUtils.toBean(request.getParameterMap(), example.class)去完成封装。
     *
     * SpringMVC中集成了这种请求参数封装成对象的方式要求：
     * Controller中的业务方法的POJO参数的属性名与请求参数的标签中的name名称一致，参数值会自动映射完成匹配封装
     * ===================================================================================================
     *
     * 2.使用ajax直接发送PUT请求，会导致employee对象封装不上
     * 请求体中的数据是存在的，但是employee的属性全是null
     * 导致sql语句最后  update tbl_emp where emp_id = 1014; 丢失了set直接报错
     * 原因：
     *      1.Tomcat服务器将请求体重的数据封装为一个map
     *      2.request.getParameter("empName")就会从map中获取值
     *      3,但是SpringMVC的POJO参数的属性通过第二步赋值
     * 所以不可以直接使用ajax直接发送PUT请求，上面说明即使是request.getParameter("empName")都拿不到数据
     * tomcat是put请求，就不会封装map了，只有post才封装为请求体
     *
     * 解决方法：在web.xml中配置HttpPutFormContentFilter过滤器
     * 1.会将请求体中的数据封装成map
     * request.getParameter被重写，当查不到request的参数时，就用自己的数据
     *
     */
    //@RequestMapping(value = "/emp/{id}",method = RequestMethod.PUT)
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Message updateEmp(Employee employee){
        employeeService.updateEmpById(employee);
        return Message.success();
    }

    /**
     * 查询员工的数据用于数据修改,和之前不同，这里不需要封装分页信息
     *约定好的访问路径中的id值可以用@@PathVariable("id")直接赋值给参数
     * */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Message getEmp(@PathVariable("id") Integer id){
        Employee emp = employeeService.getSingleEmp(id);
        return Message.success().add("emp",emp);
    }
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
