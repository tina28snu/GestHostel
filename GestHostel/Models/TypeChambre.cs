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
    
    public partial class TypeChambre
    {
        public TypeChambre()
        {
            this.Chambre = new HashSet<Chambre>();
        }
    
        public int IdType { get; set; }
        public string Libelle { get; set; }
    
        public virtual ICollection<Chambre> Chambre { get; set; }
    }
}