//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace GestHostel.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Service
    {
        public Service()
        {
            this.Chambre = new HashSet<Chambre>();
            this.Hostel = new HashSet<Hostel>();
        }
    
        public int IdService { get; set; }
        public string Libelle { get; set; }
        public string icone { get; set; }
    
        public virtual ICollection<Chambre> Chambre { get; set; }
        public virtual ICollection<Hostel> Hostel { get; set; }
    }
}
