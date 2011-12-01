<%-- 
    Document   : top
    Created on : Nov 8, 2011, 11:09:12 PM
    Author     : ajay
--%>
<%@ page session="true" %><%@
page pageEncoding="UTF-8" %><%@
page contentType="text/html; charset=UTF-8" %><%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@
taglib prefix="spring" uri="http://www.springframework.org/tags" %><%@
taglib prefix="form" uri="http://www.springframework.org/tags/form" %><%@
taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%@
taglib uri="/tld/ala.tld" prefix="ala" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
    <head profile="http://gmpg.org/xfn/11">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

        <title>Services | Atlas Living Australia </title>

        <link rel="stylesheet" href="https://www.ala.org.au/wp-content/themes/ala/style.css" type="text/css" media="screen" />
        <link rel="icon" type="image/x-icon" href="https://www.ala.org.au/wp-content/themes/ala/images/favicon.ico" />
        <link rel="shortcut icon" type="image/x-icon" href="https://www.ala.org.au/wp-content/themes/ala/images/favicon.ico" />

        <link rel="stylesheet" type="text/css" media="screen" href="https://www.ala.org.au/wp-content/themes/ala/css/sf.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="https://www.ala.org.au/wp-content/themes/ala/css/highlights.css" />
        <%-- <link type="text/css" rel="stylesheet" href="<spring:theme code="standard.custom.css.file" />" /> --%>
        <link rel="stylesheet" type="text/css" media="screen" href="http://biocache.ala.org.au/static/css/tabs-no-images.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/styles/styles.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/styles/demo_table.css" />

        <!--
        <script type="text/javascript" src="js/common_rosters.js"></script>
        <script language="JavaScript" type="text/javascript" src="https://www.ala.org.au/wp-content/themes/ala/scripts/jquery-1.4.2.min.js"></script>
        -->
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/scripts/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load("visualization", "1", {packages:["corechart", "annotatedtimeline"]});
        </script>

        <meta name='robots' content='noindex,nofollow' />
        <link rel="alternate" type="application/rss+xml" title="Atlas Living Australia NG &raquo; Feed" href="http://www.ala.org.au/feed/" />
        <link rel="alternate" type="application/rss+xml" title="Atlas Living Australia NG &raquo; Comments Feed" href="http://www.ala.org.au/comments/feed/" />
        <link rel="alternate" type="application/rss+xml" title="Atlas Living Australia NG &raquo; Site Map Comments Feed" href="http://www.ala.org.au/support/site-map/feed/" />
        <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.ala.org.au/xmlrpc.php?rsd" />
        <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="http://www.ala.org.au/wp-includes/wlwmanifest.xml" />
        <link rel='index' title='Atlas Living Australia' href='http://www.ala.org.au/' />
        <link rel='up' title='Support' href='http://www.ala.org.au/support/' />
        <link rel='prev' title='Get Started Video' href='http://www.ala.org.au/support/get-started/get-started-video/' />
        <link rel='next' title='How To' href='http://www.ala.org.au/support/how-to/' />
        <link rel='canonical' href='http://www.ala.org.au/support/site-map/' />
    </head>
    <body id="cas" class="page page-id-1485 page-child parent-pageid-81 page-template page-template-default one-column">
        <div id="wrapper">
            <c:if test="${empty param.format || param.format != 'minimal'}"><ala:bannerMenu returnUrlPath="http://spatial-dev.ala.org.au/actions/dashboard" /></c:if>
