<%@page import="com.wso2.raspberrypi.RaspberryPi" %>
<%@page import="com.wso2.raspberrypi.Util" %>
<%@ page import="com.wso2.raspberrypi.Zone" %>
<%@ page import="com.wso2.raspberrypi.ZonesRegistry" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
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
        session.setAttribute("autorefresh", "true");
    } else if("off".equalsIgnoreCase(refresh)){
        autoRefresh = false;
        session.setAttribute("autorefresh", "false");
    } else {
        autoRefresh = Boolean.valueOf((String) session.getAttribute("autorefresh"));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="css/local.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">


    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
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
    <META HTTP-EQUIV="Refresh" CONTENT="30; URL=index.jsp?refresh=on">
    <%
        }
    %>
    <script type="text/javascript">
        function reservePi(owner, mac) {
            location.href = 'reservepi.jsp?owner=' + owner + "&mac=" + mac;
        }
    </script>
</head>
<body class="back-bg">

<!-- NAVBAR
================================================== -->
<div class="navbar-wrapper">
    <!-- Wrap the .navbar in .container to center it within the absolutely positioned parent. -->
    <div class="container">

        <div class="navbar navbar-inverse">
            <div class="navbar-inner">
                <!-- Responsive Navbar Part 1: Button for triggering responsive navbar (not covered in tutorial). Include responsive CSS to utilize. -->
                <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <a class="brand" href="#"></a>
                <!-- Responsive Navbar Part 2: Place all navbar contents you want collapsed withing .navbar-collapse.collapse. -->
                <div class="nav-collapse collapse pull-right">
                    <ul class="nav">
                        <li class="active"><a href="index.jsp">Home</a></li>
                        <li><a href="controlpanel.jsp">Cluster Operations</a></li>

                    </ul>
                </div><!--/.nav-collapse -->
            </div><!-- /.navbar-inner -->
        </div><!-- /.navbar -->

    </div> <!-- /.container -->
</div><!-- /.navbar-wrapper -->


<div class="container-fluid content-section">
<div class="row-fluid">
<div class="span12">
<div class="heading-back">
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span8"><h1>Raspberry Pi Control Center</h1></div>
            <div class="span3">
                <%
                    if (autoRefresh) {
                %>
                <a class="pull-right auto-refresh" href="index.jsp?refresh=off">
                    Auto Refresh (on)
                    <i class="icon-refresh-on"></i>
                </a>
                <%
                } else {
                %>
                <a class="pull-right auto-refresh" href="index.jsp?refresh=on">
                    Auto Refresh (off)
                    <i class="icon-refresh-off"></i>
                </a>
                <%
                    }
                %>


            </div>
        </div>
    </div>


</div>
<div class="white-back">
<div id="message_area" style="background: yellow"></div>
<br/>
<br/>

<table class="table table-striped table-bordered" id="pi-table">
<thead>
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
        <% if (!orderby.equals("zone")) {%>
        <a href="index.jsp?orderby=zone">Zone</a>
        <% } else { %>
        [<a href="index.jsp?orderby=zone">Zone</a>]
        <% } %>
    </th>
    <%--<th>
        <% if (!orderby.equals("rack")) {%>
        <a href="index.jsp?orderby=rack">Rack</a>
        <% } else { %>
        [<a href="index.jsp?orderby=rack">Rack</a>]
        <% } %>
    </th>
    <th>
        <% if (!orderby.equals("pi")) {%>
        <a href="index.jsp?orderby=pi">Pi</a>
        <% } else { %>
        [<a href="index.jsp?orderby=pi">Pi</a>]
        <% } %>
    </th>
    <th>
        <% if (!orderby.equals("label")) {%>
        <a href="index.jsp?orderby=label">Label</a>
        <% } else { %>
        [<a href="index.jsp?orderby=label">Label</a>]
        <% } %>
    </th>--%>
    <th>CK</th>
    <th>CS</th>
    <th>User Reg. URL</th>
    <th>
        <% if (!orderby.equals("load_avg")) {%>
        <a href="index.jsp?orderby=load_avg">Load Avg.</a>
        <% } else { %>
        [<a href="index.jsp?orderby=load_avg">Load Avg.</a>]
        <% } %>
    </th>
    <th>
        <% if (!orderby.equals("free_mem")) {%>
        <a href="index.jsp?orderby=free_mem">Free Memory</a>
        <% } else { %>
        [<a href="index.jsp?orderby=free_mem">Free Memory</a>]
        <% } %>
    </th>
    <%--<th>
        <% if (!orderby.equals("owner")) {%>
        <a href="index.jsp?orderby=owner">Owner</a>
        <% } else { %>
        [<a href="index.jsp?orderby=owner">Owner</a>]
        <% } %>
    </th>--%>
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
</thead>
<tbody>
<%
    List<RaspberryPi> raspberryPis = Util.getRaspberryPis(orderby);
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss zzz");
    int i = 0;
    ZonesRegistry zonesRegistry = ZonesRegistry.getInstance();
    Map<String, Zone> zones = zonesRegistry.getZones();
    for (RaspberryPi pi : raspberryPis) {
        String mac = pi.getMacAddress();
        String ip = pi.getIpAddress();
        String rack = pi.getRack();
        String piId = pi.getId();
        String label = pi.getLabel();
        String ck = pi.getConsumerKey();
        String cs = pi.getConsumerSecret();
        String userCheckinURL = pi.getUserCheckinURL();
        String zoneId = pi.getZoneID() != null ? pi.getZoneID() : "";
        boolean selected = pi.isSelected();
        long lastUpdated = pi.getLastUpdated();
        i++;
        String clazz;
        if (System.currentTimeMillis() - lastUpdated > 3 * 60 * 1000) {
            clazz = "inactive";
        } else if (selected) {
            clazz = "sel";
        } else {
            clazz = (i % 2 == 0) ? "d0" : "d1";
        }
%>
<tr class="<%= clazz%>" id="<%= mac%>.row">
    <td><%= i%></td>
    <td><%= ip %></td>
    <td><%= mac %></td>
    <td>
        <select id="<%= ip%>.zoneID" onchange="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&zoneID=' + document.getElementById('<%= ip%>.zoneID').value,
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
        <input type="text" size="20" id="<%= ip%>.ck" value="<%= ck%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&ck=' + document.getElementById('<%= ip%>.ck').value,
                   'Updated Consumer Key of Raspberry Pi <%= mac%>')">Apply</a>
    </td>
    <td>
        <input type="text" size="20" id="<%= ip%>.cs" value="<%= cs%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&cs=' + document.getElementById('<%= ip%>.cs').value,
                   'Updated Consumer Secret of Raspberry Pi <%= mac%>')">Apply</a>
    </td>
    <td>
        <input type="text" size="20" id="<%= ip%>.userCheckinURL" value="<%= userCheckinURL%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&userReg=' + document.getElementById('<%= ip%>.userCheckinURL').value,
                   'Updated user checkin URL  of Raspberry Pi <%= mac%>')">Apply</a>
    </td>
    <%--<td>
        <input type="text" size="5" id="<%= ip%>.rack" value="<%= rack%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&rack=' + document.getElementById('<%= ip%>.rack').value,
                   'Updated rack ID of Raspberry Pi <%= mac%>')">Apply</a>
    </td>
    <td>
        <input type="text" size="5" id="<%= ip%>.piId" value="<%= piId%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&pi=' + document.getElementById('<%= ip%>.piId').value,
                   'Updated ID of Raspberry Pi <%= mac%>')">Apply</a>
    </td>
    <td>
        <input type="text" size="20" id="<%= ip%>.label" value="<%= label%>"/>
        <a href="#"
           onclick="xmlhttpGet('updatepi.jsp?mac=<%= mac%>&label=' + document.getElementById('<%= ip%>.label').value,
                   'Updated label of Raspberry Pi <%= mac%>')">Apply</a>
    </td>--%>
    <td>...</td>
    <td>...</td>
    <%--<td>
        <%
            if (pi.getReservedFor() == null || pi.getReservedFor().isEmpty()) {
        %>
        <input type="text" size="10" name="reservedFor" id="mac<%= mac%>"/>
        <a href="#"
           onclick="reservePi(document.getElementById('mac<%= mac%>').value, '<%= mac%>')">Reserve</a>
        <%
        } else {
        %>
        <input type="text" size="10" name="reservedFor" id="mac<%= mac%>"
               value="<%= pi.getReservedFor()%>" disabled="true"/>
        <a href="releasepi.jsp?mac=<%= mac%>">Release</a>
        <%
            }
        %>
    </td>--%>
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
    <td id="<%= mac%>.swUpdate">
        <%
            if (pi.isSoftwareUpdateRequired()) {
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
        <a href="#" onclick="deletePi('<%= mac%>')"><i class="fa fa-trash-o"></i></a>
        &nbsp;
        <%
            if (selected) {
        %>
        <a href="selectpi?mac=<%= mac%>&selected=false"><i class="fa fa-space-shuttle"></i></a>
        <%
            }
        %>
    </td>
</tr>
<%
    }
%>
</tbody>
</table>
</div>

</div>
</div>
</div>



<div class="container-fluid marketing">
    <!-- FOOTER -->
    <footer>
        <p class="pull-right"><a href="#">Back to top</a></p>
        <p>&copy; 2014 WSO2</p>
    </footer>

</div><!-- /.container -->



</body>
</html>

