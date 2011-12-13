/**************************************************************************
 *  Copyright (C) 2010 Atlas of Living Australia
 *  All Rights Reserved.
 *
 *  The contents of this file are subject to the Mozilla Public
 *  License Version 1.1 (the "License"); you may not use this file
 *  except in compliance with the License. You may obtain a copy of
 *  the License at http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing
 *  rights and limitations under the License.
 ***************************************************************************/

package org.ala.spatial.services.dto;

import java.sql.Timestamp;
import org.codehaus.jackson.map.annotate.JsonSerialize;

/**
 *
 * @author ajay
 */

@JsonSerialize(include=JsonSerialize.Inclusion.NON_DEFAULT)
public class Action {
    private long id;
    private Timestamp time;
    private String appid;
    private String email;
    private long serviceid;
    private String type;
    private String userip;
    private String sessionid;
    private String category1;
    private String category2;

    private Service service;

    public String getAppid() {
        return appid;
    }

    public void setAppid(String appid) {
        this.appid = appid;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getServiceid() {
        return serviceid;
    }

    public void setServiceid(long serviceid) {
        this.serviceid = serviceid;
    }

    public Timestamp getTime() {
        return time;
    }

    public void setTime(Timestamp time) {
        this.time = time;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUserip() {
        return userip;
    }

    public void setUserip(String userip) {
        this.userip = userip;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public String getSessionid() {
        return sessionid;
    }

    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
    }

    public String getCategory1() {
        return category1;
    }

    public void setCategory1(String category1) {
        this.category1 = category1;
    }

    public String getCategory2() {
        return category2;
    }

    public void setCategory2(String category2) {
        this.category2 = category2;
    }

    @Override
    public String toString() {
        //return "Action{" + "id=" + id + "time=" + time + "appid=" + appid + "email=" + email + "serviceid=" + serviceid + "type=" + type + "userip=" + userip + "sessionid=" + sessionid + "category1=" + category1 + "category2=" + category2 + "service=" + service + '}';
        StringBuffer sb = new StringBuffer();
        sb
                .append(id).append(",")
                .append(time).append(",")
                .append("\"").append(appid).append("\",")
                .append("\"").append(email).append("\",")
                .append("\"").append(userip).append("\",")
                .append("\"").append(sessionid).append("\",")
                .append("\"").append(type).append("\",")
                .append("\"").append(category1).append("\",")
                .append("\"").append(category2).append("\",")
                .append("\"").append(service.getName()).append("\",")
                .append("\"").append((service.getSpecieslsid()==null)?"":service.getSpecieslsid()).append("\",")
                .append("\"").append((service.getArea()==null)?"":service.getArea()).append("\",")
                .append("\"").append((service.getLayers()==null)?"":service.getLayers()).append("\",")
                .append("\"").append((service.getExtra()==null)?"":service.getExtra()).append("\",")
                .append(service.getProcessid()).append(",")
                .append("\"").append(service.getStatus()).append("\",")
                .append("");

        return sb.toString(); 
    }

}
