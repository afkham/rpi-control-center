<%@ page import="com.wso2.raspberrypi.Util" %>
<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%
    String mac = request.getParameter("mac");
    String reboot = request.getParameter("reboot");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    raspberryPi.setReboot(Boolean.valueOf(reboot));
    Util.updateRaspberryPi(raspberryPi);

    response.sendRedirect("index.jsp");
%>