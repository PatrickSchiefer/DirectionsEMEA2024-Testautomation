namespace Test.WeatherForecast.v2;
using WeatherForecast.v2;
using System.TestLibraries.Utilities;
using WeatherForecast;
codeunit 52010 TestWeatherForecastV2
{

    Subtype = "Test";

    [Test]
    procedure TestWeatherForecast()
    var
        WeatherForecast: Record WeatherForecast;
        GetWeatherForecast: Codeunit "GetWeatherForecastV2";
    begin
        GetWeatherForecast.GetWeatherForecast(WeatherForecast);
    end;

    [Test]
    procedure TestWeatherForecastAssert()
    var
        WeatherForecast: Record WeatherForecast;
        GetWeatherForecast: Codeunit "GetWeatherForecastV2";
        Assert: Codeunit "Library Assert";
        MockGetWeatherForecast: Codeunit "MockGetWeatherForecast";
    begin
        GetWeatherForecast.initialize(MockGetWeatherForecast);
        GetWeatherForecast.GetWeatherForecast(WeatherForecast);
        Assert.AreEqual(Today(), WeatherForecast.Date, 'Date is not today');
        Assert.AreEqual('HOT', WeatherForecast.Weather, 'Weather is not HOT');
    end;
}