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

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.ala.spatial.services.dao.ActionDAO;
import org.ala.spatial.services.dto.Action;
import org.ala.spatial.services.dto.Session;
import org.ala.spatial.services.utils.Utilities;
import org.apache.commons.lang.time.FastDateFormat;
import org.apache.log4j.Logger;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Dashboard controller for a logged-in user
 *
 * @author ajay
 */
@Controller
public class DashboardController {

    private static final Logger logger = Logger.getLogger(PageController.class);
    private final String DASHBOARD_HOME = "/dashboard";
    private final String DASHBOARD_INDEX = "/dashboard/index";
    @Resource(name = "actionDao")
    private ActionDAO actionDao;

    @RequestMapping(value = {DASHBOARD_HOME, DASHBOARD_INDEX})
    public ModelAndView index(HttpServletRequest req) {

        if (!Utilities.isLoggedIn(req)) {
            //ModelAndView mv = new ModelAndView("dashboard/types");
            //mv.addAttribute("error", "authentication");
            //mv.addAttribute("message", "Please authenticate yourself with the ALA system");
            //return mv;

            return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system");
        }

        String useremail = Utilities.getUserEmail(req);
        List<Action> abe = actionDao.getActionsByEmail(useremail);

        FastDateFormat df = FastDateFormat.getInstance("yyyy-MM-dd hh:mm");
        HashMap<String, String> types = new HashMap<String, String>();
        for (Action a : abe) {
            if (a.getService() == null) {
                continue;
            }

            String val = "";
            if (types.containsKey(a.getCategory1())) {
                val = types.get(a.getCategory1()) + "|";
            }

            val += a.getService().getName() + "-" + a.getId() + "-" + df.format(a.getTime()).replaceAll("-", "_");
            types.put(a.getCategory1(), val);
        }

        List<Session> sessions = actionDao.getActionsBySessionsByUser(useremail);

        for (int i = 0; i < sessions.size(); i++) {
            Session session = sessions.get(i);
            String[] mal = session.getTasks().split(",");

            for (String s : mal) {
                session.incrementCount(s);
            }
        }

        ModelAndView mv = new ModelAndView("dashboard/index");
        mv.addObject("abe", abe);
        mv.addObject("types", types);
        mv.addObject("sessions", sessions);
        mv.addObject("useremail", useremail);
        mv.addObject("isAdmin", Utilities.isUserAdmin(req));

        return mv;
    }

    @RequestMapping(value = {DASHBOARD_HOME + "/types/{type}", "app/types/{type}"})
    public ModelAndView displayFullTypeList(@PathVariable String type, HttpServletRequest req) {

        if (type.equals("")) {
            return index(req);
        }

        String useremail = null;

        if (Utilities.isAppAuth(req)) {
            try {
                useremail = URLDecoder.decode(req.getParameter("email"), "UTF-8");
            } catch (UnsupportedEncodingException e) {
                logger.error("User: " + req.getParameter("email"));
                return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system");
            }
        } else if (!Utilities.isLoggedIn(req)) {
            //ModelAndView mv = new ModelAndView("dashboard/types");
            //mv.addAttribute("error", "authentication");
            //mv.addAttribute("message", "Please authenticate yourself with the ALA system");
            //return mv;

            return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system");
        } else {
            useremail = Utilities.getUserEmail(req);
        }

        List<Action> abe = actionDao.getActionsByEmailAndCategory1(useremail, type);

        FastDateFormat df = FastDateFormat.getInstance("yyyy-MM-dd hh:mm");
        HashMap<String, String> types = new HashMap<String, String>();
        for (Action a : abe) {
            if (a.getService() == null) {
                continue;
            }
            if (a.getCategory1() != null && !a.getCategory1().equalsIgnoreCase(type)) {
                continue;
            }

            String val = "";
            if (types.containsKey(a.getCategory1())) {
                val = types.get(a.getCategory1()) + "|";
            }

            val += a.getService().getName() + "-" + a.getId() + "-" + df.format(a.getTime()).replaceAll("-", "_");
            types.put(a.getCategory1(), val);
        }


        String key = type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase();
        ModelAndView mv = new ModelAndView("dashboard/types");
        mv.addObject("abe", abe);
        mv.addObject("types", types);
        mv.addObject("key", key);
        mv.addObject("useremail", useremail);
        mv.addObject("isAdmin", Utilities.isUserAdmin(req));

        return mv;

    }
}
