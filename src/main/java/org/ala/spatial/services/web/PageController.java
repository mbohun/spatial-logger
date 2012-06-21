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

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.tagext.TryCatchFinally;
import org.ala.spatial.services.dao.ActionDAO;
import org.ala.spatial.services.dto.Action;
import org.ala.spatial.services.dto.Service;
import org.ala.spatial.services.dto.Session;
import org.ala.spatial.services.utils.Utilities;
import org.apache.commons.lang.StringUtils;
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
    private final String VIEW_ACTIONS_CSV = "/logs.csv";
    private final String VIEW_SESSIONS_CSV = "/sessions.csv";
    private final String VIEW_SESSIONS_INFO = "/session/{sessionid}";
    private final String LOGOUT = "/logout";
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
    public
    @ResponseBody
    String logAction(HttpServletRequest req) {

        Service service = new Service();
        service.setArea(req.getParameter("area"));
        service.setExtra(req.getParameter("extra"));
        service.setLayers(req.getParameter("layers"));
        service.setName(req.getParameter("name"));

        String privacy = req.getParameter("privacy");
        try {
            service.setPrivacy(Boolean.parseBoolean(privacy));
        } catch (Exception e) {
            service.setPrivacy(false);
        }

        String processid = req.getParameter("processid");
        try {
            service.setProcessid(Long.parseLong(processid));
        } catch (Exception e) {
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
    public
    @ResponseBody
    String logUpdateService(@PathVariable("pid") String pid, @PathVariable("status") String status, HttpServletRequest req) {
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
        
        int start = 0;
        int count = 500;

        if (!Utilities.isUserAdmin(req)) {
            //ModelAndView mv = new ModelAndView("dashboard/types");
            //mv.addAttribute("error", "authentication");
            //mv.addAttribute("message", "Please authenticate yourself with the ALA system");
            //return mv;

            return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system with administrator credentials");
        }


        List<Action> actions = actionDao.getActionsByPage(start, count);
        ModelAndView m = new ModelAndView("actions");
        m.addObject("actions", actions);

        List<Session> sessions = actionDao.getActionsBySessionsPage(start, count);

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

    @RequestMapping(value = VIEW_ACTIONS_CSV)
    public void viewLogsAsCSV(HttpServletRequest req, HttpServletResponse res) {
        StringBuffer sb = new StringBuffer();

        if (!Utilities.isUserAdmin(req)) {
            //return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system with administrator credentials");
            sb.append("Please authenticate yourself with the ALA system with administrator credentials");
        } else {
            sb.append("Action ID,Time,Email,User IP,Session ID,Type,Category1,Category 2,Name,Species LSID,Layers,Extra options,Process ID,Status\n");
            // ,Area
            List<Action> actions = actionDao.getActions();
            for (int i = 0; i < actions.size(); i++) {
                sb.append(actions.get(i).toString()).append("\n");
            }
        }

        try {

            res.setContentType("text/csv");
            OutputStream os = res.getOutputStream();
            os.write(sb.toString().getBytes("UTF-8"));
            os.close();
        } catch (Exception e) {
            System.out.println("Unable to write actions log as csv");
            e.printStackTrace(System.out);
        }
    }

    @RequestMapping(value = VIEW_SESSIONS_CSV)
    public void viewSessionsAsCSV(HttpServletRequest req, HttpServletResponse res) {
        StringBuffer sb = new StringBuffer();

        if (!Utilities.isUserAdmin(req)) {
            //return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system with administrator credentials");
            sb.append("Please authenticate yourself with the ALA system with administrator credentials");
        } else {
            sb.append("Email,User IP,Session ID,Species,Areas,Layers,Tools,Imports,Exports,Start,End,Duration(mins)\n");
            List<Session> sessions = actionDao.getActionsBySessions();

            for (int i = 0; i < sessions.size(); i++) {
                Session session = sessions.get(i);
                String[] mal = session.getTasks().split(",");

                for (String s : mal) {
                    session.incrementCount(s);
                }

                sb.append(session.toCSV()).append("\n");
            }
        }

        try {

            res.setContentType("text/csv");
            OutputStream os = res.getOutputStream();
            os.write(sb.toString().getBytes("UTF-8"));
            os.close();
        } catch (Exception e) {
            System.out.println("Unable to write sessions log as csv");
            e.printStackTrace(System.out);
        }
    }

    @RequestMapping(value = VIEW_SESSIONS_INFO)
    public @ResponseBody HashMap viewSessionById(@PathVariable("sessionid") String sessionid, HttpServletRequest req, HttpServletResponse res) {
        StringBuffer sb = new StringBuffer();
        
        HashMap map = new HashMap(); 
        
        /*

        if (!Utilities.isUserAdmin(req)) {
            //return new ModelAndView("message", "msg", "Please authenticate yourself with the ALA system with administrator credentials");
            sb.append("Please authenticate yourself with the ALA system with administrator credentials");
        } else {
            sb.append("Session ID,Species,Areas,Layers,Tools,Imports,Exports,Duration(mins)\n");
            List<Session> sessions = actionDao.getActionsBySessions();

            for (int i = 0; i < sessions.size(); i++) {
                Session session = sessions.get(i);
                String[] mal = session.getTasks().split(",");

                for (String s : mal) {
                    session.incrementCount(s);
                }

                sb.append(session.toCSV()).append("\n");
            }
        }

        try {

            res.setContentType("text/csv");
            OutputStream os = res.getOutputStream();
            os.write(sb.toString().getBytes("UTF-8"));
            os.close();
        } catch (Exception e) {
            System.out.println("Unable to write sessions log as csv");
            e.printStackTrace(System.out);
        }
        * 
        */
        
        if (StringUtils.isNotBlank(sessionid)) {
            List<Action> actions = actionDao.getActionsBySessionId(sessionid); 
            
            map.put("status","success");
            map.put("actions", actions);
            map.put("total", actions.size()); 
            
        } else {
            map.put("status", "failure");
            map.put("reason", "no session id provided"); 
        }
        
        return map; 
    }

    @RequestMapping(value = LOGOUT)
    public ModelAndView userLogout(HttpServletRequest req) {
        req.getSession(false).invalidate();
        return new ModelAndView("redirect:https://auth.ala.org.au/cas/logout?url=http://spatial-dev.ala.org.au/actions/");

    }
}
