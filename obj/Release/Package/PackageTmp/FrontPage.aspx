<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FrontPage.aspx.cs" Inherits="arni.local.FrontPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/SealingProcess.aspx">Sealing Process</asp:HyperLink>
            </div>
            <div>
                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/WebChart_2.aspx">Log Charts</asp:HyperLink>
            </div>
            <div>
                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/SaveImageToEmployee.aspx">Save Image</asp:HyperLink>
            </div>
            <div>
                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/Computers.aspx">Computers and Sensors</asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html>
