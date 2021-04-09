package com.atguigu.crud.service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author xinhaojie
 * @create 2021-04-04-17:33
 *

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
    /**保存新增的员工数据*/
    public void saveEmployee(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**检查新增员工是否重名*/
    public boolean checkUser(String name) {
        EmployeeExample employeeExample = new EmployeeExample();
        //example中有判断标准方法，可以限定一些条件
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(name);
        long count = employeeMapper.countByExample(employeeExample);
        //等与0 就是true 没有重复名字，所以可用
        return count == 0;
    }
    /**用id查询单个具体的员工，*/
    public Employee getSingleEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 根据path中的id找到对应的数据进行选择性的修改
     * @param employee
     */
    public void updateEmpById(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 通过id删除用户
     * @param id
     */
    public void deleteEmpById(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    /**
     * 通过list中的id全部删除
     * @param idList
     */
    public void deleteEmpByIds(List<Integer> idList) {
        //借助example中标准来删除
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(idList);
        employeeMapper.deleteByExample(employeeExample);
    }
}
