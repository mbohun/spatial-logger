<%-- 
    Document   : top
    Created on : Dec 7, 2011, 10:33:50 AM
    Author     : ajay
--%>
<%@
        page contentType="text/html; charset=UTF-8"
             import="java.util.Properties,java.io.FileInputStream" %>

<% Properties p = new Properties();
    try {
        p.load(new FileInputStream("/data/actions/config/actions-config.properties"));
        pageContext.setAttribute("serverName",p.getProperty("serverName"));
    } catch (Exception e){}
%>

<%@
        taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@
            taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@
        taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@
        taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@
        taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@
        taglib uri="/tld/ala.tld" prefix="ala" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
    <meta name="google-site-verification" content="MdnA79C1YfZ6Yx2qYOXWi_TYFfUvEJOQAmHNaeEWIts"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="description"
          content="The Atlas of Living Australia provides tools to enable users of biodiversity information to find, access, combine and visualise data on Australian plants and animals"/>
    <title>Spatial | Atlas of Living Australia</title>

    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/style.css" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/wp-styles.css" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="http://www.ala.org.au/wp-content/themes/ala2011/css/buttons.css" type="text/css"
          media="screen"/>
    <link rel="icon" type="image/x-icon" href="http://www.ala.org.au/wp-content/themes/ala2011/images/favicon.ico"/>
    <link rel="shortcut icon" type="image/x-icon"
          href="http://www.ala.org.au/wp-content/themes/ala2011/images/favicon.ico"/>

    <link rel="stylesheet" type="text/css" media="screen"
          href="http://www.ala.org.au/wp-content/themes/ala2011/css/jquery.autocomplete.css"/>

    <link rel="stylesheet" type="text/css" media="screen"
          href="http://www.ala.org.au/wp-content/themes/ala2011/css/search.css"/>
    <link rel="stylesheet" type="text/css" media="screen"
          href="http://www.ala.org.au/wp-content/themes/ala2011/css/skin.css"/>
    <link rel="stylesheet" type="text/css" media="screen"
          href="http://www.ala.org.au/wp-content/themes/ala2011/css/sf.css"/>

    <!-- <link rel="stylesheet" type="text/css" media="screen" href="http://jqueryui.com/themes/base/jquery.ui.tabs.css" /> -->
    <link rel="stylesheet" type="text/css" media="screen"
          href="${pageContext.request.contextPath}/static/includes/css/jquery.ui.tabs.css"/>
    <link rel="stylesheet" type="text/css" media="screen"
          href="http://biocache.ala.org.au/static/css/tabs-no-images.css"/>

    <link rel="stylesheet" type="text/css" media="screen"
          href="${pageContext.request.contextPath}/static/includes/dashboard/dashboard.css"/>
    <link rel="stylesheet" type="text/css" media="screen"
          href="${pageContext.request.contextPath}/static/includes/dashboard/datatables/data_table.css"/>

    <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/html5.js"></script>
    <link rel="alternate" type="application/rss+xml" title="Atlas of Living Australia &raquo; Feed"
          href="http://www.ala.org.au/feed/"/>
    <link rel="alternate" type="application/rss+xml" title="Atlas of Living Australia &raquo; Comments Feed"
          href="http://www.ala.org.au/comments/feed/"/>
    <link rel="alternate" type="application/rss+xml"
          title="Atlas of Living Australia &raquo; Australia&#8217;s species Comments Feed"
          href="http://www.ala.org.au/australias-species/feed/"/>
    <link rel='stylesheet' id='commentvalidation-css'
          href='http://www.ala.org.au/wp-content/plugins/comment-validation/comment-validation.css?ver=3.3.1'
          type='text/css' media='all'/>
    <link rel='stylesheet' id='jquery.lightbox.min.css-css'
          href='http://www.ala.org.au/wp-content/plugins/wp-jquery-lightbox/lightbox.min.css?ver=1.2' type='text/css'
          media='all'/>

    <script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'></script>
    <script type="text/javascript"
            src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type='text/javascript'
            src='http://www.ala.org.au/wp-content/plugins/comment-validation/jquery.validate.pack.js?ver=3.3.1'></script>
    <script type='text/javascript'
            src='http://www.ala.org.au/wp-content/plugins/comment-validation/comment-validation.js?ver=3.3.1'></script>
    <script type='text/javascript'
            src='http://www.ala.org.au/wp-content/plugins/menubar-templates/Superfish/superfish.js?ver=3.3.1'></script>
    <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.ala.org.au/xmlrpc.php?rsd"/>
    <link rel="wlwmanifest" type="application/wlwmanifest+xml"
          href="http://www.ala.org.au/wp-includes/wlwmanifest.xml"/>
    <link rel='index' title='Atlas of Living Australia' href='http://www.ala.org.au/'/>
    <link rel='up' title='Mapping &amp; analysis' href='http://www.ala.org.au/mapping-analysis/'/>
    <link rel='prev' title='bkThe Collection Manager Story'
          href='http://www.ala.org.au/about-home/digitisation-guidance/the-collection-manager-story/'/>
    <link rel='next' title='Department of Sustainability, Environment, Water, Population and Communities'
          href='http://www.ala.org.au/natural-history-collections/department-of-sustainability-environment-water-population-and-communities/'/>
    <meta name="generator" content="WordPress 3.2.1"/>
    <link rel='canonical' href='http://www.ala.org.au/mapping-analysis/layer-list/'/>

    <!-- WP Menubar 4.10: start CSS -->
    <!-- WP Menubar 4.10: end CSS -->
    <style type="text/css">.broken_link, a.broken_link {
        text-decoration: line-through;
    }</style>
    <script src="http://cdn.jquerytools.org/1.2.6/full/jquery.tools.min.js"></script>

    <script language="JavaScript" type="text/javascript"
            src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/jquery.dimensions.js"></script>
    <script language="JavaScript" type="text/javascript"
            src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/jquery.mousewheel.min.js"></script>
    <script language="JavaScript" type="text/javascript"
            src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/hoverintent-min.js"></script>
    <script language="JavaScript" type="text/javascript"
            src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/superfish/superfish.js"></script>
    <script language="JavaScript" type="text/javascript"
            src="http://www.ala.org.au/wp-content/themes/ala2011/scripts/jquery.autocomplete.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/static/includes/dashboard/datatables/jquery.dataTables.min.js"></script>
    <!--<script type="text/javascript" src="${pageContext.request.contextPath}/static/includes/dashboard/datatables/TableTools.min.js"></script>-->
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", {packages: ["corechart", "annotatedtimeline"]});
    </script>
    <script type="text/javascript">

        // initialise plugins

        jQuery(function () {
            jQuery('ul.sf').superfish({
                delay: 500,
                autoArrows: false,
                dropShadows: false
            });

            jQuery("form#search-form input#search").autocomplete('http://bie.ala.org.au/search/auto.jsonp', {
                extraParams: {limit: 100},
                dataType: 'jsonp',
                parse: function (data) {
                    var rows = new Array();
                    data = data.autoCompleteList;
                    for (var i = 0; i < data.length; i++) {
                        rows[i] = {
                            data: data[i],
                            value: data[i].matchedNames[0],
                            result: data[i].matchedNames[0]
                        };
                    }
                    return rows;
                },
                matchSubset: false,
                formatItem: function (row, i, n) {
                    return row.matchedNames[0];
                },
                cacheLength: 10,
                minChars: 3,
                scroll: false,
                max: 10,
                selectFirst: false
            });
            jQuery("form#search-inpage input#search").autocomplete('http://bie.ala.org.au/search/auto.jsonp', {
                extraParams: {limit: 100},
                dataType: 'jsonp',
                parse: function (data) {
                    var rows = new Array();
                    data = data.autoCompleteList;
                    for (var i = 0; i < data.length; i++) {
                        rows[i] = {
                            data: data[i],
                            value: data[i].matchedNames[0],
                            result: data[i].matchedNames[0]
                        };
                    }
                    return rows;
                },
                matchSubset: false,
                formatItem: function (row, i, n) {
                    return row.matchedNames[0];
                },
                cacheLength: 10,
                minChars: 3,
                scroll: false,
                max: 10,
                selectFirst: false
            });

            jQuery("ul.button-tabs").tabs("div.panes > ul"), { history: true, effect: 'fade' };
            jQuery("ul.tabs").tabs("div.tabs-panes-noborder > section"), { history: true, effect: 'fade' };
        });
    </script>
</head>
<c:choose>
<c:when test="${param.fluid}">
<body id="page-spatial" class="fluid">
</c:when>
<c:otherwise>
<body id="page-spatial" class="">
</c:otherwise>
</c:choose>

    <c:set var="returnUrlPath"
           value="${serverName}${requestScope['javax.servlet.forward.context_path']}${not empty pageContext.request.queryString ?
    '?' :
    ''}${pageContext.request.queryString}"/>

<ala:banner returnUrlPath="${returnUrlPath}"/>
<ala:menu/>
