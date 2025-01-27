﻿using MySql.Data.MySqlClient;
using SoftEngWebEmployee.Helpers;
using SoftEngWebEmployee.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SoftEngWebEmployee.Repository
{
    public class SpecificOrdersRepository
    {
        private static SpecificOrdersRepository instance = null;
        private SpecificOrdersRepository()
        {

        }

        public static SpecificOrdersRepository SingleInstance
        {
            get
            {
                if (instance == null)
                {
                    instance = new SpecificOrdersRepository();
                }
                return instance;
            }            
        }        
        /// <summary>
        ///     This function retrieves the total orders of a certain order ID
        /// </summary>
        /// <param name="orderID">
        ///     Passes order ID as a parameter
        /// </param>
        /// <returns>
        ///     <para>Returns product ID</para>
        ///     <para>Type: Int</para>
        /// </returns>
        public async Task<Dictionary<int, int>> FetchProductIDsAsync(int orderID)
        {
            Dictionary<int, int> productID = new Dictionary<int, int>();
            using (MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING))
            {
                await connection.OpenAsync();
                string queryString = "SELECT product_id,total_orders FROM specific_orders_table WHERE order_id = @orderID";
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@orderID",orderID);
                using (MySqlDataReader reader = (MySqlDataReader)await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        productID.Add(int.Parse(reader["product_id"].ToString()), int.Parse(reader["total_orders"].ToString()));
                    }
                }
            }
            return productID;
        }
        /// <summary>
        ///     This function retrieves the specific orders of a certain order ID
        /// </summary>
        /// <param name="orderID">
        ///     Passes order ID as a parameter
        /// </param>
        /// <returns>
        ///     <para>Returns specific orders details</para>
        ///     <para>Type: List<SpecificOrdersModel></para>
        /// </returns>
        public async Task<List<SpecificOrdersModel>> FetchSpecificOrdersAsync(int orderID)
        {
            List<SpecificOrdersModel> specificOrdersModels = new List<SpecificOrdersModel>();
            using (MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING))
            {
                await connection.OpenAsync();
                string queryString = "SELECT * FROM specific_orders_table WHERE order_id=@orderID";
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@orderID", orderID);
                MySqlDataReader reader = command.ExecuteReader();
                while (await reader.ReadAsync())
                {
                    SpecificOrdersModel specificOrdersModel = new SpecificOrdersModel()
                    {
                        SpecificOrdersId = int.Parse(reader["specific_orders_id"].ToString()),
                        OrdersID = int.Parse(reader["order_id"].ToString()),
                        ProductID = int.Parse(reader["product_id"].ToString()),
                        TotalOrders = int.Parse(reader["total_orders"].ToString()),
                        Administrator = reader["administrator_username"].ToString(),
                        ProductsModel = await ProductRepository.SingleInstance.GetProductsAsync(int.Parse(reader["product_id"].ToString()))
                    };
                    specificOrdersModels.Add(specificOrdersModel);
                }
            }
            return specificOrdersModels;
        }

    }
}
