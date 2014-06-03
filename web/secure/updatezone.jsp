<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="com.wso2.raspberrypi.Util" %>
<%
    String mac = request.getParameter("mac");
    String zoneID = request.getParameter("zoneID");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    raspberryPi.setZoneID(zoneID);
    Util.updateRaspberryPi(raspberryPi);
    System.out.println("Updated zone of Raspberry Pi: " + mac + " to " + zoneID);
%>