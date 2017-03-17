using GestHostel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GestHostel.utils
{
    public class Utils
    {
        public static Client ConnectedUSer
        {
            get { return (Client)HttpContext.Current.Session["User"]; }

            set { HttpContext.Current.Session["User"] = value; }
        }

    }
}