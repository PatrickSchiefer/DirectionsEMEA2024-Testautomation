namespace Test.WeatherForecast;
using WeatherForecast.v1;
using System.TestLibraries.Utilities;
using WeatherForecast;
codeunit 52000 TestWeatherForecast
{

    Subtype = "Test";

    [Test]
    procedure TestWeatherForecast()
    var
        WeatherForecast: Record WeatherForecast;
        GetWeatherForecast: Codeunit "GetWeatherForecast";
    begin
        GetWeatherForecast.GetWeatherForecast(WeatherForecast);
    end;

    [Test]
    procedure TestWeatherForecastAssert()
    var
        WeatherForecast: Record WeatherForecast;
        GetWeatherForecast: Codeunit "GetWeatherForecast";
        Assert: Codeunit "Library Assert";
    begin
        GetWeatherForecast.GetWeatherForecast(WeatherForecast);
        Assert.AreEqual(Today(), WeatherForecast.Date, 'Date is not today');
        //Assert.AreEqual('HOT', WeatherForecast.Weather, 'Weather is not HOT');
        Assert.IsTrue((WeatherForecast.Weather in ['Freezing', 'Mild', 'Hot']), 'Weather is not Freezing, Mild or Cold');
    end;
}