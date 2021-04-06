package com.atguigu.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @author xinhaojie
 * @create 2021-04-06-16:15
 */
public class Message {
    //状态码100 成功  200 失败
    private int code;

    //提示信息
    private String msg;

    //用户要返回给浏览器的数据
    private Map<String, Object> extend = new HashMap<>();

    //自定义方法实现成功失败对象的返回
    public static Message success(){
        Message message = new Message();
        message.setCode(100);
        message.setMsg("操作成功");
        return message;
    }

    public static Message failure(){
        Message message = new Message();
        message.setCode(200);
        message.setMsg("操作失败");
        return message;
    }
    //还有就是链式添加数据,第一个参数就是key,第二个就是添加的数据对象
    public Message add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }

    public String toString() {
        return "Message{" +
                "code=" + code +
                ", msg='" + msg + '\'' +
                ", extend=" + extend +
                '}';
    }

    public void setCode(int code) {
        this.code = code;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    public int getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }
}
