page 50030 SalesOrderAPI
{
    PageType = API;
    Caption = 'SalesOrderAPI';
    APIPublisher = 'PatrickSchiefer';
    APIGroup = 'Sales';
    APIVersion = 'v1.0';
    EntityName = 'SalesOrder';
    EntitySetName = 'SalesOrder';
    SourceTable = "Sales Header";
    DelayedInsert = true;
    PopulateAllFields = true;
    ODataKeyFields = "No.";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("No"; rec."No.")
            {
                Caption = 'no';
            }
            field(CustomerNo; rec."Sell-to Customer No.")
            {
                Caption = 'customerNo';
            }
            part(SalesOrderLines; "SalesOrderLineAPI")
            {
                EntityName = 'SalesOrderLine';
                EntitySetName = 'SalesOrderLines';
                SubPageLink = "Document No." = field("No."), "Document Type" = field("Document Type");
            }
        }
    }

    trigger OnInit()
    begin
        rec.SetRange("Document Type", Enum::"Sales Document Type"::Order);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec."Document Type" := Enum::"Sales Document Type"::Order;
    end;
}