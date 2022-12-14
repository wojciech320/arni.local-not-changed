<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Computers.aspx.cs" Inherits="arni.local.Computers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Computers & Sensors</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous"
  ></script>
  <script src="Washing/TimerFunctions.js"></script>
  <script type="text/javascript">
      $(document).ready(function () {
          $('#loadComputers').click(function () {
              getComputers(1000);
          });
          $('#loadSensors').click(function () {
              getSensors(1000);
          });
          $("#saveComputer").click(function () {
              saveComputerData();
          });
          $("#insertNewComputer").click(function () {
              saveNewComputerData();
          });
          $("#saveSensor").click(function () {
              saveSensorData();
          });
          $("#insertNewSensor").click(function () {
              saveNewSensorData();
          });
          $("#atachSensorToComputer").click(function () {
              atachSensor($("#ComputerId").text(), $("#Sensor_ID").val());
          });
          $("#deletAtachment").click(function () {
              deletAtachment($("#ComputerId").text(), $("#Sensor_ID").val());
          });          
      });
  </script>
  <style>
  .mainContainer {
    display: grid;
    grid-template-columns: 220px 1fr 220px 1fr;
    padding-left: 30px;
    padding-top: 70px;
  }

  .container1 {
    background-color: lightgray;
    border-color: #cc3300;
    width: 220px;
    /* height: 500px; */
    /*display: none;*/
    /* scroll-behavior: auto; */
  }

  .container2 {
      display: grid;
      /*grid-template-rows: 30px 30px 60px 30px 30px 60px auto;*/
      grid-template-rows: auto auto auto auto auto auto auto;
      row-gap: 5px;
      /* padding: 5px; */
      background-color: #ddd;
      border-color: #cc3300;
      padding: 30px;
      top: 100px;
      left: 300px;
      width: 400px;
      height: 500px;
    /*display: none;*/
  }
  .item {
      padding: 5px;
      background-color: gainsboro;
  }
  .inputs {
      border-radius: 5px;
    /* width: 150px; */
    /* height: 100px; */
  }

  .content {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }

  .atachedSensors {
    border: 2px solid rgb(13, 76, 245);    
  }

.atachedItem{
    cursor: pointer;
}

.atachedItem:hover{
color:#fff;
background-color: #ccc;
}
</style>

<style>

  /* Tooltip container */
  .tooltip {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
  }

  /* Tooltip text */
  .tooltip .tooltiptext {
    visibility: hidden;
    width: 300px;
    background-color: #555;
    color: #fff;
    text-align: center;
    padding: 5px 0;
    border-radius: 6px;

    /* Position the tooltip text */
    position: absolute;
    z-index: 1;
    bottom: 125%;
    left: 50%;
    margin-left: -60px;

    /* Fade in tooltip */
    opacity: 0;
    transition: opacity 0.3s;
  }

  /* Tooltip arrow */
  .tooltip .tooltiptext::after {
    content: "";
    position: absolute;
    top: 100%;
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: #555 transparent transparent transparent;
  }

  /* Show the tooltip text when you mouse over the tooltip container */
  .tooltip:hover .tooltiptext {
    visibility: visible;
    opacity: 1;
  }
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <div class="mainContainer">
        <div id="selectionC" class="container1"></div>
    <div class="container2">
        <div>
          <span>Name</span><br /><input id="NameC" class="inputs" type="text" name="" value="" style="width: 150px;" />
          <span>Id: </span><span id="ComputerId" style="background-color: rgb(40, 137, 207);" >Id</span>
        </div>
        <div>
          <span>Type</span> <br /> <input id="TypeC" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Discription</span><br /><textarea id="DiscriptionC" class="inputs" type="text" name="" value="" style="width: 250px; height: 60px;"  ></textarea>
        </div>
      <div class="content">
      <div>
        <div>
          <span>Located</span><br /><input id="LocatedC" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Address</span><br /><input id="AddressC" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Activated</span><br /><input id="ActivatedC" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
      </div>
      <div>
        <!-- atatched sensors -->
          <span>Atached Sensors</span>
          <div id="selectAtachedSensors" class="atachedSensors">          
          </div>
          <button id="deletAtachment" class="inputs" >Delete Atachment</button>
      </div>
      </div>
        <div>
          <span>Log</span><br /><textarea id="LogC" class="inputs" type="text" name="" value="" style="width: 250px; height: 60px;" ></textarea>
        </div>
        <div>
          <button id="saveComputer" class="inputs" type="button" name="button">Save changes</button>
          <button id="insertNewComputer" class="inputs" type="button" name="button">Save new computer</button>
        </div>
    </div>
    <div id="selectionS" class="container1"></div>
    <div class="container2">
        <div>
          <span>Name</span><br /><input id="NameS" class="inputs" type="text" name="" value="" style="width: 150px;" />
          <span>Id: </span><input class="inputs" id="Sensor_ID" />
        </div>
        <div>
          <span>Type</span> <br /> <input id="TypeS" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Discription</span><br /><textarea id="DiscriptionS" class="inputs" type="text" name="" value="" style="width: 250px; height: 60px;"  ></textarea>
        </div>
        <div>
          <span>Located</span><br /><input id="LocatedS" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Address</span><br /><input id="AddressS" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Activated</span><br /><input id="ActivatedS" class="inputs" type="text" name="" value="" style="width: 150px;" />
        </div>
        <div>
          <span>Log</span><br /><textarea id="LogS" class="inputs" type="text" name="" value="" style="width: 250px; height: 60px;" ></textarea>
        </div>
        <div>
          <span>Unit</span><br /><textarea id="UnitS" class="inputs" type="text" name="" value="" style="width: 50px; height: 60px;" ></textarea>
        </div>
        <div>
          <span>Attached</span><br /><textarea id="AttachedS" class="inputs" type="text" name="" value="" style="width: 50px; height: 60px;" ></textarea>
        </div>
        <div>
          <button id="saveSensor" class="inputs" type="button" name="button">Save changes</button>
          <button id="insertNewSensor" class="inputs" type="button" name="button">Save new sensor</button>
          <button id="atachSensorToComputer" class="inputs" type="button">Attach Sensor To Computer</button>
        </div>
    </div>
    </div>
        <button id="loadComputers" type="button">Computers</button>
        <button id="loadSensors" type="button">Sensors</button>       
  </form>
</body>
</html>


