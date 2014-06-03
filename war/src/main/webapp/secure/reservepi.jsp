<%@ page import="com.wso2.raspberrypi.Util" %>

<%
    String owner = request.getParameter("owner");
    String mac = request.getParameter("mac");
    Util.reservePi(owner, mac);
    response.sendRedirect("index.jsp");
%>