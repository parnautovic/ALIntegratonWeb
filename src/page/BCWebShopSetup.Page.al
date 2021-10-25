page 50900 "BCWeb Shop Setup"
{

    Caption = 'Web Shop Setup';
    PageType = Card;
    SourceTable = "BCWebShop Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    AdditionalSearchTerms = 'Web Shop';

    layout
    {
        area(content)
        {
            group("Backend Web Service")
            {
                Caption = 'Backend Web Service';


                field("Backend Web Service URL"; Rec."Backend Web Service URL")
                {
                    ToolTip = 'Specifies the value of the Backend Web Service URL field.';
                    ApplicationArea = All;
                    MultiLine = true;
                    Caption = 'Backend Web Service URL';
                }
            }
            group("Backend WebService Credntials")
            {
                Caption = 'Backend WebService Credntials';
                field("Backend Username"; Rec."Backend Username")
                {
                    ToolTip = 'Specifies the value of the Backend Username field.';
                    ApplicationArea = All;
                    Caption = 'Backend Username';
                }
                field("Backend Password"; Rec."Backend Password")
                {
                    ToolTip = 'Specifies the value of the Backend Password field.';
                    ApplicationArea = All;
                    Caption = 'Backend Password';
                }
            }
        }
    }

    trigger OnOpenPage()

    begin
        //Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Backend Web Service URL" := 'https://<servername>/<service>/api/1.0';
            Rec.Insert();
        end;
    end;

}
