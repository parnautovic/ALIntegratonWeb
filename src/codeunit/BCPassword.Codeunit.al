codeunit 50902 "BCPassword"
{
    trigger OnRun()
    begin
        StorePassword('admin', 'Pa$$w0rd!');
        if HasUser('admin') then
            Message('%1', GetPassword('admin'));

        Message('Wrong user');
    end;

    local procedure HasUser(User: Text): Boolean;

    begin
        exit(IsolatedStorage.Contains(User));
    end;

    local procedure StorePassword(User: Text; Pwd: Text): Boolean

    begin
        exit(IsolatedStorage.SetEncrypted(User, Pwd));

    end;

    local procedure GetPassword(User: Text) Pwd: Text

    begin
        IsolatedStorage.Get(User, Pwd);
        exit(Pwd);
    end;

}