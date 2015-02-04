program bin2fnt;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  ERROR_NO_ERROR = 0; // =)
  ERROR_NO_PARAM = 1;
  ERROR_NO_IFILE = 2;

var
  FontFile: File of Byte;
  CodeFile: TextFile;
  FileS1ze: Integer;
  JustByte: Byte;
  i: Integer;

begin
  WriteLn('bin2fnt by Yoti');

  if (ParamCount < 3)
  then
    begin
      WriteLn('usage: ' + ExtractFileName(ParamStr(0)) + 'in_file title out_file');
      Halt(ERROR_NO_PARAM);
    end;

  if (FileExists(ParamStr(1)) = False)
  then
    begin
      WriteLn('error: ' + ExtractFileName(ParamStr(1)) + ' not found');
      Halt(ERROR_NO_IFILE);
    end;

  AssignFile(FontFile, ParamStr(1));
  AssignFile(CodeFile, ParamStr(3));
  Reset(FontFile);
  Rewrite(CodeFile);
  //
  FileS1ze:=FileSize(FontFile);
  //
  WriteLn(CodeFile, '#include <psptypes.h>');
  WriteLn(CodeFile, '');
  WriteLn(CodeFile, 'u8 ' + ParamStr(2) + '[]=');
  //
  for i:=1 to FileS1ze do
    begin
      Read(FontFile, JustByte);
      //
      if (i mod 16 = 1)
      then Write(CodeFile, '"');
      //
      Write(CodeFile, '\x' + LowerCase(IntToHex(JustByte, 2)));
      //
      if (i mod 16 = 0)
      then Write(CodeFile, '"');
      //
      if (i = FileS1ze)
      then Write(CodeFile, ';');
      //
      if (i mod 16 = 0)
      then WriteLn(CodeFile, '');
    end;
  //
  CloseFile(FontFile);
  CloseFile(CodeFile);

  WriteLn('Done!');
  Halt(ERROR_NO_ERROR);
end.
