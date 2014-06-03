<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="com.wso2.raspberrypi.Util" %>
<%
    String mac = request.getParameter("mac");
    String label = request.getParameter("label");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    raspberryPi.setLabel(label);
    Util.updateRaspberryPi(raspberryPi);
%>