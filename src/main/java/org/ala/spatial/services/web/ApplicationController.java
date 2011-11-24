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

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.ala.spatial.services.dao.ApplicationDAO;
import org.ala.spatial.services.dto.Application;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author ajay
 */
@Controller
public class ApplicationController {
    
    private static final Logger logger = Logger.getLogger(ApplicationController.class);

    private final String APP_LIST = "/apps/";
    private final String APP_VIEW = "/app/{appid}";
    private final String APP_NEW = "/app/new";

    @Resource(name = "applicationDao")
    private ApplicationDAO applicationDao;

    @RequestMapping(value = APP_LIST)
    public ModelAndView viewApplications() {
        List<Application> apps = applicationDao.findApplications();

        System.out.println("Got " + apps.size() + " items");

        ModelAndView m = new ModelAndView("apps/list");
        m.addObject("apps", apps);

        return m;
    }

    @RequestMapping(value = APP_VIEW)
    public ModelAndView appInfo(@PathVariable String appid) {
        Application app = applicationDao.findApplicationByAppId(appid);

        ModelAndView m = new ModelAndView("apps/view");
        m.addObject("app", app);

        return m;
    }


    @RequestMapping(method = RequestMethod.GET, value = APP_NEW)
    public String newApplicationForm() {
        return "apps/new";
    }

    @RequestMapping(method = RequestMethod.POST, value = APP_NEW)
    public ModelAndView newApplication(@ModelAttribute("application") Application app, HttpServletRequest req) {

        logger.info("Adding application: \n" + app.toString());

        List<Application> apps = applicationDao.findApplicationsByEmail(app.getEmail());
        ModelAndView m = new ModelAndView("message");

        if (apps.size() > 0) {
            m.addObject("msg", "An application with the email has already been registered. Would you like to register yet another application?");
            //return "Application with the email has already been registered.";
        } else {
            applicationDao.addApplication(app);

            logger.info("now application is: \n" + app.toString());
            String html = "";
            html += "Thank you for registering your application.";
            html += "Please keep your AppID secure and use it as part of your client application.";
            html += "<br />";
            html += "<strong>" + apps.get(0).getAppid() + "</strong>";
            html += "<br /><br />";

            m.addObject("msg", html);
            m.addObject("isnew", true);

            //return "application successfully created. Your appid is '" + app.getAppid() + "', please keep this safe.";
        }

        return m; 

    }
}
