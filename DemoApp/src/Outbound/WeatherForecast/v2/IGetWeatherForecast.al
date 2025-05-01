namespace WeatherForecast.v2;

using System.RestClient;

interface IGetWeatherForecast
{
    procedure GetWeatherForecast(): Codeunit "Http Response Message";
}