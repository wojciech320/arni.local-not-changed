<%@ Page Language="C#" AutoEventWireup="true"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta charset="utf-8" />
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous">
</script>
    <script>
        //Call the yourAjaxCall() function every 1000 millisecond
        //setInterval("getSensorInfo()", 22000);
    </script>
    <script type="text/javascript">
        var chart;
        //var dateNow = new Date();
        window.onload = function () {
            //alert("rendering chart");
                chart = new CanvasJS.Chart("chartContainer", 
                theme: "theme2",//theme1
                title: {
                    text: "Basic Column Chart - CanvasJS"
                },
                animationEnabled: true,   // change to true
                data: [
                    {
                        // Change type to "bar", "area", "spline", "pie",etc.
                        type: "column",
                        dataPoints: [
                            //{ label: "apple", y: 10 },
                            //{ label: "orange", y: 15 },
                            //{ label: "banana", y: 25 },
                            //{ label: "mango", y: 30 },
                            //{ label: "grape", y: 28 }
                        ]
                    }
                ]
            });
            chart.render();           
        };

        setInterval(function () {
            getSensorValue();
        }, 1000);
        var postId = 0;
        var valueRh = 0;
        var xValue = 0;

        function upDateChart(xVal, yVal) {
            //label: "apple", y: 10
            chart.data[0].dataPoints.push({ label: xVal, y: yVal });
            //chart.data[0].dataPoints.push({ x: xValue, y: yVal });
            if (chart.data[0].dataPoints.length > 20) {
                //chart.data[0].dataPoints.push({ x: data[0][20], y: data[0][21] });
                chart.data[0].dataPoints.shift();
            }
            //}
            // re-render the chart
            xValue++;
            chart.render();
            //chart.update();
        };

        function getSensorValue() {
            var sensId = "Env-001-02"; //$("Env-001-02").val();
            $.ajax({
                url: "Sensors.asmx/GetLatestSensorValue",
                data: { sensorId: sensId },
                method: "post",
                dataType: "xml",
                error: function (request, status, error) {
                    alert(request.responseText);
                },
                success: function (data, textStatus, XmlHttpRequest) {
                    timeVal = $(XmlHttpRequest.responseText).find("Timeing").text();
                    $("#txtID").text(timeVal);
                    valueRh = $(XmlHttpRequest.responseText).find("SensorValue").text();
                    $("#txtValue").text(valueRh + " Rh");
                    upDateChart(timeVal, parseFloat(valueRh));
                },
            });
        };

        //function getSensorValue() {
        //    var sensId = $("#txtId").val();
        //    $.ajax({
        //        url: "DataSave.asmx/spGetSensorLatestValue",
        //        data: { sensorId: sensId },
        //        method: "post",
        //        dataType: "xml",
        //        error: function (request, status, error) {
        //            alert(request.responseText);
        //        },
        //        success: function (data, textStatus, XmlHttpRequest) {
        //            $("#txtID").text($(XmlHttpRequest.responseText).find("SensorID").text());
        //            $("#txtValue").text($(XmlHttpRequest.responseText).find("SensorValue").text() + " Rh");
        //        },
        //    });
        //};
        //function getSensorInfo() {
        //        var sensId = $("#txtId").val();
        //        $.ajax({
        //            url: "DataSave.asmx/spGetSensorLatestValue",
        //            data: {sensorId : sensId},
        //            method: "post",
        //            dataType: "xml",
        //            error: function (request, status, error) {
        //                alert(request.responseText);
        //            },
        //            success: function (data, textStatus, XmlHttpRequest) {
        //                $("#txtID").text($(XmlHttpRequest.responseText).find("SensorID").text());
        //                $("#txtName").text($(XmlHttpRequest.responseText).find("SensorName").text());
        //                $("#txtValue").text($(XmlHttpRequest.responseText).find("SensorValue").text() + " Rh");
        //            },
        //        });
        //    };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Timer ID="Timer1" runat="server"></asp:Timer>            
            ID : <input id="txtId" type="text" value="100" />
            <input type="button" id="btnGetSensorInfo" value="Get sensor info" />
            <br />
            <span id="txtID" >500</span>
            <br />
            <span id="txtName" >test</span>
            <br />
            <span id="txtValue" >Rh</span>
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
    </form>
        <button class="btn btn-success" onclick="getSensorValue()">Server data for chart update</button>
    <br />
            <button class="btn btn-success" onclick="upDateChart()">Update chart</button>
    <span typeof="button"></span>
    <div id="chartContainer"></div>
</body>
</html>
