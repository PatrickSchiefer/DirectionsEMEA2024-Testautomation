namespace WeatherForecast;
table 50000 WeatherForecast
{
    TableType = Temporary;
    fields
    {
        field(1; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Temperature; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Weather; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
