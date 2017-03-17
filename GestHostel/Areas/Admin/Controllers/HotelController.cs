using GestHostel.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GestHostel.Areas.Admin.Controllers
{
    public class HotelController : Controller
    {
        private GestHostelDbEntities _db = new GestHostelDbEntities();

        // GET: Admin/Hotel
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(Hostel h, HttpPostedFileBase photo)
        {
            string name = Path.GetFileName(photo.FileName);
            photo.SaveAs(HttpContext.Server.MapPath(string.Format("~/img/{0}", name)));
            h.Photo = name;

            _db.Hostel.Add(h);
            try
            {
                _db.SaveChanges();
            }
            catch (Exception ex)
            {
                throw;
            }
            return RedirectToAction("HostelCreated");
        }

        public ActionResult HostelCreated()
        {
            return View();
        }
    }
}