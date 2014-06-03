/*
 *  Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 *
 */
package com.wso2.raspberrypi;

import com.wso2.raspberrypi.apicalls.APICall;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * TODO: class level comment
 */
public class MainServlet extends HttpServlet {
    @Override
    public void init(ServletConfig config) throws ServletException {
//        Properties zones = new Properties();
//            zones.load(new FileInputStream(System.getProperty("carbon.home") + File.separator + "repository" +
//                    File.separator + "conf" + File.separator + "zones.properties"));
        List<Zone> zones = APICall.listZones();
        ZonesRegistry zonesRegistry = ZonesRegistry.getInstance();
        zonesRegistry.addZones(zones);
    }
}
