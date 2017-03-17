using GestHostel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GestHostel.Areas.Admin.Controllers
{
    public class RoomController : Controller
    {
        private GestHostelDbEntities _db = new GestHostelDbEntities();

        // GET: Admin/Rooms
        public ActionResult Index()
        {
            List<ChambreModel> list = new List<ChambreModel>();

            list = _db.Chambre.Select(c => new ChambreModel()
            {
                Photos = c.ChambrePhoto.Select(p => p.Photo.Url).ToList(),
                    Nom = c.Nom,
                    DescCourte = c.DescCourte,
                    DescLongue = c.DescLongue,
                    Prix = c.Prix,
                    TypeChambre = c.TypeChambre.Libelle,
                    Service = c.Service.ToList(),
                    IdChambre = c.IdChambre,
            }).ToList()
                .Where(w => !w.EsTSupprimer.HasValue || w.EsTSupprimer.Value == false)
                .OrderByDescending(b => b.IdChambre)
                .Take(10)
                .ToList();

            return View(list);
        }

        public ActionResult ShowRoom(int IdChambre)
        {
            Chambre model = _db.Chambre.Where(c => c.IdChambre == IdChambre).FirstOrDefault();
            return View(model);
        }

        public ActionResult ModifyRoom(int IdChambre)
        {
            Chambre chambre = _db.Chambre.Where(c => c.IdChambre == IdChambre).FirstOrDefault();
            ChambreTypesHostelsModel model = new ChambreTypesHostelsModel();
            model.chambre = chambre;
            model.hostels = _db.Hostel.ToList();
            model.types = _db.TypeChambre.ToList();
            return View(model);
        }

        public ActionResult DeleteRoom(int IdChambre)
        {
            Chambre model = _db.Chambre.Where(c => c.IdChambre == IdChambre).FirstOrDefault();
            model.EsTSupprimer = true;
            _db.SaveChanges();
            return View();
        }

        public ActionResult AddRoom()
        {
            ChambreTypesHostelsModel model = new ChambreTypesHostelsModel();
            model.hostels = _db.Hostel.ToList();
            model.types = _db.TypeChambre.ToList();
            return View(model);
        }

        public ActionResult CreateRoom(Chambre c, IEnumerable<HttpPostedFileBase> uploads)
        {
            foreach (var photo in uploads)
            {
                string name = photo.FileName;
                photo.SaveAs(HttpContext.Server.MapPath(string.Format("~/img/", name)));
                _db.Photo.Add(new Photo() { Url = name });
                _db.SaveChanges();
                Photo last = _db.Photo.OrderByDescending(p => p.IdPhoto).FirstOrDefault();
                _db.ChambrePhoto.Add(new ChambrePhoto() { IdPhoto = last.IdPhoto, IdChambre = c.IdChambre });
                _db.SaveChanges();
            }
            _db.Chambre.Add(c);
            _db.SaveChanges();
            return RedirectToAction("ChambreCreated");
        }

    }
}