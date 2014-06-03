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
package com.wso2.raspberrypi.apicalls;

import com.wso2.raspberrypi.Zone;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import sun.misc.BASE64Encoder;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * TODO: class level comment
 */
public class APICall {
    private static final Log log = LogFactory.getLog(APICall.class);

    private static String consumerKey = "WgFO8ftXdewCSMAdMtf1Vl9uOAAa";
    private static String consumerSecret = "yXdCdk4nXCv3kHVf1_u3fA74jRYa";
    private static String tokenEndpoint = "http://gateway.apicloud.cloudpreview.wso2.com:8280/token";

    public static void registerDevice(String deviceID, String zoneID){
        String url = "http://gateway.apicloud.cloudpreview.wso2.com:8280/t/indikas.com/wso2coniot/1.0.0/conferences/2/iot/scannerZones/byScannerUUID";
        Token token = getToken();
        if (token != null) {
            HttpClient httpClient = new HttpClient();
            JSONObject json = new JSONObject();
            json.put("rfidScannerUUID", deviceID);
            json.put("zoneId", zoneID);
            try {
                HttpResponse httpResponse =
                        httpClient.doPost(url, "Bearer " + token.getAccessToken(), json.toJSONString(), "application/json");
                int statusCode = httpResponse.getStatusLine().getStatusCode();
                if(statusCode != 200){
                    log.error("Device to Zone registration failed. HTTP Status Code:" + statusCode);
                }
            } catch (IOException e) {
                log.error("", e);
            }
        }
    }

    public static List<Zone> listZones() {
        List<Zone> zones = new ArrayList<Zone>();
        Token token = getToken();
        if (token != null) {
            HttpClient httpClient = new HttpClient();
            try {
                HttpResponse httpResponse =
                        httpClient.doGet("http://gateway.apicloud.cloudpreview.wso2.com:8280/t/indikas.com/wso2coniot/1.0.0/conferences/2/iot/zones",
                                "Bearer " + token.getAccessToken());
                int statusCode = httpResponse.getStatusLine().getStatusCode();
                if(statusCode == 200){
                    JSONParser parser = new JSONParser();
                    JSONArray jsonArray = (JSONArray) parser.parse(httpClient.getResponsePayload(httpResponse));
                    for (int i = 0; i < jsonArray.size(); i++) {
                        JSONObject obj = (JSONObject) jsonArray.get(i);
                        zones.add(new Zone((String) obj.get("id"), (String) obj.get("name")));
                    }
                } else {
                    log.error("Could not get Zones. HTTP Status code: " + statusCode);
                }
            } catch (IOException e) {
                log.error("", e);
            } catch (ParseException e) {
                log.error("", e);
            }
        }

        return zones;
    }


    public static Token getToken() {
        HttpClient httpClient = new HttpClient();
//        String consumerKey = PizzaShackWebConfiguration.getInstance().getConsumerKey();
//        String consumerSecret = PizzaShackWebConfiguration.getInstance().getConsumerSecret();
        try {
            String applicationToken = consumerKey + ":" + consumerSecret;
            BASE64Encoder base64Encoder = new BASE64Encoder();
            applicationToken = "Basic " + base64Encoder.encode(applicationToken.getBytes()).trim();

//            String payload = "grant_type=password&username="+username+"&password="+password;
            String payload = "grant_type=client_credentials";
            HttpResponse httpResponse = httpClient.doPost(tokenEndpoint, applicationToken,
                    payload, "application/x-www-form-urlencoded");
            if (httpResponse.getStatusLine().getStatusCode() != 200) {
                return null;
            }
            String response = httpClient.getResponsePayload(httpResponse);
            return getAccessToken(response);
        } catch (IOException e) {
            log.error("", e);
            return null;
        }
    }

    /**
     * Populates Token object using folloing JSON String
     * {
     * "token_type": "bearer",
     * "expires_in": 3600000,
     * "refresh_token": "f43de118a489d56c3b3b7ba77a1549e",
     * "access_token": "269becaec9b8b292906b3f9e69b5a9"
     * }
     *
     * @param accessTokenJson
     * @return
     */
    public static Token getAccessToken(String accessTokenJson) {
        JSONParser parser = new JSONParser();
        Token token = new Token();
        try {
            Object obj = parser.parse(accessTokenJson);
            JSONObject jsonObject = (JSONObject) obj;
            token.setAccessToken((String) jsonObject.get("access_token"));
            long expiresIn = ((Long) jsonObject.get("expires_in")).intValue();
            token.setExpiresIn(expiresIn);
            token.setRefreshToken((String) jsonObject.get("refresh_token"));
            token.setTokenType((String) jsonObject.get("token_type"));

        } catch (ParseException e) {
            log.error("", e);
        }
        return token;

    }

    public static void main(String[] args) {
        listZones();
    }
}
