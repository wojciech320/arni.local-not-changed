$(document).ready(function(){
  $('#startWashing').click(function () {
    var sensId = $('#txtSensorPoolID').text();
    $.ajax({
      url: 'Sensors.asmx/StartWashing',
      data: { sensorPoolId: sensId },
      method: 'post',
      dataType: 'xml',
      error: function (request, status, error) {
        alert(request.responseText);
      },

      success: function (data) {
        var txtStartD = document.getElementById('txtStartDate');
        txtStartD.value = new Date().format('dd.MMM.yy');
        txtStartD.style.backgroundColor = '#ebe';
        var txtStartT = document.getElementById('txtStartTime');
        txtStartT.value = new Date().format('HH:mm');
        txtStartT.style.backgroundColor = '#ebe';
      },
    });
  });

  setInterval(function () {
    countDown();
  }, 1000);
});
