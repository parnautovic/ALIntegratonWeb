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
        }
    }

}