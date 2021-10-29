codeunit 50901 "BCInvoicePosting"
{

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateSalesHeader(SalesHeader, '21233572');

        CreateSalesLine(SalesHeader, 10000, '1001', 3, 100);
        CreateSalesLine(SalesHeader, 20000, '1100', 2, 100);
        CreateSalesLine(SalesHeader, 30000, '1110', 4, 100);

        PostOrder(SalesHeader);
        CreatePayment(SalesHeader);
        OpenSalesPosted(SalesHeader);


        //Page.Run(Page::"Sales Order", SalesHeader);


    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])

    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Validate("Posting Date", Today());
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);

    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; NewLineNo: Integer; ItemNo: Code[20]; Qty: Integer; UnitPrice: Decimal)
    var
        SalesLine: Record "Sales Line";

    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Validate("Unit Price", UnitPrice);
        SalesLine.Validate("Qty. to Ship", Qty);

        SalesLine.Modify(true);
    end;

    local procedure PostOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        Codeunit.Run(CODEUNIT::"Sales-Post", SalesHeader);
    end;

    local procedure OpenSalesPosted(var SalesHeader: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then
            Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    end;

    local procedure CreatePayment(var SalesHeader: Record "Sales Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.CalcFields("Amount Including VAT");
        GenJournalLine.Init();
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then begin

            GenJournalLine.Validate("Posting Date", Today());
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.Validate("Document No.", 'PAY-12312');
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
            GenJournalLine.Validate("Account No.", '21233572');
            GenJournalLine.Validate("Currency Code", '');
            GenJournalLine.Validate("Payment Method Code", 'CASH');
            GenJournalLine.Validate(Amount, -SalesInvoiceHeader."Amount Including VAT");
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
            GenJournalLine.Validate("Applies-to Doc. No.", '12312');
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
            GenJournalLine.Validate("Bal. Account No.", 'WWB-OPERATING');

            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Line", GenJournalLine);
        end;
    end;

    local procedure FindPostedSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    begin
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        SalesInvoiceHeader.SetRange("Posting Date", SalesHeader."Posting Date");
        exit(SalesInvoiceHeader.FindFirst());
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSaleDoc(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");

        if SalesLine.FindSet(true) then
            repeat
                SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;

    end;

}
