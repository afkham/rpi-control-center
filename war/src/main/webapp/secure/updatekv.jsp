<%@ page import="com.wso2.raspberrypi.Util" %><%
    String key = request.getParameter("key");
    String value = request.getParameter("value");

    Util.updateKeyValuePair(key, value);
    response.sendRedirect("controlpanel.jsp");
%>