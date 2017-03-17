using GestHostel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace GestHostel.Controllers
{
    public class UserController : Controller
    {
        private GestHostelDbEntities _db = new GestHostelDbEntities();

        // GET: UserZone/User
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(Client u)
        {
            _db.Client.Add(u);
            _db.SaveChanges();
            return RedirectToAction("UserCreated");
        }


        [HttpPost]
        public ActionResult Connect(Client u)
        {
            if (u.Pseudo == "Admin")
            {
                List<DedicatedConnexion> ListAdmin = _db.DedicatedConnexion.Where(admin => admin.Login == u.Pseudo).ToList();
                List<string> passAdmin = ListAdmin.Select(admin => admin.Password).ToList();
                foreach (var pass in passAdmin)
                {
                    if (u.MotDePasse == pass)
                    {
                        return RedirectToAction("Index", "Home", new { area = "Admin" });
                    }
                    else
                    {
                        ViewBag.ErrMsg = "Error Connection! Try again";
                        return RedirectToAction("Index", "User");
                    }
                }
            }
            else
            {
                List<Client> ListUsers = _db.Client.ToList();
                List<string> Logins = ListUsers.Select(user => user.Pseudo).ToList();
                bool ok = false;

                foreach (var item in Logins)
                {
                    if (u.Pseudo == item)
                    {
                        List<Client> PassLogin = _db.Client.Where(user => user.Pseudo == u.Pseudo).ToList();
                        List<string> passDB = PassLogin.Select(user => user.MotDePasse).ToList();
                        foreach (var passCheck in passDB)
                        {
                            if (u.MotDePasse == passCheck)
                            {
                                ok = true;
                                utils.Utils.ConnectedUSer = _db.Client.FirstOrDefault(us => us.Pseudo == u.Pseudo);
                            }
                            else { ok = false; }
                        }
                    }
                    else { ok = false; }
                }

                if (ok == true)
                {
                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    ViewBag.ErrMsg = "Error Connection! Try again";
                    return RedirectToAction("Index", "User");
                }
            }
            return View();
        }


        public ActionResult UserCreated()
        {
            return View();
        }

        public ActionResult LogOut()
        {
            Session.Abandon();
            return RedirectToAction("Index", "Home");
        }
       
    }
}