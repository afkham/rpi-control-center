<%@page import="com.wso2.raspberrypi.Util" %>

<%
    String myip = request.getParameter("myip");
    String mymac = request.getParameter("mymac");
    if (mymac != null && myip != null) {
        Util.registerRaspberryPi(mymac, myip);
        System.out.println("Successfully added/updated Mac & IP address: " + mymac + "/" + myip);
%>
Successfully added/updated MAC & IP address: <%=mymac %>/<%= myip %>
<%
    }
%>
