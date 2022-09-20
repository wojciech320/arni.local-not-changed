<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaveImageToTable.aspx.cs" Inherits="arni.local.SaveImageToTable" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <script
      src="https://code.jquery.com/jquery-3.6.0.min.js"
      integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
      crossorigin="anonymous"
    ></script>
    <script type="text/javascript">
        'use strict';
        $(document).ready(function () {
            $('#ckEquipment').click(function () {
                getEquipment("Sealer");
                //getTyvekLots();
                //getBatches();
            });
            $("#selSealer").change(function (e) {
                $('#Equipment_ID').text((e.target.options[event.target.selectedIndex].value));
            });
        });
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
    </script>
<%--<script type="text/javascript">
    $(function () {
        GetCategory();
    });
    function GetCategory() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ImageService.asmx/GetProducts",
            dataType: "json",
            success: function (data) {
                //alert(data);
                for (var i = 0; i < data.d.length; i++) {
                    var image = "data:image/png;base64," + data.d[i].ImageData;
                    var id = data.d[i].Employee_ID;
                    var name = data.d[i].Name;
                    $("#ttablepdtgrid").append(
                        "<div class=trclass>" +
                        "   <tr><td class=tdcolumn>" +
                        "       <div class=tabledivprod>" +
                        "           <img src='" + image + "' />" +
                        "           <div>" + name + "</div>" +
                        "           <div>" + id + "</div>" +
                        "           <br /><br />" +
                        "       </div>" +
                        "   </td></tr>" +
                        "</div>");
                }
            },
            error: function (response) {
                alert("Error while Showing update data");
            }
        });
    }
</script>--%>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <span>Employee: </span><input id="ckEmployee" type="checkbox" value="Employee" />   <br />
            <span>Equipment: </span><input id="ckEquipment" type="checkbox" value="Equipment" /> <br />
                <div><span>Select sealing equipment: </span><select id="selSealer" class="selLook" >
                    <option>- Select Sealer -</option>
                </select>
                    <div id="Equipment_ID"></div>
            </div><br />
            <div id="sealerImage" ></div>
            <input id="btn_upload" type="button" value="Save Image" /><br />
            <input id="uploadefile" type="file" />
        </div>
    </form>
</body>
<script type="text/javascript">
    $(document).ready(function () {

        $('#btn_upload').click(function () {

            var data = new FormData();
            var files = $("#uploadefile").get(0).files;
            // Add the uploaded image content to the form data collection
            if (files.length > 0) {
                data.append("UploadedImage", files[0]);
            }
            if (document.getElementById("ckEmployee").checked == true) {
                data.append("id", "1203613849");
                data.append("spImage", "spSaveEmployeeImage");
            }
            if (document.getElementById("ckEquipment").checked  == true) {
                data.append("id", $('#Equipment_ID').text());
                data.append("spImage", "spSaveEquipmentImage");
            }

            // Make Ajax request with the contentType = false, and procesDate = false
            var ajaxRequest = $.ajax({
                type: "POST",
                url: "/Sensors.asmx/UploadImage",
                contentType: false,
                processData: false,
                data: data,
                error: function (request, status, error) {
                    alert(request.responseText);
                },
                success: function (xhr, textStatus) {
                    alert(textStatus);
                }
            });

            ajaxRequest.done(function (xhr, textStatus) {
                // Do other operation
            });
        });
    });
</script>
</html>
