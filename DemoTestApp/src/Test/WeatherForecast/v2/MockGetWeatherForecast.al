namespace Test.WeatherForecast.v2;
using WeatherForecast.v2;
using WeatherForecast;
using System.RestClient;
codeunit 52011 MockGetWeatherForecast implements IGetWeatherForecast
{

    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast)
    begin
        WeatherForecast.Date := Today();
        WeatherForecast.Weather := 'HOT';
    end;

    procedure GetWeatherForecast(): codeunit "Http Response Message"
    var
        response: codeunit "Http Response Message";
        httpContent: Codeunit "Http Content";
    begin
        response.SetHttpStatusCode(200);
        response.SetIsSuccessStatusCode(true);
        // Save in file as soon as this feature is released
        // https://learn.microsoft.com/en-us/dynamics365/release-plan/2024wave2/smb/dynamics365-business-central/package-resources-extensions-access-al
        httpContent.Create('{"date": "2024-09-24","temperatureC": 30,"temperatureF": 86,"summary": "HOT"}');
        response.SetContent(httpContent);
        exit(response);
    end;
}