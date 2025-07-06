program CompareEncryptedFiles;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes;

function FilesAreEqual(const File1, File2: string): Boolean;
var
  FS1, FS2: TFileStream;
  Buffer1, Buffer2: array[0..4095] of Byte;
  Read1, Read2: Integer;
begin
  Result := False;
  if not FileExists(File1) or not FileExists(File2) then Exit;

  FS1 := TFileStream.Create(File1, fmOpenRead or fmShareDenyWrite);
  try
    FS2 := TFileStream.Create(File2, fmOpenRead or fmShareDenyWrite);
    try
      if FS1.Size <> FS2.Size then Exit;
      while FS1.Position < FS1.Size do
      begin
        Read1 := FS1.Read(Buffer1, SizeOf(Buffer1));
        Read2 := FS2.Read(Buffer2, SizeOf(Buffer2));
        if (Read1 <> Read2) or (CompareMem(@Buffer1, @Buffer2, Read1) = False) then
          Exit;
      end;
      Result := True;
    finally
      FS2.Free;
    end;
  finally
    FS1.Free;
  end;
end;

var
  FileA, FileB: string;
begin
  Write('Введите путь к первому зашифрованному файлу: ');
  Readln(FileA);
  Write('Введите путь ко второму зашифрованному файлу: ');
  Readln(FileB);

  if FilesAreEqual(FileA, FileB) then
    Writeln('Содержимое файлов совпадает!')
  else
    Writeln('Содержимое файлов НЕ совпадает!');
  Readln;
end.
