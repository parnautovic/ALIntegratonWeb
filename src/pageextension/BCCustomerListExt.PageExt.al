pageextension 50900 "BCCustomerListExt" extends "Customer List"
{


    actions
    {
        addfirst(Action104)
        {
            action(BCGEtWebServiceItem)
            {
                ApplicationArea = All;
                Caption = 'Get Web Service Item';
                RunObject = Codeunit BCWebServiceGet;
                Promoted = true;
                Image = NextRecord;
                PromotedCategory = Process;
                ToolTip = 'Executes the Get Web Service Item action.';
            }

            action(BCRunIncovicePosting)
            {
                ApplicationArea = All;
                Caption = 'Invoice Posting';
                RunObject = Codeunit BCInvoicePosting;
                Promoted = true;
                Image = NextRecord;
                PromotedCategory = Process;
                ToolTip = 'Executes invoice posting';

            }
            action(BCTestpassword)
            {
                ApplicationArea = All;
                Caption = 'Invoice Posting';
                RunObject = Codeunit BCPassword;
                Promoted = true;
                Image = NextRecord;
                PromotedCategory = Process;
                ToolTip = 'Executes invoice posting';
            }
        }
    }

}