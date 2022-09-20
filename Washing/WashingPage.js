

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
