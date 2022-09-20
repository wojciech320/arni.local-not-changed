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
using System.Text;

namespace arni.local
{
    /// <summary>
    /// Summary description for RF_ID
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class RF_ID : System.Web.Services.WebService
    {
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string SealingAction(string SSID, string Uid)
        {

            return "";
        }
        static string SSid()
        {
            int length = 10;

            // creating a StringBuilder object()
            StringBuilder str_build = new StringBuilder();
            Random random = new Random();

            char letter;

            for (int i = 0; i < length; i++)
            {
                double flt = random.NextDouble();
                int shift = Convert.ToInt32(Math.Floor(25 * flt));
                letter = Convert.ToChar(shift + 65);
                str_build.Append(letter);
            }
            return str_build.ToString();
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string RF_ID_Incoming(string SSID, string UID, string SealerID, bool CreateSS)
        {
            bool SSIDexists = false;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AmbientDataConnectionString"].ConnectionString))
            {
                //  RF_ID.asmx/RF_ID_Incoming?SSID=xxxxxx&UID=04d3b5d1
                //Check if SSID exists and is active.
                //IF the SSID exists we assume it is also active.
                if (SSID != "X" & CreateSS == false) // "X" means that a new SealingSeassionID has not been created.
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        command.CommandText = "Select SealingSessionID From dbo.SealingSessions Where SealingSessionID = '" + SSID + "'";
                        try
                        {
                            connection.Open();
                            SqlDataReader rdr = command.ExecuteReader();
                            if (rdr.HasRows) //The SealingSessionID exisists and it is Active.
                            {
                                rdr.Close();
                                SSIDexists = true;
                            }
                            else    //Insert new pouch.
                            {
                                rdr.Close();
                                command.Connection = connection;
                                command.CommandText = "Insert Into dbo.SealingSessions(SealingSessionID, SealerID, Started, Active, PouchPerSeal) Values(@SealingSessionID, @SealerID, @Started, @Active, @PouchPerSeal)";
                                command.Parameters.AddWithValue("@SealingSessionID", SSid());
                                command.Parameters.AddWithValue("@SealerID", SealerID);
                                command.Parameters.AddWithValue("@Started", DateTime.Now.ToString());
                                command.Parameters.AddWithValue("@Active", 1);
                                command.Parameters.AddWithValue("@PouchPerSeal", 3);
                                command.ExecuteNonQuery();
                                SSIDexists = false;
                                return "";
                                //return "Please confirm that you want to create new SelaingSession";
                            }
                            //return "Ok";
                        }
                        catch (SqlException e)
                        {
                            //str = e.Message;
                        }
                        finally
                        {
                            connection.Close();
                        }
                        //return "Ok";
                    }
                }
                else
                {
                    //Create new SealingSession...
                }
                //Active SealingSession and No Pouch(es) in sealer then => "Put pouches in sealer".
                //No Active SealingSession then => "You have to create a new SealingSession to be able to add a pouch".
                if (SSIDexists == true)
                {
                    if (UID.Length == 14 & SSIDexists) //PouchID
                    {
                        using (SqlCommand command = new SqlCommand())
                        {
                            command.Connection = connection;
                            command.CommandText = "Select Pouch_ID From dbo.SealedPouches Where Pouch_ID = '" + UID + "'";
                            try
                            {
                                connection.Open();
                                SqlDataReader rdr = command.ExecuteReader();
                                if (rdr.HasRows) //The pouch exisists. You have already scaned this bag.
                                {

                                }
                                else
                                {
                                    //Insert new pouch.
                                    rdr.Close();
                                    command.CommandText = "Insert into SealedPouches(Pouch_ID) Values(@Uid)";
                                    command.Parameters.AddWithValue("@Uid", UID);
                                    command.ExecuteNonQuery();
                                }
                                return "Ok";
                            }
                            catch (SqlException e)
                            {
                                //str = e.Message;
                            }
                            finally
                            {
                                connection.Close();
                            }
                            return "Ok";
                        }
                    }

                    //Active SealingSession and Pouch(es) in sealer then => start sealing.
                    //Active SealingSession and No Pouch(es) in sealer then => "Put pouches in sealer".
                    //Active SealingSession and No pouch(es) in sealer then => "Ask to confirm end of SealingSession".
                    if (UID.Length == 8) //EmployeeID
                    {
                        using (SqlCommand command = new SqlCommand())
                        {
                            command.Connection = connection;
                            command.CommandText = "Select Employee_ID From dbo.Employees1 Where Employee_RFID = '" + UID + "'";
                            try
                            {
                                connection.Open();
                                SqlDataReader rdr = command.ExecuteReader();
                                while (rdr.Read())
                                {
                                    // sensor.Sensor_ID = rdr["Employee_ID"].ToString();
                                    // sensor.Name = rdr["Name"].ToString();
                                }
                                //else
                                {
                                    //Insert new pouch.
                                    rdr.Close();
                                    command.CommandText = "Insert into SealedPouches(Pouch_ID) Values(@Uid)";
                                    command.Parameters.AddWithValue("@Uid", UID);
                                    command.ExecuteNonQuery();
                                }
                                return "Ok";
                            }
                            catch (SqlException e)
                            {
                                //str = e.Message;
                            }
                            finally
                            {
                                connection.Close();
                            }
                            return "Ok";
                        }
                    }
                }
                return "Ok";
            }
        }
    }
}
