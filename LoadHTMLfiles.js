var xSensVal = [];
var ySensVal = [];
var myChartTmp;
var mychartHum;
var myChartPres;
var myChartFlowFlow;
var myChartFlowTmp;

var toTime;

function LoadFilesForWashing() {
    $("#mainHeader").load("../Atom/Heading.html");
    $("#mainButtons").load("../Atom/Buttons.html");
    $("#main_3_1").load("../Atom/WashingStarted.html");
    $("#main_3_2").load("../Atom/TimerDuration.html");
    $("#main_3_3").load("../Atom/TimerRemaining.html");
    $("#main_3_4").load("../Atom/WashingEnded.html");
    $("#main_4_1").load("../Atom/InfoFromSensors.html");
    $("#flowFlow").load("../Atom/ChartFlowFlow.html");
    $("#flowTmp").load("../Atom/ChartFlowtmp.html");
}

function LoadFlowChart() {
  $("#chartTmp").load("../Atom/ChartTmp.html");
  $("#chartHum").load("../Atom/ChartHum.html");
  $("#chartPres").load("../Atom/ChartPres.html");
}
