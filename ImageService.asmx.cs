using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Data;
using System.Web.Script.Services;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace arni.local
{
    /// <summary>
    /// Summary description for ImageService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class ImageService : System.Web.Services.WebService
    {

        [WebMethod]
        public List<Product> GetProducts()
        {
            List<Product> products = new List<Product>();
            string conString = ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString;
            string query = "SELECT * FROM Employees1";
            using (SqlConnection con = new SqlConnection(conString))
            {
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    products.Add(new Product
                    {
                        //Employee_ID = Convert.ToInt32(sdr["Employee_ID"]),
                        Employee_ID = sdr["Employee_ID"].ToString(),
                        Name = sdr["Name"].ToString().TrimEnd(),
                        ImageData = Convert.ToBase64String((byte[])sdr["Image"], 0, ((byte[])sdr["Image"]).Length)
                    });
                }
                con.Close();
            }

            return products;
        }     
        
        [WebMethod]
        public List<Equipment> GetEquipmentImage() 
        {
            var jsonString = String.Empty;

            HttpContext.Current.Request.InputStream.Position = 0;
            using (var inputStream = new StreamReader(HttpContext.Current.Request.InputStream))
            {
                jsonString = inputStream.ReadToEnd();
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic blogObject = js.Deserialize<dynamic>(jsonString);
            string Equipment_ID = blogObject["Equipment_ID"];
           
            List<Equipment> Equipments = new List<Equipment>();
            string conString = ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString;
            string query = "SELECT * FROM Equipment Where (Equipment_ID = '" + Equipment_ID + "')";
            using (SqlConnection con = new SqlConnection(conString))
            {
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    Equipments.Add(new Equipment
                   {
                        //Equipment_ID = sdr["Equipment_ID"].ToString(),
                        //Name = sdr["Name"].ToString().TrimEnd(),
                        Image = Convert.ToBase64String((byte[])sdr["Image"], 0, ((byte[])sdr["Image"]).Length)
                    });
                }
                con.Close();
            }

            return Equipments;
        }

    }
}

