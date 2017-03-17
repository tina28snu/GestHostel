using System.Web;
using System.Web.Optimization;

namespace GestHostel
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/js").Include(
            
                "~/js/jquery-ui-1.10.1.min.js",
                "~/js/calendar_func.js",
                "~/js/jquery.easing.1.3.min.js",
                "~/js/jquery.superslides.min.js",
                "~/js/retina.min.js",
                "~/js/jquery.placeholder.min.js",
                "~/js/functions.js", 
                "~/js/owl.carousel.min.js",
                "~/js/jquery.simpleWeather.min.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.min.css",
                      "~/Content/jquery-ui-1.10.1.css",
                      "~/Content/style.css",
                      "~/Content/owl.carousel.css",
                      "~/Content/owl.theme.css",
                      "~/fontello/css/fontello.css",
                      "~/fontello/css/animation.css"
                      ));
        }
    }
}
