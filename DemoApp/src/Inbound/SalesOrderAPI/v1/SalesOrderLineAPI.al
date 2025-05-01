page 50031 SalesOrderLineAPI
{
    PageType = API;
    Caption = 'SalesOrderLineAPI';
    APIPublisher = 'PatrickSchiefer';
    APIGroup = 'Sales';
    APIVersion = 'v1.0';
    EntityName = 'SalesOrderLine';
    EntitySetName = 'SalesOrderLines';
    SourceTable = "Sales Line";
    DelayedInsert = true;
    ODataKeyFields = "Document Type", "Document No.";
    PopulateAllFields = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(SalesOrderLines)
            {
                field(DocumentType; rec."Document Type")
                {
                    Caption = 'documentType';
                }
                field(DocumentNo; rec."Document No.")
                {
                    Caption = 'documentNo';
                }
                field(ItemNo; rec."No.")
                {
                    Caption = 'itemNo';
                }
                field(Quantity; rec."Quantity")
                {
                    Caption = 'quantity';
                }
            }
        }
    }


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales Line";
    begin
        salesHeader.Get(rec."Document Type", rec."Document No.");
        salesLine.SetRange("Document Type", salesHeader."Document Type");
        salesLine.SetRange("Document No.", salesHeader."No.");
        if salesLine.FindLast() then
            rec."Line No." := salesLine."Line No." + 10000
        else
            rec."Line No." := 10000;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.Type := Enum::"Sales Line Type"::Item;
    end;

}