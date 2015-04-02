program icn2src;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  ERROR_NO_ERROR = 0; // =)
  ERROR_NO_PARAM = 1;
  ERROR_NO_IFILE = 2;

var
  CfwFile: File of Byte;
  FileS1ze: Cardinal;
  HrdFile: TextFile;
  JustByte: Byte;
  i: Cardinal;

begin
  WriteLn('icn2src by Yoti');

  if (ParamCount < 1)
  then
    begin
      WriteLn('usage: ' + ExtractFileName(ParamStr(0)) + 'in_file');
      Halt(ERROR_NO_PARAM);
    end;

  if (FileExists(ParamStr(1)) = False)
  then
    begin
      WriteLn('error: ' + ExtractFileName(ParamStr(1)) + ' not found');
      Halt(ERROR_NO_IFILE);
    end;

  AssignFile(CfwFile, ParamStr(1));
  //AssignFile(HrdFile, ChangeFileExt(ParamStr(1), '.h'));
  AssignFile(HrdFile, 'icon.c'); // hardcoded for icn2src
  Reset(CfwFile);
  Rewrite(HrdFile);

  FileS1ze:=FileSize(CfwFile);

  WriteLn(HrdFile, '#include <psptypes.h>'); // only for icn2src
  WriteLn(HrdFile, '');
  //WriteLn(HrdFile, 'u8 ' + ChangeFileExt(ParamStr(1), '') + '[' + IntToStr(FileS1ze) + ']=');
  WriteLn(HrdFile, 'u8 g_icon_png[' + IntToStr(FileS1ze) + ']='); // hardcoded for icn2src
  WriteLn(HrdFile, '{');

  for i:=1 to FileS1ze do
    begin
      Read(CfwFile, JustByte);

      if (i mod 11 = 1) // hardcoded for icn2src
      then Write(HrdFile, #9);

      Write(HrdFile, '0x');
      Write(HrdFile, IntToHex(JustByte, 2));
      if (i <> FileS1ze)
      then Write(HrdFile, ', ');

      if (i mod 11 = 0) // hardcoded for icn2src
      then WriteLn(HrdFile, '');

      if (i = FileS1ze)
      then Write(HrdFile, #13#10 + '};');
    end;

  WriteLn(HrdFile, '');

  CloseFile(CfwFile);
  CloseFile(HrdFile);

  WriteLn('Done!');
  Halt(ERROR_NO_ERROR);
end.
