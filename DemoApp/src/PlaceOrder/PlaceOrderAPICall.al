codeunit 50021 PlaceOrderAPICall implements IPlaceOrderAPICall
{


    procedure PlaceOrder(JSON: JsonObject): codeunit System.RestClient."Http Response Message"
    var
        restClient: codeunit System.RestClient."Rest Client";
        httpContent: codeunit System.RestClient."Http Content";
    begin
        httpContent := httpContent.Create(JSON);
        exit(restClient.Post('http://testautomation-directionsemea2024.germanywestcentral.cloudapp.azure.com/testapi/order', httpContent));
    end;
}