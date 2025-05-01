page 50040 "Sales Order API v2"
{
    PageType = API;
    Caption = 'SalesOrderAPI';
    APIPublisher = 'PatrickSchiefer';
    APIGroup = 'Sales';
    APIVersion = 'v2.0';
    EntityName = 'SalesOrder';
    EntitySetName = 'SalesOrder';
    SourceTable = "Temp Sales Order Header";
    DelayedInsert = true;
    ODataKeyFields = "Document No.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(salesOrderNo; SalesOrderNo)
                {
                    Caption = 'Sales Order No.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        SalesOrderNo: Code[20];
        SalesOrderProcessor: Codeunit "Sales Order Processor";

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Enum::"Sales Document Type"::Order;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SalesOrderNo := SalesOrderProcessor.ProcessSalesOrder(Rec);
        exit(false); // Do not insert the record into Temp Sales Order Header
    end;
}