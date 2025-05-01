namespace WeatherForecast.v1;

using WeatherForecast;

codeunit 50000 GetWeatherForecast
{

    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast)
    var
        restClient: Codeunit System.RestClient."Rest Client";
        response: Codeunit System.RestClient."Http Response Message";
        JSONObj: JsonObject;
        JSONToken: JsonToken;
    begin
        response := restClient.Get('http://testautomation-directionsemea2024.germanywestcentral.cloudapp.azure.com/testapi/weatherforecast');
        if response.GetIsSuccessStatusCode() then begin
            WeatherForecast.DeleteAll();
            JSONObj := response.GetContent().AsJson().AsObject();
            JSONObj.Get('date', JSONToken);
            WeatherForecast.Date := JSONToken.AsValue().AsDate();
            JSONObj.Get('temperatureC', JSONToken);
            WeatherForecast.Temperature := JSONToken.AsValue().AsDecimal();
            JSONObj.Get('summary', JSONToken);
            WeatherForecast.Weather := JSONToken.AsValue().AsText();
            WeatherForecast.Insert();
        end;
    end;
}