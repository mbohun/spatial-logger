<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <div id="header">
        <h1>ALA WS Client Application list</h1>
    </div><!--close header-->

    <div class="section">

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

    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
