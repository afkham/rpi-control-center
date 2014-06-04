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

import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.*;
import org.apache.http.entity.ContentProducer;
import org.apache.http.entity.EntityTemplate;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class HttpClient {

    private CloseableHttpClient client;

    public HttpClient() {
        client =  HttpClientBuilder.create().build();
    }

    public HttpResponse doPost(String url, String token, final String payload, String contentType) throws IOException {
        HttpUriRequest request = new HttpPost(url);
        addSecurityHeaders(request, token);

        HttpEntityEnclosingRequest entityEncReq = (HttpEntityEnclosingRequest) request;
        EntityTemplate ent = new EntityTemplate(new ContentProducer() {
            public void writeTo(OutputStream outputStream) throws IOException {
                outputStream.write(payload.getBytes());
                outputStream.flush();
            }
        });
        ent.setContentType(contentType);
        entityEncReq.setEntity(ent);
        return client.execute(request);
    }

    public HttpResponse doGet(String url, String token) throws IOException {
        HttpUriRequest request = new HttpGet(url);
        addSecurityHeaders(request, token);
        return client.execute(request);
    }

    public String getResponsePayload(HttpResponse response) throws IOException {
        StringBuffer buffer = new StringBuffer();
        InputStream in = null;
        try {
            if (response.getEntity() != null) {
                in = response.getEntity().getContent();
                int length;
                byte[] tmp = new byte[2048];
                while ((length = in.read(tmp)) != -1) {
                    buffer.append(new String(tmp, 0, length));
                }
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } finally {
            if (in != null) {
                in.close();
            }
        }

        return buffer.toString();
    }

    public HttpResponse doPut(String url, String token, final String payload, String contentType) throws IOException {
        HttpUriRequest request = new HttpPut(url);
        addSecurityHeaders(request, token);

        HttpEntityEnclosingRequest entityEncReq = (HttpEntityEnclosingRequest) request;
        EntityTemplate ent = new EntityTemplate(new ContentProducer() {
            public void writeTo(OutputStream outputStream) throws IOException {
                outputStream.write(payload.getBytes());
                outputStream.flush();
            }
        });
        ent.setContentType(contentType);
        entityEncReq.setEntity(ent);
        return client.execute(request);
    }

    public HttpResponse doDelete(String url, String token) throws IOException {
        HttpUriRequest request = new HttpDelete(url);
        addSecurityHeaders(request, token);
        return client.execute(request);
    }

    private void addSecurityHeaders(HttpRequest request, String token) {
        if (token != null) {
            request.setHeader(HttpHeaders.AUTHORIZATION, token);
        }
    }
}
