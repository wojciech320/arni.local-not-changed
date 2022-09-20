<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SealingProcess.aspx.cs" Inherits="arni.local.SealingProcess" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .selLook {
            font-family: Verdana;
            font-size: 14px;
        }
        .groupHeader {
            background-color: aqua;

        }
    </style>
    <link rel="shortcut icon" href="#" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script
      src="https://code.jquery.com/jquery-3.6.0.min.js"
      integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
      crossorigin="anonymous"
    ></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
    <script src="Washing/TimerFunctions.js"></script>
    <script type="text/javascript">
        'use strict';
        $(document).ready(function () {
            $('#startSealing').click(function () {
                getEquipment("Sealer");
                getTyvekLots();
                getBatches();
            });
            $("#selSealer").change(function (e) {
                GetEquipmentImage(e.target.options[event.target.selectedIndex].value);
            });
        });
        </script>
        <script type="text/javascript">
            function GetEquipmentImage(id) {
                //var data1 = new FormData();
               //data1.append("Equipment_ID", id)
                id = '\"' + id + '\"';
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ImageService.asmx/GetEquipmentImage",
                    contentType: "application/json; charset=utf-8",
                    //contentType: false,
                    //processData: false,
                    data: '{"Equipment_ID":' + id + '}',
                    //'{"foo":"foovalue", "bar":"barvalue"}'
                    dataType: "json",
                    success: function (data) {
                        for (var i = 0; i < data.d.length; i++) {
                            var image = "data:image/png;base64," + data.d[i].Image;
                            //var id = data.d[i].Equipment_ID;
                            //var name = data.d[i].Name;
                            //$("#sealerImage").append(
                            //    "<img src='" + image + "' />");
                            $('#sealerImage').attr('src', image);
                            //$('#pic').attr('src', 'file#-896x277.jpg');
                        }
                    },
                    error: function (response) {
                        alert("Error while Showing update data");
                    }
                });
            }

        function getEquipment(type) {
            $.ajax({
                url: "Sensors.asmx/GetEquipmentType",
                data: { type: type },
                method: "post",
                dataType: "xml",
                error: function (request, status, error) {
                    alert(request.responseText);
                },
                success: function (xml) {
                    $(xml).find('Equipment').each(function () {
                        $('#selSealer')
                            .append($('<option>', { value: $(this).find('Equipment_ID').text() })
                                .text($(this).find('Name').text()));
                    });
                }
            });
        };
        function getTyvekLots() {
            $.ajax({
                url: "Sensors.asmx/GetTyvekLots",
                method: "post",
                dataType: "xml",
                error: function (request, status, error) {
                    alert(request.responseText);
                },
                success: function (xml) {
                    //$("#fileId").empty();
                    var selTyv = $('#selTyvek');
                    //$(xml).find('TyvekLot').each(function () {
                        var $prevGroup, prevGroupName;
                        $(xml).find('TyvekLot').each(function () {
                            if (prevGroupName != $(this).find('Pouch_Size').text()) {
                                selTyv.appendTo()
                                $prevGroup = $('<optgroup />').prop('label', $(this).find('Pouch_Size').text() + ' | Lnumber |  Lsize   |Lremaining ').appendTo('#selTyvek');
                            }
                            $("<option />").val($(this).find('TyvekLot_ID').text()).text('------|' + $(this).find('Lot_Number').text() + ' | ' + $(this).find('Lot_Size').text() + ' | ' + $(this).find('Lot_Remaining').text()).appendTo($prevGroup);
                            prevGroupName = $(this).find('Pouch_Size').text();
                        });
                    //});
                },
                //success: function (xml) {
                //    $(xml).find('TyvekLot').each(function () {
                //        $('#selTyvek')
                //            .append($('<option>', { value: $(this).find('TyvekLot_ID').text() })
                //                .text($(this).find('Size').text()));
                //    });
                //}
            });
        };
        function getBatches() {
            $.ajax({
                url: "Sensors.asmx/GetBatches",
                method: "post",
                dataType: "xml",
                error: function (request, status, error) {
                    alert(request.responseText);
                },
                success: function (xml) {
                    $(xml).find('Batch').each(function () {
                        const dato = new Date($(this).find('Date').text()).toLocaleDateString('en-GB', {
                            day: 'numeric',
                            month: 'short',
                            year: 'numeric',
                        });
                        $('#selBatch')
                            .append($('<option>', { value: $(this).find('Batch_ID').text() })
                                .text($(this).find('Batch_ID').text() + ' | ' + dato));
                    });
                }
            });
        };        
        </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div><input id="startSealing" type="button" value="Start new Sealing Batch" /> </div>
            <div><span>Select batch Id: </span><select id="selBatch" class="selLook" >
                    <option>- Select Batch Id -</option>
                </select>
            </div>
            <div><span>Starting time: </span><input id="started" type="text"/> </div>
            <div><span>Select tyvek lot: </span><select id="selTyvek" class="selLook" >
                    <option>- Select Tyvek lot -</option>
                </select>
            </div>
            <div><span>Number of pouches per seal: </span><input id="countPSeal" type="text" /> </div>
            <div><span>Select sealing equipment: </span><select id="selSealer" class="selLook" >
                    <option>- Select Sealer -</option>
                </select>
            </div><br />
           <image id="sealerImage" ></image>
        </div>
    </form>
</body>
</html>
