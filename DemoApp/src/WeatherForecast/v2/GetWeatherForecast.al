namespace WeatherForecast.v2;

using WeatherForecast;

codeunit 50010 GetWeatherForecastV2
{

    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast)
    begin
        initialize();
        impl.GetWeatherForecast(WeatherForecast);
    end;

    procedure initialize()
    var
        impl: Codeunit GetWeatherForecastImpl;
    begin
        initialize(impl);
    end;

    procedure initialize(impl: Interface IGetWeatherForecast)
    begin
        if initialized then
            exit;
        this.impl := impl;
        this.initialized := true;
    end;

    var
        impl: Interface IGetWeatherForecast;
        initialized: Boolean;
}