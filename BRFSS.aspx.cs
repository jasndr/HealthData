using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HealthData2.Models;
using System.Text;
using System.Reflection;
using System.IO;
using System.Collections.Specialized;
using System.Configuration;
using System.Xml.XPath;
//using System.IO;

namespace HealthData2
{
    public partial class BRFSS : System.Web.UI.Page
    {
        public SasServer activeSession = null;

        //first dictionary for group, second for year, tree might be a better structure

        //Dictionary for group --------------------------------------------> (not required for BRFSS)
        Dictionary<string, List<BRFSSFile>> _tables;
        //Dictionary for year
        Dictionary<string, Dictionary<string, List<BRFSSFile>>> _yeartables = new Dictionary<string, Dictionary<string, List<BRFSSFile>>>();

        /// <summary>
        /// Loads the Page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindGrid();
            }

        }

        /// <summary>
        /// Generates GridView table
        /// </summary>
        private void BindGrid()
        {
            //File path to ~/App_Data/BRFSS_study.xml
            string filePath = ConfigurationManager.AppSettings["BRFSS"];
            //Map to aforementioned (^) file path
            string path = Server.MapPath(filePath);
            //Creates new DataTable to display on Gridview
            DataTable dt = new DataTable("Study");

            try
            {
                //Add Columns in datatable - Column names must match XML File nodes (in aformentioned file path) 
                dt.Columns.Add("Section", typeof(System.String));

                // Reading the XML file and display data in the gridview
                dt.ReadXml(path);
            }
            catch (Exception e)
            {
                throw e;
            }

            //GridViewStudy.DataSource = dt; (Originally commented out)

            //Connects Gridview with DataTable and aligns with group header [Calls InsertGroupHeader(DataTable), see below]
            GridViewStudy.DataSource = InsertGroupHeaderRow(dt);
            //Binds Data to Gridview
            GridViewStudy.DataBind();

        }

        /// <summary>
        /// Partitions data items by their group headers (years)
        /// </summary>
        /// <param name="dt"></param>
        /// <returns>DataTable organized by group header as assigned</returns>
        private DataTable InsertGroupHeaderRow(DataTable dt)
        {
            //clone the dataschema into a new table
            //this is our final sorted list
            DataTable dtNew = dt.Clone();

            //group rows by productsubcategory (not necessary for BRFSS, but useful to create one row of sections)
            var results = from myRow in dt.AsEnumerable()
                          group myRow by myRow["Section"]
                              into grp
                          select new
                          {
                              Id = grp.Key,
                              Rows = grp.Select(x => x)
                          };
            DataRow newRow;
            //iterate through resultset and insert the group header row
            //at the start of each subcategory
            foreach (var row in results)
            {
                //create a new row with only subcategoryid and name populated
                //do not populate any other attributes as that would be our
                //criteria to figure out the group start
                newRow = dtNew.NewRow();
                newRow["Section"] = row.Rows.FirstOrDefault()["Section"];
                List<DataRow> dataRows = row.Rows.ToList();
                //dataRows.Insert(0, newRow);
                //copy results to a new resultset
                foreach (DataRow dr in dataRows)
                {
                    dtNew.Rows.Add(dr.ItemArray);
                }
            };
            return dtNew;
        }

        /// <summary>
        /// Creates header if row is a header row.  
        /// If not, adds more height for increased visibility.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void GridViewStudy_DataBound(object sender, GridViewRowEventArgs e)
        {
            //check if it is a datarow or header row
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (e.Row.RowIndex == 0)
                    {
                        e.Row.Style.Add("height", "50px");
                    }
                }

            }

        }

        /// <summary>
        /// Disables checkbox if file doesn't exist.
        /// Gridview iterates this class before assigning 
        /// data to checkboxes.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void GridViewStudy_PreRender(object sender, EventArgs e)
        {
            //// disable check box if file doesn't exist
            DisableCheckBox(GridViewStudy);
        }

        /// <summary>
        /// Disables checkbox if it doesn't exist in the XML file. ----------> (Not required for BRFSS)
        /// </summary>
        /// <param name="GridViewStudy"></param>
        private void DisableCheckBox(GridView GridViewStudy)
        {
            //Provides linkage to "~/App_Data/BRFSS_columns.xml"
            string filePath = ConfigurationManager.AppSettings["BRFSSFile"];
            string path = Server.MapPath(filePath);

            //Adds navigation to columns XML file
            XPathDocument docNav = new XPathDocument(path);
            String strExpression;    

            //For each gridview row, if checkbox
            foreach (GridViewRow row in GridViewStudy.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                  
                    int yearFrom = 2015;
                    //int value = 1;

                    for (int i = 15; i > 0; i--)
                    {
                        string chkBoxId = "chkRow" + yearFrom.ToString();
                        CheckBox chkBox = row.FindControl(chkBoxId) as CheckBox;
                        

                        if (chkBox.Enabled)
                        {
                            //string folderName;

                            //XPathNodeIterator NodeIter;
                            XPathItem nodeItem;
                            XPathNavigator nav;

                            nav = docNav.CreateNavigator();
                            strExpression = String.Format("/BRFSS_Columns/File[YearFrom='{0}']/ColumnName", yearFrom);
                           
                            nodeItem = nav.SelectSingleNode(strExpression);

                            //Response.Write("<script>alert('The strExpression is "+strExpression+"')</script>");

                            if (nodeItem != null)
                            {
                                chkBox.Attributes.Add("YearFrom", yearFrom.ToString());
                                chkBox.Attributes.Add("ColumnName", nodeItem.Value);   

                            }

                            strExpression = String.Format("/BRFSS_Columns/File[YearFrom='{0}']/CodeBook", yearFrom);
                            nodeItem = nav.SelectSingleNode(strExpression);

                           // Response.Write("<script>alert('The nodeItem is : "+nodeItem+"')</script>");

                            if (nodeItem != null)
                            {
                                chkBox.Attributes.Add("CodeBook", nodeItem.Value);
                            }
                        }

                        yearFrom -= 1;

                    }


                    
                }



            }
        }

        //(Originally commented out from DisableCheckBox method, so not required)
        // ----------------------------------------------------------------------
        //private string GetColumnName(int yearFrom, string folderName) 
        //{
        //    //find column name from xml file
        //    StringBuilder sb = new StringBuilder();

        //    return sb.ToString();
        //}

        // (Orginally commented out from GridViewStudy_PreRender method, so not required)
        // ------------------------------------------------------------------------------
        //private void MergeGridviewRows(GridView gridView)
        //{
        //    for (int rowIndex = gridView.Rows.Count - 2; rowIndex >= 0; rowIndex--)
        //    {
        //        GridViewRow row = gridView.Rows[rowIndex];
        //        GridViewRow previousRow = gridView.Rows[rowIndex + 1];

        //        string s1 = ((Label)row.Cells[1].FindControl("lblGroupName")).Text;
        //        string s2 = ((Label)previousRow.Cells[1].FindControl("lblGroupName")).Text;
        //        if (s1 == s2)
        //        {
        //            row.Cells[1].RowSpan = previousRow.Cells[1].RowSpan < 2 ? 2 : previousRow.Cells[1].RowSpan + 1;

        //            previousRow.Cells[1].Visible = false;
        //        }
        //    }
        //}







        /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

        //---------Start .txt Button
        /// <summary>
        /// Download .txt file from dataset
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click_Txt(object sender, EventArgs e)
        {
            produceDatasets(sender, e, 1);   
        } 
        //------------------- End .txt Button

        //---------Start SPSS Button
        /// <summary>
        /// Download .sav file from dataset
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click_Spss(object sender, EventArgs e)
        {
            produceDatasets(sender, e, 2);
        } 
        //------------------- End SPSS Button

        //---------Start .CSV Button
        /// <summary>
        /// Download .csv file from dataset
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click_Csv(object sender, EventArgs e)
        {
            produceDatasets(sender, e, 3);
        }
        //------------------- End CSV Button

        //-----------------Start SAS Button
        /// <summary>
        /// Download .sas7bat file from dataset
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            produceDatasets(sender, e, 4);
        }
        //-------- End SAS Button


        //---------Start produceDatasets
        /// <summary>
        /// Creates datasets based on selected BRFSS data values.
        /// Downloads file based on selected download format.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <param name="downloadFormat">1 = txt file, 2 = sav file, 3 = csv file, 4 = sas file</param>
        protected void produceDatasets(object sender, EventArgs e, int downloadFormat)
        {


            //Tracks current session
            string sessionId = this.Session.SessionID;

            //Creates temporary folder to store information, 
            //with current date value in year, month, day format
            string folder = Path.Combine(Path.GetTempPath(), DateTime.Now.ToString("yyyyMMdd"));
            if (!Directory.Exists(folder) && !File.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string studyYear = "";
            // int studyYearFrom = 0;

            //Adds a new array list of columns of GridViewStudy
            List<BRFSSFile>[] studyArrayList = new List<BRFSSFile>[15];
            for (int i = 0; i < 15; i++)
            {
                studyArrayList[i] = new List<BRFSSFile>();
            }

            //Creates array of checkbox with distinct ids for each rows
            CheckBox[] checkBoxArray = new CheckBox[15];
            foreach (GridViewRow row in GridViewStudy.Rows)
            {
                //Checks if row is datatype (not required to check in BRFSS)
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int yearFrom = 2015;
                    for (int i = 0; i < 15; i++)
                    {
                        //Adds checkboxid name from each row and finds & binds to GridView
                        string chkBoxId = "chkRow" + yearFrom.ToString();
                        checkBoxArray[i] = row.FindControl(chkBoxId) as CheckBox;

                        //
                        if (checkBoxArray[i] != null && checkBoxArray[i].Checked)
                        {

                            // [Assigned label and checks if label used to be in this area, 
                            //                          but not used in BRFSS, so redacted]

                            // Creates cookiename from yearfrom information
                            string cookieName = yearFrom.ToString() + "cookie";
                            //As long as cookie exist, a new instance of BRFSS file model
                            //and adds year from and column name information 
                            if (Request.Cookies[cookieName] != null)
                            {
                                BRFSSFile file = new BRFSSFile()
                                {
                                    YearFrom = yearFrom.ToString(),
                                    ColumnName = HttpUtility.UrlDecode(Request.Cookies[cookieName].Value)
                                };

                                //Adds file of BRFSS information as into column
                                studyArrayList[i].Add(file);

                            }


                        }
                        //Increments yearly from 2015 to 2001
                        yearFrom -= 1;

                    }
                }
            }

            //Adds group information for each year for BuildSAS code
            int yearHeader = 0;
            for (int i = 0; i < 15; i++)
            {
                studyYear = GridViewStudy.HeaderRow.Cells[yearHeader].Text;

                if (studyArrayList[i].Count > 0)
                {
                    //Instantiates new group dictionary and new listgroup 
                    _tables = new Dictionary<string, List<BRFSSFile>>();
                    List<string> listGroup = new List<string>();

                    foreach (BRFSSFile file in studyArrayList[i])
                    {

                        listGroup.Add(file.YearFrom);

                    }

                    foreach (string groupName in listGroup)
                    {
                        List<BRFSSFile> sameGroupList = new List<BRFSSFile>();
                        foreach (BRFSSFile file in studyArrayList[i])
                        {
                            if (file.YearFrom.Equals(groupName))
                            {
                                sameGroupList.Add(file);
                            }
                        }

                        _tables.Add(groupName, sameGroupList);

                    }

                    _yeartables.Add(studyYear, _tables);
                }

                yearHeader += 1;
            }

            ////call SAS
            string macroPath = ConfigurationManager.AppSettings["BRFSSMacro"];
            string macroSource = Server.MapPath(macroPath); //@"C:\VS2013\HealthData2\SASMacro\combineall.txt";
            string fileSource = ConfigurationManager.AppSettings["BRFSSSource"];
            string SASCode = SASBuilder.BuildBRFSSCode(_yeartables, folder, macroSource, fileSource, 1);

            SASBuilder.RunSAS(SASCode);

            //download SAS code
            string codeFileName = @"sascode.txt";
            string codeFilePath = string.Format("{0}\\{1}", folder, codeFileName);
            using (StreamWriter sw = File.CreateText(codeFilePath))
            {
                sw.Write(SASCode);
            }

            //open file dialog
            String FileName = "";

            switch (downloadFormat)
            {
                case 1:
                    FileName = @"merged.txt";
                    break;
                case 2:
                    FileName = @"merged.sav";
                    break;
                case 3:
                    FileName = @"merged.csv";
                    break;
                case 4:
                    FileName = @"merged.sas7bat";
                    break;
                default:
                    FileName = @"merged.sas7bdat";
                    break;
            }

            String FilePath = string.Format("{0}\\{1}", folder, FileName);  //@"D:\NHANES_EXTRA\1999-2000\lab\Biochemistry Profile and Hormones\lab18.sas7bdat"; //Replace this


            if (DownloadableProduct_Tracking(FilePath, FileName))
            {
               
                //Response.Write("<script>alert('reached DownloadableProduct_Tracking() point!!!');</script>");
            }
            else
            {
                Response.Write("<script>alert('failed');</script>");
            };
        } //------------------- End produceDatasets


        /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

        private void RunSAS(string sasCode)
        {
            string connectionStatus = ConnectToSAS();

            string log = RunSASProgram(sasCode);

        }

        private string RunSASProgram(string sasCode)
        {
            StringBuilder logBuilder = new StringBuilder();
            if (activeSession != null && activeSession.Workspace != null)
            {
                logBuilder.AppendLine("Running SAS ...");

                activeSession.Workspace.LanguageService.Submit(sasCode);

                bool hasErrors = false, hasWarnings = false;

                Array carriage, lineTypes, lines;
                do
                {
                    //SAS.LanguageServiceCarriageControl CarriageControl = new SAS.LanguageServiceCarriageControl();
                    // SAS.LanguageServiceLineType LineType = new SAS.LanguageServiceLineType();

                    activeSession.Workspace.LanguageService.FlushLogLines(1000,
                        out carriage,
                        out lineTypes,
                        out lines);

                    for (int i = 0; i < lines.GetLength(0); i++)
                    {
                        SAS.LanguageServiceLineType pre =
                            (SAS.LanguageServiceLineType)lineTypes.GetValue(i);
                        switch (pre)
                        {
                            case SAS.LanguageServiceLineType.LanguageServiceLineTypeError:
                                hasErrors = true;
                                break;
                            case SAS.LanguageServiceLineType.LanguageServiceLineTypeNote:
                                break;
                            case SAS.LanguageServiceLineType.LanguageServiceLineTypeWarning:
                                hasWarnings = true;
                                break;
                            case SAS.LanguageServiceLineType.LanguageServiceLineTypeTitle:
                            case SAS.LanguageServiceLineType.LanguageServiceLineTypeFootnote:
                                break;
                            default:
                                break;
                        }

                        logBuilder.AppendLine(string.Format("{0}{1}", lines.GetValue(i) as string, Environment.NewLine));
                    }
                }
                while (lines != null && lines.Length > 0);

                if (hasWarnings && hasErrors)
                    logBuilder.AppendLine("Program complete - has ERRORS and WARNINGS");
                else if (hasErrors)
                    logBuilder.AppendLine("Program complete - has ERRORS");
                else if (hasWarnings)
                    logBuilder.AppendLine("Program complete - has WARNINGS");
                else
                    logBuilder.AppendLine("Program complete - no warnings or errors!");
            }

            return logBuilder.ToString();

        }

        private string ConnectToSAS()
        {
            string statusMsg = "";
            activeSession = new SasServer();

            try
            {
                activeSession.Connect();

                if (activeSession.UseLocal)
                {
                    statusMsg = "Connected to local SAS session";
                }
            }
            catch (Exception ex)
            {
                statusMsg = string.Format("Connection failure {0}", ex.Message);
            }

            return statusMsg;
        }

        private bool DownloadableProduct_Tracking(string _filePath, string _fileName)
        {

            //File Path and File Name
            string filePath = _filePath;                                         //Server.MapPath("~/ApplicationData/DownloadableProducts");
            string _DownloadableProductFileName = _fileName;                     //"DownloadableProduct_FileName.pdf";

            System.IO.FileInfo FileName = new System.IO.FileInfo(filePath);
            FileStream myFile = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            //Reads file as binary values
            BinaryReader _BinaryReader = new BinaryReader(myFile);

            //Ckeck whether user is eligible to download the file
            if (true)
            {
                //Check whether file exists in specified location
                if (FileName.Exists)
                {
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(),
                    "FileFoundWarning", "alert('File is available now!')", true);

                    try
                    {
                        long startBytes = 0;
                        string lastUpdateTiemStamp = File.GetLastWriteTimeUtc(filePath).ToString("r");
                        string _EncodedData = HttpUtility.UrlEncode(_DownloadableProductFileName, Encoding.UTF8) + lastUpdateTiemStamp;

                        Response.Clear();
                        Response.AppendCookie(new HttpCookie("fileDownloadToken", download_token_value_id.Value)); //downloadTokenValue will have been provided in the form submit via the hidden input field
                        Response.Buffer = false;
                        Response.AddHeader("Accept-Ranges", "bytes");
                        Response.AppendHeader("ETag", "\"" + _EncodedData + "\"");
                        Response.AppendHeader("Last-Modified", lastUpdateTiemStamp);
                        Response.ContentType = "application/octet-stream";
                        Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName.Name);
                        Response.AddHeader("Content-Length", (FileName.Length - startBytes).ToString());
                        Response.AddHeader("Connection", "Keep-Alive");
                        Response.ContentEncoding = Encoding.UTF8;

                        //Send data
                        _BinaryReader.BaseStream.Seek(startBytes, SeekOrigin.Begin);

                        //Dividing the data in 1024 bytes package
                        int maxCount = (int)Math.Ceiling((FileName.Length - startBytes + 0.0) / 1024);

                        //Response.Write("<script type='text/javascript'>");
                        //Response.Write("window.location = '" + Request.RawUrl + "'</script>");

                        //Download in block of 1024 bytes
                        int i;
                        for (i = 0; i < maxCount && Response.IsClientConnected; i++)
                        {
                            Response.BinaryWrite(_BinaryReader.ReadBytes(1024));
                            Response.Flush();
                        }
                        //if blocks transfered not equals total number of blocks
                        if (i < maxCount)
                        {
                            return false;
                        }
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                    finally
                    {
                        //Response.End();
                        _BinaryReader.Close();
                        myFile.Close();

                        if (Response.IsClientConnected)
                        {
                            Response.Write("<script>alert('test');</script>");
                        }
                    }
                }
                else System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(),
                    "FileNotFoundWarning", "alert('File is not available now!')", true);
            }
            else
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(),
                    "NotEligibleWarning", "alert('Sorry! File is not available for you')", true);
            }
            return false;
        }

        protected void GridViewStudy_RowCreated(object sender, GridViewRowEventArgs e)
        {
            // The GridViewCommandEventArgs class does not contain a
            // property that indicates which row's command button was
            // clicked. To identify which row's button was clicked, use
            // the button's CommandArgument property by setting it to the
            // row's index.
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    ImageButton imgExpand = (ImageButton)e.Row.Cells[0].FindControl("imgExpand");
            //    imgExpand.CommandArgument = e.Row.RowIndex.ToString();
            //    ImageButton imgCollapse = (ImageButton)e.Row.Cells[0].FindControl("imgCollapse");
            //    imgCollapse.CommandArgument = e.Row.RowIndex.ToString();
            //}
        }

        protected void GridViewStudy_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // If multiple buttons are used in a GridView control, use the
            // CommandName property to determine which button was clicked.
            if (e.CommandName == "Expand")
            {
                // Convert the row index stored in the CommandArgument
                // property to an Integer.
                int currRowIndex = Convert.ToInt32(e.CommandArgument);

                // Retrieve the row that contains the button clicked
                // by the user from the Rows collection.
                GridViewRow row = GridViewStudy.Rows[currRowIndex];

                int productCount = GridViewStudy.Rows.Count;
                //starting from the row on which user clicked the "expand" button
                //make all rows visible until you find the next group header row
                for (int i = currRowIndex + 1; i < productCount; i++)
                {
                    if (GridViewStudy.Rows[i].Cells[1].Text.Replace("&nbsp;", "") != "")
                    {
                        GridViewStudy.Rows[i].Visible = true;
                    }
                    else
                    {
                        //we have reached the end of the current group
                        //make expand image invisible and collapse image visible
                        //HideUnHideToggleButtons(row.Cells[0], false, true);
                        break;
                    }
                    //if we are dealing with the last row,
                    //hide/unhide collapse/expand logic needs to be
                    //handled here
                    //if (i + 1 == GridViewStudy.Rows.Count)
                    //    HideUnHideToggleButtons(row.Cells[0], false, true);
                }
            }

            if (e.CommandName == "Collapse")
            {
                // Convert the row index stored in the CommandArgument
                // property to an Integer.
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridViewStudy.Rows[index];
                for (int i = index + 1; i < GridViewStudy.Rows.Count; i++)
                {
                    if (GridViewStudy.Rows[i].Cells[1].Text.Replace("&nbsp;", "") != "")
                    {
                        GridViewStudy.Rows[i].Visible = false;
                    }
                    else
                    {
                        //we have reached the end of the current group
                        //make expand image visible and collapse image invisible
                        //HideUnHideToggleButtons(row.Cells[0], true, false);
                        break;
                    }
                    //if we are dealing with the last row,
                    //hide/unhide collapse/expand logic needs to be
                    //handled here
                    //if (i + 1 == GridViewStudy.Rows.Count)
                    //    HideUnHideToggleButtons(row.Cells[0], true, false);
                }
            }
        }



    }
}