<%@page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@page import="com.wso2.raspberrypi.ZonesRegistry" %>
<%@page import="com.wso2.raspberrypi.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wso2.raspberrypi.Zone" %>
<%@ page import="java.util.Map" %>


<%
    String refresh = request.getParameter("refresh");
    String orderby = request.getParameter("orderby");
    if (orderby == null) {
        String orderByAttrib = (String) session.getAttribute("orderby");
        if (orderByAttrib != null) {
            orderby = orderByAttrib;
        } else {
            orderby = "ip";
        }
    }
    session.setAttribute("orderby", orderby);
    boolean autoRefresh = false;
    if ("on".equalsIgnoreCase(refresh)) {
        autoRefresh = true;
    }
%>
<html>
<head>
    <style type="text/css">
        tr.d0 td {
            background-color: rgba(176, 168, 174, 0.30);
            color: black;
        }

        tr.d1 td {
            background-color: #fffdfe;
            color: black;
        }

        tr.sel td {
            background-color: #4bff1c;
            color: black;
        }

        tr.inactive td {
            background-color: red;
            color: black;
        }

    </style>
    <script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript">

        var rowsHighlighted = false;

        function checkSelected() {
            $.ajax({
                       type: "GET",
                       url: "selectedpis",
                       success: function (resp) {
                           var data = resp.pis;
                           if (data.length != 0 || rowsHighlighted) {
                               var table = document.getElementById("pi-table");
                               for (var j = 0, row; row = table.rows[j]; j++) {
                                   if(row.className == "inactive") continue;
                                   if (j % 2 == 0) {
                                       row.className = "d0";
                                   } else {
                                       row.className = "d1";
                                   }
                                   rowsHighlighted = false;
                               }
                               for (var i = 0; i < data.length; i++) {
                                   document.getElementById(data[i].mac + ".row").className = "sel";
                                   rowsHighlighted = true;
                               }
                           }
                       },
                       error: function (json) {
                           // To handle errors like bad connection, timeout, invalid url

                       },
                       complete: function (json) {
                           //This function is invoked after success or error functions.
                       }
                   });
            setTimeout("checkSelected()", 10000);
        }


        setTimeout("checkSelected()", 10000);

        function deletePi(mac) {
            if (confirm('Do you want to delete Raspberry Pi with Mac Address ' + mac + '?')) {
                location.href = 'deletepi.jsp?mac=' + mac;
            }
        }

        function toggleBlink(mac, onOff) {
            var element = document.getElementById(mac + '.blink');
            if (onOff == 'on') {
                element.innerHTML =
                '<a href="#" onclick=\"xmlhttpGet(\'blink.jsp?mac=' + mac + '&blink=true\', \'Blinking turned on for Raspberry Pi ' + mac + '\');toggleBlink(\'' + mac + '\',\'off\')\"> <font color=\"red\">Off</font> </a>';
            } else {
                element.innerHTML =
                '<a href="#" onclick=\"xmlhttpGet(\'blink.jsp?mac=' + mac + '&blink=false\', \'Blinking turned off for Raspberry Pi ' + mac + '\');toggleBlink(\'' + mac + '\',\'on\')\"> <font color=\"green\">On</font> </a>';
            }
        }

        function toggleReboot(mac, reboot) {
            var element = document.getElementById(mac + '.reboot');
            if (reboot) {
                element.innerHTML =
                '<a href=\"#\" onclick=\"xmlhttpGet(\'reboot.jsp?mac=' + mac + '&reboot=true\', \'Rebooting cancelled for Raspberry Pi ' + mac + '\');toggleReboot(\'' + mac + '\', false)\"><font color=\"orange\">Rebooting</font></a>';
            } else {
                element.innerHTML =
                '<a href=\"#\" onclick=\"xmlhttpGet(\'reboot.jsp?mac=' + mac + '&reboot=true\', \'Rebooting Raspberry Pi ' + mac + '\');toggleReboot(\'' + mac + '\', true)\"><font color=\"green\">Running</font></a>';
            }
        }

        function xmlhttpGet(strURL, msg) {
            var xmlHttpReq = false;
            var self = this;
            // Mozilla/Safari
            if (window.XMLHttpRequest) {
                self.xmlHttpReq = new XMLHttpRequest();
            }
            // IE
            else if (window.ActiveXObject) {
                self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
            }
            self.xmlHttpReq.open('GET', strURL, true);
            self.xmlHttpReq.onreadystatechange = function () {
                if (self.xmlHttpReq.readyState == 4) {
                    document.getElementById('message_area').innerHTML = msg;
                } else {
//                    document.getElementById('message_area').innerHTML = 'Operation failed';
                }
            }
            self.xmlHttpReq.send(null);
        }
    </script>

    <title>Raspberry Pi Control Center</title>
    <%
        if (autoRefresh) {
    %>
    <META HTTP-EQUIV="Refresh" CONTENT="30; URL=index.jsp">
    <%
        }
    %>
    <script type="text/javascript">
        function reservePi(owner, mac) {
            location.href = 'reservepi.jsp?owner=' + owner + "&mac=" + mac;
        }
    </script>
</head>
<body>
<h2>Raspberry Pi Control Center</h2>
<hr/>
<p>
    <a href="controlpanel.jsp">Cluster Operations</a>
    &nbsp;&nbsp;|&nbsp;&nbsp;
    Auto Refresh:
    <%
        if (autoRefresh) {
    %>
    <a href="index.jsp?refresh=off">on</a>
    <%
    } else {
    %>
    <a href="index.jsp?refresh=on">off</a>
    <%
        }
    %>
</p>

<p>

<div id="message_area" style="background: yellow"></div>
</p>
<table border="1" style="border-collapse: separate; border-spacing: 5px;" id="pi-table">
    <tr style="background: rgba(131,118,113,0.71); color: black;">
        <th>#</th>
        <th>
            <% if (!orderby.equals("ip")) {%>
            <a href="index.jsp?orderby=ip">IP Address</a>
            <% } else { %>
            [<a href="index.jsp?orderby=ip">IP Address</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("mac")) {%>
            <a href="index.jsp?orderby=mac">MAC Address</a>
            <% } else { %>
            [<a href="index.jsp?orderby=mac">MAC Address</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("zoneName")) {%>
        <a href="index.jsp?orderby=zoneName">Zone</a>
            <% } else { %>
        [<a href="index.jsp?orderby=zoneName">Zone</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("label")) {%>
            <a href="index.jsp?orderby=label">Label</a>
            <% } else { %>
            [<a href="index.jsp?orderby=label">Label</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("owner")) {%>
            <a href="index.jsp?orderby=owner">Owner</a>
            <% } else { %>
            [<a href="index.jsp?orderby=owner">Owner</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("last_updated")) {%>
            <a href="index.jsp?orderby=last_updated">Last Updated</a>
            <% } else { %>
            [<a href="index.jsp?orderby=last_updated">Last Updated</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("blink")) {%>
            <a href="index.jsp?orderby=blink">Blink</a>
            <% } else { %>
            [<a href="index.jsp?orderby=blink">Blink</a>]
            <% } %>
        </th>
        <th>
            <% if (!orderby.equals("reboot")) {%>
            <a href="index.jsp?orderby=reboot">Reboot</a>
            <% } else { %>
            [<a href="index.jsp?orderby=reboot">Reboot</a>]
            <% } %>
        </th>
        <th>&nbsp;</th>
    </tr>
    <%
        List<RaspberryPi> raspberryPis = Util.getRaspberryPis(orderby);
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss zzz");
        int i = 0;
        ZonesRegistry zonesRegistry = ZonesRegistry.getInstance();
        Map<String, Zone> zones = zonesRegistry.getZones();
        for (RaspberryPi pi : raspberryPis) {
            String mac = pi.getMacAddress();
            String ip = pi.getIpAddress();
            String label = pi.getLabel();
            String zoneId = pi.getZoneID() != null ? pi.getZoneID() : "";
            boolean selected = pi.isSelected();
            long lastUpdated = pi.getLastUpdated();
            i++;
            String clazz = null;
            if (System.currentTimeMillis() - lastUpdated > 3 * 60 * 1000) {
                clazz = "inactive";
            } else if (selected) {
                clazz = "sel";
            } else {
                clazz = (i % 2 == 0) ? "d0" : "d1";
            }
    %>
    <tr class="<%= clazz%>" id="<%= mac%>.row">
        <td><%= i%>
        </td>
        <td><%= ip %>
        </td>
        <td><%= mac %>
        <td>
            <select id="<%= ip%>.zoneID" onchange="xmlhttpGet('updatezone.jsp?mac=<%= mac%>&zoneID=' + document.getElementById('<%= ip%>.zoneID').value,
                    'Updated Zone of Raspberry Pi <%= mac%>')">

                <%  if(zoneId.isEmpty()){
                %>
                    <option value="UNASSIGNED" selected="true">-- UNASSIGNED -- </option>
                <% } else { %>
                    <option value="UNASSIGNED">-- UNASSIGNED -- </option>
                <%
                }
                    for (Map.Entry<String, Zone> entry : zones.entrySet()) {
                    if (zoneId.equals(entry.getKey())) {
                %>
                <option value="<%= entry.getKey()%>" selected="true"><%= entry.getValue().getName()%>
                </option>
                <% } else { %>
                <option value="<%= entry.getKey()%>"><%= entry.getValue().getName()%>
                </option>
                <%
                        }
                    }
                %>
            </select>
        </td>
        <td>
            <input type="text" size="20" id="<%= ip%>.label" value="<%= label%>"/>
            <a href="#"
               onclick="xmlhttpGet('updatelabel.jsp?mac=<%= mac%>&label=' + document.getElementById('<%= ip%>.label').value,
                       'Updated label of Raspberry Pi <%= mac%>')">Apply</a>
        </td>
        <td>
            <%
                if (pi.getReservedFor() == null || pi.getReservedFor().isEmpty()) {
            %>
            <input type="text" size="20" name="reservedFor" id="mac<%= mac%>"/>
            <a href="#"
               onclick="reservePi(document.getElementById('mac<%= mac%>').value, '<%= mac%>')">Reserve</a>
            <%
            } else {
            %>
            <input type="text" size="20" name="reservedFor" id="mac<%= mac%>"
                   value="<%= pi.getReservedFor()%>" disabled="true"/>
            <a href="releasepi.jsp?mac=<%= mac%>">Release</a>
            <%
                }
            %>
        </td>
        <td>
            <%= sdf.format(new Date(lastUpdated))%>
        </td>
        <td id="<%= mac%>.blink">
            <%
                if (pi.isBlink()) {
            %>
            <a href="#"
               onclick="xmlhttpGet('blink.jsp?mac=<%= mac%>&blink=false',
                       'Blinking turned off for Raspberry Pi <%= mac%>');
                       toggleBlink('<%= mac%>','on')">
                <font color="green">On</font>
            </a>
            <%
            } else {
            %>
            <a href="#"
               onclick="xmlhttpGet('blink.jsp?mac=<%= mac%>&blink=true',
                       'Blinking turned on for Raspberry Pi <%= mac%>');
                       toggleBlink('<%= mac%>','off')">
                <font color="red">Off</font>
            </a>
            <%
                }
            %>
        </td>
        <td id="<%= mac%>.reboot">
            <%
                if (pi.isReboot()) {
            %>
            <a href="#"
               onclick="xmlhttpGet('reboot.jsp?mac=<%= mac%>&reboot=false',
                       'Rebooting cancelled for Raspberry Pi <%= mac%>');
                       toggleReboot('<%= mac%>', false)">
                <font color="orange">Rebooting</font>
            </a>
            <%
            } else {
            %>
            <a href="#"
               onclick="xmlhttpGet('reboot.jsp?mac=<%= mac%>&reboot=true',
                       'Rebooting Raspberry Pi <%= mac%>');
                       toggleReboot('<%= mac%>', true)">
                <font color="green">Running</font>
            </a>
            <%
                }
            %>
        </td>
        <td>
            <a href="#" onclick="deletePi('<%= mac%>')"><img src="../images/delete.png" alt="Delete"
                                                             width="16px" height="16px"/></a>
            &nbsp;
            <%
                if (selected) {
            %>
            <a href="selectpi?mac=<%= mac%>&selected=false"><img src="../images/clear.png"
                                                                 alt="Deselect" width="16px"
                                                                 height="16px"/></a>
            <%
                }
            %>
        </td>
    </tr>
    <%
        }
    %>
</table>
</body>
</html>

