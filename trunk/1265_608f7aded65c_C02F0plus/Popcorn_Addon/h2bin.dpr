program h2bin;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

var
  b: byte;
  s: string;
  i: integer;
  f: textfile;
  w: file of byte;

begin
  SetConsoleTitle('h2bin');
  WriteLn('h2bin.exe v3 by Yoti');
  if (ParamStr(1) = '')
  then
    begin
      WriteLn('usage: '+ExtractFileName(ParamStr(0))+' infile.ext [debug]');
      Halt(1);
    end;

  if (FileExists(ParamStr(1)) = False)
  then
    begin
      WriteLn('error: infile.ext not found!');
      Halt(2);
    end;

  AssignFile(f, ParamStr(1));
  Reset(f);
  AssignFile(w, ChangeFileExt(ParamStr(1), '_h2b.bin'));
  ReWrite(w);

  while not Eof(f) do
  begin
    ReadLn(f, s);
    if (Length(s) > 0) and ((s[1] = #009) or (s[1] = #032) or (s[1] = #034))
    then
      begin
        s:=StringReplace(s, ' ', '', [rfReplaceAll]);
        s:=StringReplace(s, ',', '', [rfReplaceAll]);
        s:=StringReplace(s, ';', '', [rfReplaceAll]);
        s:=StringReplace(s, '"', '', [rfReplaceAll]);
        s:=StringReplace(s, #09, '', [rfReplaceAll]);
        s:=StringReplace(s, '0x', '', [rfReplaceAll]);
        s:=StringReplace(s, '\x', '', [rfReplaceAll]);        
        {* ѕроверить строку на чЄтность *}
        if AnsiLowerCase(ParamStr(2)) = 'debug'
        then WriteLn(s); // отображение итераций
        i:=0;
        repeat
          begin
            b:=StrToInt('$'+s[i+1]+s[i+2]);
            Write(w, b);
            if AnsiLowerCase(ParamStr(2)) = 'debug'
            then Write('..'); // отображение итераций
            i:=i+2;
          end;
        until(i = Length(s));
        if AnsiLowerCase(ParamStr(2)) = 'debug'
        then WriteLn; // отображение итераций
      end;
  end;

  CloseFile(w);
  CloseFile(f);

  WriteLn('Done!');
  Halt(0);
end.
 