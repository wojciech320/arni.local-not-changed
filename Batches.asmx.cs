using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace arni.local
{
    /// <summary>
    /// Summary description for Batches
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class Batches : System.Web.Services.WebService
    {
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Batch> GetActiveBatches()
        {
            List<Batch> Batchs = new List<Batch>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetBatches"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    //command.Parameters.Add(parmeter_Id);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            Batch batch = new Batch
                            {
                                Batch_ID = rdr["Batch_ID"].ToString(),
                                Date = Convert.ToDateTime(rdr["Date"])
                            };
                            Batchs.Add(batch);
                        }
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return Batchs;
                }
            }
        }
    }
}
