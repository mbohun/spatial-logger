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

            <span style="float: right; padding-right: 30px">
                <a class="button" href="/actions/dashboard">Dashboard</a>
                <a class="button" href="/actions/logs.csv" id="downloadcsv">Download</a>
            </span>

            <c:choose>
                <c:when test="${fn:length(actions) > 0}">
                    <div id="resultsReturned">
                        <strong>${fn:length(actions)}</strong> actions returned
                    </div>

                    <div id="tabs">
                        <ul class="css-tabs">
                            <li>
                                <a href="#records">Records</a>
                            </li>
                            <li>
                                <a href="#charts">Charts</a>
                            </li>
                            <li>
                                <a href="#sessions">Sessions</a>
                            </li>
                        </ul>
                        <div id="records" class="paneDiv">
                            <table id="actionstable">
                                <thead class="grey-bg">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Time</th>
                                        <th>Analysis type</th>
                                        <th>Status</th>
                                        <th>Email</th>
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
                                            <td>${action.email}</td>
                                            <td>${action.userip}</td>
                                            <td>${action.sessionid}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

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
                        </div>

                        <div id="sessions" class="paneDiv">
                            <table id="sessionstable">
                                <thead class="grey-bg">
                                    <tr>
                                        <th>Email</th>
                                        <th>User IP</th>
                                        <th>Session</th>
                                        <th>Species</th>
                                        <th>Areas</th>
                                        <th>Layers</th>
                                        <th>Tools</th>
                                        <th>Imports</th>
                                        <th>Exports</th>
                                        <th>Start</th>
                                        <th>End</th>
                                        <th>Duration (mins)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${sessions}" var="s" varStatus="status">
                                        <tr>
                                            <td>${s.email}</td>
                                            <td>${s.userip}</td>
                                            <td>${s.sessionid}</td>
                                            <td>${s.speciesCount}</td>
                                            <td>${s.areaCount}</td>
                                            <td>${s.layerCount}</td>
                                            <td>${s.toolCount}</td>
                                            <td>${s.importCount}</td>
                                            <td>${s.exportCount}</td>
                                            <td>${s.startTime}</td>
                                            <td>${s.endTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${s.totaltime eq 0}">
                                                        0.01
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber type="number" maxFractionDigits="2" value="${s.totaltime/60}" groupingUsed="false" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                    </div> <!-- tabs -->

                    <style type="text/css">
                        ul.css-tabs {
                            list-style: none;
                            margin: 0;
                            padding: 0;
                        }

                        ul.css-tabs li {
                            display: inline;
                        }

                        ul.css-tabs li a {
                            padding: 3px 5px;
                            background-color: #DA471E;
                            color: #fff;
                            text-decoration: none;
                        }

                        ul.css-tabs li a.selected,
                        ul.css-tabs li a:hover {
                            background-color: #3D464C;
                            color: #fff;
                            padding-top: 7px;
                        }

                        ul.css-tabs li a:focus {
                            outline: 0;
                        }

                        div#tabs > div {
                            padding: 5px;
                            margin-top: 3px;
                        }

                        div#tabs > div h2 {
                            margin-top: 0;
                        }
                    </style>
                    <script>
                        // Jquery Document.onLoad equivalent
                        $(document).ready(function() {

                            // load the tabs
                            //                            $( "#tabs" ).tabs({
                            //                                show: function(event, ui) {
                            //                                    setDownloadUrl(ui.index);
                            //                                    if (ui.index == 1) {
                            //                                        if (chartApiLoaded) return false;
                            //                                        else {
                            //                                            loadCharts();
                            //                                            loadBreakdownByChart("category1");
                            //                                        }
                            //                                    }
                            //                                    backLink = $(".backLink");
                            //                                    backLink.click(function(){
                            //                                        // only act if link was real
                            //                                        if (!backLink.hasClass('link')) return;
                            //
                            //                                        backLink.html("Click a slice to drill into the next category.").removeClass('link');
                            //                                        loadBreakdownByChart("category1","");
                            //                                    });
                            //                                }
                            //                            });


                            var tabContainers = $('div#tabs > div');
                            tabContainers.hide().filter(':first').show();

                            $('div#tabs ul.css-tabs a').click(function () {
                                tabContainers.hide();
                                tabContainers.filter(this.hash).show();
                                $('div#tabs ul.css-tabs a').removeClass('selected');
                                $(this).addClass('selected');

                                setDownloadUrl(this.hash);

                                if (this.hash == "#charts") {
                                    loadCharts();
                                    loadBreakdownByChart("category1");
                                    backLink = $(".backLink");
                                    backLink.click(function(){
                                        // only act if link was real
                                        if (!backLink.hasClass('link')) return;

                                        backLink.html("Click a slice to drill into the next category.").removeClass('link');
                                        loadBreakdownByChart("category1","");
                                    });

                                }

                                return false;
                            }).filter(':first').click();


                            // setup the table
                            $('#actionstable').dataTable({
                                "aaSorting": [[ 2, "desc" ]],
                                "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                                "sPaginationType": "full_numbers",
                                "sDom": 'T<"clear"><"sort-options"fl<"clear">>rt<"sort-options"ip<"clear">>',
                                "oLanguage": {
                                    "sSearch": ""
                                }
                            });
                            $('#sessionstable').dataTable({
                                "aaSorting": [[ 8, "desc" ]],
                                "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                                "sPaginationType": "full_numbers",
                                "sDom": 'T<"clear"><"sort-options"fl<"clear">>rt<"sort-options"ip<"clear">>',
                                "oLanguage": {
                                    "sSearch": ""
                                }
                            });
                            $("div.dataTables_filter input").attr("placeholder", "Filter within results");

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

                        function setDownloadUrl(tab) {
                            // tab 2 is the Sessions tab
                            if (tab=="#sessions") {
                                $('#downloadcsv').attr("href","/actions/sessions.csv");
                            } else {
                                $('#downloadcsv').attr("href","/actions/logs.csv");
                            }
                        }

                    </script>

                </c:when>
                <c:otherwise>
                    <p>No logs available</p>
                </c:otherwise>
            </c:choose>

        </section> <!-- section -->

    </div><!--col-wide-->

</div><!--inner-->

<%@include file="common/bottom.jsp" %>