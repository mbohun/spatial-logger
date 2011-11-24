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

import org.codehaus.jackson.map.annotate.JsonSerialize;

/**
 *
 * @author ajay
 */

@JsonSerialize(include=JsonSerialize.Inclusion.NON_DEFAULT)
public class Service {
    private long id;
    private String name;
    private long processid;
    private String specieslsid;
    private String area;
    private String layers;
    private String extra;
    private String status;
    private boolean privacy;

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getLayers() {
        return layers;
    }

    public void setLayers(String layers) {
        this.layers = layers;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getProcessid() {
        return processid;
    }

    public void setProcessid(long processid) {
        this.processid = processid;
    }

    public String getSpecieslsid() {
        return specieslsid;
    }

    public void setSpecieslsid(String specieslsid) {
        this.specieslsid = specieslsid;
    }

    public boolean getPrivacy() {
        return privacy;
    }

    public void setPrivacy(boolean privacy) {
        this.privacy = privacy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Service{" + " id=" + id + " name=" + name + " processid=" + processid + " specieslsid=" + specieslsid + " area=" + area + " layers=" + layers + " extra=" + extra + " status=" + status + "  privacy=" + privacy + '}';
    }
    
}
