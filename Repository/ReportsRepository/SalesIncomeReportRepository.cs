﻿using MySql.Data.MySqlClient;
using SoftEngWebEmployee.Helpers;
using SoftEngWebEmployee.Models.ReportModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace SoftEngWebEmployee.Repository.ReportsRepository
{
    public class SalesIncomeReportRepository
    {
        private static SalesIncomeReportRepository instance = null;
        private SalesIncomeReportRepository()
        {

        }
        public static SalesIncomeReportRepository GetInstance()
        {
            if(instance == null)
            {
                instance = new SalesIncomeReportRepository();
            }
            return instance;
        }
        public async Task<SalesIncomeReportViewModel> FetchTotalSaleOfAdmin(string administrator)
        {
            SalesIncomeReportViewModel salesIncome = new SalesIncomeReportViewModel();
            using (MySqlConnection connection = new MySqlConnection(DbConnString.DBCONN_STRING))
            {
                await connection.OpenAsync();
                string queryString = "SELECT (SELECT SUM(onsite_products_transaction_table.subtotal_price) FROM onsite_products_transaction_table WHERE onsite_products_transaction_table.administrator_username = 'sample') as TotalSaleOnSite, (SELECT SUM(specific_orders_table.subtotal_price) FROM specific_orders_table WHERE specific_orders_table.administrator_username = 'sample') AS TotalSaleOrder";
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@administrator", administrator);
                MySqlDataReader reader = (MySqlDataReader)await command.ExecuteReaderAsync();
                if(await reader.ReadAsync())
                {
                    if (String.IsNullOrEmpty(reader["TotalSaleOnSite"].ToString()))
                        salesIncome.TotalSaleOnsite = 0;
                    else
                        salesIncome.TotalSaleOnsite = int.Parse(reader["TotalSaleOnSite"].ToString());
                    if (String.IsNullOrEmpty(reader["TotalSaleOrder"].ToString()))
                        salesIncome.TotalSaleOrders = 0;
                    else
                        salesIncome.TotalSaleOrders = int.Parse(reader["TotalSaleOrder"].ToString());
                    salesIncome.TotalSale = salesIncome.TotalSaleOnsite + salesIncome.TotalSaleOrders;
                    salesIncome.Administrator = await AdministratorRepository.GetInstance().FindAdministrator(administrator);
                }
            }
            return salesIncome;
        }
    }
}