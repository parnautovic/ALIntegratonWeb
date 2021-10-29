page 50902 "BCLedger Entries"
{

    Caption = 'Ledger Entries';
    PageType = CardPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
            }
        }

    }

}
