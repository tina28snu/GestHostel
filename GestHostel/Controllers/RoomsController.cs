using GestHostel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GestHostel.Controllers
{
    public class RoomsController : Controller
    {
        private GestHostelDbEntities _db = new GestHostelDbEntities();

        // GET: Rooms
        public ActionResult Index()
        {
            List<ChambreModel> list = new List<ChambreModel>();

            list = _db.Chambre.Select(c=> new ChambreModel() {  Photos = c.ChambrePhoto.Select(p => p.Photo.Url).ToList(), Nom = c.Nom, DescCourte = c.DescCourte, DescLongue = c.DescLongue,Prix = c.Prix, 
                TypeChambre = c.TypeChambre.Libelle, Service = c.Service.ToList(), IdChambre = c.IdChambre }).ToList()
                .Where(w => !w.EsTSupprimer.HasValue || w.EsTSupprimer.Value  == false)
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
    }
}