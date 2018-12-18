using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace HealthData2
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            //AreaRegistration.RegisterAllAreas();

            // Register API Routes
            WebApiConfig.Register(GlobalConfiguration.Configuration);
            

            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            GlobalConfiguration.Configuration.EnsureInitialized();
            
        }
    }
}