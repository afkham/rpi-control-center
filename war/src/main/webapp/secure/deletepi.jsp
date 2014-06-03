<%@ page import="com.wso2.raspberrypi.Util" %>
<%
    String mac = request.getParameter("mac");
    Util.deleteRaspberryPi(mac);

    response.sendRedirect("index.jsp");
%>