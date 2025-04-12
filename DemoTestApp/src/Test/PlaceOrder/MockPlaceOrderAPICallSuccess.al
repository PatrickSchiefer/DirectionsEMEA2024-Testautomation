codeunit 52021 MockPlaceOrderAPICallSuccess implements IPlaceOrderAPICall
{
    procedure PlaceOrder(JSON: JsonObject) result: codeunit System.RestClient."Http Response Message"
    begin
        result.SetHttpStatusCode(200);
        result.SetIsSuccessStatusCode(true);
    end;
}