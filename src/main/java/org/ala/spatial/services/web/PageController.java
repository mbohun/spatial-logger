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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.ala.spatial.services.dao.ActionDAO;
import org.ala.spatial.services.dto.Action;
import org.ala.spatial.services.dto.Service;
import org.ala.spatial.services.dto.Session;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Basic page serving Controller
 *
 * @author ajay
 */
@Controller
public class PageController {

    private static final Logger logger = Logger.getLogger(PageController.class);

    private final String INDEX = "/index";
    private final String LOG_ACTION = "/log/action";
    private final String LOG_UPDATE = "/log/update/{pid}/{status}";
    private final String VIEW_ACTION = "/log/view/{id}";
    private final String VIEW_ACTIONS = "/logs";

    @Resource(name = "actionDao")
    private ActionDAO actionDao;

    @RequestMapping(value = INDEX)
    public String index() {
        return "index";
    }

//    //public String logAction(@RequestParam("appid") String appid) {
//    @RequestMapping(method = RequestMethod.POST, value = LOG_ACTION)
//    public @ResponseBody String logAction(@ModelAttribute("action") Action action, @ModelAttribute("service") Service service, HttpServletRequest req) {
//
////        String userip = req.getHeader("x-forwarded-for");
////        if (userip == null) {
////            userip = req.getRemoteAddr();
////        }
////        action.setUserip(userip);
//        action.setService(service);
//
//        logger.info("Adding action: \n" + action.toString());
//
//        actionDao.addAction(action);
//
//        logger.info("now action is: \n" + action.toString());
//
//        return "action logged";
//    }

    @RequestMapping(method = RequestMethod.POST, value = LOG_ACTION)
    public @ResponseBody String logAction(HttpServletRequest req) {

        Service service = new Service();
        service.setArea(req.getParameter("area"));
        service.setExtra(req.getParameter("extra"));
        service.setLayers(req.getParameter("layers"));
        service.setName(req.getParameter("name"));
                
        String privacy = req.getParameter("privacy");
        try {
            service.setPrivacy(Boolean.parseBoolean(privacy));
        } catch(Exception e) {
            service.setPrivacy(false);
        }

        String processid = req.getParameter("processid");
        try {
            service.setProcessid(Long.parseLong(processid));
        } catch(Exception e) {
            service.setProcessid(-1);
        }
        
        service.setSpecieslsid(req.getParameter("specieslsid"));
        service.setStatus(req.getParameter("status"));

        Action action = new Action();
        action.setAppid(req.getParameter("appid"));
        action.setEmail(req.getParameter("email"));
        action.setType(req.getParameter("type"));
        action.setCategory1(req.getParameter("category1"));
        action.setCategory2(req.getParameter("category2"));
        action.setUserip(req.getParameter("userip"));
        action.setSessionid(req.getParameter("sessionid"));
        action.setService(service);

        actionDao.addAction(action);

        return "action request logged";
    }

    @RequestMapping(method = RequestMethod.GET, value = LOG_UPDATE)
    public @ResponseBody String logUpdateService(@PathVariable("pid") String pid, @PathVariable("status") String status, HttpServletRequest req) {
        actionDao.updateActionStatus(pid, status);
        return "service updated";
    }

    @RequestMapping(value = VIEW_ACTION)
    public ModelAndView viewLogAction(@PathVariable long id) {
        Action action = actionDao.getActionById(id);
        ModelAndView m = new ModelAndView("actionview");
        m.addObject("action", action);

        return m;
    }

    @RequestMapping(value = VIEW_ACTIONS)
    public ModelAndView viewLogs(HttpServletRequest req) {

        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        System.out.println("Authentication details");
        if(req.getUserPrincipal() != null) {
            System.out.println("req.getUserPrincipal().getName(): " + req.getUserPrincipal().getName());
        } else {
            System.out.println("No user principal. ");
        }
        String remoteuser = req.getRemoteUser();
        if (remoteuser == null) {
            System.out.println("Got remote user: " + remoteuser);
        } else {
            System.out.println("No remote user. :(");
        }

        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");


        List<Action> actions = actionDao.getActions();
        ModelAndView m = new ModelAndView("actions");
        m.addObject("actions", actions);

        List<Session> sessions = actionDao.getActionsBySessions();

        for (int i = 0; i < sessions.size(); i++) {
            Session session = sessions.get(i);
            String[] mal = session.getTasks().split(",");

            for (String s : mal) {
                session.incrementCount(s);
            }
        }
        m.addObject("sessions", sessions);

        return m;
    }

}
