<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="XML_Test.aspx.cs" Inherits="arni.local.XML_Test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous">
</script>
    <script type="text/javascript">
        //$(document).ready(function () {
        //    $("#getXML").click(function () {
        //        $.ajax({
        //            url: "Sensors.asmx/GetXMLInfo",
        //            method: "post",
        //            data: "text",
        //            contentType: "application/x-www-form-urlencoded;charset=ISO-8859-15",
        //            error: function (request, status, error) {
        //                alert(request.responseText);
        //            },
        //            success: function (data, textStatus, XmlHttpRequest) {
        //                //$('#txtDiv').text(XmlHttpRequest.responseText);
        //                alert(XmlHttpRequest.responseText);
        //            //var $this = $(this);
        //            //    $(XmlHttpRequest.responseText).text(function (i, text) {
        //            //        return text.replace('&lt;', '<').replace('&gt;', '>');
        //            //    });
        //            //var t = XmlHttpRequest.responseText;
        //            //$this.html(t.replace('&lt', '<').replace('&gt', '>'));
        //            //    var xmlDoc = jQuery.parseXML($.html(XmlHttpRequest.responseText.replace('&lt', '<').replace('&gt', '>')));
        //                //if (xmlDoc) {
        //                //    window.alert(xmlDoc.documentElement.nodeName);
        //                //}             
        //                //$("#xmlTxt").val($(XmlHttpRequest.responseText).find("String").text());
        //                //$('#txtDiv').$(function () {
        //                //    var $this = $(this);
        //                //    var t = $this.text();
        //                //    $this.html(t.replace('&lt;', '<').replace('&gt;', '>'));
        //                //});
        //            },
        //        });
        //    });
            $(document).ready(function () {
                $("#btnSaveHTML").click(function () {
                    alert("arni");
                });
            });
        function test() {
            alert("arni");
        }
            // Encode the content for storing in Sql server.
            //string htmlEncoded = WebUtility.HtmlEncode(text);

            // Decode the content for showing on Web page.
            //string original = WebUtility.HtmlDecode(htmlEncoded);

            //$('#test').each(function () {
            //    var $this = $(this);
            //    var t = $this.text();
            //    $this.html(t.replace('&lt', '<').replace('&gt', '>'));
            //});
            //function specialchars($special) {
            //    $replace = array(
            //        '<' => '&lt;',
            //        '>' => '&gt;',
            //        '&' => '&amp;'
            //    );
            //    return strtr($special, $replace);
            //}
        //});
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="button" id="btnSaveHTML" value="Save HTML document" onclick="function test();" />
            <input type="button" id="getXML" value="XML"  style="background-color: #8DA8F5" />
            <br />
            <br />
            <input type="text" id="xmlTxt" value="XML"  style="background-color: #8DA8F5" />
            <br />
            <div id="txtDiv"> </div>
        </div>
    </form>
</body>
</html>
