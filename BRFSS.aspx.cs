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
        Dictionary<string, List<BRFSSFile>> _tables;
        Dictionary<string, Dictionary<string, List<BRFSSFile>>> _yeartables = new Dictionary<string, Dictionary<string, List<BRFSSFile>>>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindGrid();
            }

        }

        private void BindGrid()
        {
            string filePath = ConfigurationManager.AppSettings["BRFSS"];
            string path = Server.MapPath(filePath);
            DataTable dt = new DataTable("Study");

            try
            {
                //Add Columns in datatable - Column names must match XML File nodes 
                dt.Columns.Add("Section", typeof(System.String));

                // Reading the XML file and display data in the gridview         
                dt.ReadXml(path);
            }
            catch (Exception e)
            {
                throw e;
            }

            //GridViewStudy.DataSource = dt;
            GridViewStudy.DataSource = InsertGroupHeaderRow(dt);
            GridViewStudy.DataBind();

        }


        private DataTable InsertGroupHeaderRow(DataTable dt)
        {
            //clone the dataschema into a new table
            //this is our final sorted list
            DataTable dtNew = dt.Clone();

            //group rows by productsubcategory
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

        protected void GridViewStudy_PreRender(object sender, EventArgs e)
        {
            //// disable check box if file doesn't exist
            DisableCheckBox(GridViewStudy);
        }

        private void DisableCheckBox(GridView GridViewStudy)
        {
            string filePath = ConfigurationManager.AppSettings["BRFSSFile"];
            string path = Server.MapPath(filePath);
            XPathDocument docNav = new XPathDocument(path); //(@"C:\VS2013\HealthData2\App_Data\NHANES_column.xml");
            String strExpression;    

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

        //private string GetColumnName(int yearFrom, string folderName)
        //{
        //    //find column name from xml file
        //    StringBuilder sb = new StringBuilder();

        //    return sb.ToString();
        //}





        /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

        //---------Start .txt Button
        protected void btnSubmit_Click_Txt(object sender, EventArgs e)
        {

            string sessionId = this.Session.SessionID;

            string folder = Path.Combine(Path.GetTempPath(), DateTime.Now.ToString("yyyyMMdd"));
            if (!Directory.Exists(folder) && !File.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string studyYear = "";
            int studyYearFrom = 0;
            List<BRFSSFile>[] studyArrayList = new List<BRFSSFile>[15];
            for (int i = 0; i < 15; i++)
            {
                studyArrayList[i] = new List<BRFSSFile>();
            }

            CheckBox[] checkBoxArray = new CheckBox[15];
            foreach(GridViewRow row in GridViewStudy.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int yearFrom = 2015;
                    for (int i = 15; i>0; i--)
                    {
                        string chkBoxId = "chkRow" + yearFrom.ToString();
                        checkBoxArray[i] = row.FindControl(chkBoxId) as CheckBox;

                        if (checkBoxArray[i] != null && checkBoxArray[i].Checked)
                        {
                            string cookieName = yearFrom.ToString() + "cookie";
                            if(Request.Cookies[cookieName] != null)
                            {
                                BRFSSFile file = new BRFSSFile()
                                {
                                    YearFrom = yearFrom.ToString(),
                                    ColumnName = HttpUtility.UrlDecode(Request.Cookies[cookieName].Value)
                                };

                                studyArrayList[i].Add(file);

                            }
                 

                        }

                        yearFrom -= 1;

                    }
                }
            }


            int yearHeader = 4;
            for (int i = 15; i < 0; i--)
            {
                studyYear = "" + studyYearFrom;

                if (studyArrayList[i].Count > 0)
                {

                    _tables = new Dictionary<string, List<BRFSSFile>>();
                    List<string> listGroup = new List<string>();
                 
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
            String FileName = @"merged.txt";
            String FilePath = string.Format("{0}\\{1}", folder, FileName);  //@"D:\NHANES_EXTRA\1999-2000\lab\Biochemistry Profile and Hormones\lab18.sas7bdat"; //Replace this

            if (DownloadableProduct_Tracking(FilePath, FileName))
            {
                //Response.Write("<script>alert('reached DownloadableProduct_Tracking() point!!!');</script>");
            }
            else
            {
                Response.Write("<script>alert('failed');</script>");
            };
        } //------------------- End .txt Button


        //---------Start SPSS Button
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click_Spss(object sender, EventArgs e)
        {
            //get cookies
            //string s = Request.Cookies["1999/Dietary/Dietary Interview - Individual Foods"].Value;

            //return;

            string sessionId = this.Session.SessionID;

            string folder = Path.Combine(Path.GetTempPath(), DateTime.Now.ToString("yyyyMMdd"));    //Guid.NewGuid().ToString());
            if (!Directory.Exists(folder) && !File.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string studyYear = "";
            int studyYearFrom = 0;
            List<BRFSSFile>[] studyArrayList = new List<BRFSSFile>[8];
            for (int i = 0; i < 8; i++)
            {
                studyArrayList[i] = new List<BRFSSFile>();
            }

            CheckBox[] checkBoxArray = new CheckBox[15];

            //Adds label for each checkbox in web form
            foreach (Control ctl in Form.FindControl("brfssTable").Controls)
            {

                if (ctl is CheckBox)
                {
                    if (((CheckBox)ctl).Checked)
                    {

                        int yearFrom = 2001;
                        for (int i = 0; i < 15; i++)
                        {
                            string chkBoxId = "chk" + yearFrom.ToString("yy");
                            checkBoxArray[i] = ctl.FindControl(chkBoxId) as CheckBox;

                            if (checkBoxArray[i] != null && checkBoxArray[i].Checked)
                            {

                                string cookieName = yearFrom.ToString() + ctl.FindControl(chkBoxId).ClientID;
                                if (Request.Cookies[cookieName] != null)
                                {
                                    BRFSSFile file = new BRFSSFile()
                                    {
                                        YearFrom = yearFrom.ToString(),
                                        ColumnName = HttpUtility.UrlDecode(Request.Cookies[cookieName].Value)
                                    };

                                    studyArrayList[i].Add(file);
                                }

                            }

                            yearFrom++;
                        }



                    }
                }




            }

            int yearHeader = 4;
            for (int i = 0; i < 15; i++)
            {
                studyYear = "" + studyYearFrom;

                if (studyArrayList[i].Count > 0)
                {

                    _tables = new Dictionary<string, List<BRFSSFile>>();
                    List<string> listGroup = new List<string>();


                    //foreach (string groupName in listGroup)
                    //{
                    //    List<BRFSSFile> sameGroupList = new List<BRFSSFile>();
                    //    _tables.Add(groupName, sameGroupList);
                    //}

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
            String FileName = @"merged.sav";
            String FilePath = string.Format("{0}\\{1}", folder, FileName);  //@"D:\NHANES_EXTRA\1999-2000\lab\Biochemistry Profile and Hormones\lab18.sas7bdat"; //Replace this

            if (DownloadableProduct_Tracking(FilePath, FileName))
            {
                //Request.Headers.Add(Request.Headers);
                //Response.Redirect(Request.RawUrl);

                //Response.AppendHeader("Refresh", "0;URL=/NHANES.aspx");
            }
            else
            {
                Response.Write("<script>alert('failed');</script>");
            };
        } //------------------- End SPSS Button

        //---------Start .CSV Button
        protected void btnSubmit_Click_Csv(object sender, EventArgs e)
        {
            //get cookies
            //string s = Request.Cookies["1999/Dietary/Dietary Interview - Individual Foods"].Value;

            //return;

            string sessionId = this.Session.SessionID;

            string folder = Path.Combine(Path.GetTempPath(), DateTime.Now.ToString("yyyyMMdd"));    //Guid.NewGuid().ToString());
            if (!Directory.Exists(folder) && !File.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string studyYear = "";
            int studyYearFrom = 0;
            List<BRFSSFile>[] studyArrayList = new List<BRFSSFile>[8];
            for (int i = 0; i < 8; i++)
            {
                studyArrayList[i] = new List<BRFSSFile>();
            }

            CheckBox[] checkBoxArray = new CheckBox[15];

            //Adds label for each checkbox in web form
            foreach (Control ctl in Form.FindControl("brfssTable").Controls)
            {

                if (ctl is CheckBox)
                {
                    if (((CheckBox)ctl).Checked)
                    {

                        int yearFrom = 2001;
                        for (int i = 0; i < 15; i++)
                        {
                            string chkBoxId = "chk" + yearFrom.ToString("yy");
                            checkBoxArray[i] = ctl.FindControl(chkBoxId) as CheckBox;

                            if (checkBoxArray[i] != null && checkBoxArray[i].Checked)
                            {

                                string cookieName = yearFrom.ToString() + ctl.FindControl(chkBoxId).ClientID;
                                if (Request.Cookies[cookieName] != null)
                                {
                                    BRFSSFile file = new BRFSSFile()
                                    {
                                        YearFrom = yearFrom.ToString(),
                                        ColumnName = HttpUtility.UrlDecode(Request.Cookies[cookieName].Value)
                                    };

                                    studyArrayList[i].Add(file);
                                }

                            }

                            yearFrom++;
                        }



                    }
                }




            }

            int yearHeader = 4;
            for (int i = 0; i < 15; i++)
            {
                studyYear = "" + studyYearFrom;

                if (studyArrayList[i].Count > 0)
                {

                    _tables = new Dictionary<string, List<BRFSSFile>>();
                    List<string> listGroup = new List<string>();


                    //foreach (string groupName in listGroup)
                    //{
                    //    List<BRFSSFile> sameGroupList = new List<BRFSSFile>();
                    //    _tables.Add(groupName, sameGroupList);
                    //}

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
            String FileName = @"merged.csv";
            String FilePath = string.Format("{0}\\{1}", folder, FileName);  //@"D:\NHANES_EXTRA\1999-2000\lab\Biochemistry Profile and Hormones\lab18.sas7bdat"; //Replace this

            if (DownloadableProduct_Tracking(FilePath, FileName))
            {
                //Request.Headers.Add(Request.Headers);
                //Response.Redirect(Request.RawUrl);

                //Response.AppendHeader("Refresh", "0;URL=/NHANES.aspx");
            }
            else
            {
                Response.Write("<script>alert('failed');</script>");
            };
        } //------------------- End CSV Button


        //-----------------Start SAS Button
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //get cookies
            //string s = Request.Cookies["1999/Dietary/Dietary Interview - Individual Foods"].Value;

            //return;

            string sessionId = this.Session.SessionID;

            string folder = Path.Combine(Path.GetTempPath(), DateTime.Now.ToString("yyyyMMdd"));    //Guid.NewGuid().ToString());
            if (!Directory.Exists(folder) && !File.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string studyYear = "";
            int studyYearFrom = 0;
            List<BRFSSFile>[] studyArrayList = new List<BRFSSFile>[8];
            for (int i = 0; i < 8; i++)
            {
                studyArrayList[i] = new List<BRFSSFile>();
            }

            CheckBox[] checkBoxArray = new CheckBox[15];

            //Adds label for each checkbox in web form
            foreach (Control ctl in Form.FindControl("brfssTable").Controls)
            {

                if (ctl is CheckBox)
                {
                    if (((CheckBox)ctl).Checked)
                    {

                        int yearFrom = 2001;
                        for (int i = 0; i < 15; i++)
                        {
                            string chkBoxId = "chk" + yearFrom.ToString("yy");
                            checkBoxArray[i] = ctl.FindControl(chkBoxId) as CheckBox;

                            if (checkBoxArray[i] != null && checkBoxArray[i].Checked)
                            {

                                string cookieName = yearFrom.ToString() + ctl.FindControl(chkBoxId).ClientID;
                                if (Request.Cookies[cookieName] != null)
                                {
                                    BRFSSFile file = new BRFSSFile()
                                    {
                                        YearFrom = yearFrom.ToString(),
                                        ColumnName = HttpUtility.UrlDecode(Request.Cookies[cookieName].Value)
                                    };

                                    studyArrayList[i].Add(file);
                                }

                            }

                            yearFrom++;
                        }



                    }
                }




            }

            int yearHeader = 4;
            for (int i = 0; i < 15; i++)
            {
                studyYear = "" + studyYearFrom;

                if (studyArrayList[i].Count > 0)
                {

                    _tables = new Dictionary<string, List<BRFSSFile>>();
                    List<string> listGroup = new List<string>();


                    //foreach (string groupName in listGroup)
                    //{
                    //    List<BRFSSFile> sameGroupList = new List<BRFSSFile>();
                    //    _tables.Add(groupName, sameGroupList);
                    //}

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
            String FileName = @"merged.sas7bdat";
            String FilePath = string.Format("{0}\\{1}", folder, FileName);  //@"D:\NHANES_EXTRA\1999-2000\lab\Biochemistry Profile and Hormones\lab18.sas7bdat"; //Replace this

            if (DownloadableProduct_Tracking(FilePath, FileName))
            {
                //Request.Headers.Add(Request.Headers);
                //Response.Redirect(Request.RawUrl);

                //Response.AppendHeader("Refresh", "0;URL=/NHANES.aspx");
            }
            else
            {
                Response.Write("<script>alert('failed');</script>");
            };
        }//-------- END SAS Button

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
                    SAS.LanguageServiceCarriageControl CarriageControl = new SAS.LanguageServiceCarriageControl();
                    SAS.LanguageServiceLineType LineType = new SAS.LanguageServiceLineType();

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
                        //Response.AppendCookie(new HttpCookie("fileDownloadToken", download_token_value_id.Value)); //downloadTokenValue will have been provided in the form submit via the hidden input field
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