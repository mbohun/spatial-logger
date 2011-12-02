<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <c:choose>
        <c:when test="${!empty pageContext.request.remoteUser}">
            <div id="loginId">You are logged in as: ${pageContext.request.remoteUser}</div>
        </c:when>
        <c:otherwise>
            <div id="loginId">No user logged in.</div>
        </c:otherwise>
    </c:choose>
    <div id="header">
        <h1>ALA WS Client Application list</h1>
    </div><!--close header-->

    <div class="section">

        <span style="float: right; padding-right: 30px">
            <a href="/actions/dashboard">Dashboard</a>
        </span>

        <c:choose>
            <c:when test="${fn:length(actions) > 0}">
                <div id="resultsReturned">
                    <strong>${fn:length(actions)}</strong> actions returned
                </div>

                <div id="tabs">
                    <ul class="css-tabs">
                        <li>
                            <a href="#tabs-1">Records</a>
                        </li>
                        <li>
                            <a href="#tabs-2">Charts</a>
                        </li>
                        <li>
                            <a href="#tabs-3">Sessions</a>
                        </li>
                    </ul>
                    <div id="tabs-1" class="paneDiv">
                        <table id="actionstable" width="98%" border="1">
                            <thead class="grey-bg">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Time</th>
                                    <th>Analysis type</th>
                                    <th>Status</th>
                                    <th>User IP</th>
                                    <th>Session ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${actions}" var="action" varStatus="status">
                                    <tr>
                                        <td>${action.id}</td>
                                        <td><a href="/actions/log/view/${action.id}">${action.service.name}</a></td>
                                        <td>${action.time}</td>
                                        <td>${action.category1}</td>
                                        <td>${action.service.status}</td>
                                        <td>${action.userip}</td>
                                        <td>${action.sessionid}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div id="tabs-2" class="paneDiv">
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
                    </div>

                    <div id="tabs-3" class="paneDiv">
                        <table id="sessionstable" width="98%" border="1">
                            <thead class="grey-bg">
                                <tr>
                                    <th>Session</th>
                                    <th>Species</th>
                                    <th>Layers</th>
                                    <th>Areas</th>
                                    <th>Tools</th>
                                    <th>Imports</th>
                                    <th>Exports</th>
                                    <th>Time spent</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${sessions}" var="s" varStatus="status">
                                    <tr>
                                        <td>${s.sessionid}</td>
                                        <td>${s.speciesCount}</td>
                                        <td>${s.layerCount}</td>
                                        <td>${s.areaCount}</td>
                                        <td>${s.toolCount}</td>
                                        <td>${s.importCount}</td>
                                        <td>${s.exportCount}</td>
                                        <td>${s.displaytime}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>

                <script>
                    // Jquery Document.onLoad equivalent
                    $(document).ready(function() {

                        // load the tabs
                        $( "#tabs" ).tabs({
                            show: function(event, ui) {
                                if (ui.index == 1) {
                                    if (chartApiLoaded) return false;
                                    else {
                                        loadCharts();
                                        loadBreakdownByChart("category1");
                                    }
                                }
                                backLink = $(".backLink");
                                backLink.click(function(){
                                    // only act if link was real
                                    if (!backLink.hasClass('link')) return;

                                    backLink.html("Click a slice to drill into the next category.").removeClass('link');
                                    loadBreakdownByChart("category1","");
                                });
                            }
                        });

                        // setup the table
                        $('#actionstable').dataTable( {
                            "aaSorting": [[ 2, "desc" ]]
                        } );

                    }); // end JQuery document ready

                    var chartApiLoaded = false;
                    
                    function loadCharts() {
                        $.ajax({
                            url: "/actions/actions/breakdown.json?usr=all",
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
                        url += ".json?usr=all";
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
                            'width':600,
                            'height':400,
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
                            if(category=="Species") {
                                alert("No breakdowns available for Species");
                            } else {
                                loadBreakdownByChart("category1", category);
                                backLink.html("&laquo; Previous category").addClass('link');
                            }
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

            </c:when>
            <c:otherwise>
                <p>No logs available</p>
            </c:otherwise>
        </c:choose>

    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
