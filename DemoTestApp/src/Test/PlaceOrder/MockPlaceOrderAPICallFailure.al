codeunit 52022 MockPlaceOrderAPICallFailure implements IPlaceOrderAPICall
{
    procedure PlaceOrder(JSON: JsonObject) result: codeunit System.RestClient."Http Response Message"
    var
        responseMessage: HttpResponseMessage;
    begin
        result.SetHttpStatusCode(500);
        result.SetIsSuccessStatusCode(false);
    end;
}