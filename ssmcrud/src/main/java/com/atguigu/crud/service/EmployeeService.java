package com.atguigu.crud.service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author xinhaojie
 * @create 2021-04-04-17:33
 */
//业务逻辑组件
@Service
public class EmployeeService {

    //service又需要dao的组件
    @Autowired
    EmployeeMapper employeeMapper;

    /**查询所有员工*/
    public List<Employee> getAll() {

        return employeeMapper.selectByExampleWithDept(null);
    }
}
