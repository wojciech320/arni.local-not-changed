using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace arni.local
{
    public class Sensor
    {
        public string Sensor_ID { get; set; }
        public string Name { get; set;}
        public string Type { get; set; }
        public string Located { get; set; }
        public DateTime Activated { get; set; }
        public string Discription { get; set;}
        public string Unit { get; set; }
        public string Log { get; set; }
        public bool Attached { get; set; }
    }

    public class SensorValue
    {
        public int Sensor_ID { get; set; }
        public DateTime Sensor_Log_ID { get; set; }
        public string Sensor_Value { get; set; }
    }

    public class Computer
    {
        public string Computer_Id { get; set; }
        public string Name { get; set; }
        public string Discription { get; set; }
        public string Type { get; set; }
        public string Located { get; set; }
        public string Address { get; set; }
        public DateTime Activated { get; set; }
        public string Image { get; set; }
        public string Log { get; set; }
    }
    public class Equipment
    {
        public string Equipment_ID { get; set; }
        public string Name { get; set; }
        public string Image { get; set; }
    }
    public class EquipmentTest
    {
        public string Equipment_ID { get; set; }
    }

    public class TyvekLot
    {
        public string TyvekLot_ID { get; set; }
        public string Prod_Number { get; set; }
        public string Pouch_Size { get; set; }
        public int Lot_Size { get; set; }
        public string Lot_Number { get; set; }
        public int Lot_Remaining { get; set; }
    }
    public class Batch
    {
        public string Batch_ID { get; set; }
        public DateTime Date { get; set; }
    }
    public class Product
    {
        public string Employee_ID { get; set; }
        public string Name { get; set; }
        public string ImageData { get; set; }
    }

    public class Pouch
    {
        public string Pouch_ID { get; set; }
        public string EmployeeID { get; set; }
    }
}