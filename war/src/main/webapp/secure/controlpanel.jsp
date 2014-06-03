<%@ page import="com.wso2.raspberrypi.Util" %>
<%--
  Created by IntelliJ IDEA.
  User: azeez
  Date: 1/23/13
  Time: 2:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Raspberry Pi Cluster - Control Panel</title>
</head>
<body>
<h2>Raspberry Pi Cluster - Control Panel</h2>
&nbsp;&nbsp;&nbsp;<a href="index.jsp">Home</a>
<hr/>

<%
    String lbIP = Util.getValue("elb.pi.wso2.com");
    String appserverClusterState = Util.getValue("appserver.cluster.state");
%>
<table>
    <tr>
        <form name="as-cluster-state-frm" action="updatekv.jsp">
            <td>Load Balancer (elb.pi.wso2.com) IP Address:</td>
            <td>
                <input type="hidden" name="key" value="elb.pi.wso2.com"/>
                <input type="text" name="value" value="<%= lbIP%>" size="12"/>
            </td>
            <td><input type="submit" value="Update"/></td>
        </form>
    </tr>
    <tr>
        <form name="as-cluster-state-frm" action="updatekv.jsp">
            <td>App Server Cluster State:</td>
            <td>
                <input type="hidden" name="key" value="appserver.cluster.state"/>
                <select name="value">
                    <%
                        if("on".equalsIgnoreCase(appserverClusterState)){
                    %>
                    <option value="on" selected="true">Powered On</option>
                    <option value="off">Powered Off</option>
                    <%
                        } else {
                    %>
                    <option value="on">Powered On</option>
                    <option value="off" selected="true">Powered Off</option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td><input type="submit" value="Update"/></td>
        </form>
    </tr>
</table>

</body>
</html>