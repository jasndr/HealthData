<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NHANES2.aspx.cs" Inherits="HealthData2.NHANES2" %>

<%--<%@ Register TagPrefix="fb" TagName="FileBrowser" Src="~/FileBrowser.ascx" %>--%>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <header></header>

    <style>
        .innerContainer {
            max-height: 55vh;
            overflow: auto;
        }

        #gridArea {
            background-color: #EEE
        }
        /*table thead{
            
        }*/
    </style>

    <div class="navbar navbar-default" style="margin-top: -60px;">
        <a href="Default.aspx">
            <img src="./images/Banner_Print(CIM).png"
                style="width: 75%; max-height: 4%; margin-left: auto; margin-right: auto; display: block; position: relative;" /></a>
    </div>

    <div class="navbar-default sidebar" style="margin-top: -.5%;">
        <div class="container" style="margin-left: 10%;">
            <h5><strong>Data Documentation & Codebook</strong></h5>
        </div>
        <div class="container text-center" style="margin-left: 1%;">
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2013" target="_blank">2013 - 2014</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2011" target="_blank">2011 - 2012</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2009" target="_blank">2009 - 2010</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2007" target="_blank">2007 - 2008</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2005" target="_blank">2005 - 2006</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2003" target="_blank">2003 - 2004</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/Nchs/Nhanes/continuousnhanes/default.aspx?BeginYear=2001" target="_blank">2001 - 2002</a></p>
            <p><a style="font-weight: bold; color: forestgreen;" href="https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=1999" target="_blank">1999 - 2000</a></p>
        </div>


    </div>

    <script src="Scripts/jquery.cookie.js"></script>
    <script type="text/javascript" src="Scripts/jquery.floatThead.js"></script>
    <script type="text/javascript" src="Scripts/jQuery.gridviewFix.js"></script>

    <script type="text/javascript">

        $(function () {
            //$('#Sidebar').css("width", "20px");
            $('#topbarlinks').hide();
            //$('#titleOfPage').hide();
        });

        $(document).ready(function () {

            /**___Fixed Header Scrollable Table____ */

            

            var $table = $('#MainContent_GridViewStudy');

            // Convert Gridview header into HTML header.
            $table.gridviewFix();

            // Make header stick while scrolling through columns.
            $table.floatThead({
                scrollContainer: function ($table) {
                    return $table.closest('.innerContainer');
                }

            });

            //$table.css("background-color", "#B3FFB3");
            $('.floatThead-container').css("background-color", "#B3FFB3");

            //var $theadCols = $('#MainContent_GridViewStudy tr:first-child'),
            //    $table = $('#MainContent_GridViewStudy');

            ////$theadCols.css('background-color', 'maroon');

            //// create thead and append <th> columns
            //$table.prepend("</thead>");
            //$table.find("thead").append($theadCols);

            //$table.dataTable({
            //    "paging": false,
            //    "ordering": false,
            //    "dom":'<"top"fi>rt<"bottom"><"clear">'
            //});

            /**___Fixed Header Scrollable Table____ */
        });


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


        function pageLoad(sender, args) {
            $('#li_nhanesdata').addClass('active');
            $('#li_nhanes').addClass('active');

            Grid = document.getElementById('<%= this.GridViewStudy.ClientID %>');
            <%--UpperBound = parseInt('<%= this.GridViewStudy.Rows.Count %>');--%>
            UpperBound = 2;
            Rows = Grid.getElementsByTagName('tr');
        }

        function Toggle(Image) {
            ToggleImage(Image);
            ToggleRows();
        }

        function ToggleImage(Image) {
            var group = document.getElementById(Image.id).nextElementSibling;
            var groupName = group.innerText || group.textContent;
            //alert(groupName);
            switch (groupName) {
                case "Demographics":
                    LowerBound = 2;
                    UpperBound = 2;
                    IsExpanded = DemoIsExpanded;
                    DemoIsExpanded = !DemoIsExpanded;
                    break;
                case "Dietary":
                    LowerBound = 4;
                    UpperBound = 28;
                    IsExpanded = DietIsExpanded;
                    DietIsExpanded = !DietIsExpanded;
                    break;
                case "Examination":
                    LowerBound = 30;
                    UpperBound = 63;
                    IsExpanded = ExamIsExpanded;
                    ExamIsExpanded = !ExamIsExpanded;
                    break;
                case "Laboratory":
                    LowerBound = 65;
                    UpperBound = 252;
                    //UpperBound = 74;
                    IsExpanded = LabIsExpanded;
                    LabIsExpanded = !LabIsExpanded;
                    break;
                case "Questionnaire":
                    LowerBound = 254;
                    UpperBound = 321;
                    //LowerBound = 76;
                    //UpperBound = 77;
                    IsExpanded = QuesIsExpanded;
                    QuesIsExpanded = !QuesIsExpanded;
                    break;
            }

            //alert(IsExpanded);
            if (IsExpanded) {
                Image.src = ExpandImage;
                Image.title = 'Expand';
                Grid.rules = 'none';
                n = LowerBound;

                //IsExpanded = false;
            }
            else {
                Image.src = CollapseImage;
                Image.title = 'Collapse';
                Grid.rules = 'cols';
                n = UpperBound;

                //IsExpanded = true;
            }

            //alert(LowerBound + ' ' + UpperBound + ' ' + n);
        }

        function ToggleRows() {
            if (n < LowerBound || n > UpperBound) return;

            Rows[n].style.display = Rows[n].style.display === '' ? 'none' : '';
            if (!IsExpanded) n--; else n++;
            setTimeout("ToggleRows()", TimeSpan);
        }

        $(document).ready(function () {
            $('#ct101').submit(function () {
                blockUIForDownload();
            });
        });

        function ShowColumns(CheckBox) {
            if (CheckBox.checked) {
                //alert($(CheckBox).parent().attr('columnname'));
                $(".pdsa-column-display").removeClass("hidden");

                var columns = $(CheckBox).parent().attr('columnname').split(',');
                //var studyName = $(CheckBox).closest('td').prev('td').text();

                var id = $(CheckBox).parent().attr('id');
                var yearfrom = $(CheckBox).parent().attr('yearfrom');
                var yearto = parseInt(yearfrom) + 1;
                var groupname = $(CheckBox).parent().attr('groupname');
                var foldername = $(CheckBox).parent().attr('foldername');
                var codebook = $(CheckBox).parent().attr('codebook');
                var studyname = yearfrom + '-' + yearto + '/' + groupname + '/' + foldername;
                var selectedList = [];
                var cookieId = yearfrom + id;

                var specialId = id * (parseFloat(yearfrom) + parseFloat(yearto));


                //var html = "<label title='wwwn.cdc.gov/Nchs/Nhanes/2011-2012/CBC_G.htm' for='" + studyname + "'>" + studyname + "</label><br/>";
                //var html = "<a href='http://" + codebook + "' color='green' target='_blank' title='code book'" + "'>" + studyname + "</a>"; 
                var html = "<h5 style='color: green;'><strong><a href='http://" + codebook + "' style='color: green;' target='_blank' title='code book'" + "'>" + studyname + "</a></strong></h5>";
                html += "<input type='button' id='btnSelectAll' class='btn btn-success btn-sm' value='Select All' onclick='selectAll(" + specialId + "," + cookieId + ")'><input type='button' id='btnDeselectAll' class='btn btn-danger btn-sm' value='Deselect All' onclick='deSelectAll(" + specialId + "," + cookieId + ")'>";
                html += "<span id='closeDiv' onclick='closeWindow()'>x</span><br />&nbsp;";
                //html += "<a href='http://" + codebook + "' color='green' target='_blank' title='code book'" + "'>" + studyname + "</a>"; 
                html += "<div class='row'>";
                for (var i = 0; i < columns.length - 1; i++) {
                    var columnName = columns[i];

                    if (columnName === "SEQN") {
                        html += "<div class='col-md-4' id='" + specialId + "'><input checked='true' type='checkbox' onclick='return false;' name='columns' id='" + columnName + "' class='module' />";
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                        //add cookie to SEQN (since it's pre-checked)--------------
                        if (dict[cookieId]) {
                            dict[cookieId] += 'SEQN' + ',';
                        }
                        else {
                            ClearCookie(cookieId);
                            dict[cookieId] = 'SEQN' + ',';
                        }
                        //end add cookie --------------------
                    } else {
                        html += "<div class='col-md-4' id='" + specialId + "'><input type='checkbox' name='columns' id='" + columnName + "' class='module' />";
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                    }

                    //$('#' + columnName).attr("specialId", specialId);

                    if ((i + 1) % 3 === 0) {
                        html += "</div>";
                        html += "<div class='row'>";
                    }

                }

                html += "<div class='row'><br />&nbsp;</div>";
                html += "&emsp;<div class='col-md-4'><input type='button' id='btnSelectAll' class='btn btn-success btn-sm' value='Select All' onclick='selectAll(" + specialId + "," + cookieId + ")'><input type='button' id='btnDeselectAll' class='btn btn-danger btn-sm' value='Deselect All' onclick='deSelectAll(" + specialId + "," + cookieId + ")'></div><div class='col-md-4'><input type='button' id='btnClose' class='btn btn-primary' value='Close' onclick='closeWindow()' /><br /><br /></div>&emsp;";
                html += "</div>";


                //Generate viewBox
                $("#moduleListTitle").html(html);
                $('#moduleListTitle').parent().trigger('create');

                //-->Add cookie through dict[cookieID]
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



                //if (selectedList.length > 0) {
                //    var columns;
                //    for (i = 0; i < selectedList.length; i++) {
                //        columns += selectedList[i].value;
                //    }

                //    SetCookie(id, columns);
                //}

            }
            else {
                $(".pdsa-column-display").addClass("hidden");
            }
        }

        //$(':checkbox').each(function () {
        //    numOfChecked++;
        //});

        //if (numOfChecked > maxChecked) {
        //    alert('WARNING:  You have exceeded the number of allowed variables.  Please limit your number of variables to 100 and try again.');
        //}

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
                if (pId === specialId) {
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
                if (pId === specialId && this.id !== 'SEQN') {
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
                if (cookieValue === token)
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

        $(document).ready(function () {

            <%--var target = $('#<%=GridViewStudy.ClientID%>');     
            var target_children = target.children();
            var panelHeader = $('#<%=GridViewStudy.ClientID%>').clone(); 
            panelHeader.attr("class", "panelHeader");
            panelHeader.find("tr:gt(0)").hide();           
            panelHeader.css('width', '98.6%');
            panelHeader.css('height', '60px');
            panelHeader.find("th:first-child").css('width', '6.2%');//3.4%
            panelHeader.find("th:nth-child(2)").css('width', '54.45%');//55.1%
            panelHeader.find("th:nth-child(3)").css('width', '4.8%');
            panelHeader.find("th:nth-child(4)").css('width', '4.8%');
            panelHeader.find("th:nth-child(5)").css('width', '5%');
            panelHeader.find("th:nth-child(6)").css('width', '5%');
            panelHeader.find("th:nth-child(7)").css('width', '5%');
            panelHeader.find("th:nth-child(8)").css('width', '5%');
            panelHeader.find("th:nth-child(9)").css('width', '5%');
            panelHeader.find("th:nth-child(10)").css('width', '5%');
            panelHeader.prependTo($('#results_table')); --%>

        });


    </script>

    <style>
        /*.table {
            width: 100%;
        }

        #panelHeader, .panelHeader {
            position: absolute;
            
        }

        html{ 
            overflow-y: scroll;
        }*/
    </style>

    <div id="floatingHeader"></div>

    <div style="margin-left: -10px;">
        <div class="row">
            <div class="col-lg-12">
                <h4 class="page-header"><strong>NHANES Data</strong></h4>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <input type="hidden" id="download_token_value_id" runat="server">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-body innerContainer2" id="gridArea">


                        <div <%--style="position: relative;" --%> class="innerContainer">
                            

                            <asp:GridView ID="GridViewStudy" runat="server" AutoGenerateColumns="False"
                                class="table table-bordered container-fluid"
                                OnPreRender="GridViewStudy_PreRender"
                                OnRowDataBound="GridViewStudy_DataBound"
                                OnRowCreated="GridViewStudy_RowCreated"
                                OnRowCommand="GridViewStudy_RowCommand">

                                <HeaderStyle CssClass="ColumnHeaderStyle dataHeader" BackColor="#B3FFB3" />

                                <AlternatingRowStyle BackColor="LightYellow" />
                                <RowStyle BackColor="White" />

                                <Columns>
                                    <asp:TemplateField HeaderText="DataSet">
                                        <ItemTemplate>

                                            <asp:Image ID="imgCollapse" runat="server" onclick="javascript:Toggle(this);"
                                                Visible="true" ImageUrl="~/images/collapse.gif"
                                                Height="17px" Width="14px" />
                                            <asp:Label ID="lblGroupName" runat="server"
                                                Text='<%#Eval("GroupName")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblId" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="GroupShortName" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGroupShortName" runat="server" Text='<%# Bind("GroupShortName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="1999-2000">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow1999" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2001-2002">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2001" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2003-2004">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2003" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2005-2006">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2005" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2007-2008">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2007" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2009-2010">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2009" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2011-2012">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2011" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="2013-2014">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkRow2013" runat="server" onclick="javascript:ShowColumns(this)"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="FileExists" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFileExists" runat="server" Text='<%# Bind("FileExists") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>




                                </Columns>
                            </asp:GridView>



                        </div> <%-- Inner Container --%>
                        <div class="row" <%--style="background-color: olivedrab"--%>>

                            <br />

                            <%-- <div class='col-md-8'></div>--%>


                            <div style="text-align: right; margin-right: 10px;">

                                <strong>Download Format:</strong>

                                <asp:Button ID="txtFormat" runat="server" Text=".txt" OnClick="btnSubmit_Click_Txt" OnClientClick="blockUIForDownload()" class="btn btn-success" UseSubmitBehavior="False" />

                                <asp:Button ID="spssFormat" runat="server" Text="SPSS" OnClick="btnSubmit_Click_Spss" OnClientClick="blockUIForDownload()" class="btn btn-danger" UseSubmitBehavior="False" />

                                <asp:Button ID="csvFormat" runat="server" Text="CSV" OnClick="btnSubmit_Click_Csv" OnClientClick="blockUIForDownload()" class="btn btn-default" UseSubmitBehavior="False" />

                                <asp:Button ID="btnSubmit" runat="server" Text="SAS" OnClick="btnSubmit_Click" OnClientClick="blockUIForDownload()" class="btn btn-primary" UseSubmitBehavior="False" />


                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>


    <%--<style>
            button:active{
                background-color: black !important;
                font-weight: bold;
            }
            button:focus{
                background-color: black !important;
                font-weight: bold;
            }
        </style>--%>




    <div class="pdsa-submit-progress hidden">
        <i class="fa fa-2x fa-spinner fa-spin"></i>
        <label>Please wait while Downloading...</label>
    </div>

    <div id="moduleListTitle" class="pdsa-column-display hidden">
        <%--<asp:Button id="b1" Text="Close" runat="server" OnClientClick="close()" />--%>
    </div>




</asp:Content>
