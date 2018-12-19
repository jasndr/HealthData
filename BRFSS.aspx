<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BRFSS.aspx.cs" Inherits="HealthData2.BRFSS" %>

<%--<%@ Register TagPrefix="fb" TagName="FileBrowser" Src="~/FileBrowser.ascx" %>--%>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <header></header>

    <script type="text/javascript">
        $(function () {
            $('#Sidebar').hide();
            $('#topbarlinks').hide();
            $('#titleOfPage').hide();
        });
    </script>

    <div class="navbar navbar-default" style="margin-top: -60px;">
        <a href="Default.aspx">
            <img src="./images/Banner_Print(CIM).png"
                style="width: 75%; max-height: 4%; margin-left: auto; margin-right: auto; display: block; position: relative;" />
        </a>
    </div>

    <div class="navbar-default sidebar" style="margin-top: -.5%;">
        <div class="container" style="margin-left: 1%;">
            <h5 class="text-center"><strong>Codebook</strong></h5>
        </div>
        <div class="container text-center" style="margin-left: 1%; columns: 2;">
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf" target="_blank">2015</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2014/pdf/codebook14_llcp.pdf" target="_blank">2014</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2013/pdf/codebook13_llcp.pdf" target="_blank">2013</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2012/pdf/codebook12_llcp.pdf" target="_blank">2012</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2011/pdf/codebook11_llcp.pdf" target="_blank">2011</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2010/pdf/codebook_10.pdf" target="_blank">2010</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2009/pdf/codebook_09.pdf" target="_blank">2009</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2008/pdf/codebook08.pdf" target="_blank">2008</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2007/pdf/codebook_07.pdf" target="_blank">2007</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2006/pdf/codebook_06.pdf" target="_blank">2006</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2005/pdf/codebook_05.pdf" target="_blank">2005</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2004/pdf/codebook_04.pdf" target="_blank">2004</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2003/pdf/codebook_03.pdf" target="_blank">2003</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2002/pdf/codebook_02.pdf" target="_blank">2002</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2001/pdf/codebook_01.pdf" target="_blank">2001</a></p>
            <%-- <p><a style="font-weight: bold; color: forestgreen;" href="https://www.cdc.gov/brfss/annual_data/2000/pdf/codebook_00.pdf" target="_blank">2000</a></p>--%>
        </div>


    </div>


    <script src="Scripts/jquery.cookie.js"></script>
    <%--<script src="Scripts/jquery-1.10.2.js"></script>--%>
    <script type="text/javascript">
        var Grid = null;
        var UpperBound = 0;
        var LowerBound = 2;
        var CollapseImage = 'images/collapse.gif';
        var ExpandImage = 'images/expand.gif';
        var DemoIsExpanded = true;
        var DietIsExpanded = true;
        var ExamIsExpanded = true;
        var LabIsExpanded = true;
        var QuesIsExpanded = true;
        var IsExpanded = true;
        var Rows = null;
        var n = 1;
        var TimeSpan = 0;

        var numOfChecked = 0;
        var maxChecked = 100;

        var dict = new Object();

        $(document).ready(function () {
            $('#ct101').submit(function () {
                blockUIForDownload();
            });
        });

        function ShowColumns(CheckBox) {
            if (CheckBox.checked) {

                //--Test to view column name and id--//
                //alert($(CheckBox).attr('id') + '\n ' + chkbox_year + '\n' + chkbox_codebook + '\n' + chkbox_special);


                //Unhide viewbox
                $(".pdsa-column-display").removeClass("hidden");


                var columns = $(CheckBox).parent().attr('columnname').split(',');
                //---> Set id, year, cookieID, specialID, codebook
                var id = $(CheckBox).parent().attr('yearfrom');
                var year = $(CheckBox).parent().attr('yearfrom');
                var codebook = $(CheckBox).parent().attr('codebook');
                var cookieId = year + "cookie";

                //alert(columns + '/n ' + id + '/n ' + year + '/n ' + codebook + '/n ' + cookieId);
                //alert('Kamusta kayong lahat diyan?  Mucho salsa.');

                var specialId = (395 * parseFloat(year));

                //---> Create HTML elements of page
                var html = "<h5 style='color: green;'><strong><a href='" + codebook + "' style='color: green;' target='_blank' title='code book'" + "'> BRFSS " + year + " Datasets</a></strong></h5>"
                html += "<input type='button' id='btnSelectAll' class='btn btn-success btn-xs' value='Select All' onclick='selectAll(&quot;" + specialId + "&quot;,&quot;" + cookieId + "&quot;)'><input type='button' id='btnDeselectAll' class='btn btn-danger btn-xs' value='Deselect All' onclick='deSelectAll(&quot;" + specialId + "&quot;,&quot;" + cookieId + "&quot;)'>"
                html += "<span id='closeDiv' onclick='closeWindow()'>X</span><br />&nbsp;"
                html += "<div class='row'>";
                for (var i = 0; i < columns.length - 1; i++) {
                    var columnName = columns[i];

                    if (columnName == " SEQNO") {


                        html += "<div class='col-md-4' id='" + specialId + "'><input checked='true' type='checkbox' onclick='return false;' name='columns' id='" + columnName + "' class='module' />"
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                        //add cookie to SEQNO (since it's pre-checked)--------------
                        if (dict[cookieId]) {
                            dict[cookieId] += 'SEQNO' + ',';
                        }
                        else {
                            ClearCookie(cookieId);
                            dict[cookieId] = 'SEQNO' + ',';
                        }
                        //end add cookie --------------------
                    } else {
                        html += "<div class='col-md-4' id='" + specialId + "'><input type='checkbox' name='columns' id='" + columnName + "' class='module' />"
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                    }

                    //$('#' + columnName).attr("specialId", specialId);

                    if ((i + 1) % 3 == 0) {
                        html += "</div>"
                        html += "<div class='row'>";
                    }

                }

                //  alert('cookieID: ' + cookieId + '\n specialID: ' + specialId);

                //---> Add row of buttons
                html += "<div class='row'><br />&nbsp;</div>"
                html += "&emsp;<div class='col-md-4'><input type='button' id='btnSelectAll2' class='btn btn-success btn-xs' value='Select All' onclick='selectAll(&quot;" + specialId + "&quot;,&quot;" + cookieId + "&quot;)'><input type='button' id='btnDeselectAll2' class='btn btn-danger btn-xs' value='Deselect All' onclick='deSelectAll(&quot;" + specialId + "&quot;,&quot;" + cookieId + "&quot;)'></div><div class='col-md-4'><input type='button' id='btnClose' class='btn btn-primary btn-xs' value='Close' onclick='closeWindow()' /><br /><br /></div>&emsp;";
                html += "</div>";

                // alert('id: ' + id + '\n year: ' + year + '\n cookieID: ' + cookieID + '\n specialID: ' + specialID + '\n codebook: ' + codebook);

                //Generate viewBox
                $("#moduleListTitle").html(html);
                $('#moduleListTitle').parent().trigger('create');

                //---> Add cookie through dict[cookieID]
                $('input:checkbox.module').on('change', function () {
                    if ($(this).is(':checked')) {
                        if (dict[cookieId]) {
                            dict[cookieId] += this.id + ',';
                        }
                        else {
                            ClearCookie(cookieId);
                            dict[cookieId] = this.id + ',';
                        }
                    }
                    else {
                        dict[cookieId] = dict[cookieId].replace(this.id + ',', '');
                    }


                });

            } else {
                $(".pdsa-column-display").addClass("hidden");
            }
        }

        function ClearCookie(name) {
            document.cookie = name + '=;expires=Thu, 01 Jan 2000 00:00:01 GMT;';
        }

        function SetCookie(name, value) {
            document.cookie = name + "=" + escape(value);
        }

        function closeWindow() {
            //alert("test");
            for (var key in dict) {
                SetCookie(key, dict[key]);
            }

            $(".pdsa-column-display").addClass("hidden");
        }


        //Selects all checkboxes in the current window
        function selectAll(specialId, cookieId) {
            $(':checkbox').each(function () {
                var pId = this.parentNode.id;
                if (pId == specialId) {
                    $(this).prop('checked', true);

                    //add cookie
                    if (dict[cookieId]) {
                        dict[cookieId] += this.id + ',';
                    }
                    else {
                        ClearCookie(cookieId);
                        dict[cookieId] = this.id + ',';
                    }

                }

            });
        }


        //Deselects all checkboxes in the current window
        function deSelectAll(specialId, cookieId) {
            $(':checkbox').each(function () {
                var pId = this.parentNode.id;
                if (pId == specialId && this.id != ' SEQNO') {
                    $(this).prop('checked', false);
                    dict[cookieId] = dict[cookieId].replace(this.id + ',', '');
                }

            });
        }


        var fileDownloadCheckTimer;
        function blockUIForDownload() {
            var token = new Date().getTime(); //use the current timestamp as the token value
            $('#MainContent_download_token_value_id').val(token);
            $('#MainContent_btnSubmit').prop("disabled", true).text("downloading...");
            $(".pdsa-submit-progress").removeClass("hidden");
            fileDownloadCheckTimer = window.setInterval(function () {
                var cookieValue = $.cookie('fileDownloadToken');
                if (cookieValue == token)
                    finishDownload();
            }, 1000);

        }

        function finishDownload() {
            window.clearInterval(fileDownloadCheckTimer);
            $.cookie('fileDownloadToken', null); //clears this cookie value
            $(".pdsa-submit-progress").addClass("hidden");
            $('#MainContent_btnSubmit').prop("disabled", false);
            location.reload();
        }







    </script>




</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <script>
        var panelHeader = $('#<%=GridViewStudy.ClientID%>');
        panelHeader.find("tr:not(:nth-child(1)):not(:nth-child(2))").hide();
    </script>


    <style>
        table {
            width: 100%;
        }

        #panelHeader, .panelHeader {
            position: absolute;
        }

        html {
            overflow-y: scroll;
        }
    </style>

    <div id="floatingHeader"></div>

    <div style="margin-left: -10px;">
        <div class="row">
            <div class="col-lg-12">
                <h4 class="page-header"><strong>BRFSS Data</strong></h4>
            </div>
            <%-- /.col-lg-12 --%>
        </div>
        <%-- -- /.row --%>

        <div id="brfssTable" class="row container" runat="server">
            <input type="hidden" id="download_token_value_id" runat="server" />


            <div class="table-responsive container-fluid" style="height: 400px; width: 100%; overflow-x: auto; position: relative;">
                <asp:GridView ID="GridViewStudy" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-bordered container-fluid"
                    OnPreRender="GridViewStudy_PreRender"
                    OnRowDataBound="GridViewStudy_DataBound"
                    OnRowCreated="GridViewStudy_RowCreated"
                    OnRowCommand="GridViewStudy_RowCommand">
                    <HeaderStyle CssClass="ColumnHeaderStyle dataHeader" BackColor="#B3FFB3" />

                    <AlternatingRowStyle BackColor="LightYellow" />
                    <Columns>

                        <asp:TemplateField HeaderText="2015">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2015" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2014">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2014" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2013">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2013" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2012">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2012" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2011">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2011" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2010">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2010" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2009">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2009" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2008">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2008" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2007">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2007" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2006">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2006" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2005">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2005" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2004">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2004" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2003">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2003" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2002">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2002" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="2001">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRow2001" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>



                    </Columns>
                </asp:GridView>
            </div>
            <hr />

            <div style="text-align: right; margin-right: 10px;">

                <strong>Download Format:</strong>

                <asp:Button ID="txtFormat" runat="server" Text=".txt" OnClick="btnSubmit_Click_Txt" OnClientClick="blockUIForDownload()" CssClass="btn btn-success btn-xs" UseSubmitBehavior="False" />

                <asp:Button ID="spssFormat" runat="server" Text="SPSS" OnClick="btnSubmit_Click_Spss" OnClientClick="blockUIForDownload()" CssClass="btn btn-danger btn-xs" UseSubmitBehavior="False" />

                <asp:Button ID="csvFormat" runat="server" Text="CSV" OnClick="btnSubmit_Click_Csv" OnClientClick="blockUIForDownload()" CssClass="btn btn-default btn-xs" UseSubmitBehavior="False" />

                <asp:Button ID="btnSubmit" runat="server" Text="SAS" OnClick="btnSubmit_Click" OnClientClick="blockUIForDownload()" CssClass="btn btn-primary btn-xs" UseSubmitBehavior="False" />

            </div>

        </div>




        <div class="pdsa-submit-progress hidden">
            <i class="fa fa-2x fa-spinner fa-spin"></i>
            <label>Please wait while Downloading...</label>
        </div>

        <div id="moduleListTitle" class="pdsa-column-display hidden">
            <%--<asp:Button id="b1" Text="Close" runat="server" OnClientClick="close()" />--%>
        </div>

    </div>
</asp:Content>
