﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SoftEngWebEmployee.Models
{
    public class OrdersModel
    {
        public int Order_ID { get; set; }
        public int CustomerID { get; set; }
        public int OrderTotalPrice { get; set; }
        public string OrderStatus { get; set; }
        public string OrderDate { get; set; }
        public int TotalNumberOfOrders { get; set; }
        public List<SpecificOrdersModel> SpecificOrdersModel { get; set; }
    }
}