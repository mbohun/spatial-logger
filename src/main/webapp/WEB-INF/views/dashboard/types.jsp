<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <div id="header">
        <h1>ALA Spatial Dashboard</h1>
    </div><!--close header-->

    <div class="section">

        <h3>Dashboard system for <c:out value="${useremail}" default="everybody" /></h3>

        <c:choose>
            <c:when test="${!empty types}">
                <c:set var="typeList" value="${fn:split(types[key],'|')}" />
                <ul>
                    <c:forEach var="a" items="${typeList}">
                        <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                No category information available. Please head back to the <a href="/actions/dashboard">dashboard</a>.
            </c:otherwise>
        </c:choose>

    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>