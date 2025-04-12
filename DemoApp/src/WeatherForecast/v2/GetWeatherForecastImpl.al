namespace WeatherForecast.v2;

using System.RestClient;

codeunit 50011 GetWeatherForecastImpl implements IGetWeatherForecast
{

    procedure GetWeatherForecast(): Codeunit "Http Response Message";
    var
        restClient: Codeunit "Rest Client";
    begin
        exit(restClient.Get('http://testautomation-directionsemea2024.germanywestcentral.cloudapp.azure.com/testapi/weatherforecast'));
    end;
}