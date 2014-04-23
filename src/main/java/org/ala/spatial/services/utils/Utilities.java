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
package org.ala.spatial.services.utils;

import java.io.FileReader;
import java.security.Principal;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.log4j.Logger;
import org.jasig.cas.client.authentication.AttributePrincipal;

/**
 * General utilities
 *
 * @author ajay
 */
public class Utilities {

    private static Logger logger = Logger.getLogger(Utilities.class);

    private static String DEFAULT_USER_EMAIL = "guest@ala.org.au";
    private static String DEFAULT_SPATIAL_USER_ADMIN = "ROLE_SPATIAL_ADMIN";
    private static String DEFAULT_USER_ADMIN = "ROLE_ADMIN";


    public static String getUserEmail(HttpServletRequest req) {
        String useremail = DEFAULT_USER_EMAIL;
        try {
            //System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //System.out.println("Breakdown Authentication details");
            if (req.getUserPrincipal() != null) {
                Principal principal = req.getUserPrincipal();
                if (principal instanceof AttributePrincipal) {
                    AttributePrincipal ap = (AttributePrincipal) principal;
                    //System.out.println("ap: " + ap.getAttributes().toString());
                    useremail = (String) ap.getAttributes().get("email");
                } else {
                    useremail = principal.getName();
                }
            }
            //System.out.println("useremail: " + useremail);
            //System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

        } catch (Exception e) {
            System.out.println("No user available");
        }

        return useremail;
    }

    public static boolean isLoggedIn(HttpServletRequest req) {
        if (getUserEmail(req).equals(DEFAULT_USER_EMAIL)) {
            return false;
        } else {
            return true;
        }
    }

    public static boolean isUserAdmin(HttpServletRequest req) {
        if (!isLoggedIn(req)) return false;
        return req.isUserInRole(DEFAULT_SPATIAL_USER_ADMIN);
    }

    public static boolean isAppAuth(HttpServletRequest req) {
        return req.getParameter("appid") != null && isValidAppId(req.getParameter("appid"));
    }

    private static boolean isValidAppId(String appid) {
        String url = "http://auth.ala.org.au/apikey/ws/check?apikey=" + appid;
        try {
            HttpClient client = new HttpClient();
            GetMethod get = new GetMethod(url);

            int result = client.executeMethod(get);

            JSONObject jo = JSONObject.fromObject(get.getResponseBodyAsString());

            if (jo.containsKey("valid"))
                if (jo.getString("valid").equalsIgnoreCase("true")) {
                    return true;
                } else {
                    logger.warn("invalid appid: " + appid);
                }

        } catch (Exception e) {
            logger.error("failed to validate appid with url: " + url, e);
        }

        //temporary, also match against properties file
        System.out.println("webportal.appid=" + getProperty("webportal.appid") + " comparing to: " + appid);
        if (getProperty("webportal.appid") != null && getProperty("webportal.appid").equals(appid)) {
            return true;
        }

        return false;
    }

    private static Properties properties = null;

    public static String getProperty(String property) {
        String file = "/data/actions/config/actions-config.properties";

        if (properties == null) {
            properties = new Properties();
            try {
                properties.load(new FileReader(file));
            } catch (Exception e) {
                logger.error("failed to load properties file: " + file, e);
            }
        }

        if (properties.getProperty(property) == null) {
            logger.error("******* MISSING PROPERTY from " + file + " for property: " + property);
        }

        return properties.getProperty(property);
    }
}
