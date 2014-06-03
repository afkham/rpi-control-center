<%@ page import="com.wso2.raspberrypi.Util" %>
<%
    String mac = request.getParameter("mac");
    Util.releasePi(mac);
    response.sendRedirect("index.jsp");
%>