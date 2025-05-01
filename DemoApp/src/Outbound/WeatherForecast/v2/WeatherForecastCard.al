namespace WeatherForecast.v2;

using WeatherForecast;
page 50010 WeatherForecastV2
{
    Caption = 'Weather Forecast V2';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = WeatherForecast;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Temperature; rec.Temperature)
                {
                    ApplicationArea = All;
                }
                field(Weather; rec.Weather)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetWeatherForecast)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Get Weather Forecast';
                trigger OnAction()
                var
                    getForecast: Codeunit "GetWeatherForecastV2";
                begin
                    getForecast.GetWeatherForecast(rec);
                end;
            }
        }
    }
}