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

package org.ala.spatial.services.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.ala.spatial.services.dao.ActionDAO;
import org.ala.spatial.services.dto.Action;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Actions breakdown controller
 * 
 * @author ajay
 */
@Controller
public class BreakdownController {

    private static final Logger logger = Logger.getLogger(PageController.class);
    
    private final String ACTIONS_BREAKDOWN = "/actions/breakdown";
    private final String ACTIONS_USAGE_DAY = "/actions/usage/day";
    private final String ACTIONS_USAGE_WEEK = "/actions/usage/week";
    private final String ACTIONS_USAGE_MONTH = "/actions/usage/month";
    private final String ACTIONS_USAGE_YEAR = "/actions/usage/year";

    private final String[] AVAILABLE_BREAKDOWN_PARAMS = {"type","category1", "specieslsid", "layers"};


    @Resource(name = "actionDao")
    private ActionDAO actionDao;

    @RequestMapping(value = ACTIONS_BREAKDOWN)
    public ModelMap breakdown() {
        ModelMap m = new ModelMap();

        //m.addAttribute("breakdown", actionDao.getActionBreakdownByType());
        //m.addAttribute("breakdown", actionDao.getActionBreakdownBy("category1",""));
        m.addAttribute("actionsbyday", actionDao.getActionBreakdownByDay());

        return m;
    }

    @RequestMapping(value = ACTIONS_USAGE_DAY)
    public ModelMap usageByDay() {
        ModelMap m = new ModelMap();

        m.addAttribute("breakdown", actionDao.getActionBreakdownByType());

        return m;
    }

    @RequestMapping(value = ACTIONS_BREAKDOWN + "/{breakdown}")
    public ModelMap breakdownBy(@PathVariable String breakdown) {
        return performBreakdown(breakdown, "");
    }

    @RequestMapping(value = ACTIONS_BREAKDOWN + "/{breakdown}/{by}")
    public ModelMap breakdownBy(@PathVariable String breakdown, @PathVariable String by) {
        return performBreakdown(breakdown, by);
    }

    private ModelMap performBreakdown(String breakdown, String by) {
        ModelMap m = new ModelMap();

        if (!Arrays.asList(AVAILABLE_BREAKDOWN_PARAMS).contains(breakdown)) {
            m.addAttribute("message", "no breakdown available");
            
        } else {
            m.addAttribute("breakdown", actionDao.getActionBreakdownBy(breakdown, by));
        }

        return m;

    }
    
}
