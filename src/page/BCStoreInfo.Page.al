page 50903 "BCStore Info"
{

    Caption = 'Store Info';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Specifies the value of the Picture field.';
                    ApplicationArea = All;
                }
            }
        }

    }

}
