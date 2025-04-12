namespace PlaceOrder;

using Microsoft.Purchases.Document;
using System.RestClient;

codeunit 50020 PlaceOrder
{
    procedure PlaceOrder(rec: Record "Purchase Header")
    var
        json: JsonObject;
        lines: JsonArray;
        line: JsonObject;
        purchaseLines: Record "Purchase Line";
        httpResponse: Codeunit "Http Response Message";
    begin
        initialize();
        json.Add('vendorId', rec."Buy-from Vendor No.");
        purchaseLines.SetRange("Document Type", rec."Document Type");
        purchaseLines.SetRange("Document No.", rec."No.");
        if purchaseLines.FindSet() then
            repeat
                Clear(line);
                line.Add('productId', purchaseLines."No.");
                line.Add('quantity', purchaseLines."Quantity");
                lines.Add(line);
            until purchaseLines.Next = 0;
        json.Add('lines', lines);

        httpResponse := this.impl.PlaceOrder(json);
        if httpResponse.GetHttpStatusCode <> 200 then begin
            error('Failed to place order: ' + httpResponse.GetContent().AsText());
        end;
    end;

    procedure initialize()
    var
        impl: Codeunit PlaceOrderAPICall;
    begin
        initialize(impl);
    end;

    procedure initialize(impl: Interface IPlaceOrderAPICall)
    begin
        if initialized then
            exit;
        this.impl := impl;
        this.initialized := true;
    end;

    var
        impl: Interface IPlaceOrderAPICall;
        initialized: Boolean;
}