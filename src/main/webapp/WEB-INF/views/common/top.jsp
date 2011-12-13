<%-- 
    Document   : top
    Created on : Dec 7, 2011, 10:33:50 AM
    Author     : ajay
--%>
<%@
page contentType="text/html; charset=UTF-8" %><%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@
taglib prefix="spring" uri="http://www.springframework.org/tags" %><%@
taglib prefix="form" uri="http://www.springframework.org/tags/form" %><%@
taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html dir="ltr" lang="en-US">

    <head profile="http://gmpg.org/xfn/11">
        <meta name="google-site-verification" content="MdnA79C1YfZ6Yx2qYOXWi_TYFfUvEJOQAmHNaeEWIts" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="description" content="The Atlas of Living Australia provides tools to enable users of biodiversity information to find, access, combine and visualise data on Australian plants and animals" />
        
        <title>Spatial | Atlas of Living Australia</title>

        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/static/includes/images/favicon.ico" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/static/includes/images/favicon.ico" />
        <link rel="alternate" type="application/rss+xml" title="Atlas of Living Australia &raquo; Feed" href="http://www.ala.org.au/feed/" />
        <link rel="alternate" type="application/rss+xml" title="Atlas of Living Australia &raquo; Comments Feed" href="http://www.ala.org.au/comments/feed/" />
        <link rel="alternate" type="application/rss+xml" title="Atlas of Living Australia &raquo; Layer list Comments Feed" href="http://www.ala.org.au/mapping-analysis/layer-list/feed/" />
        <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.ala.org.au/xmlrpc.php?rsd" />
        <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="http://www.ala.org.au/wp-includes/wlwmanifest.xml" />
        <link rel='index' title='Atlas of Living Australia' href='http://www.ala.org.au/' />
        <link rel='up' title='Mapping &amp; analysis' href='http://www.ala.org.au/mapping-analysis/' />
        <link rel='prev' title='bkThe Collection Manager Story' href='http://www.ala.org.au/about-home/digitisation-guidance/the-collection-manager-story/' />
        <link rel='canonical' href='http://www.ala.org.au/mapping-analysis/layer-list/' />

        <link rel="stylesheet" type="text/css" media="screen" href="http://jqueryui.com/themes/base/jquery.ui.tabs.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="http://biocache.ala.org.au/static/css/tabs-no-images.css" />
        <!--
        <link rel="stylesheet" type="text/css" media="screen" href="http://jqueryui.com/demos/demos.css" />
        -->
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/style.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/css/wp-styles.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/css/buttons.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/css/jquery.autocomplete.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/css/sf.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/dashboard/dashboard.css" />        
        <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/dashboard/datatables/data_table.css" />
        <!--<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/static/includes/dashboard/datatables/TableTools.css" />-->

        <script type="text/javascript" src="${pageContext.request.contextPath}/static/includes/scripts/html5.js"></script>
        <script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
        <script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala/scripts/uservoice.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/includes/dashboard/datatables/jquery.dataTables.min.js"></script>
        <!--<script type="text/javascript" src="${pageContext.request.contextPath}/static/includes/dashboard/datatables/TableTools.min.js"></script>-->
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
            google.load("visualization", "1", {packages:["corechart", "annotatedtimeline"]});
        </script>
    </head>
    <body id="page-spatial" class="page">
    <header id="site-header">
        <div class="inner">

            <h1 title="Atlas of Living Australia"><a href="http://www.ala.org.au" title="Atlas of Living Australia home"><img src="${pageContext.request.contextPath}/static/includes/images/logo.png" width="315" height="33" alt="" /></a></h1>
            <section id="nav-search">
                <section id="header-search">
                    <form id="search-form" action="http://bie.ala.org.au/search" method="get" name="search-form"><label for="search">Search</label>
                        <input id="search" class="filled" title="Search" type="text" name="q" placeholder="Search the Atlas" />
                        <span class="search-button-wrapper"><button id="search-button" class="search-button" value="Search" type="submit"><img src="${pageContext.request.contextPath}/static/includes/images/button_search-grey.png" alt="Search" width="12" height="12" /></button></span></form>
                </section>
                <nav>
                    <c:choose>
                        <c:when test="${useremail eq 'guest@ala.org.au'}">
                            <ol>
                                <li><a href="http://www.ala.org.au" title="Atlas of Living Australia home">Home</a></li>
                                <li class="last"><a href="https://auth.ala.org.au/cas/login?service=${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/dashboard" title="Log in">Log in</a></li>
                            </ol>
                        </c:when>
                        <c:otherwise>
                            <ol>
                                <li><a href="http://www.ala.org.au" title="Atlas of Living Australia home">Home</a></li>
                                <!-- <li><a href="https://auth.ala.org.au/cas/login?service=http://www.ala.org.au/wp-login.php?redirect_to=http://www.ala.org.au/my-profile/" title="My Profile">My Profile</a></li> -->
                                <li class="last"><a href="${pageContext.request.contextPath}/logout" title="Log out">Log out</a></li>
                            </ol>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </section>
        </div>
    </header>

    <nav id="nav-site">
        <!-- WP Menubar 4.8: start menu nav-site, template Superfish, CSS  -->


        <ul class="sf">
            <li class="nav-species"><a href="http://test.ala.org.au/australias-species/" >Species</a></li>
            <li class="nav-locations"><a href="http://test.ala.org.au/species-by-location/" >Locations</a>
            </li><li class="nav-collections"><a href="http://test.ala.org.au/natural-history-collections/" >Collections</a></li>
            <li class="nav-mapping"><a href="http://spatial.ala.org.au" >Mapping & analysis</a></li>
            <li class="nav-datasets"><a href="http://test.ala.org.au/data-sets/" >Data sets</a></li>
            <li class="nav-blogs"><a href="http://test.ala.org.au/blogs-news/" >Blogs</a></li>
            <li class="nav-getinvolved"><a href="http://test.ala.org.au/get-involved/" >Get involved</a></li>
            <li class="nav-about"><a href="http://test.ala.org.au/about-home/" >About the Atlas</a>
                <ul>
                    <li><a href="http://test.ala.org.au/about-home/atlas-background/" >bkAtlas Background</a></li>
                    <li><a href="http://test.ala.org.au/about-home/our-data/" >bkOur Data</a></li>
                    <li><a href="http://test.ala.org.au/about-home/our-data-providers/" >bkOur Data Providers</a></li>
                    <li><a href="http://test.ala.org.au/about-home/how-we-integrate-data/" >bkHow we Integrate Data</a></li>
                    <li><a href="http://test.ala.org.au/about-home/downloadable-tools/" >bkDownloadable Tools</a></li>
                    <li><a href="http://test.ala.org.au/about-home/digitisation-guidance/" >bkDigitisation Guidance</a></li>
                    <li><a href="http://test.ala.org.au/about-home/communications-centre/" >bkCommunications Centre</a></li>
                    <li><a href="http://test.ala.org.au/about-home/terms-of-use/" >bkTerms of Use</a></li>
                    <li><a href="http://test.ala.org.au/about-home/contact-us/" >bkContact Us</a></li>
                </ul>
            </li>
        </ul>

        <!-- WP Menubar 4.8: end menu nav-site, template Superfish, CSS  -->
    </nav>
