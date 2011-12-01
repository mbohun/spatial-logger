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

import java.security.Principal;
import java.util.Arrays;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.ala.spatial.services.dao.ActionDAO;
import org.ala.spatial.services.utils.Utilities;
import org.apache.log4j.Logger;
import org.jasig.cas.client.authentication.AttributePrincipal;
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
    private final String[] AVAILABLE_BREAKDOWN_PARAMS = {"type", "category1", "specieslsid", "layers"};
    @Resource(name = "actionDao")
    private ActionDAO actionDao;

    @RequestMapping(value = ACTIONS_BREAKDOWN)
    public ModelMap breakdown(HttpServletRequest req) {
        ModelMap m = new ModelMap();

        if (!Utilities.isLoggedIn(req)) {
            m.addAttribute("error", "authentication");
            m.addAttribute("message", "Please authenticate yourself with the ALA system");
        } else {
            String useremail = Utilities.getUserEmail(req);

            //m.addAttribute("breakdown", actionDao.getActionBreakdownByType());
            //m.addAttribute("breakdown", actionDao.getActionBreakdownBy("category1",""));

            String forUser = req.getParameter("usr");
            if (forUser != null && !forUser.trim().equals("") && forUser.trim().equals("all")) {
                if (Utilities.isUserAdmin(req)) {
                    m.addAttribute("actionsbyday", actionDao.getActionBreakdownByDay());
                } else {
                    m.addAttribute("error", "authentication");
                    m.addAttribute("message", "Please authenticate yourself with the ALA system with an administrator account");
                }
            } else {
                m.addAttribute("actionsbyday", actionDao.getActionBreakdownByDayUser(useremail));
            }
        }

        return m;
    }

    @RequestMapping(value = ACTIONS_USAGE_DAY)
    public ModelMap usageByDay(HttpServletRequest req) {
        ModelMap m = new ModelMap();

        m.addAttribute("breakdown", actionDao.getActionBreakdownByType());

        return m;
    }

    @RequestMapping(value = ACTIONS_BREAKDOWN + "/{breakdown}")
    public ModelMap breakdownBy(@PathVariable String breakdown, HttpServletRequest req) {
        return performBreakdown(breakdown, "", req);
    }

    @RequestMapping(value = ACTIONS_BREAKDOWN + "/{breakdown}/{by}")
    public ModelMap breakdownBy(@PathVariable String breakdown, @PathVariable String by, HttpServletRequest req) {
        return performBreakdown(breakdown, by, req);
    }

    private ModelMap performBreakdown(String breakdown, String by, HttpServletRequest req) {

        ModelMap m = new ModelMap();

        if (!Utilities.isLoggedIn(req)) {
            m.addAttribute("error", "authentication");
            m.addAttribute("message", "Please authenticate yourself with the ALA system");
        } else {
            String useremail = Utilities.getUserEmail(req);

            if (!Arrays.asList(AVAILABLE_BREAKDOWN_PARAMS).contains(breakdown)) {
                m.addAttribute("error", "empty");
                m.addAttribute("message", "No breakdown available");
            } else {
                String forUser = req.getParameter("usr");
                if (forUser != null && !forUser.trim().equals("") && forUser.trim().equals("all")) {
                    if (Utilities.isUserAdmin(req)) {
                        m.addAttribute("breakdown", actionDao.getActionBreakdownBy(breakdown, by));
                    } else {
                        m.addAttribute("error", "authentication");
                        m.addAttribute("message", "Please authenticate yourself with the ALA system with an administrator account");
                    }

                } else {
                    m.addAttribute("breakdown", actionDao.getActionBreakdownUserBy(useremail, breakdown, by));
                }
            }
        }

        return m;

    }
}
