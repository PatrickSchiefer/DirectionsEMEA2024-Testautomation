namespace WeatherForecast.v2;

using WeatherForecast;

codeunit 50010 GetWeatherForecastV2
{

    procedure GetWeatherForecast(var WeatherForecast: Record WeatherForecast)
    var
        restClient: Codeunit System.RestClient."Rest Client";
        response: Codeunit System.RestClient."Http Response Message";
        JSONObj: JsonObject;
        JSONToken: JsonToken;
    begin
        initialize();
        response := impl.GetWeatherForecast();
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