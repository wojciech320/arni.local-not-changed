'use strict';
function countDown() {
  //var dateStart = new Date($("#txtDateStart").val());
  //var timeStart = new Date($("#txtDateStart").val() + ' ' + $("#txtTimeStart").val());
  var options = { hour12: false };
  var timeNow = new Date();
  //$("#txtEnded").val(timeNow);
  //$($("#washingStarted")).find($("#txtDateStart")).text();
  //$($("#washingStarted")).find($("#txtTimeStart")).text();
  var startWash = new Date($("#txtDateStart").text() + " " + $("#txtTimeStart").text());
  //console.log(date.toLocaleString('en-US', options));
  var secDif = parseInt((timeNow.getTime() - startWash.getTime()) / 1000);
  const totalWashingTimeMin = 1200; //  20 hours.
  var secRem = (totalWashingTimeMin * 60) - secDif;
  secRem = parseInt(secRem % 60)
  var minRem = parseInt(totalWashingTimeMin - secDif / 60);
  minRem = parseInt(minRem % 60);
  var hourRem = parseInt(Math.floor((totalWashingTimeMin - (secDif / 60)) / 60));
  //Display remaining time.
  //timerDuration
  if (hourRem < 10) {
    //$($("#timerRemaining")).find($("#txtRemHH")).text("0" + hourRem);
    $("#txtRemHH").text("0" + hourRem);
  }
  else {
    $("#txtRemHH").text(hourRem);
  }
  if (minRem < 10) {
    $("#txtRemMM").text("0" + minRem);
  }
  else {
    $("#txtRemMM").text(minRem);
  }
  if (secRem < 10) {
    $("#txtRemSS").text("0" + secRem);
  }
  else {
    $("#txtRemSS").text(secRem);
  }
  var hourDur = parseInt(secDif / 3600);
  var minDur = parseInt((secDif / 60 % 60));
  var secDur = parseInt(Math.floor((secDif % 60)));
  //Display duration time.
  if (hourDur < 10) {
    $("#txtDurHH").text("0" + hourDur);
  }
  else {
    $("#txtDurHH").text(hourDur);
  }
  if (minDur < 10) {
    $("#txtDurMM").text("0" + minDur);
  }
  else {
    $("#txtDurMM").text(minDur);
  }
  if (secDur < 10) {
    $("#txtDurSS").text("0" + secDur);
  }
  else {
    $("#txtDurSS").text(secDur);
  }
}

// function that loads the chart on chart pages loading
function LoadAllChartsContent() {
  //alert("loadCharts()");
  getData($('#tmpId').val(), 0, 'tmp', 'fillUp', '8');
  getData($('#humId').val(), 0, 'hum', 'fillUp', '8');
  getData($('#presId').val(), 0, 'pres', 'fillUp', '8');
  getData($('#flowFlowId').val(), 0, 'flowFlow', 'fillUp', 'year');
  getData($('#flowTmpId').val(), 0, 'flowTmp', 'fillUp', '8');
  //setInterval(function () {
  //  maintainCharts();
  //}, 10000);
}

function maintainCharts() {
  fromTime = toTime;
  getData($('#tmpId').val(), 1, 'tmp', 'maintainance', 'fromLast', fromTime);
  getData($('#humId').val(), 1, 'hum', 'maintainance', 'fromLast', fromTime);
  getData($('#presId').val(), 1, 'pres', 'maintainance', 'fromLast', fromTime);
  getData($('#flowFlowId').val(), 1, 'flowFlow', 'maintainance', 'fromLast', fromTime);
  getData($('#flowTmpId').val(), 1, 'flowTmp', 'maintainance', 'fromLast', fromTime);
}

function getData(sensId, sensCount, sensType, processType, period, fromTime) {
  //alert("SensorData/getData");
  switch (processType) {
    case "maintainance":
    toTime = new Date();
    getSensorValues(sensId, sensCount, fromTime, toTime, sensType);
    break;
    case "fillUp":
    var fromTime = new Date();
    switch (period) {
      case "8":
      fromTime.setHours(fromTime.getHours() - 8);
      toTime = new Date();
      getSensorValues(sensId, sensCount, fromTime, toTime, sensType);
      break;
      case "week":
      fromTime.setHours(fromTime.getHours() - 168);
      toTime = new Date();
      getSensorValues(sensId, sensCount, fromTime, toTime, sensType);
      case "fromLast":
      break;
      case "month":
      fromTime.setHours(fromTime.getHours() - 720);
      toTime = new Date();
      getSensorValues(sensId, sensCount, fromTime, toTime, sensType);
      case "fromLast":
      break;
      default:
    }
    break;
    default:
  }
}

function getChartData(sensId, sensCount, sensType, processType, period) {
    switch (sensType) {
        case 'tmp':
            xSensTmpVal.length = 0;
            ySensTmpVal.length = 0;
            break;
        case 'hum':
            xSensHumVal.length = 0;
            ySensHumVal.length = 0;
            break;
        case 'pres':
            xSensPresVal.length = 0;
            ySensPresVal.length = 0;
            break;
        case 'flowFlow':
            xSensFlowFlowVal.length = 0;
            ySensFlowFlowVal.length = 0;
            break;
        case 'flowTmp':
            xSensFlowTmpVal.length = 0;
            ySensFlowTmpVal.length = 0;
            break;
        default:
            break;
    }
    getData(sensId, sensCount, sensType, processType, period);
}

function getSensorValues(sensorId, count, fromTime, toTime, sensType) {
  var dato;
  $.ajax({
    url: "Sensors.asmx/GetSensorValues",
    data: { sensorId: sensorId, scount: count, fromTime: fromTime.format("MM/dd/yyyy HH:mm"), toTime: toTime.format("MM/dd/yyyy HH:mm") },
    method: "post",
    dataType: "xml", //"json",
    error: function (request, status, error) {
      alert(request.responseText);
    },
    success: function (xml) {
      if (count == 0) {
        //alert("TimerFunctions/getSensorValues count > 1");
          $(xml).find('SensorValue').each(function () {
              dato = new Date($(this).find('Sensor_Log_ID').text());
          //alert(dato);
          switch (sensType) {
            case 'tmp':
            xSensTmpVal.push(dato.format("dd/HH"));
            ySensTmpVal.push($(this).find('Sensor_Value').text());
            break;
            case 'hum':
            xSensHumVal.push(dato.format("HH:mm"));
            ySensHumVal.push($(this).find('Sensor_Value').text());
            break;
            case 'pres':
            xSensPresVal.push(dato.format("HH:mm"));
            ySensPresVal.push($(this).find('Sensor_Value').text());
            break;
            case 'flowFlow':
            xSensFlowFlowVal.push(dato.format("HH:mm"));
            ySensFlowFlowVal.push($(this).find('Sensor_Value').text());
            break;
            case 'flowTmp':
            xSensFlowTmpVal.push(dato.format("HH:mm"));
            ySensFlowTmpVal.push($(this).find('Sensor_Value').text());
            break;
            default:
          }
        });
      } else {
          $(xml).find('SensorValue').each(function () {
          //alert("xml = " + xml);
              dato = new Date($(this).find('Sensor_Log_ID').text());
          switch (sensType) {
            case 'tmp':
            xSensTmpVal.push(dato.format("HH:mm"));
            ySensTmpVal.push($(this).find('Sensor_Value').text());
            xSensTmpVal.shift();
            ySensTmpVal.shift();
            break;
            case 'hum':
            xSensHumVal.push(dato.format("HH:mm"));
            ySensHumVal.push($(this).find('Sensor_Value').text());
            xSensHumVal.shift();
            ySensHumVal.shift();
            break;
            case 'pres':
            xSensPresVal.push(dato.format("HH:mm"));
            ySensPresVal.push($(this).find('Sensor_Value').text());
            xSensPresVal.shift();
            ySensPresVal.shift();
            break;
            case 'flowFlow':
            xSensFlowFlowVal.push(dato.format("HH:mm"));
            ySensFlowFlowVal.push($(this).find('Sensor_Value').text());
            xSensFlowFlowVal.shift();
            ySensFlowFlowVal.shift();
            break;
            case 'flowTmp':
            xSensFlowTmpVal.push(dato.format("HH:mm"));
            ySensFlowTmpVal.push($(this).find('Sensor_Value').text());
            xSensFlowTmpVal.shift();
            ySensFlowTmpVal.shift();
            break;
            default:
          }
        });
      }
      //alert(ySensVal[0]);
      if (sensType === "tmp") {
        //alert(sensType);
        myChartTmp.update();
      }
      if (sensType === "hum") {
        //alert(sensType);
        myChartHum.update();
      }
      if (sensType === "pres") {
        //alert(sensType);
        myChartPres.update();
      }
      if (sensType === "flowFlow") {
        //alert(sensType);
        myChartFlowFlow.update();
      }
      if (sensType === "flowTmp") {
        //alert(sensType);
        myChartFlowTmp.update();
      }
      if (sensType === "flowRate") {
        //alert(sensType);
        //$("#txtFlowRate").text(ySensVal[0]);
      }
      if (sensType === "flowVolume") {
        //alert(sensType);
        //  $("#txtTotalVolume").text(ySensVal[0]);
      }
      if (sensType === "flowTemp") {
        //alert(sensType);
        //  $("#txtTemp").text(ySensVal[0]);
      }
    },
  });
}

function editComputer(id) {
    //var id = $("#" + id );
    getComputers(id);
    getAtachedSensors(id)
  //alert($("#" + id + '"'));
}

function editSensor(id) {
    //var id = $("#" + id );
    getSensors(id);
    //alert($("#" + id + '"'));
}

function getSensors(id) {
    $.ajax({
        url: "Sensors.asmx/GetAllSensorData",
        data: { id: id },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            if (id == 1000) {
                $('#selectionS').html(composeSensorsForSelect(xml));
            } else {
                composeSensorEdit(xml);
            }
        },
    });
}

function getAtachedSensors(id) {
    $.ajax({
        url: "Sensors.asmx/GetAtachedSensors",
        data: { id: id },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            $('#selectAtachedSensors').html(composeAtacheSensorsForSelect(xml));
        },
    });
}

function atachSensor(Computer_ID, Sensor_ID) {
    $.ajax({
        url: "Sensors.asmx/AtachSensor",
        data: { Computer_ID: Computer_ID, Sensor_ID: Sensor_ID },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            $("#AttachedS").val(1);
            saveSensorData();
        },
    });
}

function deletAtachment(Computer_ID, Sensor_ID) {
    $.ajax({
        url: "Sensors.asmx/DeletAtachment",
        data: { Computer_ID: Computer_ID, Sensor_ID: Sensor_ID },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (data) {
            getAtachedSensors($("#ComputerId").text());
        },
    });
}

function composeAtacheSensorsForSelect(xml) {
    var selectContent = '';
    $(xml).find('Sensor').each(function () {
        selectContent += "<div class='atachedItem' onClick=\"editSensor('" + $(this).find('Sensor_ID').text().trim() + "')\";>" + $(this).find('Sensor_ID').text().trim() + "</div>";
    });
    return selectContent;
}

function getComputers(id) {
    $.ajax({
        url: "Sensors.asmx/GetAllComputerData",
        data: { id: id },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            if (id == 1000) {
              $('#selectionC').html(composeComputersForSelect(xml));
          }else{
                composeComputerEdit(xml);
          }
        },
    });
}

function composeSensorsForSelect(xml) {
    var selectContent = '';
    $(xml).find('Sensor').each(function () {
        var activDate = new Date($(this).find('Activated').text()).toLocaleDateString('en-us', { year: "numeric", month: "short", day: "numeric" });
        var tooltipText = $(this).find('Type').text().trim() +
            ' - ' + $(this).find('Address').text().trim() +
            ' - ' + activDate +
            ' - ' + $(this).find('Discription').text().trim();
        selectContent += "<span class='item' onClick=\"editSensor('" + $(this).find('Sensor_ID').text().trim() + "')\";>";
        selectContent += "<span id='" + $(this).find('Sensor_ID').text().trim() + "' class='tooltip' > <span class='tooltiptext'>" + tooltipText + "</span>";
        selectContent += '<span>' + $(this).find('Name').text().trim() + '</span > ';
        selectContent += '<span>' + $(this).find('Located').text().trim() + '</span>';
        // comboItem += '<div>' + $(this).find('Description').text().trim() + '</div>';        
        selectContent += '</span>';
        selectContent += '</span>';
    });
    return selectContent;
}

function composeComputersForSelect(xml) {
  var selectContent='';
     $(xml).find('Computer').each(function () {
    var activDate = new Date($(this).find('Activated').text()).toLocaleDateString('en-us', { year: "numeric", month: "short", day: "numeric" });
    var tooltipText = $(this).find('Type').text().trim() +
      ' - ' + $(this).find('Address').text().trim() +
      ' - ' + activDate +
      ' - ' + $(this).find('Discription').text().trim();
      selectContent += "<span class='item' onClick='editComputer(" + $(this).find('Computer_Id').text().trim() + ")';>";
    selectContent += "<span id='" + $(this).find('Computer_Id').text().trim()  + "' class='tooltip' > <span class='tooltiptext'>" + tooltipText + "</span>";
      selectContent += '<span>' + $(this).find('Name').text().trim() + '</span>';
      selectContent += '<span>' + $(this).find('Located').text().trim() + '</span>';
      // selectContent += "<div style='display: none;'>"
      // comboItem += '<div>' + $(this).find('Description').text().trim() + '</div>';
      // selectContent += '<div>' + $(this).find('Computer_Id').text().trim() + '</div>';
      // selectContent += '<div>' + $(this).find('Type').text().trim() + '</div>';
      // selectContent += '<div>' + $(this).find('Address').text().trim() + '</div>';
      // selectContent += '<div>' + $(this).find('Activation').text().trim() + '</div>';
      // selectContent += '<div>' + $(this).find('Log').text().trim() + '</div>';
      // selectContent += '</div>';
      selectContent += '</span>';
      selectContent += '</span>';
  });
  return selectContent;
}

function composeComputerEdit(xml) {
  $("#ComputerId").text($(xml).find('Computer_Id').text().trim());
  $("#NameC").val($(xml).find('Name').text().trim());
  $("#TypeC").val($(xml).find('Type').text().trim());
  $("#LocatedC").val($(xml).find('Located').text().trim());
  $("#DiscriptionC").val($(xml).find('Discription').text().trim());
  $("#AddressC").val($(xml).find('Address').text().trim());
  $("#ActivatedC").val(new Date($(xml).find('Activated').text()).toLocaleDateString('en-us', { year: "numeric", month: "short", day: "numeric" }));
  $("#LogC").val($(xml).find('Log').text().trim());
}

function composeSensorEdit(xml) {
    $("#Sensor_ID").val($(xml).find('Sensor_ID').text().trim());
    $("#NameS").val($(xml).find('Name').text().trim());
    $("#TypeS").val($(xml).find('Type').text().trim());
    $("#LocatedS").val($(xml).find('Located').text().trim());
    $("#DiscriptionS").val($(xml).find('Discription').text().trim());
    $("#AddressS").val($(xml).find('Address').text().trim());
    $("#ActivatedS").val(new Date($(xml).find('Activated').text()).toLocaleDateString('en-us', { year: "numeric", month: "short", day: "numeric" }));
    $("#LogS").val($(xml).find('Log').text().trim());
}

function collectComputerData() {
  let data = {
      id: $("#ComputerId").text(),
      name: $("#NameC").val(),
      type: $("#TypeC").val(),
      located: $("#LocatedC").val(),
      discription: $("#DiscriptionC").val(),
      address: $("#AddressC").val(),
      activated: $("#ActivatedC").val(),
      log: $("#LogC").val()
  };
  return data;
}

function collectSensorData() {
    let data = {
        id: $("#Sensor_ID").text(),
        name: $("#NameS").val(),
        type: $("#TypeS").val(),
        location: $("#LocatedS").val(),
        discription: $("#DiscriptionS").val(),
        address: $("#AddressS").val(),
        activation: $("#ActivatedS").val(),
        log: $("#LogS").val(),
        unit: $("#UnitS").val(),
        attached: $("#AttachedS").val()
    };
    return data;
}

function saveComputerData() {
    let data = collectComputerData();
$.ajax({
    url: "Sensors.asmx/SaveComputerData",
    data: {
        Computer_ID: data.id,
        Name: data.name,
        Type: data.type,
        Located: data.located,
        Discription: data.discription,
        Address: data.address,
        Activated: data.activated,
        Log: data.log
    },
    method: "post",
    dataType: "xml",
    error: function (request, status, error) {
        alert(request.responseText);
    },
    success: function (xml) {
      alert("saved");
    },
});
}

function saveSensorData() {
    let data = collectSensorData();
    $.ajax({
        url: "Sensors.asmx/SaveSensorData",
        data: {
            Sensor_ID: data.id,
            Name: data.name,
            Type: data.type,
            Location: data.location,
            Discription: data.discription,
            Address: data.address,
            Activation: data.activation,
            Log: data.log,
            Unit: data.unit,
            Attached: data.attached
        },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            alert("saved");
        },
    });
}

function saveNewSensorData() {
    let data = collectSensorData();
    $.ajax({
        url: "Sensors.asmx/SaveNewSensorData",
        data: {
            Sensor_ID: data.id,
            Name: data.name,
            Type: data.type,
            Location: data.location,
            Discription: data.discription,
            Address: data.address,
            Activation: data.activation,
            Log: data.log,
            Attached: data.attached
        },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            alert("saved");
        },
    });
}

function saveNewComputerData() {
    let data = collectComputerData();
$.ajax({
    url: "Sensors.asmx/SaveNewComputerData",
    data: {
        Computer_ID: data.id,
        Name: data.name,
        Type: data.type,
        Location: data.location,
        Discription: data.discription,
        Address: data.address,
        Activation: data.activation,
        Log: data.log
    },
    method: "post",
    dataType: "xml",
    error: function (request, status, error) {
        alert(request.responseText);
    },
    success: function (xml) {
      alert("saved");
    },
});
}
//Computer_ID, Name, Type, Location, Discription, Address, Activation, Log
//@Computer_ID int,
//@Name nchar(100),
//@Address nchar(100),
//@Activation datetime,
//@Discription varchar(500),
//@Location nvarchar(50),
//@Type nchar(100),
//@Log nchar(1000)
//alert("getC");
// function Computer(computerId, name, description, type, location, address, activation, log) {
//     this.ComputerId = computerId;
//     this.Name = name;
//     this.Description = description;
//     this.Type = type;
//     this.Location = location;
//     this.Address = address;
//     this.Activation = activation;
//     this.Log = log;
// }
//$('#SelComputer').append($("<option style='background - color: #C0C0C0;' >", {
//    value: 1,
//    //text: $(this).find('Name').text()
//    html: comboItem
//}));
//var o = new Option("option text", "value");
///// jquerify the DOM object 'o' so we can use the html method
//$(o).html("option text");
//$("#SelComputer").append(o);
//$('#SelComputer').val.
//var comput = new Computer();
//comput.computerId = $(this).find('Computer_Id').text();
//comput.name = $(this).find('Name').text();
//comput.description = $(this).find('Description').text();
//comput.type = $(this).find('Type').text();
//comput.location = $(this).find('Location').text();
//comput.address = $(this).find('Address').text();
//comput.activation = $(this).find('Activation').text();
//comput.log = $(this).find('Log').text();
//computers.push(comput);
//var Image = $(this).find('Image').text();
