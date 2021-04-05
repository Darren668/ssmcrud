<%--
  Created by IntelliJ IDEA.
  User: MACHENIKE
  Date: 2021/4/4
  Time: 17:30
  To change this template use File | Settings | File Templates.
--%>
<%--引入标签库--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
    <%--//标题--%>
    <div class="row">
        <%--//所有列12宽--%>
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--/按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <div class="btn btn-primary">新增</div>
            <div class="btn btn-danger">删除</div>
        </div>
    </div>
    <%--显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                <%--使用标签c：foreach可以获取model中的list或者大量数据，然后取别名方便下面每一个模块调用--%>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <td>${emp.empId}</td>
                        <td>${emp.empName}</td>
                        <td>${emp.gender}</td>
                        <td>${emp.email}</td>
                        <td>${emp.department.deptName}</td>
                        <td>
                            <button class="btn btn-primary btn-sm">
                                <%--添加一个图标--%>
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>

                </c:forEach>
            </table>
        </div>
    </div>
    <%--分页信息--%>
    <div class="row">
        <%--记录信息--%>
        <div class="col-md-6">
            当前${pageInfo.pageNum}页,总${pageInfo.pages}页，总${pageInfo.total}条记录
        </div>
        <%--分页信息--%>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
                    <%--前一页逻辑注意首页和末页去除该按钮--%>
                    <c:if test="${pageInfo.pageNum != 1}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                        <%--分页当前页码等与pageInfo存的pageNum页码那么就高亮显示，
                        否则其他的默认状态--%>
                        <c:if test="${page_Num == pageInfo.pageNum}">
                            <li class="active">
                                <a href="#">${page_Num}</a>
                            </li>
                        </c:if>
                        <c:if test="${page_Num != pageInfo.pageNum}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a>
                            </li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${pageInfo.pageNum != pageInfo.pages}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
