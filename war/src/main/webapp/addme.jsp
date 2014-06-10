<%@page import="com.wso2.raspberrypi.Util" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@ page import="java.io.PrintWriter" %>

<%
    String myip = request.getParameter("myip");
    String mymac = request.getParameter("mymac");
    if (mymac != null && myip != null) {
        Util.registerRaspberryPi(mymac, myip);
        RaspberryPi raspberryPi = Util.getRaspberryPi(mymac);
        System.out.println("Successfully added/updated Mac & IP address: " + mymac + "/" + myip);
        response.setContentType("application/json");
        JSONObject json = new JSONObject();
        json.put("mac", raspberryPi.getMacAddress());
        json.put("ip", raspberryPi.getIpAddress());
        json.put("reboot", raspberryPi.isReboot());
        json.put("ck", raspberryPi.getConsumerKey());
        json.put("cs", raspberryPi.getConsumerSecret());
        json.put("cs", raspberryPi.getConsumerSecret());
        json.put("zoneID", raspberryPi.getZoneID());
        json.put("mode", raspberryPi.getMode().name());
        json.put("blink", raspberryPi.isBlink());
        json.put("swUpdateReqd", raspberryPi.isSoftwareUpdateRequired());
        json.put("userCheckinURL", raspberryPi.getUserCheckinURL());
        PrintWriter writer = response.getWriter();
        writer.append(json.toJSONString());
        writer.flush();
        writer.close();

%>
Successfully added/updated MAC & IP address: <%=mymac %>/<%= myip %>
<%
    }
%>
