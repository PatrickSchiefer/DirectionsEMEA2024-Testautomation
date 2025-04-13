codeunit 52001 TestSalesOrderAPI
{
    Subtype = "Test";


    [Test]
    procedure CreateSalesOrderSuccess()
    var
        SalesOrderProcessor: Codeunit "Sales Order Processor";
        salesLibrary: Codeunit "Library - Sales";
        Assert: Codeunit "Library Assert";
        TempSalesOrderHeader: Record "Temp Sales Order Header";
        customer: Record Customer;
        salesHeader: Record "Sales Header";
        SalesOrderNo: Code[20];
    begin
        // GIVEN customer
        salesLibrary.CreateCustomer(customer);
        // GIVEN temp sales order header
        TempSalesOrderHeader.Init();
        TempSalesOrderHeader."Document Type" := Enum::"Sales Document Type"::Order;
        TempSalesOrderHeader."Customer No." := customer."No.";
        TempSalesOrderHeader."Posting Date" := DMY2Date(31, 12, 2024);
        TempSalesOrderHeader.Insert(true);
        // WHEN process sales order
        SalesOrderNo := SalesOrderProcessor.ProcessSalesOrder(TempSalesOrderHeader);
        // THEN sales order no. is not empty
        Assert.AreNotEqual('', SalesOrderNo, 'Sales Order No. is empty');
        // THEN sales order header is created
        Assert.IsTrue(salesHeader.Get(salesHeader."Document Type"::Order, SalesOrderNo), 'Sales Order Header not found');
    end;

    [Test]
    procedure CreateSalesOrderInvalidCustomer()
    var
        SalesOrderProcessor: Codeunit "Sales Order Processor";
        salesLibrary: Codeunit "Library - Sales";
        Assert: Codeunit "Library Assert";
        TempSalesOrderHeader: Record "Temp Sales Order Header";
        customer: Record Customer;
        salesHeader: Record "Sales Header";
        SalesOrderNo: Code[20];
    begin
        // GIVEN customer
        salesLibrary.CreateCustomer(customer);
        // GIVEN temp sales order header
        TempSalesOrderHeader.Init();
        TempSalesOrderHeader."Document Type" := Enum::"Sales Document Type"::Order;
        TempSalesOrderHeader."Customer No." := 'INVALID_CUSTOMER_NO'; // assuming this customer does not exist
        TempSalesOrderHeader."Posting Date" := DMY2Date(31, 12, 2024);
        TempSalesOrderHeader.Insert(true);
        // WHEN process sales order
        // THEN error is thrown
        asserterror SalesOrderNo := SalesOrderProcessor.ProcessSalesOrder(TempSalesOrderHeader);
    end;
}