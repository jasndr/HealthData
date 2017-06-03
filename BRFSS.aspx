﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="BRFSS.aspx.cs" Inherits="HealthData2.BRFSS" %>
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
        <img src="./images/Banner_Print(CIM).png" style="width: 75%; max-height: 4%; margin-left: auto; margin-right: auto; display: block; position: relative;" />
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
        
        function ShowColumns2(CheckBox, chkbox_columnname, chkbox_year, chkbox_codebook, chkbox_special) {
            if (CheckBox.checked) {

                //--Test to view column name and id--//
                //alert($(CheckBox).attr('id') + '\n ' + chkbox_year + '\n' + chkbox_codebook + '\n' + chkbox_special);
              
                //Unhide viewbox
                $(".pdsa-column-display").removeClass("hidden");
                

                var columns = chkbox_columnname.split(',');
                //---> Set id, year, cookieID, specialID, codebook
                var id = $(CheckBox).attr('id');
                var year = chkbox_year;
                var cookieId = year + id;
                var specialId = (id + (parseFloat(year)*352));
                var codebook = chkbox_codebook;
                

                //---> Create HTML elements of page
                var html = "<h5 style='color: green;'><strong><a href='" + codebook + "' style='color: green;' target='_blank' title='code book'" + "'> BRFSS " + year + " Datasets</a></strong></h5>";
                html += "<input type='button' id='btnSelectAll' class='btn btn-success btn-xs' value='Select All' onclick='selectAll2(" + CheckBox + ", " + specialId + "," + cookieId + ")' /><input type='button' id='btnDeselectAll' class='btn btn-danger btn-xs' value='Deselect All' onclick='deSelectAll2(" + CheckBox + ", " + specialId + "," + cookieId + ")' />";
                html += "<span id='closeDiv' onclick='closeWindow()'>X</span><br />&nbsp;";
                html += "<div class='row'>";
                for (var i = 0; i < columns.length - 1; i++) {
                    var columnName = columns[i];

                    if (columnName == " SEQNO") {
                        

                        html += "<div class='col-md-4' id='" + specialId + "'><input checked='true' type='checkbox' onclick='return false;' name='columns' id='" + columnName + "' class='module' />";
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                        //add cookie to SEQN (since it's pre-checked)--------------
                        if (dict[cookieId]) {
                            dict[cookieId] += 'SEQNO' + ',';
                        }
                        else {
                            ClearCookie(cookieId);
                            dict[cookieId] = 'SEQNO' + ',';
                        }
                        //end add cookie --------------------
                    } else {
                        html += "<div class='col-md-4' id='" + specialId + "'><input type='checkbox' name='columns' id='" + columnName + "' class='module' />";
                        html += "<label for='" + columnName + "'>" + columnName + "</label></div>";
                    }

                    //$('#' + columnName).attr("specialId", specialId);

                    if ((i + 1) % 3 == 0) {
                        html += "</div>"
                        html += "<div class='row'>";
                    }

                }

               //---> Add row of buttons
                html += "<div class='row'><br />&nbsp;</div>"
                html += "&emsp;<div class='col-md-4'><input type='button' id='btnSelectAll' class='btn btn-success btn-xs' value='Select All' onclick='selectAll2(" + CheckBox + ", " + specialId + "," + cookieId + ")' /><input type='button' id='btnDeselectAll' class='btn btn-danger btn-xs' value='Deselect All' onclick='deSelectAll2(" + CheckBox + ", " + specialId + "," + cookieId + ")'/></div><div class='col-md-4'><input type='button' id='btnClose' class='btn btn-primary btn-xs' value='Close' onclick='closeWindow()' /><br /><br /></div>&emsp;";
                html += "</div>"
 
               // alert('id: ' + id + '\n year: ' + year + '\n cookieID: ' + cookieID + '\n specialID: ' + specialID + '\n codebook: ' + codebook);

                //Generate viewBox
                $("#moduleListTitle").html(html);
                $('#moduleListTitle').parent().trigger('create');

                //---> Add cookie through dict[cookieID]
                $('input:checkbox.module').on('change', function () {
                    if ($(this).is(':checked')) {
                        if (dict[cookieId]) {
                            dict[cookieId] += $(CheckBox).attr('id') + ',';
                        }
                        else {
                            ClearCookie(cookieId);
                            dict[cookieId] = $(CheckBox).attr('id') + ',';
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

        function SetCookie(name, value)
        {
            document.cookie = name + "=" + escape(value);
        }

        function closeWindow() {
            //alert("test");
            for (var key in dict) {
                SetCookie(key, dict[key]);
            }

            $(".pdsa-column-display").addClass("hidden");
        }

        /************************************************************************************
        //Selects all checkboxes in the current window
        function selectAll(specialId, cookieId) {
            $(':checkbox').each(function () {
                //Obtains the parent node
                var pId = this.parentNode.id;

                //If the parent node equals the special id specified, then check this box
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
                    //alert('pId' + pId + '\nspecialId' + specialId);
                }


            });
        }


        //Deselects all checkboxes in the current window
        function deSelectAll(specialId, cookieId) {
            $(':checkbox').each(function () {
                var pId = this.parentNode.id;
                if (pId == specialId && this.id != 'SEQN') {
                    $(this).prop('checked', false);
                    dict[cookieId] = dict[cookieId].replace(this.id + ',', '');
                }

            });
        }
        ****************************************************************************************/

        //Selects all checkboxes in the current window
        function selectAll2(me, specialId, cookieId) {
            alert('Comment t`allez vous?');
            $(':checkbox').each(function () {
                //Obtains the parent node
                var pId = me.special;

                //If the parent node equals the special id specified, then check this box
                if (pId == specialId) {
                    me.prop('checked', true);

                    //add cookie
                    if (dict[cookieId]) {
                        dict[cookieId] += this.id + ',';
                    }
                    else {
                        ClearCookie(cookieId);
                        dict[cookieId] = this.id + ',';
                    }
                    //alert('pId' + pId + '\nspecialId' + specialId);
                }


            });
        }

        //Deselects all checkboxes in the current window
        function deSelectAll2(me, specialId, cookieId) {
            $(':checkbox').each(function () {
                var pId = me.special;
                if (pId == specialId /*&& this.id != 'SEQN'*/) {
                    me.prop('checked', false);
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
    <%--<script src="Scripts/common.js"></script>--%>



</asp:Content>
 

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">



    <script>

        $(document).ready(function () {

            //Set checkbox parent attributes
            <%--$('#<%=chk15.ClientID%>').attr('columnname', '_STATE, FMONTH, IDATE, IMONTH, IDAY, IYEAR, DISPCODE, SEQNO, _PSU, CTELENUM, PVTRESD1, COLGHOUS, STATERES, CELLFON3, LADULT, NUMADULT, NUMMEN, NUMWOMEN, CTELNUM1, CELLFON2, CADULT, PVTRESD2, CCLGHOUS, CSTATE, LANDLINE, HHADULT, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLN1, PERSDOC2, MEDCOST, CHECKUP1, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, ASTHNOW, CHCSCNCR, CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, DIABETE3, DIABAGE2, SEX, MARITAL, EDUCA, RENTHOM1, NUMHHOL2, NUMPHON2, CPDEMO1, VETERAN3, EMPLOY1, CHILDREN, INCOME2, INTERNET, WEIGHT2, HEIGHT3, PREGNANT, QLACTLM2, USEEQUIP, BLIND, DECIDE, DIFFWALK, DIFFDRES, DIFFALON, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK2, USENOW3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, FRUITJU1, FRUIT1, FVBEANS, FVGREEN, FVORANG, VEGETAB1, EXERANY2, EXRACT11, EXEROFT1, EXERHMM1, EXRACT21, EXEROFT2, EXERHMM2, STRENGTH, LMTJOIN3, ARTHDIS2, ARTHSOCL, JOINPAIN, SEATBELT, FLUSHOT6, FLSHTMY2, IMFVPLAC, PNEUVAC3, HIVTST6, HIVTSTD3, WHRTST10, PDIABTST, PREDIAB1, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, CAREGIV1, CRGVREL1, CRGVLNG1, CRGVHRS1, CRGVPRB1, CRGVPERS, CRGVHOUS, CRGVMST2, CRGVEXPT, VIDFCLT2, VIREDIF3, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT4, VIGLUMA2, VIMACDG2, CIMEMLOS, CDHOUSE, CDASSIST, CDHELP, CDSOCIAL, CDDISCUS, WTCHSALT, LONGWTCH, DRADVISE, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, HAREHAB1, STREHAB1, CVDASPRN, ASPUNSAF, RLIVPAIN, RDUCHART, RDUCSTRK, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, TETANUS, HPVADVC2, HPVADSHT, SHINGLE2, HADMAM, HOWLONG, HADPAP2, LASTPAP2, HPVTEST, HPLSTTST, HADHYST2, PROFEXAM, LENGEXAM, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, PCPSAAD2, PCPSADI1, PCPSARE1, PSATEST1, PSATIME, PCPSARS1, PCPSADE1, PCDMDECN, SCNTMNY1, SCNTMEL1, SCNTPAID, SCNTWRK1, SCNTLPAD, SCNTLWK1, SXORIENT, TRNSGNDR, RCSGENDR, RCSRLTN2, CASTHDX2, CASTHNO2, EMTSUPRT, LSATISFY, ADPLEASR, ADDOWN, ADSLEEP, ADENERGY, ADEAT1, ADFAIL, ADTHINK, ADMOVE, MISTMNT, ADANXEV, QSTVER, QSTLANG, EXACTOT1, EXACTOT2, MSCODE, _STSTR, _STRWT, _RAWRAKE, _WT2RAKE, _CHISPNC, _CRACE1, _CPRACE, _CLLCPWT, _DUALUSE, _DUALCOR, _LLCPWT, _RFHLTH, _HCVU651, _RFHYPE5, _CHOLCHK, _RFCHOL, _MICHD, _LTASTH1, _CASTHM1, _ASTHMS1, _DRDXAR1, _PRACE1, _MRACE1, _HISPANC, _RACE, _RACEG21, _RACEGR3, _RACE_G1, _AGEG5YR, _AGE65YR, _AGE80, _AGE_G, HTIN4, HTM4, WTKG3, _BMI5, _BMI5CAT, _RFBMI5, _CHLDCNT, _EDUCAG, _INCOMG, _SMOKER3, _RFSMOK3, DRNKANY5, DROCDY3_, _RFBING5, _DRNKWEK, _RFDRHV5, FTJUDA1_, FRUTDA1_, BEANDAY_, GRENDAY_, ORNGDAY_, VEGEDA1_, _MISFRTN, _MISVEGN, _FRTRESP, _VEGRESP, _FRUTSUM, _VEGESUM, _FRTLT1, _VEGLT1, _FRT16, _VEG23, _FRUITEX, _VEGETEX, _TOTINDA, METVL11_, METVL21_, MAXVO2_, FC60_, ACTIN11_, ACTIN21_, PADUR1_, PADUR2_, PAFREQ1_, PAFREQ2_, _MINAC11, _MINAC21, STRFREQ_, PAMISS1_, PAMIN11_, PAMIN21_, PA1MIN_, PAVIG11_, PAVIG21_, PA1VIGM_, _PACAT1, _PAINDX1, _PA150R2, _PA300R2, _PA30021, _PASTRNG, _PAREC1, _PASTAE1, _LMTACT1, _LMTWRK1, _LMTSCL1, _RFSEAT2, _RFSEAT3, _FLSHOT6, _PNEUMO2, _AIDTST3');
            $('#<%=chk15.ClientID%>').attr('year', '2015');
            $('#<%=chk15.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf');
            $('#<%=chk15.ClientID%>').attr('special', 'chk15709280');

            $('#<%=chk14.ClientID%>').attr('columnname', '_STATE, FMONTH, IDATE, IMONTH, IDAY, IYEAR, DISPCODE, SEQNO, _PSU, CTELENUM, PVTRESD1, COLGHOUS, STATERES, LADULT, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLN1, PERSDOC2, MEDCOST, CHECKUP1, EXERANY2, SLEPTIM1, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, ASTHNOW, CHCSCNCR, CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, DIABETE3, DIABAGE2, LASTDEN3, RMVTETH3, VETERAN3, MARITAL, CHILDREN, EDUCA, EMPLOY1, INCOME2, WEIGHT2, HEIGHT3, NUMHHOL2, NUMPHON2, CPDEMO1, INTERNET, RENTHOM1, SEX, PREGNANT, QLACTLM2, USEEQUIP, BLIND, DECIDE, DIFFWALK, DIFFDRES, DIFFALON, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK2, USENOW3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT6, FLSHTMY2, PNEUVAC3, SHINGLE2, FALL12MN, FALLINJ2, SEATBELT, DRNKDRI2, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PCPSAAD2, PCPSADI1, PCPSARE1, PSATEST1, PSATIME, PCPSARS1, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, HIVTST6, HIVTSTD3, WHRTST10, PDIABTST, PREDIAB1, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, MEDICARE, HLTHCVR1, DELAYMED, DLYOTHER, NOCOV121, LSTCOVRG, DRVISITS, MEDSCOST, CARERCVD, MEDBILL1, ASBIALCH, ASBIDRNK, ASBIBING, ASBIADVC, ASBIRDUC, WTCHSALT, LONGWTCH, DRADVISE, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, IMFVPLAC, TETANUS, HPVTEST, HPLSTTST, HPVADVC2, HPVADSHT, CNCRDIFF, CNCRAGE, CNCRTYP1, CSRVTRT1, CSRVDOC1, CSRVSUM, CSRVRTRN, CSRVINST, CSRVINSR, CSRVDEIN, CSRVCLIN, CSRVPAIN, CSRVCTL1, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, SCNTMNY1, SCNTMEL1, SCNTPAID, SCNTWRK1, SCNTLPAD, SCNTLWK1, SCNTVOT1, SXORIENT, TRNSGNDR, RCSGENDR, RCSRLTN2, CASTHDX2, CASTHNO2, EMTSUPRT, LSATISFY, CTELNUM1, CELLFON2, CADULT, PVTRESD2, CCLGHOUS, CSTATE, LANDLINE, HHADULT, QSTVER, QSTLANG, MSCODE, _STSTR, _STRWT, _RAWRAKE, _WT2RAKE, _AGE80, _IMPRACE, _IMPNPH, _CHISPNC, _CPRACE, _CRACE1, _IMPCAGE, _IMPCRAC, _IMPCSEX, _CLLCPWT, _DUALUSE, _DUALCOR, _LLCPWT2, _LLCPWT, _RFHLTH, _HCVU651, _TOTINDA, _LTASTH1, _CASTHM1, _ASTHMS1, _DRDXAR1, _EXTETH2, _ALTETH2, _DENVST2, _PRACE1, _MRACE1, _HISPANC, _RACE, _RACEG21, _RACEGR3, _RACE_G1, _AGEG5YR, _AGE65YR, _AGE_G, HTIN4, HTM4, WTKG3, _BMI5, _BMI5CAT, _RFBMI5, _CHLDCNT, _EDUCAG, _INCOMG, _SMOKER3, _RFSMOK3, DRNKANY5, DROCDY3_, _RFBING5, _DRNKDY4, _DRNKMO4, _RFDRHV4, _RFDRMN4, _RFDRWM4, _FLSHOT6, _PNEUMO2, _RFSEAT2, _RFSEAT3, _RFMAM2Y, _MAM502Y, _MAM5021, _RFPAP32, _RFPAP33, _RFPSA21, _RFBLDS2, _RFBLDS3, _RFSIGM2, _COL10YR, _HFOB3YR, _FS5YR, _FOBTFS, _CRCREC, _AIDTST3, _IMPEDUC, _IMPMRTL, _IMPHOME, RCSBRAC1, RCSRACE1, RCHISLA1, RCSBIRTH');
            $('#<%=chk14.ClientID%>').attr('year', '2014');
            $('#<%=chk14.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2014/pdf/codebook14_llcp.pdf');
            $('#<%=chk14.ClientID%>').attr('special', 'chk14708928');

            $('#<%=chk13.ClientID%>').attr('columnname', '_STATE, FMONTH, IDATE, IMONTH, IDAY, IYEAR, DISPCODE, SEQNO, _PSU, CTELENUM, PVTRESD1, COLGHOUS, STATERES, CELLFON3, LADULT, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLN1, PERSDOC2, MEDCOST, CHECKUP1, SLEPTIM1, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, ASTHNOW, CHCSCNCR, CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, DIABETE3, VETERAN3, MARITAL, CHILDREN, EDUCA, EMPLOY1, INCOME2, WEIGHT2, HEIGHT3, NUMHHOL2, NUMPHON2, CPDEMO1, CPDEMO4, INTERNET, RENTHOM1, SEX, PREGNANT, QLACTLM2, USEEQUIP, BLIND, DECIDE, DIFFWALK, DIFFDRES, DIFFALON, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK2, USENOW3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, FRUITJU1, FRUIT1, FVBEANS, FVGREEN, FVORANG, VEGETAB1, EXERANY2, EXRACT11, EXEROFT1, EXERHMM1, EXRACT21, EXEROFT2, EXERHMM2, STRENGTH, LMTJOIN3, ARTHDIS2, ARTHSOCL, JOINPAIN, SEATBELT, FLUSHOT6, FLSHTMY2, TETANUS, PNEUVAC3, HIVTST6, HIVTSTD3, WHRTST10, PDIABTST, PREDIAB1, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, MEDICARE, HLTHCVRG, DELAYMED, DLYOTHER, NOCOV121, LSTCOVRG, DRVISITS, MEDSCOST, CARERCVD, MEDBILLS, SSBSUGAR, SSBFRUT2, WTCHSALT, LONGWTCH, DRADVISE, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, HAREHAB1, STREHAB1, CVDASPRN, ASPUNSAF, RLIVPAIN, RDUCHART, RDUCSTRK, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, IMFVPLAC, HPVADVC2, HPVADSHT, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, PCPSAAD2, PCPSADI1, PCPSARE1, PSATEST1, PSATIME, PCPSARS1, PCPSADE1, PCDMDECN, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, MISNERVS, MISHOPLS, MISRSTLS, MISDEPRD, MISEFFRT, MISWTLES, MISNOWRK, MISTMNT, MISTRHLP, MISPHLPF, SCNTMONY, SCNTMEAL, SCNTPAID, SCNTWRK1, SCNTLPAD, SCNTLWK1, SCNTVOT1, RCSGENDR, RCSRLTN2, CASTHDX2, CASTHNO2, EMTSUPRT, LSATISFY, CTELNUM1, CELLFON2, CADULT, PVTRESD2, CCLGHOUS, CSTATE, LANDLINE, PCTCELL, QSTVER, QSTLANG, MSCODE, _STSTR, _STRWT, _RAWRAKE, _WT2RAKE, _IMPRACE, _IMPNPH, _CHISPNC, _CRACE1, _IMPCAGE, _IMPCRAC, _IMPCSEX, _CLLCPWT, _DUALUSE, _DUALCOR, _LLCPWT2, _LLCPWT, _RFHLTH, _HCVU651, _RFHYPE5, _CHOLCHK, _RFCHOL, _LTASTH1, _CASTHM1, _ASTHMS1, _DRDXAR1, _PRACE1, _MRACE1, _HISPANC, _RACE, _RACEG21, _RACEGR3, _RACE_G1, _AGEG5YR, _AGE65YR, _AGE_G, HTIN4, HTM4, WTKG3, _BMI5, _BMI5CAT, _RFBMI5, _CHLDCNT, _EDUCAG, _INCOMG, _SMOKER3, _RFSMOK3, DRNKANY5, DROCDY3_, _RFBING5, _DRNKDY4, _DRNKMO4, _RFDRHV4, _RFDRMN4, _RFDRWM4, FTJUDA1_, FRUTDA1_, BEANDAY_, GRENDAY_, ORNGDAY_, VEGEDA1_, _MISFRTN, _MISVEGN, _FRTRESP, _VEGRESP, _FRUTSUM, _VEGESUM, _FRTLT1, _VEGLT1, _FRT16, _VEG23, _FRUITEX, _VEGETEX, _TOTINDA, METVL11_, METVL21_, MAXVO2_, FC60_, ACTIN11_, ACTIN21_, PADUR1_, PADUR2_, PAFREQ1_, PAFREQ2_, _MINAC11, _MINAC21, STRFREQ_, PAMISS1_, PAMIN11_, PAMIN21_, PA1MIN_, PAVIG11_, PAVIG21_, PA1VIGM_, _PACAT1, _PAINDX1, _PA150R2, _PA300R2, _PA30021, _PASTRNG, _PAREC1, _PASTAE1, _LMTACT1, _LMTWRK1, _LMTSCL1, _RFSEAT2, _RFSEAT3, _FLSHOT6, _PNEUMO2, _AIDTST3, _AGE80, _IMPEDUC, _IMPMRTL, _IMPHOME');
            $('#<%=chk13.ClientID%>').attr('year', '2013');
            $('#<%=chk13.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2013/pdf/codebook13_llcp.pdf');
            $('#<%=chk13.ClientID%>').attr('special', 'chk13708576');

            $('#<%=chk12.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, PVTRESID, COLGHOUS, CELLFON, LADULT, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLN1, PERSDOC2, MEDCOST, CHECKUP1, EXERANY2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, ASTHNOW, CHCSCNCR, CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, CHCVISN1, DIABETE3, LASTDEN3, RMVTETH3, AGE, HISPANC2, MRACE, ORACE2, VETERAN3, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, CTYCODE1, NUMHHOL2, NUMPHON2, CPDEMO1, CPDEMO4, RENTHOM1, SEX, PREGNANT, QLACTLM2, USEEQUIP, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK2, USENOW3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT5, FLSHTMY2, IMFVPLAC, PNEUVAC3, FALL12MN, FALLINJ2, SEATBELT, DRNKDRI2, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PCPSAAD1, PCPSADI1, PCPSARE1, PSATEST1, PSATIME, PCPSARS1, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, HIVTST6, HIVTSTD3, HIVRISK3, PDIABTST, PREDIAB1, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT4, VIGLUMA2, VIMACDG2, SSBSUGR1, SSBFRUT1, SSBCALRI, NUMBURN2, QLREST2, SLEPTIME, SLEPSNOR, SLEPDAY, SLEPDRIV, FRUITJU1, FRUIT1, FVBEANS, FVGREEN, FVORANG, VEGETAB1, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, WRKHCF1, DIRCONT1, DRHPAD1, HAVHPAD, SHINGLE1, TNSARCV, TNSARCNT, TNSASHT1, HPVADVC2, HPVADSHT, PCPSADEC, PCDMDECN, CNCRDIFF, CNCRAGE, CNCRTYP1, CSRVTRT1, CSRVDOC1, CSRVSUM, CSRVRTRN, CSRVINST, CSRVINSR, CSRVDEIN, CSRVCLIN, CSRVPAIN, CSRVCTL1, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, MISNERVS, MISHOPLS, MISRSTLS, MISDEPRD, MISEFFRT, MISWTLES, MISNOWRK, MISTMNT, MISTRHLP, MISPHLPF, SCNTMONY, SCNTMEAL, SCNTPAID, SCNTWRK1, SCNTLPAD, SCNTLWK1, GPWELPR3, GP3DYWTR, GP3DYFD1, GP3DYPRS, GPBATRAD, GPFLSLIT, GPEMRCM1, GPEMRIN1, GPVACPL1, GPMNDEVC, GPNOTEV1, VHCOMBAT, VHDRPTSD, VHDRTBI, VHCOUNSL, VHTAKLIF, VHSUICID, COPDTEST, COPDQOL, COPDDOC, COPDHOSP, COPDMEDS, ACEDEPRS, ACEDRINK, ACEDRUGS, ACEPRISN, ACEDIVRC, ACEPUNCH, ACEHURT, ACESWEAR, ACETOUCH, ACETTHEM, ACEHVSEX, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, FLUSHCH2, RCVFVCH4, WHRTST8, HIVRDTST, EMTSUPRT, LSATISFY, CALLBACK, ADLTCHLD, CTELNUM1, CELLFON2, CADULT, PVTRESD2, CCLGHOUS, CSTATE, RSPSTATE, LANDLINE, PCTCELL, QSTVER, QSTLANG, MSCODE, _STSTR, _STRWT, _RAW, _WT2, _RAWRAKE, _WT2RAKE, _REGION, _IMPAGE, _IMPRACE, _IMPNPH, O_STATE, CRACEORG, CRACEASC, _CRACE, _RAWCH, _WT2CH, CHILDAGE, _CLCPM01, _CLCPM02, _CLCPM03, _CLCPM04, _CLCPM05, _CLLCPWT, _DUALUSE, _DUALCOR, _LLCPM01, _LLCPM02, _LLCPM03, _LLCPM04, _LLCPM05, _LLCPM06, _LLCPM07, _LLCPM08, _LLCPM09, _LLCPM10, _LLCPM11, _LLCPM12, _LLCPWT, _RFHLTH, _HCVU651, _TOTINDA, _LTASTH1, _CASTHM1, _ASTHMS1, _DRDXAR1, _EXTETH2, _ALTETH2, _DENVST2, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN4, HTM4, WTKG3, _BMI5, _BMI5CAT, _RFBMI5, _CHLDCNT, _EDUCAG, _INCOMG, _SMOKER3, _RFSMOK3, DRNKANY5, DROCDY3_, _RFBING5, _DRNKDY4, _DRNKMO4, _RFDRHV4, _RFDRMN4, _RFDRWM4, _FLSHOT5, _PNEUMO2, _RFSEAT2, _RFSEAT3, _RFMAM2Y, _MAM502Y, _RFPAP32, _RFPSA21, _RFBLDS2, _RFSIGM2, _AIDTST3');
            $('#<%=chk12.ClientID%>').attr('year', '2012');
            $('#<%=chk12.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2012/pdf/codebook12_llcp.pdf');
            $('#<%=chk12.ClientID%>').attr('special', 'chk12708224');

            $('#<%=chk11.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLN1, PERSDOC2, MEDCOST, CHECKUP1, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, ASTHNOW, CHCSCNCR, CHCOCNCR, CHCCOPD, HAVARTH3, ADDEPEV2, CHCKIDNY, CHCVISON, DIABETE3, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK2, USENOW3, AGE, HISPANC2, MRACE, ORACE2, VETERAN3, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, CTYCODE1, NUMHHOL2, NUMPHON2, CPDEMO1, CPDEMO2, CPDEMO3, CPDEMO4, RENTHOM1, SEX, PREGNANT, FRUITJU1, FRUIT1, FVBEANS, FVGREEN, FVORANG, VEGETAB1, EXERANY2, EXRACT01, EXEROFT1, EXERHMM1, EXRACT02, EXEROFT2, EXERHMM2, STRENGTH, QLACTLM2, USEEQUIP, LMTJOIN3, ARTHDIS2, ARTHSOCL, JOINPAIN, SEATBELT, FLUSHOT5, FLSHTMY2, IMFVPLAC, PNEUVAC3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, HIVTST6, HIVTSTD3, HIVRISK3, PDIABTST, PREDIAB1, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, SSBSUGAR, SSBFRUIT, SSBCALRI, PFPPREPR, PFPPRGNT, PFPPRVNT, TYPCNTR6, NOBCUSE4, FPCHLDF2, PFPVITMN, VIDFCLT3, VIREDIF3, VIPRFVS3, VINOCRE3, VIEYEXM3, VIINSUR3, VICTRCT3, VIGLUMA3, VIMACDG3, QLREST2, SLEPTIME, SLEPSNOR, SLEPDAY, SLEPDRIV, WRKHCF1, DIRCONT1, DRHPAD1, HAREHAB1, STREHAB1, CVDASPRN, ASPUNSAF, BPEATHBT, BPSALT, BPALCHOL, BPEXER, BPEATADV, BPSLTADV, BPALCADV, BPEXRADV, BPMEDADV, BPHI2MR, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PCPSAREC, PSATEST1, PSATIME, PCPSARSN, PCPSAADV, PCPSADIS, PCPSADEC, PROSTATE, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, SMCQUITL, SMCTRYQT, SMCCALQT, SMCPROGQ, SMCCNSLQ, SMCMEDQT, SMCTIMEQ, SMCPLANQ, SHSNWRK1, SHSNHOM1, SHSRIDEV, SHSINPUB, SHSHOMES, SHSVHICL, SHSALOW1, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, TNSARCV, TNSARCNT, TNSASHT1, HPVADVC2, HPVADSHT, SHINGLE1, COPDTEST, COPDQOL, COPDDOC, COPDHOSP, COPDMEDS, GPWELPR3, GP3DYWTR, GP3DYFD1, GP3DYPRS, GPBATRAD, GPFLSLIT, GPEMRCM1, GPEMRIN1, GPVACPL1, GPMNDEVC, GPNOTEV1, VHCOMBAT, VHDRPTSD, VHDRTBI, VHCOUNSL, VHTAKLIF, VHSUICID, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, ADPLEASR, ADDOWN, ADSLEEP, ADENERGY, ADEAT1, ADFAIL, ADTHINK, ADMOVE, MISTMNT, ADANXEV, CIMEMLOS, CINOADLT, CIRBIAGE, CIHOWOFT, CIASSIST, CIINTFER, CIFAMCAR, CIHCPROF, CIMEDS, CIDIAGAZ, SCNTMONY, SCNTMEAL, SCNTPAID, SCNTWRK1, SCNTLPAD, SCNTLWK1, WHRTST9, HIVRDTS2, EMTSUPRT, LSATISFY, ACEDEPRS, ACEDRINK, ACEDRUGS, ACEPRISN, ACEDIVRC, ACEPUNCH, ACEHURT, ACESWEAR, ACETOUCH, ACETTHEM, ACEHVSEX, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, FLUSHCH2, RCVFVCH4, CHIMRCVE, CALLBACK, ADLTCHLD, CTELNUM1, CELLFON2, CADULT, PVTRESD2, CSTATE, RSPSTATE, LANDLINE, PCTCELL, QSTVER, QSTLANG, MSCODE, _STSTR, _STRWT, _RAW, _WT2, _RAWRAKE, _WT2RAKE, _REGION, _IMPAGE, _IMPRACE, _IMPNPH, O_STATE, CRACEASC, _CRACE, _RAWCH, _WT2CH, CHILDAGE, _CLCPM01, _CLCPM02, _CLCPM03, _CLCPM04, _CLCPM05, _CLLCPWT, _LLCPM01, _LLCPM02, _LLCPM03, _LLCPM04, _LLCPM05, _LLCPM06, _LLCPM07, _LLCPM08, _LLCPM09, _LLCPM10, _LLCPM11, _LLCPM12, _LLCPWT, _RFHLTH, _HCVU651, _RFHYPE5, _CHOLCHK, _RFCHOL, _LTASTH1, _CASTHM1, _ASTHMS1, _DRDXAR1, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN4, HTM4, WTKG3, _BMI5, _BMI5CAT, _RFBMI5, _CHLDCNT, _EDUCAG, _INCOMG, FTJUDA1_, FRUTDA1_, BEANDAY_, GRENDAY_, ORNGDAY_, VEGEDA1_, _MISFRTN, _MISVEGN, _FRTRESP, _VEGRESP, _FRUTSUM, _VEGESUM, _FRT16, _VEG23, _FRUITEX, _VEGETEX, _TOTINDA, METVAL1_, METVAL2_, MAXVO2_, FC60_, ACTINT1_, ACTINT2_, PADUR1_, PADUR2_, PAFREQ1_, PAFREQ2_, _MINACT1, _MINACT2, STRFREQ_, PAMISS_, PAMIN1_, PAMIN2_, PAMIN_, PAVIGM1_, PAVIGM2_, PAVIGMN_, _PACAT, _PAINDEX, _PA150R1, _PA300R1, _PA3002L, _PASTRNG, _PAREC, _PASTAER, _RFSEAT2, _RFSEAT3, _FLSHOT5, _PNEUMO2, DRNKANY5, DROCDY3_, _RFBING5, _DRNKDY4, _DRNKMO4, _RFDRHV4, _RFDRMN4, _RFDRWM4, _AIDTST3, HAVHPAD');
            $('#<%=chk11.ClientID%>').attr('year', '2011');
            $('#<%=chk11.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2011/pdf/codebook11_llcp.pdf');
            $('#<%=chk11.ClientID%>').attr('special', 'chk11707872');

            $('#<%=chk10.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP1, QLREST2, EXERANY2, DIABETE2, LASTDEN3, RMVTETH3, DENCLEAN, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA2, ASTHNOW, QLACTLM2, USEEQUIP, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK1, USENOW3, AGE, HISPANC2, MRACE, ORACE2, VETERAN2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV3, CPDEMO1, CPDEMO2, CPDEMO3, CPDEMO4, SEX, PREGNANT, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT4, FLSHTMY1, FLUSPRY3, FLSPRMY1, PNEUVAC3, FALL3MN2, FALLINJ2, SEATBELT, DRNKDRI2, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, HIVTST5, HIVTSTD2, WHRTST8, HIVRDTST, HIVRISK2, EMTSUPRT, LSATISFY, FLSYAQ01, FLSYAQ02, FLSYAQ03, FLSYAQ04, FLSYAQ05, FLSYAQ06, FLSYAQ07, FLSYAQ08, FLSYAQ09, FLSYAQ10, FLSYCQ01, FLSYCQ02, PDIABTST, PREDIAB1, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT2, VIGLUMA2, VIMACDG2, NUMBURN2, SLEPTIME, SLEPSNOR, SLEPDAY, SLEPDRIV, BRTHCNT3, TYPCNTR5, NOBCUSE3, FPCHLDF2, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, HAVARTH2, WRKHCF1, DIRCONT1, DRHPAD1, HAVHPAD, SHINGLES, TNSARCV, TNSARCNT, TNSASHOT, HPVADVC2, HPVADSHT, CNCRHAVE, CNCRDIFF, CNCRAGE, CNCRTYPE, CSRVTRT, CSRVDOC, CSRVSUM, CSRVRTRN, CSRVINST, CSRVINSR, CSRVDEIN, CSRVCLIN, CSRVPAIN, CSRVCTRL, CAREGIVE, CRGVAGE, CRGVGNDR, CRGVRELT, CRGVLONG, CRGVPROB, CRGVMST1, CRGVHRS, CRGVDIFF, CRGVCHNG, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, ADPLEASR, ADDOWN, ADSLEEP, ADENERGY, ADEAT1, ADFAIL, ADTHINK, ADMOVE, ADANXEV, ADDEPEV, CIMEMLOS, CINOADLT, CIRBIAGE, CIHOWOFT, CIASSIST, CIINTFER, CIFAMCAR, CIHCPROF, CIMEDS, CIDIAGAZ, RENTHOM1, SCNTMONY, SCNTMEAL, SCNTPAID, SCNTWORK, SCNTLPAD, SCNTLWRK, SCNTVOTE, GPWELPR3, GP3DYWTR, GP3DYFD1, GP3DYPRS, GPBATRAD, GPFLSLIT, GPEMRCM1, GPEMRIN1, GPVACPL1, GPMNDEVC, GPNOTEV1, VHCOMBAT, VHDRPTSD, VHDRTBI, VHCOUNSL, VHTAKLIF, VHSUICID, ACEDEPRS, ACEDRINK, ACEDRUGS, ACEPRISN, ACEDIVRC, ACEPUNCH, ACEHURT, ACESWEAR, ACETOUCH, ACETTHEM, ACEHVSEX, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, FLUSHCH2, RCVFVCH4, HPVCHVC, HPVCHSHT, CALLBACK, ADLTCHLD, QSTVER, QSTLANG, H1N1AQ01, H1N1AQ02, H1N1AQ03, H1N1AQ04, H1N1AQ05, H1N1AQ06, H1N1AQ07, H1N1AQ08, H1N1AQ09, H1N1AQ10, H1N1CQ01, H1N1CQ02, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _AGEG1_, _AGEG2_, _AGEG3_, _SEXG_, _SEXG1_, _SEXG2_, _SEXG3_, _RACEG3_, _RACEG31, _RACEG32, _RACEG33, _IMPAGE, _IMPNPH, MSCODE, CRACEORG, CRACEASC, _CRACE, CHILDAGE, _CIMPAG1, _CSEXG1_, _CRACE1_, _CAGEG1_, _CIMPAG2, _CSEXG2_, _CRACE2_, _CAGEG2_, _CIMPAG3, _CSEXG3_, _CRACE3_, _CAGEG3_, _CIMPAGE, _CSEXG_, _CRACEG_, _CAGEG_, _RAWCH, _WT2CH, _POSTCH, _CHILDWT, _RFHLTH, _HCVU65, _TOTINDA, _EXTETH2, _ALTETH2, _DENVST1, _LTASTHM, _CASTHMA, _ASTHMST, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, DROCDY2_, _RFBING4, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, _FLSHOT4, _PNEUMO2, _RFSEAT2, _RFSEAT3, _RFMAM2Y, _MAM502Y, _RFPAP32, _RFPSA2Y, _RFBLDS2, _RFSIGM2, _AIDTST2, CPCOUNTY, _ITSCF1, _ITSCF2, _ITSPOST, _ITSFINL, _RAWHH, _WT2HH, _POSTHH, _HOUSEWT');
            $('#<%=chk10.ClientID%>').attr('year', '2010');
            $('#<%=chk10.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2010/pdf/codebook_10.pdf');
            $('#<%=chk10.ClientID%>').attr('special', 'chk10707520');

            $('#<%=chk09.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP1, QLREST2, EXERANY2, DIABETE2, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA2, ASTHNOW, SMOKE100, SMOKDAY2, STOPSMK2, LASTSMK1, USENOW3, AGE, HISPANC2, MRACE, ORACE2, VETERAN2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, WTYRAGO, WTCHGINT, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV2, SEX, PREGNANT, CAREGIVE, QLACTLM2, USEEQUIP, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT3, FLUSHTMY, FLUSPRY2, FLUSPRMY, PNEUVAC3, HAVARTH2, LMTJOIN2, ARTHDIS2, ARTHSOCL, JOINPAIN, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, HIVTST5, HIVTSTD2, WHRTST8, HIVRDTST, HIVRISK2, EMTSUPRT, LSATISFY, CNCRHAVE, CNCRDIFF, CNCRAGE, CNCRTYPE, CPDEMO1, CPDEMO2, CPDEMO3, CPDEMO4, PDIABTST, PREDIAB1, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT2, VIGLUMA2, VIMACDG2, SLEPTIME, SLEPSNOR, SLEPDAY, SLEPDRIV, HAREHAB1, STREHAB1, CVDASPRN, ASPUNSAF, BPEATHBT, BPSALT, BPALCHOL, BPEXER, BPEATADV, BPSLTADV, BPALCADV, BPEXRADV, BPMEDADV, BPHI2MR, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, CSRVTRT, CSRVDOC, CSRVSUM, CSRVRTRN, CSRVINST, CSRVINSR, CSRVDEIN, CSRVCLIN, CSRVPAIN, CSRVCTRL, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, TNSARCV, TNSARCNT, TNSASHOT, HPVADVC, HPVADSHT, SHINGLES, CRGVAGE, CRGVGNDR, CRGVRELT, CRGVLONG, CRGVPROB, CRGVMOST, CRGVHRS, CRGVDIFF, CRGVCHNG, GPWELPR3, GP3DYWTR, GP3DYFD1, GP3DYPRS, GPBATRAD, GPFLSLIT, GPEMRCM1, GPEMRIN1, GPVACPL1, GPMNDEVC, GPNOTEV1, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, MISNERVS, MISHOPLS, MISRSTLS, MISDEPRD, MISEFFRT, MISWTLES, MISNOWRK, MISTMNT, MISTRHLP, MISPHLPF, IAQCODT1, CMDGPPWR, CMDGPBAT, CMDGPGEN, CMDGPDSL, CMDGPLOC, CMDGPRUN, CMDGPOWN, RENTHOM1, SCNTMONY, SCNTMEAL, SCNTPAID, SCNTWORK, SCNTLPAD, SCNTLWRK, SCNTVOTE, ACEDEPRS, ACEDRINK, ACEDRUGS, ACEPRISN, ACEDIVRC, ACEPUNCH, ACEHURT, ACESWEAR, ACETOUCH, ACETTHEM, ACEHVSEX, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, FLUSHCH1, RCVFVCH3, HPVCHVC, HPVCHSHT, TNSCRCV, TNSCRCNT, TNSCSHOT, CALLBACK, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, MSCODE, CHILDAGE, _CIMPAGE, _RFHLTH, _HCVU65, _TOTINDA, _RFHYPE5, _CHOLCHK, _RFCHOL, _LTASTHM, _CASTHMA, _ASTHMST, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, DROCDY2_, _RFBING4, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, _FLSHOT3, _PNEUMO2, _DRDXART, FTJUDAY_, FRUTDAY_, GNSLDAY_, POTADAY_, CRTSDAY_, VEGEDAY_, _FRTSERV, _FRTINDX, _FV5SRV, _MODPAMN, _VIGPAMN, MODCAT_, VIGCAT_, PACAT_, _RFPAMOD, _RFPAVIG, _RFPAREC, _RFNOPA, _MODMNWK, _VIGMNWK, _TOTMNWK, _PA150RC, _PA300RC, _AIDTST2, CPCOUNTY, _ITSCF1, _ITSCF2, _ITSPOST, _ITSFINL, CRACEORG, CRACEASC, _CRACE, _CSEXG_, _CRACEG_, _CAGEG_, _RAWCH, _WT2CH, _POSTCH, _CHILDWT, _RAWHH, _WT2HH, _POSTHH, _HOUSEWT, POPSIZE, CT10000, KEEPCHIM, KEEPRCSM');
            $('#<%=chk09.ClientID%>').attr('year', '2009');
            $('#<%=chk09.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2009/pdf/codebook_09.pdf');
            $('#<%=chk09.ClientID%>').attr('special', 'chk09707168');

            $('#<%=chk08.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP1, QLREST2, EXERANY2, DIABETE2, LASTDEN3, RMVTETH3, DENCLEAN, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA2, ASTHNOW, QLACTLM2, USEEQUIP, SMOKE100, SMOKDAY2, STOPSMK2, AGE, HISPANC2, MRACE, ORACE2, VETERAN1, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, WTYRAGO, WTCHGINT, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV2, SEX, PREGNANT, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT3, FLUSHTMY, FLUSPRY2, FLUSPRMY, PNEUVAC3, FALL3MN2, FALLINJ2, SEATBELT, DRNKDRI2, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS3, HADSIGM3, HADSGCO1, LASTSIG3, HIVTST5, HIVTSTD2, WHRTST8, HIVRDTST, HIVRISK2, EMTSUPRT, LSATISFY, CPDEMO, CPSCREN, PDIABTST, PREDIAB, DIABAGE2, INSULIN, BLDSUGAR, FEETCHK2, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, PAINACT2, QLMENTL2, QLSTRES2, QLHLTH2, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT2, VIGLUMA2, VIMACDG2, HRVOLNTR, HRDIRCAR, HRCHRNIL, HRSTLHAV, DRNKBER1, DRNKWIN1, DRNKLIQR, DRNKPMIX, DRNKLOC1, BINGEDRV, BINGEPAY, USEEVER3, USENOW3, USOTHNW1, SHSINWRK, SHSINHOM, HOUSSMK1, SHSALOWB, SHSALOWR, SHSALOWW, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, HPVADVC, HPVADSHT, VETSTAT2, VACARE1, VAIRQAFG, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, ADPLEASR, ADDOWN, ADSLEEP, ADENERGY, ADEAT1, ADFAIL, ADTHINK, ADMOVE, ADANXEV, ADDEPEV, GPWELPR3, GP3DYWTR, GP3DYFD1, GP3DYPRS, GPBATRAD, GPFLSLIT, GPEMRCM1, GPEMRIN1, GPVACPL1, GPMNDEVC, GPNOTEV1, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, HPVCHVC, HPVCHSHT, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, MSCODE, CHILDAGE, _CIMPAGE, _CHILDWT, _RFHLTH, _HCVU65, _TOTINDA, _EXTETH2, _ALTETH2, _DENVST1, _LTASTHM, _CASTHMA, _ASTHMST, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, DROCDY2_, _RFBING4, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, _FLSHOT3, _PNEUMO2, _RFSEAT2, _RFSEAT3, _RFMAM2Y, _MAM502Y, _RFPAP32, _RFPSA2Y, _RFBLDS2, _RFSIGM2, _AIDTST2, _ITSCF1, _ITSCF2, _ITSPOST, _ITSFINL, CRACEORG, CRACEASC, _CRACE, _CSEXG_, _CRACEG_, _CAGEG_, _RAWCH, _WT2CH, _POSTCH, _RAWHH, _WT2HH, _POSTHH, _HOUSEWT');
            $('#<%=chk08.ClientID%>').attr('year', '2008');
            $('#<%=chk08.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2008/pdf/codebook08.pdf');
            $('#<%=chk08.ClientID%>').attr('special', 'chk08706816');

            $('#<%=chk07.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP1, EXERANY2, DIABETE2, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA2, ASTHNOW, FLUSHOT3, FLUSPRY2, PNEUVAC3, HEPBVAC, HEPBRSN2, SMOKE100, SMOKDAY2, STOPSMK2, AGE, HISPANC2, MRACE, ORACE2, VETERAN1, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, WTYRAGO, WTCHGINT, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV2, SEX, PREGNANT, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK3GE5, MAXDRNKS, QLACTLM2, USEEQUIP, PAIN30DY, JOINTSYM, JOINTRT2, HAVARTH2, LMTJOIN2, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, HIVTST5, HIVTSTD2, WHRTST8, HIVRDTST, EMTSUPRT, LSATISFY, DIAR30DY, DIADRVST, DIARSMP, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRLTN2, CASTHDX2, CASTHNO2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT2, VIGLUMA2, VIMACDG2, VIATWRK2, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, HAREHAB, STREHAB, CVDASPRN, ASPUNSAF, BPEATHBT, BPSALT, BPALCHOL, BPEXER, BPEATADV, BPSLTADV, BPALCADV, BPEXRADV, BPMEDADV, BPHI2MR, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM3, HADSGCOL, LASTSIG2, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED3, ASINHALR, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, VETSTAT2, VACARE, VAIRQAFG, RRCLASS2, RRCOGNT2, RRATWRK2, RRHCARE3, RRPHYSM2, RREMTSM2, MISNERVS, MISHOPLS, MISRSTLS, MISDEPRD, MISEFFRT, MISWTLES, MISNOWRK, MISTMNT, MISTRHLP, MISPHLPF, SVSAFE, SVSEXTCH, SVNOTCH2, SVEHDSEX, SVHDSX12, SVEANOSX, SVNOSX12, SVRELAT2, SVGENDER, IPVSAFE, IPVTHRAT, IPVPHYV2, IPVPHHRT, IPVUWSEX, IPVPVL12, IPVSXINJ, IPVRELT2, GPWELPR2, GPVACPLN, GP3DYWTR, GP3DYFOD, GP3DYPRS, GPBATRAD, GPFLSLIT, GPMNDEVC, GPNOTEVC, GPEMRCOM, GPEMRINF, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, MSCODE, CHILDAGE, _RFHLTH, _HCVU65, _TOTINDA, _RFHYPE5, _CHOLCHK, _RFCHOL, _LTASTHM, _CASTHMA, _ASTHMST, _FLSHOT3, _PNEUMO2, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, RACE2, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, DROCDY2_, _RFBING4, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, _DRDXART, FTJUDAY_, FRUTDAY_, GNSLDAY_, POTADAY_, CRTSDAY_, VEGEDAY_, _FRTSERV, _FRTINDX, _FV5SRV, _MODPAMN, _VIGPAMN, MODCAT_, VIGCAT_, PACAT_, _RFPAMOD, _RFPAVIG, _RFPAREC, _RFNOPA, _AIDTST2, _ITSCF1, _ITSCF2, _ITSPOST, _ITSFINL, CRACEORG, CRACEASC, _CRACE, _CSEXG_, _CRACEG_, _CAGEG_, _RAWCH, _WT2CH, _POSTCH, _CHILDWT, _RAWHH, _WT2HH, _POSTHH, _HOUSEWT');
            $('#<%=chk07.ClientID%>').attr('year', '2007');
            $('#<%=chk07.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2007/pdf/codebook_07.pdf');
            $('#<%=chk07.ClientID%>').attr('special', 'chk07706464');

            $('#<%=chk06.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON1, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP, EXERANY2, DIABETE2, LASTDEN3, RMVTETH3, DENCLEAN, CVDINFR3, CVDCRHD3, CVDSTRK3, ASTHMA2, ASTHNOW, QLACTLM2, USEEQUIP, SMOKE100, SMOKDAY2, STOPSMK2, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV2, SEX, PREGNANT, VETERAN, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK3GE5, MAXDRNKS, FLUSHOT3, FLUSPRY2, PNEUVAC3, HEPBVAC, HEPBRSN, FALL3MN2, FALLINJ2, SEATBELT, DRINKDRI, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM3, LASTSIG2, HIVTST5, HIVTSTD2, WHRTST7, HIVRDTST, EMTSUPRT, LSATISFY, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRELN1, DRHPCH, HAVHPCH, CIFLUSH2, RCVFVCH2, RNOFVCH2, CASTHDX2, CASTHNO2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, VIDFCLT2, VIREDIF2, VIPRFVS2, VINOCRE2, VIEYEXM2, VIINSUR2, VICTRCT2, VIGLUMA2, VIMACDG2, VIATWRK2, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED2, ASINHALR, BRTHCNT3, TYPCNTR4, NOBCUSE2, FPCHLDFT, FPCHLDHS, VITAMINS, MULTIVIT, FOLICACD, TAKEVIT, RECOMMEN, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, IAQHTSRC, IAQGASAP, IAQHTDYS, IAQCODTR, IAQMOLD, HEWTRSRC, HEWTRDRK, HECHMHOM, HECHMYRD, RRCLASS2, RRCOGNT2, RRATWORK, RRHCARE2, RRPHYSM1, RREMTSM1, ADPLEASR, ADDOWN, ADSLEEP, ADENERGY, ADEAT, ADFAIL, ADTHINK, ADMOVE, ADANXEV, ADDEPEV, SVSAFE, SVSEXTCH, SVNOTCH, SVEHDSE1, SVHDSX12, SVEANOS1, SVNOSX12, SVRELAT2, SVGENDER, IPVSAFE, IPVTHRAT, IPVPHYV1, IPVPHHRT, IPVUWSEX, IPVPVL12, IPVSXINJ, IPVRELT1, GPWELPRD, GPVACPLN, GP3DYWTR, GP3DYFOD, GP3DYPRS, GPBATRAD, GPFLSLIT, GPMNDEVC, GPNOTEVC, GPEMRCOM, GPEMRINF, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _RACEG4_, _IMPAGE, _IMPNPH, MSCODE, CRACEORG, CRACEASC, _CRACE, _CSEXG_, _CRACEG_, _CAGEG_, _RAWCH, _WT2CH, _POSTCH, _CHILDWT, _RFHLTH, _TOTINDA, _EXTETH2, _ALTETH2, _DENVST1, _LTASTHM, _CASTHMA, _ASTHMST, _SMOKER3, _RFSMOK3, MRACEORG, MRACEASC, _PRACE, _MRACE, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, RACE2, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, DROCDY2_, _RFBING4, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, _FLSHOT3, _PNEUMO2, _RFSEAT2, _RFSEAT3, _RFMAM2Y, _MAM502Y, _RFPAP32, _RFPSA2Y, _RFBLDST, _RFSIGM2, _AIDTST2, _ITSCF1, _ITSCF2, _ITSPOST, _ITSFINL, _RAWHH, _WT2HH, _POSTHH, _HOUSEWT');
            $('#<%=chk06.ClientID%>').attr('year', '2006');
            $('#<%=chk06.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2006/pdf/codebook_06.pdf');
            $('#<%=chk06.ClientID%>').attr('special', 'chk06706112');

            $('#<%=chk05.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, CELLFON, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, CHECKUP, EXERANY2, DIABETE2, BPHIGH4, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, CVDINFR3, CVDCRHD3, CVDSTRK3, ASTHMA2, ASTHNOW, FLUSHOT3, FLUSPRY2, PNEUVAC3, SMOKE100, SMOKDAY2, STOPSMK2, DRNKANY4, ALCDAY4, AVEDRNK2, DRNK2GE5, MAXDRNKS, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT3, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV2, SEX, PREGNANT, VETERAN, QLACTLM2, USEEQUIP, PAIN30DY, JOINTSYM, JOINTRT2, HAVARTH2, LMTJOIN2, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, HIVTST5, HIVTSTD2, WHRTST7, HIVRISK2, EMTSUPRT, LSATISFY, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, LASTDEN3, RMVTEETH, DENCLEAN, VIDIFCLT, VITELDIF, VIREADIF, VIPRFVST, VINOCARE, VIEYEEXM, VIINSUR, VICATRCT, VIGLUCMA, VIMACDEG, VIATWORK, VIMISWRK, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, HAREHAB, STREHAB, CVDASPRN, ASPUNSAF, BPEATHBT, BPSALT, BPALCHOL, BPEXER, BPEATADV, BPSLTADV, BPALCADV, BPEXRADV, BPMEDADV, BPHI2MR, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, FLUSTLOC, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMED2, ASINHALR, RCSBIRTH, RCSGENDR, RCHISLAT, RCSRACE, RCSBRACE, RCSRELTN, CASTHDX2, CASTHNO2, CIFLUSHT, CIFLUMST, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM3, LASTSIG2, OSTPROS, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, LOSEWT, MAINTAIN, FEWCAL, PHYACT, DRADVICE, IAQHTSRC, IAQGASAP, IAQHTDYS, IAQCODTR, IAQMOLD, HEWTRSRC, HEWTRDRK, HECHMHOM, HECHMYRD, SCLSTSMK, SCGETCAR, SCQITSMK, SCDSCMED, SCDSCMTH, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, VETSTAT2, VACARE, RRCLASS2, RRCOGNT2, RRATWORK, RRHCARE2, RRPHYSM1, RREMTSM1, SVNOTCH, SVSEXTCH, SVNOSEX, SVHADSEX, SVRELATN, SVGENDER, SVEANOSX, SVEHDSEX, IPVTHRAT, IPVPHHRT, IPVPHYVL, IPVUWSEX, IPVPVL12, IPVSXINJ, IPVRELTN, SIPVSKP, QSTVER, QSTLANG, MSCODE, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, _RFHLTH, _TOTINDA, _RFHYPE5, _CHOLCHK, _RFCHOL, _LTASTHM, _CASTHMA, _ASTHMST, _FLSHOT3, _PNEUMO2, _SMOKER3, _RFSMOK3, DROCDY2_, _RFBING3, _DRNKDY3, _DRNKMO3, _RFDRHV3, _RFDRMN3, _RFDRWM3, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, _DRDXART, FTJUDAY_, FRUTDAY_, GNSLDAY_, POTADAY_, CRTSDAY_, VEGEDAY_, _FRTSERV, _FRTINDX, _FV5SRV, _MODPAMN, _VIGPAMN, MODCAT_, VIGCAT_, PACAT_, _RFPAMOD, _RFPAVIG, _RFPAREC, _RFNOPA, _AIDTST2, _HIGHRSK, _MSACODE');
            $('#<%=chk05.ClientID%>').attr('year', '2005');
            $('#<%=chk05.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2005/pdf/codebook_05.pdf');
            $('#<%=chk05.ClientID%>').attr('special', 'chk05705760');

            $('#<%=chk04.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, EXERANY2, EFILLAIR, EFILLPOL, SUNBURN, NUMBURN, SMOKE100, SMOKEDAY, STOPSMK2, ALCDAY3, AVEDRNK, DRNK2GE5, DRINKDRI, ASTHMA2, ASTHNOW, DIABETE2, LASTDEN2, RMVTEETH, DENCLEAN, FLUSHOT2, FLUSPRAY, PNEUVAC2, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT2, HEIGHT2, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV, SEX, PREGNANT, VETERAN, VETSTAT2, VACARE, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP2, LASTPAP2, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM3, LASTSIG2, BRTHCNT3, TYPCNTR3, NOBCUSE2, FPCHLDFT, FPCHLDHS, QLACTLM2, USEEQUIP, HIVTF1A, HIVTF1B, HIVTST4, HIVTSTNM, HIVTSTD2, RSNTST4, WHRTST6, HIVTSTCL, HIVTSTBY, HIVRISK2, PCSAIDS2, FIREARM4, GUNLOAD, LOADULK2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO3, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, SEXINTMN, SEXCONDM, CONDLAST, CONEFF2, NEWPARTN, STDTREAT, STDCLIN, BPHIGH3, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, IAQHTSRC, IAQGASAP, IAQHTDYS, IAQCODTR, IAQMOLD, HEWTRSRC, HEWTRDRK, HECHMHOM, HECHMYRD, FLUPRO2, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMEDS, CASTHDX, CASTHNOW, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, CVDFAT02, CVDFVG01, CVDEXR03, CVDFATR2, CVDFVEG, CVDEXRS2, CVDINFR2, CVDCRHD2, CVDSTRK2, HATTKAGE, STROKAGE, CVDREHAB, CVDASPRN, ASPUNSAF, WHYASPAN, WHYASPHA, WHYASPSK, VITAMINS, MULTIVIT, FOLICACD, TAKEVIT, RECOMMEN, USEEVER2, USENOW2, USEOTHNW, SCLSTSMK, SCGETCAR, SCQITSMK, SCDSCMED, SCDSCMTH, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, PAIN30DY, JOINTSYM, JOINTRT2, HAVARTH2, LMTJOIN2, ARTHDISB, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, DRNKBEER, DRNKWINE, DRNKLIQR, DRNKLOC, BUYALCH, BINGEDRV, RRCLASS2, RRCOGNT2, RRATWORK, RRHCARE2, RREMTSYM, RRPHYSYM, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, _RFHLTH, _TOTINDA, _SMOKER2, _RFSMOK2, DROCCDY_, DRNKANY3, _RFBING2, _DRNKDY2, _DRNKMO2, _RFDRHV2, _RFDRMN2, _RFDRWM2, _LTASTHM, _CASTHMA, _ASTHMST, _EXTEETH, _ALTEETH, _DENTVST, _FLSHOT2, _PNEUMOC, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _RACE_G, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, _AGE_G, HTIN3, HTM3, WTKG2, _BMI4, _BMI4CAT, _RFBMI4, _CHLDCNT, _EDUCAG, _INCOMG, _RFMAM2Y, _RFPAP32, _RFPSA2Y, _RFBLDST, _RFSIGM2, _AIDTST2, _HIGHRSK, _STDCND2, _RFFRARM, _RFFRAR2');
            $('#<%=chk04.ClientID%>').attr('year', '2004');
            $('#<%=chk04.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2004/pdf/codebook_04.pdf');
            $('#<%=chk04.ClientID%>').attr('special', 'chk04705408');

            $('#<%=chk03.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, PERSDOC2, MEDCOST, EXERANY2, DIABETES, BPHIGH3, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, LOSEWT, MAINTAIN, FEWCAL, PHYACT, DRADVICE, ASTHMA2, ASTHNOW, FLUSHOT, PNEUVAC2, SMOKE100, SMOKEDAY, STOPSMK2, ALCDAY3, AVEDRNK, DRNK2GE5, SUNBURN, NUMBURN, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT, WTDESIRE, HEIGHT, CTYCODE, NUMHHOL2, NUMPHON2, TELSERV, SEX, PREGNANT, PAIN30DY, JOINTSYM, JOINTRT2, HAVARTH2, LMTJOIN2, ARTHDIS2, FALL3MN, FALLINJ, QLACTLM2, USEEQUIP, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, VETERAN, VETSTAT2, VACARE, HIVTF1A, HIVTF1B, HIVOPT1B, HIVTST3, HIVTSTD2, RSNTST4, WHRTST5, HIVRISK2, PCSAIDS2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO2, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, LASTDEN2, RMVTEETH, DENCLEAN, HADMAM, HOWLONG, NEXTMAM, WHYDONE3, PROFEXAM, LENGEXAM, HADPAP, LASTPAP, HADHYST2, FLUPRO2, SMKDETE3, FIRESCP3, FRPLANDO, FIREXIT, FRPEXLOC, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMEDS, CASTHDX, CASTHNOW, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, CVDFAT02, CVDFVG01, CVDEXR03, CVDFATR2, CVDFVEG, CVDEXRS2, CVDINFR2, CVDCRHD2, CVDSTRK2, HATTKAGE, STROKAGE, CVDREHAB, CVDASPRN, ASPUNSAF, WHYASPAN, WHYASPHA, WHYASPSK, VITAMINS, MULTIVIT, FOLICACD, TAKEVIT, RECOMMEN, FIRSTSMK, REGSMK, LASTSMK, GETCARE, QUITSMOK, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, USEEVER2, USENOW2, CIGAR2, CIGARNOW, PIPESMK, PIPENOW, BIDISMK, BIDINOW, ARTTODAY, ARTHWGT, ARTHEXER, ARTHEDU, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM2, LASTSIG2, DRNKBEER, DRNKWINE, DRNKLIQR, DRNKLOC, BUYALCH, BINGEDRV, QSTVER, QSTLANG, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, _TOTINDA, _RFHYPE4, _CHOLCHK, _RFCHOL, FTJUDAY_, FRUTDAY_, GNSLDAY_, POTADAY_, CRTSDAY_, VEGEDAY_, _FRTSERV, _FRTINDX, _LTASTHM, _CASTHMA, _ASTHMST, _FLUSHOT, _PNEUMOC, _SMOKER2, _RFSMOK2, DROCCDY_, DRNKANY3, _RFBING2, _DRNKDY2, _DRNKMO2, _RFDRHV2, _RFDRMN2, _RFDRWM2, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, HTIN2, HTM2, WTKG, _BMI3, _BMI3CAT, _RFBMI3, _MODPAMN, _VIGPAMN, MODCAT_, VIGCAT_, PACAT_, _RFPAMOD, _RFPAVIG, _RFPAREC, _RFNOPA, _AIDSTST, _HIGHRSK, _STDCNDM, _RFHLTH, _FV5SRV, _CHLDCNT, _EDUCAG, _INCOMG');
            $('#<%=chk03.ClientID%>').attr('year', '2003');
            $('#<%=chk03.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2003/pdf/codebook_03.pdf');
            $('#<%=chk03.ClientID%>').attr('special', 'chk03705056');

            $('#<%=chk02.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR2, PRECALL, REPNUM, REPDEPTH, FMONTH, IDATE, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, CTELENUM, PVTRESID, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, HLTHPLAN, PERSDOC2, FACILIT3, MEDCARE, MEDREAS, EXERANY2, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, ASTHMA2, ASTHNOW, DIABETES, LASTDEN2, RMVTEETH, DENCLEAN, FLUSHOT, FLUPRO2, PNEUVAC2, SMOKE100, SMOKEDAY, STOPSMK2, ALCDAY3, AVEDRNK, DRNK2GE5, DRINKDRI, SEATBELT, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT, HEIGHT, CTYCODE, NUMHHOL2, NUMPHON2, SEX, PREGNANT, BRTHCNT2, TYPCNTR2, OTHERBC, NOBCUSE, HADMAM, HOWLONG, PROFEXAM, LENGEXAM, HADPAP, LASTPAP, HADHYST2, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, BLDSTOOL, LSTBLDS2, HADSIGM2, LASTSIG2, HIVTF1A, HIVTF1B, HIVOPT1B, HIVTST3, HIVTSTD2, RSNTST4, WHRTST5, HIVRISK2, PCSAIDS2, FIREARM4, GUNLOAD, LOADULK2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO2, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, BPHIGH3, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, PHYSHLTH, MENTHLTH, POORHLTH, QLACTLM2, USEEQUIP, HLTHPRB2, LONGLMT2, QLPERSN2, QLROUTN2, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, CHECKUP, RSNOCOV2, PSTPLAN2, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMEDS, CASTHDX, CASTHNOW, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, CVDFAT02, CVDFVG01, CVDEXR03, CVDFATR2, CVDFVEG, CVDEXRS2, CVDINFR2, CVDCRHD2, CVDSTRK2, HATTKAGE, STROKAGE, CVDREHAB, CVDASPRN, ASPUNSAF, WHYASPAN, WHYASPHA, WHYASPSK, LOSEWT, MAINTAIN, FEWCAL, PHYACT, WTDESIRE, DRADVICE, VITAMINS, MULTIVIT, FOLICACD, TAKEVIT, RECOMMEN, FIRSTSMK, REGSMK, LASTSMK, GETCARE, QUITSMOK, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, USEEVER2, USENOW2, CIGAR2, CIGARNOW, PIPESMK, PIPENOW, BIDISMK, BIDINOW, PAIN30DY, JOINTSYM, JOINTRT2, HAVARTH2, LMTJOIN2, ARTHDISB, RXNRCMOD, _QSTVER, ATKVICT, ATKVID, ATKSVCS, ATKEMPL, ATKNOWRK, ATKRSWRK, ATKDYWRK, ATKEVAC, ATKMEDIA, ATKPRB, ATKHELP, ATKAID, ATKDRNK, ATKSMOK, ATKNSMOK, ATKSITE, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, _MSACODE, _TOTINDA, FTJUDAY_, FRUTDAY_, GNSLDAY_, POTADAY_, CRTSDAY_, VEGEDAY_, _FRTSERV, _FRTINDX, _LTASTHM, _CASTHMA, _ASTHMST, _EXTEETH, _ALTEETH, _DENTVST, _FLUSHOT, _PNEUMOC, _SMOKER2, _RFSMOK2, DROCCDY_, DRNKANY3, _RFBING2, _DRNKDY2, _DRNKMO2, _RFDRHV2, _RFDRMN2, _RFDRWM2, _RFDRDR2, _RFSEAT2, _RFSEAT4, MRACEORG, MRACEASC, _PRACE, _MRACE, RACE2, _RACEG2, _RACEGR2, _CNRACE, _CNRACEC, _AGEG5YR, _AGE65YR, HTIN, HTM, WTKG, _BMI2, _BMI2CAT, _RFBMI2, BRCNTRL_, BCMETML_, BCMETFM_, _FCNTRAC, _MCNTRAC, _RFMAM2Y, _RFPAP3Y, _RFPSA2Y, _RFBLDST, _RFSIGMD, _AIDSTST, _HIGHRSK, _STDCNDM, _RFFRARM, _RFFRAR2');
            $('#<%=chk02.ClientID%>').attr('year', '2002');
            $('#<%=chk02.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2002/pdf/codebook_02.pdf');
            $('#<%=chk02.ClientID%>').attr('special', 'chk02704704');

            $('#<%=chk01.ClientID%>').attr('columnname', '_STATE, _GEOSTR, _DENSTR, LISTSTAT, PRECALL, REPNUM, REPDEPTH, _RECORD, FMONTH, IMONTH, IDAY, IYEAR, INTVID, DISPCODE, WINDDOWN, SEQNO, _PSU, NATTMPTS, NRECSEL, NRECSTR, NUMADULT, NUMMEN, NUMWOMEN, GENHLTH, PHYSHLTH, MENTHLTH, POORHLTH, HLTHPLAN, NOCOVR12, PERSDOC2, EXERANY2, BPHIGH2, BPMEDS, BLOODCHO, CHOLCHK, TOLDHI2, ASTHMA2, ASTHNOW, DIABETES, PAIN12MN, SYMTMMTH, LMTJOINT, JOINTRT, HAVARTH, TRTARTH, FLUSHOT, PNEUVAC2, SMOKE100, SMOKEDAY, STOPSMK2, ALCDAYS, AVEDRNK, DRNK2GE5, FIREARM3, AGE, HISPANC2, MRACE, ORACE2, MARITAL, CHILDREN, EDUCA, EMPLOY, INCOME2, WEIGHT, HEIGHT, CTYCODE, NUMHHOL2, NUMPHON2, CELLPHON, SEX, PREGNT2, QLACTLM2, USEEQUIP, JOBACTIV, MODPACT, MODPADAY, MODPATIM, VIGPACT, VIGPADAY, VIGPATIM, PSATEST, PSATIME, DIGRECEX, DRETIME, PROSTATE, PROSHIST, BLDSTOOL, LSTBLDS2, HADSIGM2, LASTSIG2, HIVTF1A, HIVTF1B, HIVOPT1A, HIVOPT1B, HIVTST3, HIVTSTDT, RSNTST3, WHRTST4, PCSAIDS2, DIABAGE2, INSULIN, DIABPILL, BLDSUGAR, FEETCHK2, FEETSORE, DOCTDIAB, CHKHEMO2, FEETCHK, EYEEXAM, DIABEYE, DIABEDU, SEXINTMN, SEXCONDM, CONDLAST, CONEFF2, NEWPARTN, HIVRISK, STDTREAT, STDCLIN, SEXBEHA2, SELCPTN3, SEX1PTN3, USECOND3, HLTHPRB2, LONGLMT2, QLPERSN2, QLROUTN2, PAINACT2, QLMENTL2, QLSTRES2, QLREST2, QLHLTH2, QLPCHEL2, QLPCLEV2, QLRCHEL2, QLRCLEV2, RSNOCOV2, PSTPLAN2, RSWOCOV2, PRIMCARE, MOSTCARE, FACILIT2, MEDCOST, CHECKUP, HADMAM, HOWLONG, WHYDONE, PROFEXAM, LENGEXAM, REASEXAM, HADPAP, LASTPAP, WHYPAP, HADHYST2, LASTDEN2, RMVTEETH, DENCLEAN, REASDENT, DENTLINS, ASTHMAGE, ASATTACK, ASERVIST, ASDRVIST, ASRCHKUP, ASACTLIM, ASYMPTOM, ASNOSLEP, ASTHMEDS, ASTHCHLD, ASKIDHAS, HASYMP1, HASYMP2, HASYMP3, HASYMP4, HASYMP5, HASYMP6, STRSYMP1, STRSYMP2, STRSYMP3, STRSYMP4, STRSYMP5, STRSYMP6, FIRSTAID, CVDFAT02, CVDFVG01, CVDEXR03, CVDFATR2, CVDFVEG, CVDEXRS2, CVDINFR2, CVDCRHD2, CVDSTRK2, HATTKAGE, STROKAGE, CVDREHAB, CVDASPRN, ASPUNSAF, WHYASPAN, WHYASPHA, WHYASPSK, FRUITJUI, FRUIT, GREENSAL, POTATOES, CARROTS, VEGETABL, LOSEWT, MAINTAIN, FEWCAL, PHYACT, WTDESIRE, DRADVICE, VITAMINS, MULTIVIT, FOLICACD, TAKEVIT, RECOMMEN, FIRSTSMK, REGSMK, LASTSMK, GETCARE, QUITSMOK, HOUSESMK, INDOORS, SMKPUBLC, SMKWORK, USEEVER2, USENOW2, CIGAR2, CIGARNOW, PIPESMK, PIPENOW, BIDISMK, BIDINOW, _QSTVER, MRACEORG, MRACEASC, _PRACE, _STSTR, _STRWT, _RAW, _WT2, _POSTSTR, _FINALWT, _REGION, _AGEG_, _SEXG_, _RACEG3_, _IMPAGE, _IMPNPH, _MSACODE, _AGEG5YR, _AGE65YR, RACE2, _RACEG2, _RACEGR2, _CNRACE, _CNRACEC, _BMI2, _BMI2CAT, _RFBMI2, _RFHYPE3, _CHOLCHK, _RFCHOL, _HASCJS, _CJSLMT, _CJSARTH, _SMOKER2, _RFSMOK2, _DRNKMO, _DRNKDAY, _RFBINGE, _RFDRHVY, _RFDRKMN, _RFDRKWM, _TOTINDA, _RFPAREC, _RFPAMOD, _RFPAVIG, _SMKLESS, _RFTOBAC, _FRTINDX, _FRTSERV, HTIN, HTM, WTKG, _MODPAMN, _VIGPAMN, DRNKANY2, _MRACE, IDATE');
            $('#<%=chk01.ClientID%>').attr('year', '2001');
            $('#<%=chk01.ClientID%>').attr('codebook', 'https://www.cdc.gov/brfss/annual_data/2001/pdf/codebook_01.pdf');
            $('#<%=chk01.ClientID%>').attr('special', 'chk01704352');
        --%>

        });
       
     </script>

    <style>
        table{
            width: 100%;
        }

        #panelHeader, .panelHeader{
            position: absolute;
        }

        html{
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


          <div class="text-center" style="margin-bottom: 20px;">
              <asp:CheckBoxList ID ="brfssCheckboxes" runat="server" RepeatDirection="Horizontal" RepeatColumns="5" ClientIDMode="Static">
                  <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                  <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                  <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                  <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
                  <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
                  <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
                  <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
                  <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
                  <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
                  <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
                  <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
                  <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
                  <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
                  <asp:ListItem Text="2002" Value="2002"></asp:ListItem>
                  <asp:ListItem Text="2001" Value="2001"></asp:ListItem>
              </asp:CheckBoxList>
          </div>
          
<%--              <table class="table table-bordered text-center">
                  <tbody>
                      <tr>
                        <td>2015<br /><asp:CheckBox ID="chk15" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                        <td>2014<br /><asp:CheckBox ID="chk14" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                        <td>2013<br /><asp:CheckBox ID="chk13" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                        <td>2012<br /><asp:CheckBox ID="chk12" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                        <td>2011<br /><asp:CheckBox ID="chk11" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                      </tr>
                      <tr>
                          <td>2010<br /><asp:CheckBox ID="chk10" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2009<br /><asp:CheckBox ID="chk09" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2008<br /><asp:CheckBox ID="chk08" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2007<br /><asp:CheckBox ID="chk07" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2006<br /><asp:CheckBox ID="chk06" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                      </tr>
                      <tr>
                          <td>2005<br /><asp:CheckBox ID="chk05" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2004<br /><asp:CheckBox ID="chk04" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2003<br /><asp:CheckBox ID="chk03" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2002<br /><asp:CheckBox ID="chk02" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                          <td>2001<br /><asp:CheckBox ID="chk01" runat="server" onclick="javascript:ShowColumns2(this)" ClientIDMode="Static"></asp:CheckBox></td>
                      </tr>
                  </tbody>
              </table>
            --%>
          <div style="text-align:right; margin-right: 10px;">

            <strong>Download Format:</strong>

            <asp:Button ID="Button1" runat="server" Text=".txt" OnClick="btnSubmit_Click_Txt" OnClientClick="blockUIForDownload()" class="btn btn-success btn-xs" UseSubmitBehavior="False"/>

            <asp:Button ID="Button2" runat="server" Text="SPSS" OnClick="btnSubmit_Click_Spss" OnClientClick="blockUIForDownload()" class="btn btn-danger btn-xs" UseSubmitBehavior="False"/>

            <asp:Button ID="Button3" runat="server" Text="CSV" OnClick="btnSubmit_Click_Csv" OnClientClick="blockUIForDownload()" class="btn btn-default btn-xs" UseSubmitBehavior="False"/>

            <asp:Button ID="Button4" runat="server" Text="SAS" OnClick="btnSubmit_Click" OnClientClick="blockUIForDownload()" class="btn btn-primary btn-xs" UseSubmitBehavior="False"/>
                                
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
