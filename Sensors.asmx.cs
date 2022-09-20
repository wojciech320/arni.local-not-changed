using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Services;
//using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace arni.local
{
    /// <summary>
    /// Summary description for Sensors
    /// </summary>

    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Sensors : System.Web.Services.WebService
    {
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Batch> GetBatches()
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

        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<TyvekLot> GetTyvekLots()
        {
            List<TyvekLot> TyvekLots = new List<TyvekLot>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetTyvekLots"))
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
                            TyvekLot tyvekLot = new TyvekLot
                            {
                                TyvekLot_ID = rdr["TyvekLot_ID"].ToString(),
                                Prod_Number = rdr["Prod_Number"].ToString(),
                                Lot_Size = Convert.ToInt32(rdr["Lot_Size"]),
                                Pouch_Size = rdr["Pouch_Size"].ToString(),
                                Lot_Number = rdr["Lot_Number"].ToString(),
                                Lot_Remaining = Convert.ToInt32(rdr["Lot_Remaining"]),
                            };
                            TyvekLots.Add(tyvekLot);
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
                    return TyvekLots;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Equipment> GetEquipmentType(string type)
        {
            List<Equipment> Equipments = new List<Equipment>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetEquipmentOfType"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parmeter_Id = new SqlParameter
                    {
                        ParameterName = "@Type",
                        Value = type
                    };
                    command.Parameters.Add(parmeter_Id);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            Equipment equipment = new Equipment
                            {
                                Equipment_ID = rdr["Equipment_ID"].ToString(),
                                Name = rdr["Name"].ToString(),
                            };
                            Equipments.Add(equipment);
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
                    return Equipments;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void UploadImage()
        {
            if (HttpContext.Current.Request.Files.AllKeys.Any())
            {
                // Get the uploaded image from the Files collection
                var httpPostedFile = HttpContext.Current.Request.Files["UploadedImage"];
                //foreach (string key in HttpContext.Current.Request.Form.AllKeys)
                //{
                //    string value = HttpContext.Current.Request.Form[key];
                //}

                if (httpPostedFile != null)
                {
                    //var fileSavePath = Path.Combine(Server.MapPath("upload"), httpPostedFile.FileName);
                    //var file = ConvertToByteArray(fileSavePath);
                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString);
                    using (con)
                    {
                        SqlCommand cmd = new SqlCommand(HttpContext.Current.Request.Form["spImage"], con);
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@id", SqlDbType.NChar).Value = HttpContext.Current.Request.Form["id"];
                        cmd.Parameters.Add("@image", SqlDbType.VarBinary,
                            (int)httpPostedFile.InputStream.Length).Value = httpPostedFile.InputStream;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
        public byte[] ConvertToByteArray(string varFilePath)
        {
            byte[] file;
            using (var stream = new FileStream(varFilePath, FileMode.Open, FileAccess.Read))
            {
                using (var reader = new BinaryReader(stream))
                {
                    file = reader.ReadBytes((int)stream.Length);
                }
            }
            return file;
        }

    [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string StartWashing(string sensorPoolId)
        {
            string str = "";
            //return value;
            //Array data = value.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spStartWashing"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@SensorPool_ID", Convert.ToInt32(sensorPoolId));
                    command.Parameters.AddWithValue("@Started", DateTime.Now.ToString());
                    try
                    {
                        connection.Open();
                        int recordsAffected = command.ExecuteNonQuery();
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
        [WebMethod]
        public Sensor GetSensorPoolInfo(int sensorPoolId)
        {
            Sensor sensor = new Sensor();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetSensorPoolInfo"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parSensorPoolID = new SqlParameter();
                    parSensorPoolID.ParameterName = "@sensorPoolId";
                    parSensorPoolID.Value = sensorPoolId;
                    command.Parameters.Add(parSensorPoolID);
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
        [ScriptMethod(UseHttpGet = true)]
        public string GetXMLInfo()
        {
            string xmlString = "";
            //Sensor sensor = new Sensor();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spXML_Test"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    //SqlParameter parSensorPoolID = new SqlParameter();
                    //parSensorPoolID.ParameterName = "@sensorPoolId";
                    //parSensorPoolID.Value = sensorPoolId;
                    //command.Parameters.Add(parSensorPoolID);
                    try
                    {
                        connection.Open();
                        //return "connection.Open()";
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            xmlString = rdr["XMLTemplate"].ToString();
                        }
                        return xmlString;
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return xmlString;
                }
            }
        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveMultibleSensorData(string IdValues)
        {
            string str = "";
            string[] IdValue = IdValues.Split(new[] { "," }, StringSplitOptions.None);
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spInsertSensorValue]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    string logTime = DateTime.Now.ToString();
                    for (int i = 0; i < IdValue.LongLength; i++)
                    {
                        command.Parameters.AddWithValue("@Sensor_Log_ID", logTime);
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

        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveHTMLdoc(string htmlDoc)
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

        [WebMethod]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Xml)]
        public List<SensorValue> GetSensorValues(string sensorId, int scount, DateTime fromTime, DateTime toTime)
        {
            List<SensorValue> SensorValues = new List<SensorValue>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetSensorLatestValues"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter par1 = new SqlParameter
                    {
                        ParameterName = "@Sensor_ID",
                        Value = sensorId
                    };
                    SqlParameter par2 = new SqlParameter
                    {
                        ParameterName = "@Scount",
                        Value = scount
                    };
                    SqlParameter par3 = new SqlParameter
                    {
                        ParameterName = "@fromTime",
                        Value = fromTime
                    };
                    SqlParameter par4 = new SqlParameter
                    {
                        ParameterName = "@toTime",
                        Value = toTime
                    };
                    command.Parameters.Add(par1);
                    command.Parameters.Add(par2);
                    command.Parameters.Add(par3);
                    command.Parameters.Add(par4);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            SensorValue sensorValue = new SensorValue
                            {
                                Sensor_Log_ID = Convert.ToDateTime(rdr["Sensor_Log_ID"]),
                                Sensor_Value = rdr["Sensor_Value"].ToString()
                            };
                            SensorValues.Add(sensorValue);
                        }
                        return SensorValues;
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return SensorValues;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Computer> GetAllComputerData(int id)
        {
            List<Computer> Computers = new List<Computer>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetComputers"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parmeter_Id = new SqlParameter
                    {
                        ParameterName = "@id",
                        Value = id
                    };
                    command.Parameters.Add(parmeter_Id);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            Computer computer = new Computer
                            {
                                Computer_Id = rdr["Computer_ID"].ToString(),
                                Name = rdr["Name"].ToString(),
                                Discription = rdr["Discription"].ToString(),
                                Type = rdr["Type"].ToString(),
                                Located = rdr["Located"].ToString(),
                                Address = rdr["Address"].ToString(),
                                Activated = Convert.ToDateTime(rdr["Activated"]),
                                //Image = rdr["ImagofDevice"].ToString(),
                                Log = rdr["Log"].ToString(),
                            };
                            Computers.Add(computer);
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
                    return Computers;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Sensor> GetAllSensorData(string id)
        {
            List<Sensor> Sensors = new List<Sensor>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetAllSensorData"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parmeter_Id = new SqlParameter
                    {
                        ParameterName = "@id",
                        Value = id
                    };
                    command.Parameters.Add(parmeter_Id);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            Sensor sensor = new Sensor
                            {
                                Sensor_ID = rdr["Sensor_ID"].ToString(),
                                Name = rdr["Name"].ToString(),
                                Type = rdr["Type"].ToString(),
                                Located = rdr["Located"].ToString(),
                                Activated = Convert.ToDateTime(rdr["Activated"]),
                                Discription = rdr["Discription"].ToString(),
                                Unit = rdr["Unit"].ToString(),
                                Log = rdr["Log"].ToString(),
                                Attached = Convert.ToBoolean(rdr["Attached"])
                            };
                            Sensors.Add(sensor);
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
                    return Sensors;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public List<Sensor> GetAtachedSensors(int id)
        {
            List<Sensor> Sensors = new List<Sensor>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("spGetAtachedSensors"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter parmeter_Id = new SqlParameter
                    {
                        ParameterName = "@id",
                        Value = id
                    };
                    command.Parameters.Add(parmeter_Id);
                    try
                    {
                        connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();
                        while (rdr.Read())
                        {
                            Sensor sensor = new Sensor
                            {
                                Sensor_ID = rdr["Sensor_ID"].ToString(),
                                //Name = rdr["Name"].ToString(),
                                //Type = rdr["Type"].ToString(),
                                //Located = rdr["Located"].ToString(),
                                //Activated = Convert.ToDateTime(rdr["Activated"]),
                                //Discription = rdr["Discription"].ToString(),
                                //Unit = rdr["Unit"].ToString(),
                                //Log = rdr["Log"].ToString(),
                            };
                            Sensors.Add(sensor);
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
                    return Sensors;
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public int DeletAtachment(int Computer_ID, string Sensor_ID)
        {
            int recordsAffected = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {                
                using (SqlCommand command = new SqlCommand("spDeletAtachment"))
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Sensor_ID", Sensor_ID);
                    command.Parameters.AddWithValue("@Computer_ID", Computer_ID);
                    try
                    {
                        connection.Open();
                        recordsAffected = command.ExecuteNonQuery();
                    }
                    catch (SqlException e)
                    {
                        //str = e.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                    return recordsAffected;
                }
            }
        }
        
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveSensorData(string Sensor_ID, string Name, string Type, string Located, string Discription, string Address, string Activated, string Log, string Unit, bool Attached)
        {
            string str = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spUpdateSensorData]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    //string logTime = DateTime.Now.ToString();
                    command.Parameters.AddWithValue("@Sensor_ID", Sensor_ID);
                    command.Parameters.AddWithValue("@Name", Name);
                    command.Parameters.AddWithValue("@Type", Type);
                    command.Parameters.AddWithValue("@Located", Located);
                    command.Parameters.AddWithValue("@Discription", Discription);
                    command.Parameters.AddWithValue("@Address", Address);
                    command.Parameters.AddWithValue("@Activated", Activated);
                    command.Parameters.AddWithValue("@Log", Log);
                    command.Parameters.AddWithValue("@Unit", Unit);
                    command.Parameters.AddWithValue("@Attached", Attached);
                    int recordsAffected = command.ExecuteNonQuery();
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
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveNewSensorData(string Sensor_ID, string Name, string Type, string Located, string Discription, string Address, string Activated, string Log, string Unit, bool Attached)
        {
            string str = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spInserNewSensorData]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    //string logTime = DateTime.Now.ToString();
                    command.Parameters.AddWithValue("@Sensor_ID", Sensor_ID);
                    command.Parameters.AddWithValue("@Name", Name);
                    command.Parameters.AddWithValue("@Type", Type);
                    command.Parameters.AddWithValue("@Located", Located);
                    command.Parameters.AddWithValue("@Discription", Discription);
                    command.Parameters.AddWithValue("@Address", Address);
                    command.Parameters.AddWithValue("@Activated", Activated);
                    command.Parameters.AddWithValue("@Log", Log);
                    command.Parameters.AddWithValue("@Unit", Unit);
                    command.Parameters.AddWithValue("@Attached", Attached);
                    int recordsAffected = command.ExecuteNonQuery();
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
        
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string AtachSensor(int Computer_ID, string Sensor_ID)
        {
            string str = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spConnectSensorToComputer]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    //string logTime = DateTime.Now.ToString();
                    command.Parameters.AddWithValue("@Sensor_ID", Sensor_ID);
                    command.Parameters.AddWithValue("@Computer_ID", Computer_ID);
                    int recordsAffected = command.ExecuteNonQuery();
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
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveComputerData(int Computer_ID, string Name, string Type, string Located, string Discription, string Address, string Activated, string Log)
        {
            string str = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spUpdateComputerData]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    //string logTime = DateTime.Now.ToString();
                    command.Parameters.AddWithValue("@Computer_ID", Computer_ID);
                    command.Parameters.AddWithValue("@Name", Name);
                    command.Parameters.AddWithValue("@Type", Type);
                    command.Parameters.AddWithValue("@Located", Located);
                    command.Parameters.AddWithValue("@Discription", Discription);
                    command.Parameters.AddWithValue("@Address", Address);
                    command.Parameters.AddWithValue("@Activated", Activated);
                    command.Parameters.AddWithValue("@Log", Log);
                    int recordsAffected = command.ExecuteNonQuery();
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
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SaveNewComputerData(int Computer_ID, string Name, string Type, string Located, string Discription, string Address, string Activated, string Log)
        {
            string str = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("[spInsertComputerData]", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    //string logTime = DateTime.Now.ToString();
                    //command.Parameters.AddWithValue("@Computer_ID", Computer_ID);
                    command.Parameters.AddWithValue("@Name", Name);
                    command.Parameters.AddWithValue("@Type", Type);
                    command.Parameters.AddWithValue("@Location", Located);
                    command.Parameters.AddWithValue("@Discription", Discription);
                    command.Parameters.AddWithValue("@Address", Address);
                    command.Parameters.AddWithValue("@Activation", Activated);
                    command.Parameters.AddWithValue("@Log", Log);
                    int recordsAffected = command.ExecuteNonQuery();
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