codeunit 52023 MockPlaceOrderAPIGetJSON implements IPlaceOrderAPICall
{
    procedure GetJSON(): Text
    begin
        exit(this.json);
    end;

    procedure PlaceOrder(JSON: JsonObject): codeunit System.RestClient."Http Response Message"
    var
        MockPlaceOrderAPICallSuccess: codeunit MockPlaceOrderAPICallSuccess;
    begin
        JSON.WriteTo(this.json);
        exit(MockPlaceOrderAPICallSuccess.PlaceOrder(JSON));
    end;

    var
        json: text;
}
