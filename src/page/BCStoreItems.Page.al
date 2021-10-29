page 50901 "BCStore Items"
{

    ApplicationArea = All;
    Caption = 'Store Items';
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Inventory field.';
                    ApplicationArea = All;
                    Caption = 'Inventory';
                }
            }
        }

        area(FactBoxes)
        {
            part(Info; "BCStore Info")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            part(EndgerEntries; "BCLedger Entries")
            {
                SubPageLink = "Item No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Group)
            {
                action(DemoAction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the DemoAction action.';
                    Caption = 'DemoAction';
                    Image = AboutNav;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ShortcutKey = 'Ctrl + L';

                    trigger OnAction()
                    begin
                        Message('Test');
                    end;
                }
            }
        }
    }

}
