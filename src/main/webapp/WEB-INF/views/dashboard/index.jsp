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

        <section id="dashboard-head">

            <c:if test="${isAdmin}">
                <span style="float: right; padding-right: 30px">
                    <a class="button" href="/actions/logs">View all activity</a>
                </span>
            </c:if>

            <h3>Dashboard system for <c:out value="${useremail}" default="everybody" /></h3>

        </section>

        <section id="dashboard-body">
            <div id="tabs">
                <ul class="css-tabs">
                    <li>
                        <a href="#records">Actions</a>
                    </li>
                    <li>
                        <a href="#charts">Charts</a>
                    </li>
                    <li>
                        <a href="#sessions">Sessions</a>
                    </li>
                </ul>

                <div id="records" class="paneDiv">

                    <div id="panelwrapper">

                        <div id="panelSpecies" class="panel">
                            <div class="panelhead">Species</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Species']}">
                                        <c:set var="speciesList" value="${fn:split(types['Species'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${speciesList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(speciesList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/species">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No species available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panelArea" class="panel">
                            <div class="panelhead">Areas</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Area']}">
                                        <c:set var="areaList" value="${fn:split(types['Area'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${areaList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(areaList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/area">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No areas available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panelLayer" class="panel">
                            <div class="panelhead">Layers</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Layer']}">
                                        <c:set var="layerList" value="${fn:split(types['Layer'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${layerList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(layerList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/layer">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No layers available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panelTool" class="panel">
                            <div class="panelhead">Tools</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Tool']}">
                                        <c:set var="toolList" value="${fn:split(types['Tool'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${toolList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(toolList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/tool">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No tools available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panelImport" class="panel">
                            <div class="panelhead">Imports</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Import']}">
                                        <c:set var="importList" value="${fn:split(types['Import'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${importList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(importList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/import">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No imports available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panelExport" class="panel">
                            <div class="panelhead">Exports</div>
                            <div class="panelcontent">
                                <c:choose>
                                    <c:when test="${!empty types['Export']}">
                                        <c:set var="exportList" value="${fn:split(types['Export'],'|')}" />
                                        <ul>
                                            <c:forEach var="a" items="${exportList}" end="10">
                                                <li><a href="/actions/log/view/${fn:substringAfter(a,'-')}">${fn:substringBefore(a,'-')}</a></li>
                                            </c:forEach>
                                            <c:if test="${fn:length(exportList) > 10}">
                                                <li class="last"><a class="button" href="/actions/dashboard/types/export">view more...</a></li>
                                            </c:if>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        No exports available.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>

                </div> <!-- close tab 1 panel -->

                <div id="charts" class="paneDiv">
                    <div id="charts">
                        <div class="backLink" style="padding-top: 50px">Click a slice to drill into the next category</div>
                        <div id="breakdownChart"></div>
                        <div class="backLink" style="padding-bottom: 50px">Click a slice to drill into the next category</div>
                        <div id="areaChart"></div>
                        <div id="analysisChart"></div>
                        <div style="width: 700px; height: 500px;">
                            <div style="font-family: Verdana; font-size: 15px; font-weight: bold; padding: 5px ">Actions by Day</div>
                            <div id="actionsbyday" style="width: 700px; height: 390px;"></div>
                        </div>

                    </div>
                </div> <!-- close tab 2 panel -->

                <div id="sessions" class="paneDiv">
                    <table id="sessionstable">
                        <thead class="grey-bg">
                            <tr>
                                <th>Session</th>
                                <th>Species</th>
                                <th>Areas</th>
                                <th>Layers</th>
                                <th>Tools</th>
                                <th>Imports</th>
                                <th>Exports</th>
                                <th>Duration</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${sessions}" var="s" varStatus="status">
                                <tr>
                                    <td>${s.sessionid}</td>
                                    <td>${s.speciesCount}</td>
                                    <td>${s.areaCount}</td>
                                    <td>${s.layerCount}</td>
                                    <td>${s.toolCount}</td>
                                    <td>${s.importCount}</td>
                                    <td>${s.exportCount}</td>
                                    <td>${s.displaytime}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div> <!-- close tab 3 panel -->

            </div> <!-- tabs -->

        </section>

    </div><!--col-wide-->

</div><!--inner-->

<script type="text/javascript">
    // Jquery Document.onLoad equivalent
    $(document).ready(function() {

        // load the tabs
        $( "#tabs" ).tabs({
            show: function(event, ui) {
                console.log("showing: ");
                console.log(ui);
                if (ui.index == 1) {
                    if (chartApiLoaded) return false;
                    else {
                        loadCharts();
                        loadBreakdownByChart("category1");
                    }
                    backLink = $(".backLink");
                    backLink.click(function(){
                        // only act if link was real
                        if (!backLink.hasClass('link')) return;

                        backLink.html("Click a slice to drill into the next category.").removeClass('link');
                        loadBreakdownByChart("category1","");
                    });
                }
            }
        });
        
    }); // end JQuery document ready

    var chartApiLoaded = false;

    function loadCharts() {
        $.ajax({
            url: "/actions/actions/breakdown.json",
            dataType: 'json',
            timeout: 30000,
            complete: function(jqXHR, textStatus) {
                if (textStatus == 'timeout') {
                    alert('Sorry - the request was taking too long so it has been cancelled.');
                }
                if (textStatus == 'error') {
                    alert('Sorry - the chart cannot be redrawn due to an error.');
                }
                if (textStatus != 'success') {
                    //cleanUp(chartOptions);
                }
            },
            success: function(data) {
                // check for errors
                if (data == undefined || data.length == 0) {
                    //cleanUp(chartOptions);
                }
                else {
                    // draw the chart
                    //drawChart(data);
                    drawActionsByCharts(data);
                }
            }
        });
    }
    function loadBreakdownByChart(breakdown, by) {
        var url = "/actions/actions/breakdown/"+breakdown;
        if ($.trim(by) != "") {
            url += "/"+by
        }
        url += ".json";
        $.ajax({
            url: url,
            dataType: 'json',
            timeout: 30000,
            complete: function(jqXHR, textStatus) {
                if (textStatus == 'timeout') {
                    alert('Sorry - the request was taking too long so it has been cancelled.');
                }
                if (textStatus == 'error') {
                    alert('Sorry - the chart cannot be redrawn due to an error.');
                }
                if (textStatus != 'success') {
                    //cleanUp(chartOptions);
                }
            },
            success: function(data) {
                // check for errors
                if (data == undefined || data.length == 0) {
                    //cleanUp(chartOptions);
                }
                else {
                    // draw the chart
                    drawChart(data);
                    //drawActionsByCharts(data);
                }
            }
        });
        return;

    }
    function drawChart(data) {
        // create the breakdown table
        var breakdownTable = new google.visualization.DataTable();
        breakdownTable.addColumn('string', "category");
        breakdownTable.addColumn('number','records');
        $.each(data.breakdown, function(i,obj) {
            var label = "[na]";
            if (obj.label) {
                label = obj.label;
            }
            if (label != "") {
                breakdownTable.addRow([label, obj.count]);
            }
        });

        // create the area types table
        var areasTable = new google.visualization.DataTable();
        areasTable.addColumn('string', "areas");
        areasTable.addColumn('number','records');

        // create the analysis table
        var analysisTable = new google.visualization.DataTable();
        analysisTable.addColumn('string', "analysis");
        analysisTable.addColumn('number','records');


        //                        $.each(data.breakdown, function(i,obj) {
        //                            var label = obj.label;
        //                            if (label.indexOf("area") > -1) {
        //                                label = label.substr(7);
        //                            }
        //                            if (obj.label.indexOf("area") > -1) {
        //                                areasTable.addRow([label, obj.count]);
        //                            } else if ((label.indexOf("layers") == -1) && (label.indexOf("species") == -1) && (label.indexOf("user") == -1) && (label.indexOf("upload") == -1)) {
        //                                analysisTable.addRow([label, obj.count]);
        //                            }
        //
        //                        });

        // Set chart options
        var options = {'title':'Spatial Portal analysis breakdown',
            titleTextStyle: {
                fontName: 'Verdana',
                fontSize: 15
            },
            width:600,
            height:400,
            backgroundColor:'#FFFEF7',
            is3D: true
        };
        var areaOptions = {'title':'Area Usage',
            titleTextStyle: {
                fontName: 'Verdana',
                fontSize: 15
            },
            'width':600,
            'height':400,
            is3D: true
        };
        var analysisOptions = {'title':'Analysis Usage',
            titleTextStyle: {
                fontName: 'Verdana',
                fontSize: 15
            },
            'width':600,
            'height':400,
            is3D: true
        };

        // Instantiate and draw our chart, passing in some options.
        var breakdownChart = new google.visualization.PieChart(document.getElementById('breakdownChart'));
        breakdownChart.draw(breakdownTable, options);

        //                        if (!backLink.hasClass('link')) {
        //                            // show the prev link
        //                            backLink.html("&laquo; Previous category").addClass('link');
        //                        }
        //                        else {
        //                            // show the instruction
        //                            backLink.html("Click a slice to drill into the next category.").removeClass('link');
        //                        }


        google.visualization.events.addListener(breakdownChart, 'select', function() {
            if (backLink.hasClass('link')) return;
            var category = breakdownTable.getValue(breakdownChart.getSelection()[0].row,0);
            loadBreakdownByChart("category1", category);
            backLink.html("&laquo; Previous category").addClass('link');
        });

        //                        var areaChart = new google.visualization.PieChart(document.getElementById('areaChart'));
        //                        areaChart.draw(areasTable, areaOptions);
        //
        //                        var analysisChart = new google.visualization.PieChart(document.getElementById('analysisChart'));
        //                        analysisChart.draw(analysisTable, analysisOptions);

    }

    function drawActionsByCharts(data) {
        // actions by day
        var abdTable = new google.visualization.DataTable();
        abdTable.addColumn('date', "Date");
        //vbdTable.addColumn('string', "Visited on");
        abdTable.addColumn('number','Number of actions: ');
        $.each(data.actionsbyday, function(i,obj) {
            var label = obj.label;
            abdTable.addRow([new Date(label), obj.count]);
        });

        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('actionsbyday'));
        chart.draw(abdTable, {displayAnnotations: true, displayAnnotationsFilter: true, fill: 10, thickness: 2});

    }
</script>

<%@ include file="../common/bottom.jsp"%>