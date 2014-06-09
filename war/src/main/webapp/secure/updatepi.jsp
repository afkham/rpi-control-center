<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="com.wso2.raspberrypi.Util" %>
<%@ page import="com.wso2.raspberrypi.apicalls.APICall" %>
<%
    String mac = request.getParameter("mac");
    String zoneID = request.getParameter("zoneID");
    String ck = request.getParameter("ck");
    String cs = request.getParameter("cs");
    String userCheckinURL = request.getParameter("userCheckinURL");
    String label = request.getParameter("label");
    RaspberryPi raspberryPi = Util.getRaspberryPi(mac);
    if (zoneID != null) {
        raspberryPi.setZoneID(zoneID);
        // call API to register device
        APICall.registerDevice(mac, zoneID);
    }
    if(ck != null){
        raspberryPi.setConsumerKey(ck);
    }
    if(cs != null){
        raspberryPi.setConsumerSecret(cs);
    }
    if(label != null){
        raspberryPi.setZoneID(zoneID);
    }
    if(userCheckinURL != null){
        raspberryPi.setUserCheckinURL(userCheckinURL);
    }
    Util.updateRaspberryPi(raspberryPi);
    System.out.println("Updated Raspberry Pi: " + mac);
%>