codeunit 50200 "Record version history"
{
    trigger OnRun()
    var
        ZYVersionHistory: Record "ZY Version History";
        LastUsedEntryNo: Integer;
        ApplicationSystemConstants: Codeunit "Application System Constants";
        Msg: Label '%1 (Platform %2 + Application %3)';
        LastVersion: Text[100];
    begin
        LastUsedEntryNo := 0;
        LastVersion := '';
        ZYVersionHistory.Reset();
        ZYVersionHistory.SetCurrentKey("Entry No.");
        ZYVersionHistory.Ascending(true);
        if ZYVersionHistory.FindLast() then begin
            LastUsedEntryNo := ZYVersionHistory."Entry No.";
            LastVersion := ZYVersionHistory.Version;
            ZYVersionHistory.Init();
            ZYVersionHistory."Entry No." := LastUsedEntryNo + 1;
            ZYVersionHistory.Version := StrSubstNo(Msg, ApplicationSystemConstants.ApplicationVersion(), ApplicationSystemConstants.PlatformFileVersion(), ApplicationSystemConstants.BuildFileVersion());
            ZYVersionHistory.Date := Today;
            if ZYVersionHistory.Version = LastVersion then
                ZYVersionHistory.Updated := false
            else
                ZYVersionHistory.Updated := true;
            ZYVersionHistory.Insert();
        end else begin
            ZYVersionHistory.Init();
            ZYVersionHistory."Entry No." := 1;
            ZYVersionHistory.Version := StrSubstNo(Msg, ApplicationSystemConstants.ApplicationVersion(), ApplicationSystemConstants.PlatformFileVersion(), ApplicationSystemConstants.BuildFileVersion());
            ZYVersionHistory.Date := Today;
            ZYVersionHistory.Updated := false;
            ZYVersionHistory.Insert();
        end;

    end;
}

table 50200 "ZY Version History"
{
    DataClassification = CustomerContent;
    Caption = 'ZY Version History';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Version; Text[100])
        {
            Caption = 'Version';
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
        }
        field(4; Updated; Boolean)
        {
            Caption = 'Updated';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}

page 50200 "ZY Version History"
{
    Caption = 'ZY Version History';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "ZY Version History";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Version; Rec.Version)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Updated; Rec.Updated)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
