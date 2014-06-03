<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="com.wso2.raspberrypi.Util" %>
<%@ page import="org.apache.http.client.HttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%
    String mac = request.getParameter("mac");
    String zoneID = request.getParameter("zoneID");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    raspberryPi.setZoneID(zoneID);
    Util.updateRaspberryPi(raspberryPi);

    //TODO: call URL to register device
    HttpClient client = HttpClientBuilder.create().build();
    HttpGet get = new HttpGet(controlCenterUrl);
    client.execute(get);
    System.out.println("Updated zone of Raspberry Pi: " + mac + " to " + zoneID);
%>