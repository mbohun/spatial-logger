<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <div id="header">
        <h1>ALA WS Client Application list</h1>
    </div><!--close header-->

    <div class="section">

        <p><a href="../app/new">Create</a> a new application</p>

        <c:choose>
            <c:when test="${fn:length(apps) > 0}">
                <p>Got ${fn:length(apps)} applications</p>
                <table width="50%" border="1">
                    <thead class="grey-bg">
                        <tr>                            
                            <th>Name</th>
                            <th>Organisation</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${apps}" var="app" varStatus="status">
                            <tr>
                                <td><a href="../app/${app.appid}">${app.name}</a></td>
                                <td>${app.organisation}</td>
                                <td>${app.status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>No applications available</p>
            </c:otherwise>
        </c:choose>

    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
