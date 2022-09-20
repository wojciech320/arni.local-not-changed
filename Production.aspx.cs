using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace arni.local
{
    public partial class Production : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

       
        public string saveHTMLdoc(string htmlDoc)
        {
            using (var conn = new SqlConnection("some conn string"))
            using (var cmd = conn.CreateCommand())
            {
                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.CommandType = CommandType.Text;
                        command.Connection = connection;
                        connection.Open();
                        //conn.Open();
                        cmd.CommandText = "insert into ProcessTemplates (HTMLDoc) values (@HTMLDoc)";
                        cmd.Parameters.AddWithValue("@HTMLDoc", htmlDoc);
                        cmd.ExecuteNonQuery();
                        //for (int i = 0; i < IdValue.LongLength; i++)
                        //{
                        //    command.Parameters.AddWithValue("@Sensor_Log_ID", DateTime.Now.ToString());
                        //    command.Parameters.AddWithValue("@Sensor_ID", IdValue[i]);
                        //    command.Parameters.AddWithValue("@Sensor_Value", IdValue[i + 1]);
                        //    int recordsAffected = command.ExecuteNonQuery();
                        //    command.Parameters.Clear();
                        //    i++;
                        //}
                        try
                        {
                            //return "connection.Open()";
                        }
                        catch (SqlException e)
                        {
                           // str = e.Message;
                        }
                        finally
                        {
                            connection.Close();
                        }
                        return "Recieved"; // + str;
                    }
                }
            }
        }
    }
}