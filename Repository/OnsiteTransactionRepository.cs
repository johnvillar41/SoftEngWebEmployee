﻿using MySql.Data.MySqlClient;
using SoftEngWebEmployee.Helpers;
using SoftEngWebEmployee.Models;
using System;
using System.Threading.Tasks;

namespace SoftEngWebEmployee.Repository
{
    public class OnsiteTransactionRepository
    {
        private static OnsiteTransactionRepository instance = null;
        private OnsiteTransactionRepository()
        {

        }
        public static OnsiteTransactionRepository SingleInstance
        {
            get
            {
                if (instance == null)
                {
                    instance = new OnsiteTransactionRepository();
                }
                return instance;
            }            
        }
        /// <summary>
        ///     <para>
        ///         <br>Inserts a new transaction object inside the database</br> 
        ///         <br>and returns a MySqlConnection to be used on last_insert_id()</br>
        ///         <br>Mysql function due to the reason of a single connection is required</br>
        ///     </para>
        /// </summary>
        /// <param name="onsiteTransaction">
        ///     Passes an onsitetransaction model async parameter
        /// </param>
        /// <returns>
        ///     <para>Returns the used MysqlConnection</para>
        ///     <para>Type: MySqlConnection</para>
        /// </returns>
        public async Task<MySqlConnection> InsertNewTransaction(OnsiteTransactionModel onsiteTransaction)
        {
            MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING);
            await connection.OpenAsync();
            string queryString = "INSERT INTO onsite_transaction_table(total_sale)VALUES(@totalSale)";
            MySqlCommand command = new MySqlCommand(queryString, connection);
            command.Parameters.AddWithValue("@totalSale", onsiteTransaction.TotalSale);
            await command.ExecuteNonQueryAsync();
            return connection;
        }
        /// <summary>
        ///     Fetches the last inserted id inside the database
        /// </summary>
        /// <param name="connection">
        ///     Passes a MySqlConnection as parameter to be reused to determine the last inserted id
        /// </param>
        /// <returns>
        ///     <para>Returns the last inserted id</para>
        ///     <para>Type: int</para>
        /// </returns>
        public async Task<int> FetchLastInsertID(MySqlConnection connection)
        {
            int lastIdInserted = 0;
            string queryString = "SELECT LAST_INSERT_ID()";
            MySqlCommand command = new MySqlCommand(queryString, connection);
            MySqlDataReader reader = (MySqlDataReader)await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                lastIdInserted = reader.GetInt32(0);
            }
            await connection.CloseAsync();
            return lastIdInserted;
        }       
        /// <summary>
        ///     Calculates the total sales on the onsite transactions for a specific paramref name="transactionID"
        /// </summary>
        /// <param name="transactionID">
        ///     Passes a transaction id as parameter
        /// </param>
        /// <returns>
        ///     <para>Returns a total sale.</para>
        ///     <para>Type: int</para>
        /// </returns>
        public async Task<int> CalculateTotalSaleOnsite(int transactionID)
        {
            int totalOnsiteSale = 0;
            using (MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING))
            {
                await connection.OpenAsync();
                string queryString = "SELECT SUM(total_sale) as TotalSale FROM onsite_transaction_table WHERE transaction_id = @transactionId";
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@transactionId", transactionID);
                using (MySqlDataReader reader = (MySqlDataReader)await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        if (reader["TotalSale"] != DBNull.Value)
                        {
                            totalOnsiteSale = int.Parse(reader["TotalSale"].ToString());
                        }
                    }
                }
            }
            return totalOnsiteSale;
        }
        /// <summary>
        ///     Fetches an onsite transaction from database given a paramref name="transactionID"
        /// </summary>
        /// <param name="transactionID">
        ///     Passes a transaction id as parameter
        /// </param>
        /// <returns>
        ///     <para>Returns an object of onsitetransaction</para>
        ///     <para>Type: OnsiteTransactionModel</para>
        /// </returns>
        public async Task<OnsiteTransactionModel> FetchOnsiteTransaction(int transactionID)
        {
            OnsiteTransactionModel onsiteTransactionModel = null;
            using (MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING))
            {
                await connection.OpenAsync();
                string queryString = "SELECT * FROM onsite_transaction_table WHERE transaction_id=@transactionID";
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@transactionID", transactionID);
                MySqlDataReader reader = (MySqlDataReader)await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    onsiteTransactionModel = new OnsiteTransactionModel()
                    {
                        TransactionID = int.Parse(reader["transaction_id"].ToString()),
                        //Generate Customer Model
                        TotalSale = int.Parse(reader["total_sale"].ToString()),
                        OnsiteProductTransactionList = await OnsiteProductsTransactionRepository.SingleInstance.FetchTransactionsGivenByIDAsync(int.Parse(reader["transaction_id"].ToString()))
                    };
                }
            }
            return onsiteTransactionModel;
        }
    }
}