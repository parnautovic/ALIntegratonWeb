table 50901 "BCRetail Cue"
{
    Caption = 'Retail Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "No. of Items"; Integer)
        {
            Caption = 'No. of Items';
            FieldClass = FlowField;

            CalcFormula = count(Item);
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
