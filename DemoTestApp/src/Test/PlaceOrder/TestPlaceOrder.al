codeunit 52020 PlaceOrderTest
{

    Subtype = "Test";

    [Test]
    procedure TestPlaceOrder()
    var
        PlaceOrder: Codeunit "PlaceOrder";
        rec: Record "Purchase Header";
    begin
        rec.FindFirst();
        PlaceOrder.PlaceOrder(rec);
    end;

    [Test]
    procedure TestPlaceOrderSuccess()
    var
        PlaceOrder: Codeunit "PlaceOrder";
        rec: Record "Purchase Header";
        MockPlaceOrderAPICallSuccess: Codeunit "MockPlaceOrderAPICallSuccess";
    begin
        PlaceOrder.initialize(MockPlaceOrderAPICallSuccess);
        rec.FindFirst();
        PlaceOrder.PlaceOrder(rec);
    end;

    [Test]
    procedure TestPlaceOrderFailure()
    var
        PlaceOrder: Codeunit "PlaceOrder";
        rec: Record "Purchase Header";
        MockPlaceOrderAPICallFailure: Codeunit "MockPlaceOrderAPICallFailure";
    begin
        PlaceOrder.initialize(MockPlaceOrderAPICallFailure);
        rec.FindFirst();
        asserterror PlaceOrder.PlaceOrder(rec);
    end;

    [Test]
    procedure TestPlaceOrderCheckJson()
    var
        PlaceOrder: Codeunit "PlaceOrder";
        rec: Record "Purchase Header";
        recLines: Record "Purchase Line";
        MockPlaceOrderAPIGetJSON: Codeunit MockPlaceOrderAPIGetJSON;
        PurchaseLibrary: Codeunit "Library - Purchase";
        result: Text;
        Assert: Codeunit "Library Assert";
    begin
        // GIVEN purchase order header
        PlaceOrder.initialize(MockPlaceOrderAPIGetJSON);
        PurchaseLibrary.CreatePurchaseOrder(rec);
        rec."Buy-from Vendor No." := '1';
        rec.Modify();
        recLines.SetRange("Document Type", rec."Document Type");
        recLines.SetRange("Document No.", rec."No.");
        if recLines.FindSet() then
            recLines.DeleteAll();
        PurchaseLibrary.CreatePurchaseLine(recLines, rec, Enum::"Purchase Line Type"::Item, '1896-S', 10);
        PlaceOrder.PlaceOrder(rec);
        result := MockPlaceOrderAPIGetJSON.GetJSON();
        Assert.AreEqual('{"vendorId":"1","lines":[{"productId":"1896-S","quantity":10.0}]}', result, 'JSON is not as expected');
    end;

}