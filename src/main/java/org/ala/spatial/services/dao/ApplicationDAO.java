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

package org.ala.spatial.services.dao;

import java.util.List;
import org.ala.spatial.services.dto.Application;

/**
 *
 * @author ajay
 */
public interface ApplicationDAO {
    public List<Application> findApplications();
    public List<Application> findApplicationsByName(String name);
    public List<Application> findApplicationsByEmail(String email);
    public List<Application> findApplicationsByOrganisation(String org);
    public Application findApplicationByAppId(String appid);
    public void addApplication(Application app);
    public void removeApplication(String appid);
    public void updateApplication(Application app); 
}
