<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="com.wso2.raspberrypi.Util" %>
<%@ page import="com.wso2.raspberrypi.apicalls.APICall" %>
<%
    String mac = request.getParameter("mac");
    String zoneID = request.getParameter("zoneID");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    raspberryPi.setZoneID(zoneID);
    Util.updateRaspberryPi(raspberryPi);

    // call API to register device
    APICall.registerDevice(mac, zoneID);
    System.out.println("Updated zone of Raspberry Pi: " + mac + " to " + zoneID);
%>