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

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * TODO: class level comment
 */
public class ZonesRegistry {
    private static ZonesRegistry instance = new ZonesRegistry();
    private Map<String, Zone> zones = new HashMap<String, Zone>();

    public static ZonesRegistry getInstance() {
        return instance;
    }

    private ZonesRegistry() {

    }

    public void addZones(List<Zone> zones) {
        for (Zone zone : zones) {
            addZone(zone);
        }
    }

    public void addZone(Zone zone) {
        zones.put(zone.getId(), zone);
    }

    public Map<String, Zone> getZones() {
        return Collections.unmodifiableMap(zones);
    }
}
