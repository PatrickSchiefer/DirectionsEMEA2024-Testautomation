namespace WeatherForecast.v2;

using WeatherForecast;

interface IGetWeatherForecast
{
    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast);
}