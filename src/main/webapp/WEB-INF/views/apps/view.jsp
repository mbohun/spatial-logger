<%@ include file="/WEB-INF/views/common/top.jsp"%>
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
            <c:when test="${app != null}">
                <p>
                    <span class="title">Name:</span> <br />
                    ${app.name}
                </p>
                <p>
                    <span class="title">AppID:</span> <br />
                    ${app.appid}
                </p>
                <p>
                    <span class="title">Description:</span> <br />
                    ${app.description}
                </p>
                <p>
                    <span class="title">Contact:</span> <br />
                    ${app.contact}
                </p>
                <p>
                    <span class="title">Organisation:</span> <br />
                    ${app.organisation}
                </p>
                <p>
                    <span class="title">Website:</span> <br />
                    <a href="${app.url}" target="_blank">${app.url}</a>
                </p>
                <p>
                    <span class="title">Email:</span> <br />
                    ${app.email}
                </p>
                <p>
                    <span class="title">Registration time:</span> <br />
                    ${app.regtime}
                </p>
                <p>
                    <span class="title">Status:</span> <br />
                    ${app.status}
                </p>
            </c:when>
            <c:otherwise>
                <p>No application information available</p>
            </c:otherwise>
        </c:choose>

    </section>


    </div><!--col-wide-->

</div><!--inner-->

<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
