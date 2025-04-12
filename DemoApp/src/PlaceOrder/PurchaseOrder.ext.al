pageextension 50020 PurchaseOrderExt extends "Purchase Order"
{

    actions
    {
        addlast(processing)
        {
            action(PlaceOrder)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Place Order';
                trigger OnAction()
                var
                    placeOrder: Codeunit "PlaceOrder";
                begin
                    placeOrder.PlaceOrder(rec);
                end;
            }
        }
    }

}