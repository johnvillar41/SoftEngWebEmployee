﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" Async="true" ClientIDMode="AutoID" AutoEventWireup="true" CodeBehind="Sales.aspx.cs" Inherits="SoftEngWebEmployee.Views.Sales" %>

<%@ Import Namespace="SoftEngWebEmployee.Helpers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .scrolling-wrapper {
            overflow-x: auto;
        }

        .bd-callout {
            padding: 1.25rem;
            border: 1px solid #e9ecef;
            border-left-width: .25rem;
            border-radius: .25rem;
        }

        .bd-callout-warning {
            border-left-color: #f0ad4e;
        }

        .card-text {
            height: 54px;
            overflow-y: scroll;
            width: 100%;
        }

        .card0 {
            box-shadow: 0px 4px 8px 0px #757575;
            border-radius: 5px
        }

        .card-text p {
            width: 650px;
            word-break: break-word;
        }

        #overlayDiv {
            position: fixed;
            left: 50%;
            top: 50%;
            -webkit-transform: translate(-50%, -50%);
            transform: translate(-50%, -50%);
            z-index: 99;
        }
    </style>
    <script type="text/javascript">     
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if ((charCode > 31 && charCode < 48) || charCode > 57) {
                return false;
            }
            return true;
        }
    </script>

    <ul class="nav nav-tabs card0 bg-dark" id="trans" role="tablist">
        <li class="nav-item">
            <a class="nav-link active text-warning" id="view-transactions" data-toggle="tab" href="#view" role="tab" aria-controls="home" aria-selected="true">View Transactions List</a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-warning" id="create-transactions" data-toggle="tab" href="#create" role="tab" aria-controls="profile" aria-selected="false">Create Transaction</a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-warning" id="cart-transactions" data-toggle="tab" href="#cart" role="tab" aria-controls="cart" aria-selected="false">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        Cart Transaction <span class="badge bg-warning text-dark"><%=Cart.GetCartItems().Count() %></span>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </a>
        </li>
    </ul>
    <asp:UpdateProgress ID="UpdateProgress2" runat="server">
        <ProgressTemplate>
            <div id="overlayDiv">
                <lottie-player src="https://assets8.lottiefiles.com/packages/lf20_LqA9yY.json" background="transparent" speed="1" style="width: 400px; height: 400px;" loop autoplay></lottie-player>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div class="card card0 bd-callout bd-callout-warning" style="border-radius: .25rem">
        <div class="tab-content" id="myTabContent">
            <!-- View Transactions list -->
            <div class="tab-pane fade show active" id="view" role="tabpanel" aria-labelledby="view-transactions">
                <asp:UpdatePanel ID="UpdatePanel_Dropdown" runat="server">
                    <ContentTemplate>
                        <div class="row">
                            <h3><b>Search by Employee Name</b></h3>
                        </div>
                        <div class="row mb-2">
                            <div class="btn-group">

                                <!-- Dropdown Button -->
                                <asp:Button ID="dropdownMenuReference1" CssClass="btn btn-warning dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-expanded="false" runat="server" Text="Select Employee &#x25BC;" />
                                <!-- Dropdown List -->
                                <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="dropdownMenuReference1">
                                    <li>
                                        <asp:Button ID="btnCategoryAll" runat="server" CssClass="dropdown-item" Text="All Employee" UseSubmitBehavior="false" /></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>

                                    <asp:Repeater ID="EmployeeFullnameRepeater" OnItemCreated="EmployeeFullnameRepeater_ItemCreated" runat="server">
                                        <ItemTemplate>
                                            <a runat="server" class="dropdown-item" id="categorySelected">
                                                <li>
                                                    <asp:Button ID="EmployeeFullnameCategory" runat="server" CssClass="dropdown-item" Text='<%#DataBinder.Eval(Container.DataItem,"Username")%>' UseSubmitBehavior="false" OnClick="EmployeeFullnameCategory_Click" />
                                                </li>
                                            </a>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </div>
                        <div class="table-responsive" style="height: 500px">
                            <%if (!UserSession.SingleInstance.IsAdministrator()) %>
                            <%{ %>
                            <center><lottie-player src="https://assets1.lottiefiles.com/packages/lf20_LlRvIg.json" background="transparent" speed="1" style="width: 400px; height: 400px;" loop autoplay></lottie-player></center>
                            <center><h3><b>Sorry you are not allowed to view this.</b></h3></center>
                            <%} %>
                            <asp:Repeater ID="SalesRepeater" runat="server">
                                <HeaderTemplate>
                                    <div class="table-condensed table-responsive table-borderless" style="height: 500px">
                                        <table border="1" class="table table-striped">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th scope="col">Sales ID</th>
                                                    <th scope="col">FullName</th>
                                                    <th scope="col">Type Of Sale</th>
                                                    <th scope="col">Date of Transaction</th>
                                                    <th scope="col">Total Sale</th>
                                                    <th scope="col">Details</th>
                                                </tr>
                                            </thead>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "SalesID") %></td>
                                        <td><%# DataBinder.Eval(Container.DataItem, "Administrator.Fullname") %></td>
                                        <td><span class="badge bg-dark"><%# Eval("SalesType")%></span> </td>
                                        <td><%# DataBinder.Eval(Container.DataItem, "Date") %></td>
                                        <td><%# String.Format("{0:n0}",DataBinder.Eval(Container.DataItem, "TotalSales")) %></td>
                                        <td>
                                            <asp:Button OnClick="IDS_Click" ID="IDS" CommandName="SalesCommand" CommandArgument='<%# Eval("Orders.Order_ID") +";"+Eval("OnsiteTransaction.TransactionID") %>' CssClass="btn btn-primary" runat="server" Text="View All Details" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="dropdownMenuReference1" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

            <!-- Create Transaction tab -->
            <div class="tab-pane fade" id="create" role="tabpanel" aria-labelledby="create-transactions">
                <div class="col-lg-3 col-md-6 col-sm-12">
                    <div class="row">
                        <h3><b>Search by Category</b></h3>
                    </div>
                    <div class="row">
                        <div class="btn-group" style="margin-bottom: 10px; margin-top: 10px">
                            <button type="button" class="btn btn-warning dropdown-toggle dropdown-toggle-split" id="dropdownMenuReference" data-bs-toggle="dropdown" aria-expanded="false">
                                Select Category
                            </button>
                            <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="dropdownMenuReference">
                                <li>
                                    <asp:Button ID="CategoryBtnAllProducts" runat="server" CssClass="dropdown-item" Text="All Products" OnClick="CategoryBtnAllProducts_Click" /></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <asp:Repeater ID="CategoryRepeater" runat="server" OnItemCreated="CategoryRepeater_ItemCreated">
                                    <ItemTemplate>
                                        <a runat="server" class="dropdown-item" id="categorySelected">
                                            <li>
                                                <asp:Button ID="CategoryBtn" runat="server" CssClass="dropdown-item" Text='<%#Container.DataItem%>' OnClick="CategoryBtn_Click" />
                                            </li>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </div>
                    </div>



                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="container-fluid" style="background-color: #44433C; border: 2px solid #000000;">

                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <div class="scrolling-wrapper row flex-row flex-nowrap mt-1 pb-4 pt-2">
                                        <asp:Repeater ID="ProductsRepeater" runat="server" OnItemCreated="ProductsRepeater_ItemCreated">
                                            <ItemTemplate>
                                                <div class="col-lg-4 col-xl-3 col-md-6 col-sm-8 col-xs-12 my-2">
                                                    <div class="card" style="max-width: 35rem; min-width: 15rem; height: 420px">
                                                        <img class="card-img-top" alt="Card image cap" height="200px" width="100px" src="data:image/jpeg;base64,<%# Eval("ProductPicture") %>" />
                                                        <div class="card-body">
                                                            <h5 class="card-title"><b>Product Name: </b><%# DataBinder.Eval(Container.DataItem,"ProductName") %></h5>
                                                            <p class="card-text">
                                                                <b>Description: </b>
                                                                <%# DataBinder.Eval(Container.DataItem,"ProductDescription") %>
                                                                <br />
                                                                <b>Stocks: </b>
                                                                <%# String.Format("{0:n0}",DataBinder.Eval(Container.DataItem,"ProductStocks")) %>
                                                                <br />
                                                                <b>Price: </b>
                                                                <%# String.Format("{0:n0}",DataBinder.Eval(Container.DataItem,"ProductPrice")) %>
                                                            </p>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="col-lg-12">
                                                                <div class="row">
                                                                    <div class="col-lg-6 col-sm-12">
                                                                        <asp:TextBox ID="TotalItems" runat="server" CssClass="form-control mb-1" placeholder="Quantity" onkeypress="return isNumber(event)" onpaste="return false;"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-6 col-sm-12">
                                                                        <asp:Button ID="BtnAddToCart" CommandArgument='<%#Eval("Product_ID") %>' CssClass="btn btn-primary" runat="server" Text="Add To Cart" OnClick="BtnAddToCart_Click" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="CategoryBtnAllProducts" EventName="Click" />
                                </Triggers>

                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cart transaction tab-->
            <div class="tab-pane fade" id="cart" role="tabpanel" aria-labelledby="cart-transactions">
                <div class="row">
                    <div class="col-lg-9 col-md-7">
                        <div class="row">
                            <div class="container-fluid" style="background-color: #44433C; border: 2px solid #000000;">
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                    <ContentTemplate>
                                        <%if (Cart.GetCartItems().Count == 0) %>
                                        <%{ %>
                                        <center><h3 class="text-light">No Items found</h3></center>
                                        <center><lottie-player src="https://assets4.lottiefiles.com/temp/lf20_Celp8h.json" background="transparent"  speed="1"  style="        width: 300px;
        height: 300px;"loop autoplay></lottie-player></center>
                                        <%} %>
                                        <div class="scrolling-wrapper row flex-row flex-nowrap mt-4 pb-4 pt-2">
                                            <asp:Repeater ID="CartRepeater" runat="server" OnItemCreated="CartRepeater_ItemCreated">
                                                <ItemTemplate>
                                                    <div class="col-lg-4 col-xl-3 col-md-6 col-sm-8 col-xs-12 my-2">
                                                        <div class="card" style="max-width: 35rem; height: 420px">
                                                            <img class="card-img-top" alt="Card image cap" height="200px" width="100px" src="data:image/jpeg;base64,<%# Eval("ProductPicture") %>" />
                                                            <div class="card-body">
                                                                <h5 class="card-title"><b>Product Name: </b><%# DataBinder.Eval(Container.DataItem,"ProductName") %></h5>
                                                                <p class="card-text">
                                                                    <b>Description: </b>
                                                                    <%# DataBinder.Eval(Container.DataItem,"ProductDescription") %>
                                                                    <br />
                                                                    <b>Total number of items: </b>
                                                                    <%# String.Format("{0:n0}",DataBinder.Eval(Container.DataItem,"TotalNumberOfProduct")) %>
                                                                    <br />
                                                                    <b>Subtotal Price: </b>
                                                                    <%# String.Format("{0:n0}",DataBinder.Eval(Container.DataItem,"SubTotalPrice")) %>
                                                                </p>
                                                            </div>
                                                            <div class="card-footer">
                                                                <asp:Button ID="BtnRemoveCartItem" CommandArgument='<%#Eval("Product_ID") %>' CssClass="btn btn-primary" runat="server" Text="Remove Item" OnClick="BtnRemoveCartItem_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="BtnConfirmCartOrder" EventName="Click" />
                                    </Triggers>

                                </asp:UpdatePanel>
                            </div>
                        </div>

                    </div>
                    <div class="col-lg-3 col-md-5">
                        <div class="row">
                            <div class="card ml-1 mt-1" style="border-color: #000000;">
                                <div class="card-body">
                                    <h5 class="card-title"><b>List of orders</b></h5>
                                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                        <ContentTemplate>
                                            <h6>Item Count: <%=String.Format("{0:n0}",Cart.GetCartItems().Count()) %></h6>
                                            <table class="table" style="height: 300px;">
                                                <thead>
                                                    <tr>
                                                        <th scope="col">Product Name</th>
                                                        <th scope="col">Price</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%foreach (var productItem in Cart.GetCartItems()) %>
                                                    <%{ %>
                                                    <tr>
                                                        <td><%=productItem.ProductName%>[<%=productItem.TotalNumberOfProduct %>x]</td>
                                                        <td><%=String.Format("{0:n0}",productItem.ProductPrice * productItem.TotalNumberOfProduct) %></td>
                                                    </tr>
                                                    <%} %>
                                                </tbody>
                                            </table>
                                            <h6>Total Amount: PHP <%=String.Format("{0:n0}",Cart.CalculateTotalSales()) %></h6>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="BtnConfirmCartOrder" EventName="Click" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="mt-3">
                                <center><asp:Button ID="BtnConfirmCartOrder" CssClass="btn btn-success btn-block" runat="server" Text="Confirm" OnClick="BtnConfirmCartOrder_Click" /></center>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
