/*
*  Copyright (c) 2005-2011, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
*/
package com.wso2.raspberrypi;

/**
 * TODO: class description
 */
public class RaspberryPi {

    private String macAddress;
    private String ipAddress;
    private Long lastUpdated;
    private String reservedFor;
    private String label;
    private String consumerKey;
    private String consumerSecret;
    private boolean blink;
    private boolean reboot;
    private boolean selected;
    private String zoneID;
    private String rack;
    private String id;
    private String userCheckinURL;
    private boolean softwareUpdateRequired;

    public RaspberryPi() {
    }

    public RaspberryPi(String macAddress, String ipAddress, Long lastUpdated) {
        this.macAddress = macAddress;
        this.ipAddress = ipAddress;
        this.lastUpdated = lastUpdated;
    }

    public String getRack() {
        return rack;
    }

    public void setRack(String rack) {
        this.rack = rack;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMacAddress() {
        return macAddress;
    }

    public void setMacAddress(String macAddress) {
        this.macAddress = macAddress;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Long getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Long lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getConsumerKey() {
        return consumerKey;
    }

    public void setConsumerKey(String consumerKey) {
        this.consumerKey = consumerKey;
    }

    public String getConsumerSecret() {
        return consumerSecret;
    }

    public void setConsumerSecret(String consumerSecret) {
        this.consumerSecret = consumerSecret;
    }

    public String getReservedFor() {
        return reservedFor;
    }

    public void setReservedFor(String reservedFor) {
        this.reservedFor = reservedFor;
    }

    public boolean isBlink() {
        return blink;
    }

    public void setBlink(boolean blink) {
        this.blink = blink;
    }

    public boolean isReboot() {
        return reboot;
    }

    public void setReboot(boolean reboot) {
        this.reboot = reboot;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public String getZoneID() {
        return zoneID;
    }

    public void setZoneID(String zoneID) {
        this.zoneID = zoneID;
    }

    public String getUserCheckinURL() {
        return userCheckinURL;
    }

    public void setUserCheckinURL(String userCheckinURL) {
        this.userCheckinURL = userCheckinURL;
    }

    public boolean isSoftwareUpdateRequired() {
        return softwareUpdateRequired;
    }

    public void setSoftwareUpdateRequired(boolean softwareUpdateRequired) {
        this.softwareUpdateRequired = softwareUpdateRequired;
    }
}
