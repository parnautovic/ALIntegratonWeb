# Topic 1

## Topic level 2

### Topic level 3

This is my first topic.

[Google](www.google.com)

```pas
 trigger OnOpenPage()

    begin
        //Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Backend Web Service URL" := 'https://<servername>/<service>/api/1.0';
            Rec.Insert();
        end;
    end;
```
