<%--
  Created by IntelliJ IDEA.
  User: MACHENIKE
  Date: 2021/4/4
  Time: 17:30
  To change this template use File | Settings | File Templates.
--%>
<%--引入标签库--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.1.1.js"></script>
    <%--bootstrap  css js  模板link用于引入css文件，script用于引入js文件--%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <%--//1.标题--%>
    <div class="row">
        <%--//所有列12宽--%>
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--/2.按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <div class="btn btn-primary">新增</div>
            <div class="btn btn-danger">删除</div>
        </div>
    </div>
    <%--3.显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>
    <%--4.分页信息--%>
    <div class="row">
        <%--分页记录信息--%>
        <div class="col-md-6" id="page_info_area"></div>
        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>
<%--不借助模板，直接利用js发送ajax请求，拿到json数据显示--%>
<script type="text/javascript">
    <%--1.页面加载完成后，直接发送ajax请求--%>
    $(function () {
        //刚开始去首页
        to_page(1);
    });
    function to_page(pn){
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn="+pn,
            type: "GET",
            success: function (result) {
                // console.log(result);
                //1.解析并显示员工数据
                build_emps_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.显示分页条
                build_page_nav(result);
            }
        });
    }
    function build_emps_table(result) {
        //每次ajax重新发送请求调用函数，注意先清空数据，否则直接叠加
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            // alert(item.empName);
            //取出数据对应到相应的表格行中    $("标签")就是创建该元素   .append就是元素中显示内容
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var empGenderTd = $("<td></td>").append(item.genger == 'M' ? "男" : "女");
            var empEmailTd = $("<td></td>").append(item.email);
            var empDeptTd = $("<td></td>").append(item.department.deptName);
            //创建编辑和删除按钮
            /**
             * <button class="btn btn-primary btn-sm">
             <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
             编辑
             </button>
             <button class="btn btn-danger btn-sm">
             <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
             删除
             </button>*/
            var editButton = $("<button></button>").addClass("btn btn-primary btn-sm")
            .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
            var delButton = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
            //放到一个单元格中
            var btnTd = $("<td></td>").append(editButton).append(" ").append(delButton);
            //append方法执行完成之后返回之前的元素所以可以持续添加
            $("<tr></tr>").append(empIdTd).append(empNameTd).append(empGenderTd)
                .append(empEmailTd).append(empDeptTd).append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }

    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        //当前页,总页，总条记录
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页"+
            ", 总"+result.extend.pageInfo.pages+"页"+
            ", 总"+ result.extend.pageInfo.total+"条记录");
    }
    //解析显示分页条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //attr可以对a标签的属性进行修改
        var fistPageLi = $("<li></li>").append($("<a></a>").append("首页"));

        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        //第一页的前一页不可以点击，在之前用的逻辑是不显示，也可以添加class="disable就不能点了
        if(result.extend.pageInfo.hasPreviousPage == false ){
            fistPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //被禁用就不用绑定单击事件了
            fistPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            });
        }
        ul.append(fistPageLi).append(prePageLi);

        $.each(result.extend.pageInfo.navigatepageNums,function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));

        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));

        if(result.extend.pageInfo.hasNextPage == false ){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            //被禁用就不用绑定单击事件了
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
</script>
</body>
</html>
