namespace Test.WeatherForecast.v2;
using WeatherForecast.v2;
using WeatherForecast;
codeunit 52011 MockGetWeatherForecast implements IGetWeatherForecast
{

    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast)
    begin
        WeatherForecast.Date := Today();
        WeatherForecast.Weather := 'HOT';
    end;
}