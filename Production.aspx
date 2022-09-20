<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<script
    src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
        crossorigin="anonymous">
</script>
<script
    src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js">
</script>
 
<script src="Washing/Washing.js"></script>
<script src="Washing/TimerFunctions.js"></script>    
    <script type="text/javascript" >

        setInterval(function () {
            countDown();
            //getSensorValue(1);
        }, 1000);

            function timeLapsed() {
                var timeStart = new Date($("#txtStarted").val());
                var dato = new Date();
                var days = parseInt((dato - timeStart) / (1000 * 60 * 60 * 24));
                var hours = parseInt(Math.abs(dato - timeStart) / (1000 * 60 * 60) % 24);
                var minutes = parseInt(Math.abs(dato.getTime() - timeStart.getTime()) / (1000 * 60) % 60);
                var seconds = parseInt(Math.abs(dato.getTime() - timeStart.getTime()) / (1000) % 60);
                if (hours.toString().length == 1) {
                    hours = "0" + hours;
                }
                if (minutes.toString().length == 1) {
                    minutes = "0" + minutes;
                }
                if (seconds.toString().length == 1) {
                    seconds = "0" + seconds;
                    //alert(seconds - $("#txtRemSS").text());
                }
                $("#txtDurSS").text(seconds);
                $("#txtDurMM").text(minutes);
                $("#txtDurHH").text(hours);
            }
        
    </script>
<script type="text/javascript">
    var yValues = [];
    var xValues = [];
    var yValpress = [];
    var tmpValues = [];
    var myChart;
    window.onload = function () {
        //var date1 = new Date("Jan 14 2022 07: 20: 39");
        //var date2 = new Date("Jan 14 2022 07: 21: 39");
        //var date3 = new Date("Jan 14 2022 07: 22: 39");
        //var date4 = new Date("Jan 14 2022 07: 24: 39");
        var ctx = document.getElementById('myChart');

        //yValpress = [{ y: 1000, x: date1.format("hh:mm:ss") },
        //    { y: 1050, x: date2.format("hh:mm:ss") },
        //    { y: 1250, x: date3.format("hh:mm:ss") },
        //    { y: 700, x: date4.format("hh:mm:ss") }];
        myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: xValues,
                datasets: [{
                    label: 'Rh %',
                    data: yValues,
                    backgroundColor: 'rgba(255,26,104,0.2)',
                    borderColor: 'rgba(255,26,104,0.2)',
                    yAxisID: 'y',
                    tension: 0.4
                },{
                    label:'Temperature °C',
                    data: yValpress,
                    backgroundColor: 'rgba(0,26,104,0.2)',
                    borderColor: 'rgba(0,26,104,0.2)',
                    yAxisID: 'temperature',
                    tension: 0.4
                }]
            },
            options: {
                scales: {
                    y: {
                        type: 'linear',
                        backgroundColor: 'rgba(255,26,104,0.2)',
                        borderColor: 'rgba(255,26,104,0.2)',
                        position:'left'
                    },
                    temperature: {
                        type: 'linear',
                        backgroundColor: 'rgba(0,26,104,0.2)',
                        borderColor: 'rgba(0,26,104,0.2)',
                        position: 'right'
                    }
                }
            }
        })
    };

        function addData(lbl, yVal) {
            xValues.push(lbl);
            yValues.push(yVal);
            myChart.update();
    };

    function getSensorValue1(sensorId, count) {
        //var sensId = "Env-001-02";
        $.ajax({
            url: "Sensors.asmx/GetLatestSensorValue",
            data: { sensorId: sensorId, Scount: count },
            method: "post",
            dataType: "xml", //"json",
            error: function (request, status, error) {
                alert(request.responseText);
            },
            success: function (xml) {
                if (count > 1) {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        xValues.push(dato.format("hh:mm:ss"));
                        yValues.push($(this).find('SensorValue').text());
                    });
                } else {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        xValues.push(dato.format("hh:mm:ss"));
                        yValues.push($(this).find('SensorValue').text());
                        xValues.shift();
                        yValues.shift();
                    });
                }
                myChart.update();
            },
        });
    };
    function getSensorValue2(sensorId, count) {
        $.ajax({
            url: "Sensors.asmx/GetLatestSensorValue",
            data: { sensorId: sensorId, Scount: count },
            method: "post",
            dataType: "xml", //"json",
            error: function (request, status, error) {
                alert(request.responseText);
            },
            success: function (xml) {
                if (count > 1) {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        //xValues.push(dato.format("hh:mm:ss"));
                        yValpress.push($(this).find('SensorValue').text());
                    });
                } else {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        xValues.push(dato.format("hh:mm:ss"));
                        yValues.push($(this).find('SensorValue').text());
                        xValues.shift();
                        yValues.shift();
                    });
                }
                myChart.update();
            },
        });
    };
    function getData1(sensorId, count, tmp) {
        getSensorValue1(sensorId, $("#sensId1Count").val());
        //getTwoSensorValues(sensorId, count, tmp);
    };
    function getData2(sensorId, count, tmp) {
        getSensorValue2(sensorId, $("#sensId2Count").val());
        //getTwoSensorValues(sensorId, count, tmp);
    };
    var yTmpValues = [];
    var xTmpValues = [];
    var yHumValues = [];
    var xHumValues = [];
    function getTwoSensorValues(sensorId, count, tmp) {
        $.ajax({
            url: "Sensors.asmx/GetLatestSensorValue",
            data: { sensorId: sensorId, Scount: count },
            method: "post",
            dataType: "xml",
            error: function (request, status, error) {
                alert(request.responseText);
            },
            success: function (xml) {
                if (tmp) {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        //tmpValues.push = { x: dato.format("hh:mm:ss"), y: $(this).find('SensorValue').text() };
                        xTmpValues.push(dato.format("hh:mm:ss"));
                        yTmpValues.push($(this).find('SensorValue').text());
                    });
                } else {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        //xHumValues.push(dato.format("hh:mm:ss"));
                        yHumValues.push($(this).find('SensorValue').text());
                    });
                }
                //if (upDate) {
                myChart.update();
                //}
            },
        });
    }
</script>

    <style type="text/css">
        .auto-style1 {
            width: 200px;
        }
        .auto-style2 {
            width: 200px;
            font-weight: 500;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div>
            <div >
                <canvas id="myChart" width="800" height="400"></canvas>
                <button id="chartAddTmp" type="button" onclick="getData1('Env-001-02', '100', 'true' );" >Update tmp chart</button>
                <input id="sensId1" value="Env-001-01"/><input id="sensId1Count" value="100"/>
                <button id="chartAddHum" type="button" onclick="getData2('Env-001-03', '100', 'true' );" >Update humidity chart</button>
                <input id="sensId2" value="Env-001-03"/><input id="sensId2Count" value="100"/>
            </div>

            <input type="button" id="startWashing" value="Start Washing"  style="background-color: #8DA8F5" />
            <br />
            <br />
            <table style="border-style: solid; border-width: 2px">
                <tr>
                    <td>
                        <span id="test">Washing started</span>
                    </td>
                    <td>
                        <span>Washing ended</span>
                    </td>
                    <td>
                        <span>Batch Id</span>
                    </td>
                    <td style="text-align: center" class="auto-style2">
                        <span>Duration</span>
                    </td>
                    <td style="text-align: center" class="auto-style2">
                        <span>Remaining time</span>
                    </td>
                    <td>
                        <span >SensorPoolID</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input id="txtStarted" type="text" value="" style="font-size: large; width: 200px" />
                    </td>
                    <td>
                        <input id="txtEnded" type="text" value="1/15/2022, 12:00:00 PM" style="font-size: large; width: 200px" />                        
                    </td>
                    <td>
                        <input id="txtBatchId" type="text" value="50200-22" style="font-size: large; width: 200px" />
                    </td>
                    <td style="text-align: center" class="auto-style2">
                        <span id="txtDurHH" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtDurMM" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtDurSS" style="font-size: large; width: 200px" >00</span>
                    </td>
                    <td style="text-align: center" class="auto-style1">
                        <span id="txtRemHH" style="font-size: large; width: 200px" >02</span>
                        <span style="font-size: large;" >:</span>
                        <span id="txtRemMM" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtRemSS" style="font-size: large; width: 200px" >00</span>
                    </td>
                    <td><span id="txtSensorPoolID" >1</span>
                        &nbsp;</td>
                </tr>
                                <tr>
                    <td>
                       
                    </td>
                    <td>
                       
                    </td>
                    <td>
                        
                    </td>
                    <td style="text-align: center" class="auto-style2">
                        <span style="font-size: large; width: 200px" >hh</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >mm</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >ss</span>
                    </td>
                    <td style="text-align: center" class="auto-style1">
                        <span style="font-size: large; width: 200px" >hh</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >mm</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >ss</span>
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
            </table>
            <br />
            <br />
            <table>
                <tr>
                    <td>
                        <span>Flow</span>
                    </td>
                    <td>
                        <span>Temperature</span>
                    </td>
                    <td>
                        <span>Pressure</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input id="txtFlow" value="l/min"  style="font-size: large; width: 200px" />
                    </td>
                    <td>
                        <input id="txtTemp" value="°C" style="font-size: large; width: 200px" />
                    </td>
                    <td>
                        <input id="txtPressure" value="bar" style="font-size: large; width: 200px" />
                    </td>
                </tr>
            </table>
            <input type="button" id="loadHtml" value="Load HTML doc"  style="background-color: #8DA8F5" /><br />
            <br />
            <div style="width:50%;">
                <canvas id="mycanvas"></canvas>
            </div>
&nbsp;<div id="testing"></div>
        </div>
    </form>
</body>
</html>
