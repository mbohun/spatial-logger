<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <div id="header">
        <h1>Action information</h1>
    </div><!--close header-->

    <div class="section">

        <c:choose>
            <c:when test="${action != null}">

                <p>
                    <span class="title">Name:</span> <br />
                    ${action.service.name}
                </p>
                <p>
                    <span class="title">Type:</span> <br />
                    ${action.type}
                </p>
                <p>
                    <span class="title">Species:</span> <br />
                    <c:if test="${fn:length(action.service.specieslsid) > 0}">
                        <a href="http://bie.ala.org.au/species/${action.service.specieslsid}">${action.service.specieslsid}</a>
                    </c:if>
                </p>
                <p>
                    <span class="title">Layers:</span> <br />
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
                </p>
                <p>
                    <span class="title">Extra options:</span> <br />
                    ${action.service.extra}
                </p>
                <p>
                    <span class="title">Status:</span> <br />
                    ${action.service.status}
                </p>
                <p>
                    <span class="title">Time:</span> <br />
                    ${action.time}
                </p>
                <p>
                    <span class="title">App:</span> <br />
                    <c:if test="${fn:length(action.appid) > 0}">
                        <a href="/actions/app/view/${action.appid}">${action.appid}</a>
                    </c:if>
                </p>
                <p>
                    <span class="title">User IP:</span> <br />
                    ${action.userip}
                </p>
                <p>
                    <span class="title">Email:</span> <br />
                    ${action.email}
                </p>
            </c:when>
            <c:otherwise>
                <p>Log information not available</p>
            </c:otherwise>
        </c:choose>


    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
