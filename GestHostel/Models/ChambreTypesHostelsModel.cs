using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GestHostel.Models
{
    public class ChambreTypesHostelsModel
    {
        public Chambre chambre { get; set; }
        public IEnumerable<TypeChambre> types { get; set; }
        public IEnumerable<Hostel> hostels { get; set; }
    }
}