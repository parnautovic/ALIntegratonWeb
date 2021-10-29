// codeunit 50900 "BCWebServiceGet"
// {
//     trigger OnRun()
//     var
//         TempItem: Record Item temporary;
//         BCWebShopSetup: Record "BCWebShop Setup";
//         Base64Convert: Codeunit "Base64 Convert";

//         httpClient: HttpClient;
//         Response: HttpResponseMessage;
//         ResponseText: Text;
//         WebErrorMsg: Label 'Doslo je do greske %1', Comment = '%1 : Broj greske.';
//         AuthString: Text;
//         UserPwdTok: Label '%1:%2', Comment = '%1 = username, %2 = password';
//         BasicTok: Label 'Basic %1', Comment = '%1 = placeholder for username and password';
//         ResponseJsonObject: JsonObject;
//         ValueJsonToken: JsonToken;
//         ItemJsonToken: JsonToken;
//         BackEndWebShopTok: Label '%1/items?$top=1', Comment = '%1 base url';


//     begin
//         BCWebShopSetup.Get();
//         AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
//         AuthString := Base64Convert.ToBase64(AuthString);
//         httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(BasicTok, Base64Convert.ToBase64(AuthString)));

//         //httpClient.Get(StrSubstNo(BackEndWebShopTok, BCWebShopSetup."Backend Web Service URL"), Response);
//         httpClient.Get('https://bc-webshop.westeurope.cloudapp.azure.com:7048/bc/api/v1.0/companies(3adc449e-8621-ec11-bb76-000d3a29933c)/items?$top=1', Response);
//         if Response.IsSuccessStatusCode then begin
//             Response.Content.ReadAs(ResponseText);
//             ResponseJsonObject.ReadFrom(ResponseText);

//             ResponseJsonObject.Get('value', ValueJsonToken);
//             foreach ItemJsonToken in ValueJsonToken.AsArray() do
//                 ProcessItem(ItemJsonToken, TempItem);
//             Page.Run(Page::"Item List", TempItem);
//         end
//         else
//             Error(WebErrorMsg, Response.HttpStatusCode);
//     end;

//     local procedure ProcessItem(var ItemJsonToken: JsonToken; var TempItem: record Item temporary)
//     var
//         ItemJsonObject: JsonObject;
//     begin
//         ItemJsonObject := ItemJsonToken.AsObject();


//         TempItem.Init();
//         GetFieldValue(ItemJsonObject, 'displayName');

//         TempItem.Description := CopyStr(GetFieldValue(ItemJsonObject, 'displayName').AsText(), 1, MaxStrLen(TempItem.Description));
//         TempItem."No." := CopyStr(CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(TempItem.Description)), 1, MaxStrLen(TempItem."No."));
//         TempItem.Insert();
//         TempItem.Find()
//     end;

//     local procedure GetFieldValue(var ItemJsonObject: JsonObject; FieldName: Text): JsonValue
//     var
//         FieldJsonToken: JsonToken;
//     begin

//         ItemJsonObject.Get(FieldName, FieldJsonToken);
//         exit(FieldJsonToken.AsValue());
//     end;



// }

codeunit 50900 "BCWebServiceGet"
{
    trigger OnRun()
    var
        WebShopSetup: Record "BCWebShop Setup";
        TempItem: Record Item temporary;
        Base64Convert: Codeunit "Base64 Convert";
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        AuthString: Text;
        UserPwdTok: Label '%1:%2', Comment = '%1 is username, %2 is password';
        WebErrorMsg: Label 'Error occurred: %1', Comment = '%1 is http status code';
        BackEndWebShopUrlLbl: Label '%1/itemsPA?$top=3', Comment = '%1 is Web Shop url';
    begin
        WebShopSetup.Get();

        // TODO - new procedure for authorization
        AuthString := StrSubstNo(UserPwdTok, WebShopSetup."Backend Username", WebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Basic %1', AuthString));

        httpClient.Get(StrSubstNo(BackEndWebShopUrlLbl, WebShopSetup."Backend Web Service URL"), HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            ParseJson(ResponseText, TempItem);
            Page.Run(Page::"Item List", TempItem);
        end
        else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ParseJson(AuthString: Text; var TempItem: Record Item temporary)
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ItemJsonToken: JsonToken;
        ItemJsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(AuthString);
        JsonObject.Get('value', JsonToken);
        JsonArray := JsonToken.AsArray();

        foreach ItemJsonToken in JsonArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();

            TempItem.Init();
            TempItem."No." := CopyStr(GetFieldValue(ItemJsonObject, 'no').AsCode(), 1, MaxStrLen(TempItem."No."));
            TempItem.Description := CopyStr(GetFieldValue(ItemJsonObject, 'description').AsText(), 1, MaxStrLen(TempItem.Description));
            TempItem.Insert();
        end;
    end;

    local procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
        
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}

