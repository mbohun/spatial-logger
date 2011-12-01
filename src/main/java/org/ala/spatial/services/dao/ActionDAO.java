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
import org.ala.spatial.services.dto.Action;
import org.ala.spatial.services.dto.Breakdown;
import org.ala.spatial.services.dto.Session;

/**
 *
 * @author ajay
 */
public interface ActionDAO {
    public void addAction(Action action);
    public void updateActionStatus(String pid, String status);
    public List<Action> getActions();
    public Action getActionById(long id);
    public Action getActionByService(long serviceid);
    public List<Action> getActionsByType(String type);
    public List<Action> getActionsByAppId(String appid);
    public List<Action> getActionsByEmail(String email);
    
    public List<Breakdown> getActionBreakdownByType();
    public List<Breakdown> getActionBreakdownByDay();
    public List<Breakdown> getActionBreakdownByDayUser(String email);
    public List<Breakdown> getActionBreakdownBy(String breakdown, String by);
    public List<Breakdown> getActionBreakdownUserBy(String email, String breakdown, String by);
    
    public List<Session> getActionsBySessions();
    public List<Session> getActionsBySessionsByUser(String email);
}
