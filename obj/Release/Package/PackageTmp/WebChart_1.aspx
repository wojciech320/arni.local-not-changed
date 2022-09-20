<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebChart_1.aspx.cs" Inherits="arni.local.WebChart_1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
<link href="StyleSheets/Washing.css" rel="stylesheet" />    
    <style>
        .wrapper {
            display:grid;
            grid-template-columns: 0.5fr 3fr 1fr;            
            grid-auto-rows:minmax(200px, 400px);
        }
        .wrapper > div{
            background:#eee;
            padding:1em;
        }
/*        .box1{
            grid-column:1/3;
        }
        .box3{
            grid-column:1/3;
        }*/
</style>
    <title></title>
 
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
    <script>
        $(function () {
         /*   $("#includedContent").load("WashingStarted.html");*/
        })
    </script>
<script type="text/javascript">
    var xSens1Val = [];
    var ySens1Val = [];
    var xSens2Val = [];
    var ySens2Val = [];
    var myChart1;
    var myChart1;
    window.onload = function () {
        var ctx1 = document.getElementById('myChart1');
        var ctx2 = document.getElementById('myChart2');
        myChart1 = new Chart(ctx1, {
            outerWidth: 500,
            type: 'line',
            data: {
                labels: xSens1Val,
                datasets: [{
                    label: 'Rh %',
                    data: ySens1Val,
                    backgroundColor: 'rgba(255,26,104,0.2)',
                    borderColor: 'rgba(255,26,104,0.2)',
                    yAxisID: 'y',
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
                    }
                }
            }
        })
        myChart2 = new Chart(ctx2, {
            type: 'line',
            data: {
                labels: xSens2Val,
                datasets: [{
                    label: 'Rh %',
                    data: ySens2Val,
                    backgroundColor: 'rgba(255,26,104,0.2)',
                    borderColor: 'rgba(255,26,104,0.2)',
                    yAxisID: 'y',
                    tension: 0.4
                }]
            },
            options: {
                scales: {
                    y: {
                        type: 'linear',
                        backgroundColor: 'rgba(255,26,104,0.2)',
                        borderColor: 'rgba(255,26,104,0.2)',
                        position: 'left'
                    }
                }
            }
        })
    };

        function addData(lbl, yVal) {
            xValues.push(lbl);
            yValues.push(yVal);
            myChart1.update();
    };

    function getSensorValue1(sensorId, count) {
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
                        xSens1Val.push(dato.format("hh:mm:ss"));
                        ySens1Val.push($(this).find('SensorValue').text());
                    });
                } else {
                    $(xml).find('Sensor').each(function () {
                        var dato = new Date($(this).find('Timeing').text());
                        xSens1Val.push(dato.format("hh:mm:ss"));
                        ySens1Val.push($(this).find('SensorValue').text());
                        xSens1Val.shift();
                        ySens1Val.shift();
                    });
                }
                myChart1.update();
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

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="wrapper">
            <div class="box1">Menu</div>
            <div class="box2">Overview of the washing proceedure 
                <input type="button" id="startWashing" value="Start Washing"  style="background-color: #8DA8F5" />
            <br />


                            <div class="container2">
                                <div class="procedure">
                                    Washing started
                                </div>
                                <div></div>
                                <div class="dato">
                                    Date:
                                </div>
                                <div id="txtDate" class="txtDate">
                                    __/__/__
                                </div>
                                <div class="time">
                                    Time:
                                </div>
                                <div id="txtTime" class="txtTime">
                                    __:__
                                </div>
                            </div>

                            <span>Washing ended</span>

                        <span>Batch Id</span>
 
                        <span>Duration</span>

                        <span>Remaining time</span>

                        <span >SensorPoolID</span>


<%--                        <input id="txtStarted" type="text" value="" style="font-size: large; width: 200px" />--%>

                  
                        <input id="txtEnded" type="text" value="1/15/2022, 12:00:00 PM" style="font-size: large; width: 200px" />                        
           
                        <input id="txtBatchId" type="text" value="50200-22" style="font-size: large; width: 200px" />
 
                        <span id="txtDurHH" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtDurMM" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtDurSS" style="font-size: large; width: 200px" >00</span>
                   
                        <span id="txtRemHH" style="font-size: large; width: 200px" >02</span>
                        <span style="font-size: large;" >:</span>
                        <span id="txtRemMM" style="font-size: large; width: 200px" >00</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span id="txtRemSS" style="font-size: large; width: 200px" >00</span>

                       

                        <span style="font-size: large; width: 200px" >hh</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >mm</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >ss</span>

                        <span style="font-size: large; width: 200px" >hh</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >mm</span>
                        <span style="font-size: large; width: 100px" >:</span>
                        <span style="font-size: large; width: 200px" >ss</span>

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

            </div>

            <div class="box3">
                <canvas id="myChart1"  ></canvas>
                <button id="chartAddTmp" type="button" onclick="getData1('Env-001-02', '100', 'true' );">Update tmp chart</button>
                <input id="sensId1" value="Env-001-01" /><input id="sensId1Count" value="100" />
                <canvas id="myChart2"></canvas>
                <button id="chartAddHum" type="button" onclick="getData2('Env-001-03', '100', 'true' );" >Update humidity chart</button>
                <input id="sensId2" value="Env-001-03"/><input id="sensId2Count" value="100"/>
            </div>
            <div>1</div>
            <div>2</div>
            <div>3</div>
            <div>4</div>
            <div>5</div>
            <div>6</div>
        </div>

    </form>
</body>
</html>

