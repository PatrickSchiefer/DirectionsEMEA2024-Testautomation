interface IPlaceOrderAPICall
{
    procedure PlaceOrder(JSON: JsonObject): Codeunit "Http Response Message";
}