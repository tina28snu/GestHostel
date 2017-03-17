using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GestHostel.Models
{
    public class ChambreModel
    {
        public List<string> Photos { get; set; }
        public string TypeChambre { get; set; }
        public double Prix { get; set; }
        public string Nom { get; set; }
        public string DescCourte { get; set; }
        public string DescLongue { get; set; }
        public List<Service> Service { get; set; }
        public int IdChambre { get; set; }
        public Nullable<bool> EsTSupprimer { get; set; }
        public string MainPhoto
        {
            get { return Photos.FirstOrDefault(); }
        }
    }
}