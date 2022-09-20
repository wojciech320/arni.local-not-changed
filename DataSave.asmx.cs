using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Services;
using System.Collections;
using System.Web.Services.Protocols;

namespace arni.local
{
    /// <summary>
    /// Summary description for DataSave
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class DataSave : System.Web.Services.WebService
    {
        [WebMethod]
        public Sensor GetSensorByID(int sensorId)
        {
            Sensor sensor = new Sensor();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetSensorInfoByID"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    //command.CommandText = "Select Sensor_ID, Sensor_Name From dbo.AmbientData";
                    SqlParameter parSensorID = new SqlParameter();
                    parSensorID.ParameterName = "@Sensor_ID";
                    parSensorID.Value = sensorId;
                    command.Parameters.Add(parSensorID);
                    try
                    {
                        connection.Open();
                        //return "connection.Open()";
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            sensor.Sensor_ID = rdr["Sensor_ID"].ToString();
                            sensor.Name = rdr["Name"].ToString();
                        }
                        return sensor;
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return sensor;
                }
            }
        }

        [WebMethod]
        public SensorValue spGetSensorLatestValue(int sensorId)
        {
            SensorValue sensorValue = new SensorValue();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetSensorLatestValue"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parSensorID = new SqlParameter();
                    parSensorID.ParameterName = "@Sensor_ID";
                    parSensorID.Value = sensorId;
                    command.Parameters.Add(parSensorID);
                    try
                    {
                        connection.Open();
                        //return "connection.Open()";
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            sensorValue.Sensor_ID = Convert.ToInt32(rdr["Sensor_ID"]);                           
                            sensorValue.Sensor_Value = rdr["Value"].ToString();
                        }
                        return sensorValue;
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return sensorValue;
                }
            }
        }
        [WebMethod]
        public Sensor spGetSensorInfo(int sensorId)
        {
            Sensor sensor = new Sensor();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetSensorInfo"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parSensorID = new SqlParameter();
                    parSensorID.ParameterName = "@Sensor_ID";
                    parSensorID.Value = sensorId;
                    command.Parameters.Add(parSensorID);
                    try
                    {
                        connection.Open();
                        //return "connection.Open()";
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            sensor.Sensor_ID = rdr["Sensor_ID"].ToString();
                            sensor.Name = rdr["Name"].ToString();
                        }
                        return sensor;
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return sensor;
                }
            }
        }
        //[WebMethod]
        //[ScriptMethod(UseHttpGet = true)]
       // public string SaveSensorData(string value)
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveSensorData(string value)
        {
            string str = "";
            string[] IdValue = value.Split(new[] { "," }, StringSplitOptions.None);
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spInsertSensorValue]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    for (int i = 0; i < IdValue.LongLength; i++)
                    {
                        command.Parameters.AddWithValue("@Sensor_Log_ID", DateTime.Now.ToString());
                        command.Parameters.AddWithValue("@Sensor_ID", IdValue[i]);
                        command.Parameters.AddWithValue("@Sensor_Value", IdValue[i + 1]);
                        int recordsAffected = command.ExecuteNonQuery();
                        command.Parameters.Clear();
                        i++;
                    }
                    try
                    {
                        //return "connection.Open()";
                    }
                    catch (SqlException e)
                    {
                        str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return "Recieved" + str;
                }
            }
        }
    }
}


//namespace insertEmployeeJqueryAjax
//{
//    /// <summary>
//    /// Summary description for SensorDataService
//    /// </summary>
//    [WebService(Namespace = "http://tempuri.org/")]
//    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//    [System.ComponentModel.ToolboxItem(false)]
//    [System.Web.Script.Services.ScriptService]
//    public class SensorDataService : System.Web.Services.WebService
//    {
//        [WebMethod]
//        public void SaveSensorData(string text)
//        {
//            //userid=joe&password=guessme
//            Array data = text.Split(new[] { ", " }, StringSplitOptions.RemoveEmptyEntries);
//            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["JQueryDBConnectionString"].ConnectionString))
//            {
//                using (SqlCommand command = new SqlCommand())
//                {
//                    command.Connection = connection;
//                    command.CommandType = CommandType.Text;
//                    command.CommandText = "INSERT into SensorData (Measure_ID, Sensor_ID, Value, Created) Values(@Measure_ID, @Sensor_ID, @Value, @Created)";
//                    command.Parameters.AddWithValue("@Measure_ID", data.GetValue(0));
//                    command.Parameters.AddWithValue("@Sensor_ID", data.GetValue(1));
//                    command.Parameters.AddWithValue("@Value", data.GetValue(2));
//                    command.Parameters.AddWithValue("@Created", DateTime.Now.ToString());
//                    try
//                    {
//                        connection.Open();
//                        int recordsAffected = command.ExecuteNonQuery();
//                    }
//                    catch (SqlException e)
//                    {

//                    }
//                    finally
//                    {
//                        connection.Close();
//                    }
//                }
//            }
//        }
//    }
//}
