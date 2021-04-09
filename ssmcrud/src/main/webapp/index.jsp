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
    <%--    jQuery相对于bootstrap api必须在前面否则后面模态框可能出错--%>
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
            <div class="btn btn-primary" id="emp_add_btn">新增</div>
            <div class="btn btn-danger" id="emp_delete_all">删除</div>
        </div>
    </div>
    <!-- 员工添加的Modal -->
    <div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">员工添加</h4>
                </div>
                <%--为了SpringMVC自动的将提交的表单数据封装为bean对象，那么每一个input的name要与属性对应--%>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input"
                                       placeholder="EmpName">
                                <span class="help-block"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="email" name="email" class="form-control" id="email_add_input"
                                       placeholder="email@qq.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_value" value="M"
                                           checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_value" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--只需要用dId去新增就可以所以对应部门编号属性--%>
                                <%--下拉列表的内容应该是点击新增前发送ajax请求，获取部门信息，并填充到这里--%>
                                <select class="form-control" name="dId" id="dept_add_select">
                                </select>
                            </div>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 弹窗都使用模板模态框： 员工修改的Modal -->
    <div class="modal fade" id="emp_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">员工修改</h4>
                </div>
                <%--为了SpringMVC自动的将提交的表单数据封装为bean对象，那么每一个input的name要与属性对应--%>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <p class="form-control-static" id="empName_update_static"></p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="email" name="email" class="form-control" id="email_update_input"
                                       placeholder="email@qq.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--只需要用dId去新增就可以所以对应部门编号属性--%>
                                <%--下拉列表的内容应该是点击新增前发送ajax请求，获取部门信息，并填充到这里--%>
                                <select class="form-control" name="dId" id="dept_update_select">
                                </select>
                            </div>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
                </div>
            </div>
        </div>
    </div>
    <%--3.显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
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

    var totalRecord,currentPage;
    <%--1.页面加载完成后，直接发送ajax请求--%>
    $(function () {
        //刚开始去首页
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
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
        $("#check_all").prop("checked",false);
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            // alert(item.empName);
            //取出数据对应到相应的表格行中    $("标签")就是创建该元素   .append就是元素中显示内容
            var checkboxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'/>"));
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var empGenderTd = $("<td></td>").append(item.gender == "M" ? "男" : "女");
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
                //修改功能，在这里创建的时候还要添加单击事件
            var editButton = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
            //为编辑按钮添加自定义属性保存当前的id值方便后面修改时获取数据
            editButton.attr("edit_id",item.empId);
            var delButton = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
            //为删除按钮添加自定义属性保存当前的id方便删除
            delButton.attr("del_id",item.empId);

            //放到一个单元格中
            var btnTd = $("<td></td>").append(editButton).append(" ").append(delButton);
            //append方法执行完成之后返回之前的元素所以可以持续添加
            $("<tr></tr>").append(checkboxTd).append(empIdTd).append(empNameTd).append(empGenderTd)
                .append(empEmailTd).append(empDeptTd).append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }

    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        //当前页,总页，总条记录
        $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + "页" +
            ", 总" + result.extend.pageInfo.pages + "页" +
            ", 总" + result.extend.pageInfo.total + "条记录");
        //每次处理分页逻辑对我们的全局变量totalRecord进行更新
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
    }

    //解析显示分页条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //attr可以对a标签的属性进行修改
        var fistPageLi = $("<li></li>").append($("<a></a>").append("首页"));

        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        //第一页的前一页不可以点击，在之前用的逻辑是不显示，也可以添加class="disable就不能点了
        if (result.extend.pageInfo.hasPreviousPage == false) {
            fistPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            //被禁用就不用绑定单击事件了
            fistPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }
        ul.append(fistPageLi).append(prePageLi);

        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href", "#"));

        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            //被禁用就不用绑定单击事件了
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    function reset_form(ele) {
        $(ele)[0].reset();
        //清空表单样式,此时对象为整个表单，之前验证添加的样式：1.form对象添加has-error has-success
        //1.表单中两个输入框div都有可能有has-error has-success所以要全部找到
        $(ele).find("*").removeClass("has-error has-success");
        //2.就是对next("span")添加了append内容提示
        //form中有两个.help-block可以使用find()全部查找到
        $(ele).find(".help-block").empty();

    }

    //新增员工逻辑
    $("#emp_add_btn").click(function () {
        //表单重置(表单的数据和样式)，清除数据，jQuery中没有对应的reset方法，所以拿到dom对象操作
        reset_form("#emp_add_modal form");
        //发送ajax请求，查部门信息，显示下拉列表
        getDepts("#emp_add_modal select");
        //弹出模态框的动作
        $("#emp_add_modal").modal({
            //点击背景也不会消失
            backdrop: "static",
        });
    });

    //定制化是把数据放到参数指定的选择器中
    function getDepts(ele) {
        //清空之前的下拉列表值
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                //console.log(result)测试，拿到数据
                // extend:
                //     depts: Array(2)
                // 0: {deptId: 1, deptName: "开发部"}
                // 1: {deptId: 2, deptName: "测试部"}
                //$.each,参数一遍历的对象，
                // 后面必须跟每个对象的处理方式函数function(index,item)index就是索引，item/element就是当前遍历到的对象
                $.each(result.extend.depts, function (index, item) {
                    var optionEle = $("<option></option>").append(item.deptName).attr("value", item.deptId);
                    //因为modal中只有一个select所以可以直接用子寻找方式，或者直接再给select写一个id也行
                    optionEle.appendTo($(ele));
                });
            }
        });
    }

    //除了校验格式之外，对于新加的元素还要去数据库查重。绑定.change()事件，可以每次更改完及时检验
    //这里是利用后端的数据，校验。同时还应该结合之前的格式校验，可以在这里前端直接合并，或者交给后端来处理格式问题
    $("#empName_add_input").change(function () {
        //取到当前对象(标签)的值,表单内容填写后，其value值就是输入值
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkUser",
            type: "GET",
            data: "empName=" + empName,
            success: function (result) {
                //返回了状态码检查
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    //禁用掉保存按钮的实现也就是不让其发送ajax请求,定义一个属性，到时候发送前拿到该按钮的属性判断
                    $("#emp_save_btn").attr("canClick", "success");
                } else {
                    //不可用之后注意还要禁用掉保存逻辑，否则一旦输入了其他内容，还是可以添加进去
                    show_validate_msg("#empName_add_input", "error", result.extend.user_validate_msg);
                    $("#emp_save_btn").attr("canClick", "error");
                }
            }
        });
    });
    //点击保存员工的方法
    $("#emp_save_btn").click(function () {
        //1.模态框中填写的表单数据交给服务器保存
        //2.!!!!!!!!!!!!!!!发送请求前，先校验
        if (!validate_add_form()) {
            //false 或者true都可以结束方法就可以，此时保存键单击事件就会被终止
            return false;
        }
        //拿出用户名查重的属性设置，看是否可以进行下一步
        //这里注意区别this 和$(this) $()是jQuery中的基本函数，this是一个dom对象，对应具体的一个标签，
        // $(this)是通过dom对象获取的jQuery的对象数组，如果"div"找到到多个，那么数组中每一个就是一个div 的dom对象
        //相互转换dom->jQuery  $(dom)例如$("#emp_add_modal form") ，  jQuery->dom  jQuery.get()  或者jQuery[0] ...
        //获取之后可以调用jQuery的方法例如.attr()  .append(),
        //this就是简单的html dom对象，对应一个标签，只能简单的获取属性使用.id  .name等等可以直接过去
        if ($(this).attr("canClick") == "error") {
            return false;
        }
        //3.发送ajax请求保存员工
        //使用alert测试表单数据的序列化   alert($("#emp_add_modal form").serialize());
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            //可以通过js获取表单中的数据，从而添加，但是太麻烦，jQuery直接提供序列化方法
            data: $("#emp_add_modal form").serialize(),
            success: function (result) {
                //加上校验之后要判断返回的状态码
                if (result.code == 100) {
                    // alert(result.msg);
                    //员工保存成功1.关闭模态框2.来到最后一页显示刚才的数据
                    $("#emp_add_modal").modal('hide');
                    //发送ajax请求显示最后一页数据,可以传一个非常大的数，就最后了，但是不保险，那就定义一个全局变量
                    //totalRecord总记录数总是大于等于分页总数
                    to_page(totalRecord);
                } else {
                    //失败的话显示失败信息 console.log(result);
                    //有哪个字段的就显示,errorField的属性没有内容就是undefined
                    if (result.extend.errorFields.empName != undefined) {
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                    if (result.extend.errorFields.email != undefined) {
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }

                }

            }
        });
    });

    //校验用户输入，注意不要写到某个单击事件里面去。这里有返回值
    function validate_add_form() {
        //1.拿到校验的数据
        var empName = $("#empName_add_input").val();
        //jQuery官方文档查询常用用户名和中文的表达式
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)/;
        if (!regName.test(empName)) {
            //alerts不友好，改为直接校验框变红和提示
            //alert("用户名是2-5位中文或者6-16位数字 英文 — _组合");
            //!!!!!!!!!注意，每次调用该函数都会向后添加元素，所以一定要注意更新元素属性或者内容前清空
            show_validate_msg("#empName_add_input", "error", "用户名是2-5位中文或者6-16位数字 英文 — _组合");
            return false;
        } else {
            show_validate_msg("#empName_add_input", "success", "");
            return true;
        }
        //2.校验邮箱
        var email = $("#email_add_input").val();
        //jQuery官方文档查询常用用户名和中文的表达式
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            //alert("邮箱格式不正确");
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
            return true;
        }

    }

    //重复代码抽取校验信息显示函数
    function show_validate_msg(ele, status, msg) {
        //每次更新属性前即下一次校验前，先清空之前的状态！！！！！
        //remove中多个参数可以用空格隔开,只要检查有就删除
        $(ele).parent().removeClass("has-success has-error");
        //或者使用text("")直接赋值为空,为什么不直接查找类.help-block呢？因为此时对象是input标签，同级。父类向下查找可以用Find
        $(ele).next("span").empty();
        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            //next("span").text("")也可以添加内容
            $(ele).next("span").append(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").append(msg);
        }
    }

    //加载页面完成之后，才发送的ajax请求，才创建的按钮。
    // 所以在页面加载阶段直接绑定.edit_btn绑定不上的
    //解决方法：1.可以在创建的时候绑定，但是耦合度太高 2.绑定单击.live  但是jquery新版没有live替换成了on
    //参数type  selector   data function
    $(document).on("click", ".edit_btn", function () {
        //1.查出员工信息显示，查出部门信息，方法中已经有添加到选择器中的逻辑，构建显示部门列表
        getDepts("#emp_update_modal select");
        //方式1查询员工，这里处理查询后还要将结果显示到modal里面所以构建函数  方式2向上查找到emp，单独拿名字无其他逻辑
        getEmp($(this).attr("edit_id"));
        //为了更新按钮时也有这个数据，将id传给更新按钮
        $("#emp_update_btn").attr("update_id",$(this).attr("edit_id"));
        //2.弹出模态框
        $("#emp_update_modal").modal({
            //点击背景也不会消失
            backdrop: "static",
        });
    });

    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function (result) {
                var empData = result.extend.emp;
                //拿到数据后显示到modal中，用户名写死不可以修改其他的填充
                $("#empName_update_static").text(empData.empName);
                //邮箱格式的表单input直接赋值value即可
                $("#email_update_input").val(empData.email);
                //单选的话，在val中添加对应的数组就行，数组中的元素对应标签的value，有相同的即被选中
                $("#emp_update_modal input[name=gender]").val([empData.gender]);
                //下拉列表相同.通过确定的value从而直接选中，在查询getDepts的时候已经为每一个option赋值了，
                //所以一个value对应显示的文字
                $("#emp_update_modal select").val([empData.dId]);
            }
        });
    }

    //为更新按钮绑定单击事件
    $("#emp_update_btn").click(function () {
        //1.相同，填写完表单应该先检查填写内容
        var email = $("#email_update_input").val();
        //jQuery官方文档查询常用用户名和中文的表达式
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            //alert("邮箱格式不正确");
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
        } else {
            show_validate_msg("#email_update_input", "success", "");
        }

        //2.合法后再发送ajax请求进行update
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("update_id"),
            //ajax中可以直接发送PUT
            type:"PUT",
            //如果上面使用的post那么后端无法识别，需要在请求参数中添加方法说明
            //data:$("emp_update_modal").serialize()+"&_method=PUT",
            //！！！！千万注意，自己写是将表单数据序列化，不要认为模块框就是数据
            data:$("#emp_update_modal form").serialize(),
            success:function (result) {
                //1.关闭模态框，回到页面
                $("#emp_update_modal").modal('hide');
                //2.回到本页面,本页面怎么回？也可以定义全局变量时刻保存更改此时的页面值
                to_page(currentPage);
            }

        });
    });


    //删除逻辑,添加单击事件
    $(document).on("click",".delete_btn",function () {
        //1.因为没有对其他模块的逻辑，简单就是拿到名字所以直接向上搜索即可
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        //2.通过id发送ajax请求，发送前注意要设置提醒,还要有判断逻辑使用confirm
        //alert("你确定要删除"+【empName】+"吗？");
        if(confirm("你确定要删除【"+empName+"】吗？")){
            //3.点击确认之后发送ajax请求
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("del_id"),
                type:"DELETE",
                success:function (result) {
                    //删除成功提醒
                    //删除成功成功跳转页面
                    if(result.code == 100){
                        alert("删除成功")
                        to_page(currentPage);
                    }
                }
            });
        }

    });

    //添加全选和单选的逻辑
    $("#check_all").click(function () {
        //attr获取属性checked是undefined
        //dom原生属性获取推荐使用prop,而自定义的属性推荐使用attr
        //prop修改和读取dom原生的属性
        $(".check_item").prop("checked",$(this).prop("checked"));
    });
    //如果单个的全部选中，则将上面的全选按钮置为选中
    $(document).on("click",".check_item",function () {
        //jQuery中的属性checked,可以拿到当前已经被修改checked值的标签
        var isAllChecked = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked",isAllChecked);
    });

    //写全部删除按钮的逻辑
    $("#emp_delete_all").click(function () {
        //先要拿到当前被选中的框
        var checkedItems = $(".check_item:checked");
        var ids = "";
        var empNames = "";
        $.each(checkedItems,function (index,item) {
            //组装每一个empName
            empNames += $(item).parents("tr").find("td:eq(2)").text()+",";
            //组装每一个id,约定发送多个id值1-2-3作为我们批量删除的ID值
            ids += $(item).parents("tr").find("td:eq(1)").text()+"-";

        });
        //去掉最后一个没用的标点
        empNames = empNames.substring(0,empNames.length-1);
        ids = ids.substring(0,ids.length-1);
        //发送请求前提醒
        if(confirm("你确定删除【"+ empNames +"】吗？")){
            $.ajax({
                url:"${APP_PATH}/emp/"+ids,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }

    });
</script>
</body>
</html>
