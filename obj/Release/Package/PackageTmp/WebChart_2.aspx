﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebChart_2.aspx.cs" Inherits="arni.local.WebChart_2" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Basic Grids</title>
    <link rel="shortcut icon" href="#" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script
      src="https://code.jquery.com/jquery-3.6.0.min.js"
      integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
      crossorigin="anonymous"
    ></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
    <script src="Washing/TimerFunctions.js"></script>
    <script src="..\Scripts\LoadHTMLfiles.js" charset="utf-8"></script>

      <script language="JScript">
          function testNotes() {
              //var s;
              //var dbdir;
              //var db;
              //var view;
              //var doc;
              //var forms = new Array(256);
              //////var s = CreateObject("Lotus.NotesSession");
              //////var s = new ActiveXObject("Lotus.NotesSession");
              //s = new ActiveXObject("Lotus.NotesSession");
              //s.Initialize();
              //dbdir = s.getDbDirectory("kerecis3/kerecis");
              //db = dbdir.openDatabase("QualityM.nsf");
              //view = db.getView("Groups");
              //doc = view.getFirstDocument();
              //forms = VBArray(doc.GetItemValue("Form")).toArray();
              //document.write(forms[0]);
          }
      </script>

    <script type="text/javascript">
        'use strict';
        var chartTmpLoaded = false;
        var chartHumLoaded = false;
        var chartPresLoaded = false;
        var chartFlowFlowLoaded = false;
        var chartFlowTmpLoaded = false;
        $(document).ready(function () {
            $('#testing').click(function () {
                testNotes();            
            });
            $('#tab').load('../Atom/Menu.html');
            $('#mainHeader').load('../Atom/Heading.html');
            $('#mainButtons').load('../Atom/Buttons.html');
            $('#main_3_1').load('../Atom/WashingStarted.html');
            $('#main_3_2').load('../Atom/TimerDuration.html');
            $('#main_3_3').load('../Atom/TimerRemaining.html');
            $('#main_3_4').load('../Atom/WashingEnded.html');
            $('#main_4_1').load('../Atom/InfoFromSensors.html');
            $('#flowFlow').load('../Atom/ChartFlowFlow.html', function () {
                chartFlowFlowLoaded = true;
                testLoaded();
            });

            $('#flowTmp').load('../Atom/ChartFlowtmp.html', function () {
                chartFlowTmpLoaded = true;
                testLoaded();
            });

            $('#chartTmp').load('../Atom/ChartTmp.html', function () {
                chartTmpLoaded = true;
                testLoaded();
            });

            $('#chartHum').load('../Atom/ChartHum.html', function () {
                chartHumLoaded = true;
                testLoaded();
            });

            $('#chartPres').load('../Atom/ChartPres.html', function () {
                chartPresLoaded = true;
                testLoaded();
            });

            function testLoaded() {
                if (
                    chartFlowFlowLoaded == true &&
                    chartFlowTmpLoaded == true &&
                    chartTmpLoaded == true &&
                    chartHumLoaded == true &&
                    chartPresLoaded == true
                ) {
                    LoadAllChartsContent();
                }
            }
        });
    </script>

    <!-- The container -->
    <style>
      .mainGrid {
        display: grid;
        grid-template-columns: 180px 3fr 2fr;
        column-gap: 3px;
        padding: 2px;
      }

      .menu {
        padding: 2px;
      }

      .menuItem {
        padding: 2px;
      }

      .main {
        display: grid;
        align-items: stretch;
        justify-content: stretch;
        grid-template-rows: minmax(30px, 45px) minmax(30px, 40px) 115px auto;
        row-gap: 5px;
      }

      .mainLines {
        justify-content: center;
      }

      .controls_1 {
        display: grid;
        grid-template-columns: auto auto auto auto;
        column-gap: 4px;
      }

      .controls_2 {
        display: grid;
        grid-template-columns: auto auto auto auto;
      }

      .main_4_1 {
        grid-column: 1 / span 4;
      }
      .charSpan {
        display: grid;
        grid-column: 1 / span 4;
        justify-content: stretch;
      }

      .envCharts {
        display: grid;
        row-gap: 5px;
      }
      .chart {
      }
    </style>
  </head>
  <body>
    <form id="form1" runat="server">
      <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <div id="mainContainer" class="mainGrid">
        <div class="menu">
          <div id="tab" class="menuItem"></div>
          <!-- <div "menuButtons" class="menuItem">  </div> -->
        </div>
        <div class="main">
          <!-- Header -->
          <div id="mainHeader" class="mainLines"></div>
          <!-- Buttons -->
          <div id="mainButtons" class="mainLines"></div>
          <!-- Controls Section 1 -->
          <div id="mainControls_1" class="mainLines controls_1">
            <div id="main_3_1" class=""></div>
            <div id="main_3_2" class=""></div>
            <div id="main_3_3" class=""></div>
            <div id="main_3_4" class=""></div>
          </div>
          <!-- Controls Section 2 -->
          <div id="mainControls_2" class="mainLines controls_2">
            <div id="main_4_1" class="main_4_1"></div>
            <!-- <div id="c_2_2" class="">c2 </div>
          <div id="c_2_3" class="">c3 </div>
          <div id="c_2_4" class="">c4 </div> -->
          </div>
          <!-- Charts -->
          <div class="">
            <div id="flowFlow" class="charSpan"></div>
            <div id="flowTmp" class="charSpan"></div>
          </div>
        </div>
        <div class="envCharts">
          <!-- Chart 1 -->
          <div id="chartTmp" class="chart"></div>
          <!-- Chart 2 -->
          <div id="chartHum" class="chart"></div>
          <!-- Chart 3 -->
          <div id="chartPres" class="chart"></div>
        </div>
      </div>
        <button id="testing">Test Lotus Notes</button>
    </form>
  </body>
</html>



