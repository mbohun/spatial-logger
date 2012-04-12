<%@include file="common/top.jsp" %>
<header id="page-header">
    <div class="inner">
        <nav id="breadcrumb"><ol><li><a href="http://www.ala.org.au">Home</a></li> <li><a href="http://spatial.ala.org.au">Mapping &#038; analysis</a></li> <li class="last">Spatial Portal Dashboard</li></ol></nav>
        <section id="content-search">
            <h1>Spatial Portal Dashboard</h1>
        </section>
    </div><!--inner-->

</header>
<div class="inner">

    <div class="col-wide last" style="width:100%">


        <section id="dashboard-body">

            <div style="padding-bottom: 30px">
                <a class="button" href="javascript: history.go(-1)">&lt; Back to Dashboard</a>
            </div>

            <c:choose>
            <c:when test="${action != null}">

                <table id="actionviewtable">
                    <tbody>
                        <tr>
                            <td class="key">Name: </td>
                            <td>${action.service.name}</td>
                        </tr>
                        <tr>
                            <td>Type:</td>
                            <td>${action.type}</td>
                        </tr>
                        <tr>
                            <td>Process ID:</td>
                            <td>${action.service.processid}</td>
                        </tr>
                        <tr>
                            <td>Species:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:length(action.service.specieslsid) > 0}">
                                        <a href="http://bie.ala.org.au/species/${action.service.specieslsid}">${action.service.specieslsid}</a>
                                    </c:when>
                                    <c:otherwise>
                                        No species selected
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>Layers:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:length(action.service.layers) > 0}">
                                        <ul>
                                            <c:forEach var="u" items="${fn:split(action.service.layers, ':')}">
                                                <li><a href="/layers/more/${u}">${u}</a></li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No layers selected
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>Area WKT:</td>
                            <td>
                                <%--
                                <a href="#" id="button">Toggle Area WKT</a> <br />
                                <div id="areawkt" style="width: 650px; height: 300px; overflow: scroll; font-family: monospace; display: none">
                                    ${action.service.area}
                                </div>
                                --%>
                                <c:choose>
                                    <c:when test="${fn:length(action.service.area) > 0}">
                                        <div id="areawkt" style="max-height: 300px; overflow: auto; font-family: monospace">
                                            ${action.service.area}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        No area wkt available
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>Extra options:</td>
                            <td>${action.service.extra}</td>
                        </tr>
                        <tr>
                            <td>Status:</td>
                            <td>${action.service.status}</td>
                        </tr>
                        <tr>
                            <td>Time:</td>
                            <td>${action.time}</td>
                        </tr>
                        <tr>
                            <td>User IP:</td>
                            <td>${action.userip}</td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td>${action.email}</td>
                        </tr>
                        <tr>
                            <td>Application:</td>
                            <td>
                                <c:if test="${fn:length(action.appid) > 0}">
                                    <a href="/actions/app/${action.appid}">${action.appid}</a>
                                </c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>

            </c:when>
            <c:otherwise>
                <p>Log information not available</p>
            </c:otherwise>
        </c:choose>


    </section>

    <script>
        $(function() {
            function toggleWkt() {
                // most effect types need no options passed by default
                var options = {};

                // run the effect
                $( "#areawkt" ).toggle( "blind", options, 500 );
            };

            // set effect from select menu value
            $( "#button" ).click(function() {
                toggleWkt();
                return false;
            });
        });
    </script>


    </div><!--col-wide-->

</div><!--inner-->

<%@include file="common/bottom.jsp" %>