<%@include file="../common/top.jsp" %>
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

        </section>

    </div><!--col-wide-->

</div><!--inner-->
<%@ include file="../common/bottom.jsp"%>