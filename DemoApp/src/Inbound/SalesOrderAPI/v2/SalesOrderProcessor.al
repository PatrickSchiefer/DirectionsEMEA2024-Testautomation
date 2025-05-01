codeunit 50040 "Sales Order Processor"
{
    procedure ProcessSalesOrder(var TempSalesOrderHeader: Record "Temp Sales Order Header") SalesOrderNo: Code[20]
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextLineNo: Integer;
    begin
        // Create Sales Header
        SalesHeader.Init();
        SalesHeader."Document Type" := TempSalesOrderHeader."Document Type";
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesOrderNo := SalesHeader."No.";

        SalesHeader.Validate("Sell-to Customer No.", TempSalesOrderHeader."Customer No.");
        if TempSalesOrderHeader."Posting Date" <> 0D then
            SalesHeader.Validate("Posting Date", TempSalesOrderHeader."Posting Date");
        SalesHeader.Modify(true);

        exit(SalesOrderNo);
    end;
}