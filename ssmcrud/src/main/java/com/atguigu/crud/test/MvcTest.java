package com.atguigu.crud.test;

import com.atguigu.crud.bean.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * @author xinhaojie
 * @create 2021-04-04-17:51
 * 使用Spring 测试模块来测试请求
 * classpath:对应到src下面的各种命名规范的配置文件
 * applicationContext*.xml mybatis-config.xml
 * 因为当初init参数没有写，将springmvc的配置文件放在了web-info下，所以不能使用classpath定位，这里使用file
 * dispatcherServlet-servlet.xml
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
    //借助MockMvc,虚拟mvc请求，获取处理结果
    MockMvc mockMvc;

    //传入springmvc的ioc,需要借助@WebAppConfiguration
    @Autowired
    WebApplicationContext context;


    //每次要用都要初始化@Before  junit中的
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }
    @Test
    public void testPage() throws Exception {
        //模拟请求并拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();
        //请求成功以后，请求域中会有pageInfo,验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo)request.getAttribute("pageInfo");
        System.out.println("当前页面："+pageInfo.getPageNum());
        System.out.println("总页码"+pageInfo.getPages());
        System.out.println("总记录数"+pageInfo.getTotal());
        int[] navigatepageNums = pageInfo.getNavigatepageNums();
        for(int i : navigatepageNums){
            System.out.print(""+i);
            System.out.println();
        }
        //获取员工数据
        List<Employee> list = pageInfo.getList();
        for(Employee e : list){
            System.out.println(e.getdId());
            System.out.println(e.getEmpName());
        }
    }


}
