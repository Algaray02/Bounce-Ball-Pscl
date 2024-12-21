program TugasAkhir;

uses
  crt, sysutils, math,MMSystem;

const
    LAYAR_LEBAR = 80;
    LAYAR_TINGGI = 20;
    MAKS_RINTANGAN = 3;

type
  TBola = record
    x, y, dx: integer;
    lompat: boolean;
    tinggi_lompat: integer;
  end;

var
  bola: TBola;
  totalskor: integer = 0;
  totalnyawa: string = 'O O O O O';
  akhirx: array[1..50] of integer; 
  akhiry: array[1..50] of integer;
  akhirx1: array[1..50] of integer; 
  akhiry1: array[1..50] of integer;
  akhirx2: array[1..50] of integer; 
  akhiry2: array[1..50] of integer;
  rinx: array[1..50] of integer; 
  riny: array[1..50] of integer;
  lup1: boolean = true;
  lup2: boolean = true;
  lup3: boolean = true;
  lup4: boolean = true;
  lup5: boolean = true;
  tr4, fl4: boolean;
  winnih: boolean;
  buatx: integer = 0;
  buaty: integer = 0;
  buatx1: integer = 0;
  buaty1: integer = 0;
  buatx2: integer = 0;
  buaty2: integer = 0;
  forx: integer = 0;
  fory: integer = 0;
  duri: boolean = false;
  nyowo: integer = 5;
  tojump: boolean = true;
  utkshift: integer = 2;
  tjmbt: integer  = 0;
  endingnyawa: integer = 0;
  i: integer;
  stage: integer;
  savescore: integer;
  highscore: integer;
  onput: string;
  

function Limit(val, minVal, maxVal: integer): integer;
begin
    if val < minVal then
        Limit := minVal
    else if val > maxVal then
        Limit := maxVal
    else
        Limit := val;
end;

function HanyaAngka(Input: string): boolean;
var
  i: integer;
begin
  HanyaAngka := True;
  for i := 1 to Length(Input) do
    if not (Input[i] in ['0'..'9']) then
    begin
      HanyaAngka := False;
      Exit;
    end;
end;

procedure skortinggi;
begin
  if highscore < totalskor then highscore := totalskor;
  Textcolor(white);
  gotoxy(3, LAYAR_TINGGI+3);
  write('High Score   : ', highscore);
end;

procedure autojump;
begin
  utkshift := utkshift + 1;
  if utkshift mod 2 = 0 then tojump := true
  else tojump := false;
end;

procedure bbola;
begin
    Textcolor(red);  // Player character color
    write('O');
    TextColor(white);  // Reset to default color
end;

procedure Lompat;
begin
  if not bola.lompat then
  begin
    bola.lompat := true;
    bola.tinggi_lompat := 5;  // Tinggi lompatan sesuai jarak atap
  end;
end;

procedure UpdateLompatan(batas: integer);
begin
  if bola.lompat then
  begin
    if bola.tinggi_lompat > 0 then
    begin
      bola.y -= 1;
      bola.tinggi_lompat -= 1;
    end
    else
    begin
      bola.y += 1;
      if bola.y >= batas then
      begin
          bola.y := batas;
          bola.lompat := false;
      end;
    end;
  end;
end;

procedure limitTmpt(prefx:integer; skrgx:integer; prefy:integer; skrgy:integer);
begin
    bola.x := Limit(bola.x, prefx, skrgx);  // Limit x value between 2 and 41
    bola.y := Limit(bola.y, prefy, skrgy);  // Limit y value between 2 and 17
end;

procedure Gerakan;
var
  prevX, prevY: integer; 
  control: char;
begin
  prevX := bola.x;
  prevY := bola.y;
  gotoxy(prevX, prevY);
  write(' ');  // Clear previous player position

  if KeyPressed then
  begin
    control := readkey;
    case control of
        'a': bola.x := bola.x - 1;
        'd': bola.x := bola.x + 1;
        ' ': Lompat;
        'w': autojump;
        #27: begin
              lup1 := false;
              lup2 := false;
              lup3 := false;
              lup4 := false;
              lup5 := false;
              winnih := true;
        end;
    end;
  end;
end;

procedure Bingkai;
begin
  TextColor(Yellow);
  for i := 1 to LAYAR_LEBAR do
  begin
    GotoXY(i, 1);  
    Write('_');
    GotoXY(i, LAYAR_TINGGI);  
    Write('_');
  end;
  for i := 2 to LAYAR_TINGGI do
  begin
    GotoXY(1, i);  
    Write('|');
    GotoXY(LAYAR_LEBAR, i);  
    Write('|');
  end;
end;

procedure score(x: boolean);
begin
  if x = true then totalskor := totalskor + 100;
  Textcolor(white);
  gotoxy(3, LAYAR_TINGGI+2);
  write('Skor         : ', totalskor);
end;

procedure hearth(x: integer);
begin
  if x = 4 then totalnyawa := 'O O O O   '
  else if x = 3 then totalnyawa := 'O O O  '
  else if x = 2 then totalnyawa := 'O O    '
  else if x = 1 then totalnyawa := 'O    '
  else if x = 0 then totalnyawa := '   ';
  Textcolor(white);
  gotoxy(3, LAYAR_TINGGI+1);
  write('Nyawa        : '); Textcolor(red); write(totalnyawa);
end;

procedure Level1;
var
  TextRunning: array[1..10000] of string;
  KataText: string = ' STAGE 1 ';
  k, j: integer;
begin

  TextColor(cyan);
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    if i+10 <= LAYAR_LEBAR-1 then
    begin
      GotoXY(i+10, 2);  
      Write('=');
      GotoXY(i+10, 3);  
      Write('=');
      GotoXY(i+10, 4);  
      Write('=');
    end;
    
    GotoXY(i, LAYAR_TINGGI-1);  
    Write('=');
    GotoXY(i, LAYAR_TINGGI-2);  
    Write('=');
    GotoXY(i, LAYAR_TINGGI-3);  
    Write('=');

    if i+(LAYAR_LEBAR-35) <= LAYAR_LEBAR-1 then
    begin
      GotoXY(i+(LAYAR_LEBAR-35), LAYAR_TINGGI-4);  
      Write('=');
      GotoXY(i+(LAYAR_LEBAR-35), LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(i+(LAYAR_LEBAR-35), LAYAR_TINGGI-6);  
      Write('=');
      GotoXY(i+(LAYAR_LEBAR-35), LAYAR_TINGGI-7);  
      Write('=');
      GotoXY(i+(LAYAR_LEBAR-35), LAYAR_TINGGI-8);  
      Write('=');
    end;

    if i = LAYAR_LEBAR-1 then
    begin
      Textcolor(blue);
      gotoxy(i, LAYAR_TINGGI-9);
      Write('=');
      gotoxy(i, LAYAR_TINGGI-10);
      Write('=');
      Textcolor(cyan);
    end;

    if i = LAYAR_LEBAR-2 then
    begin
      Textcolor(green);
      gotoxy(i, LAYAR_TINGGI-9);
      Write('$');
      gotoxy(i, LAYAR_TINGGI-10);
      Write('$');
      Textcolor(cyan);
    end;

    if i+(LAYAR_LEBAR-21) <= LAYAR_LEBAR-12 then
    begin
      Textcolor(green);
      GotoXY(i+(LAYAR_LEBAR-21), LAYAR_TINGGI-9);  
      Write('$');
      Textcolor(cyan);
    end;

    if i = LAYAR_LEBAR-35 then
    begin
      Textcolor(green);
      GotoXY(i, LAYAR_TINGGI-9);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-8);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('$');
      GotoXY(i+1, LAYAR_TINGGI-9);  
      Write('$');
      Textcolor(cyan);
    end;
  end;

  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];

  for i := 2 to LAYAR_LEBAR+Length(KataText) do
  begin

    if i < LAYAR_TINGGI-4 then
    begin
      Textcolor(red);
      gotoxy(5, i+1);
      write('O');
      gotoxy(5, i);
      write(' ');
      Textcolor(white);
    end;

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText) do 
    begin
      if (i-k >= 2) and (i-k < LAYAR_LEBAR) then
      begin
        gotoxy(i-k, 5);
        write(TextRunning[j]);
      end;
      k := k + 1;
    end;
    delay(25); 
  end; 
end;

procedure Level2;
var
  TextRunning: array[1..10000] of string;
  KataText: string = ' STAGE 2 ';
  k, j: integer;
begin

  TextColor(cyan);
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    
    GotoXY(i, 2);  
    Write('=');
    GotoXY(i, 3);  
    Write('=');
    GotoXY(i, 4);  
    Write('=');
    
    if i <= LAYAR_LEBAR-60 then
    begin   
      GotoXY(i, LAYAR_TINGGI-1);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-8);  
      Write('=');
    end
    else if (i > LAYAR_LEBAR-55) and (i <= LAYAR_LEBAR-35) then
    begin   
      GotoXY(i, LAYAR_TINGGI-1);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('='); 
    end
    else if (i > LAYAR_LEBAR-30) and (i <= LAYAR_LEBAR-10) then
    begin   
      GotoXY(i, LAYAR_TINGGI-1);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('=');
    end
    else if (i >= LAYAR_LEBAR-6) and (i <= LAYAR_LEBAR-5) then
    begin   
      Textcolor(green);
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('$');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('$');
      Textcolor(cyan);
    end;
    if (i >= LAYAR_LEBAR-46) and (i <= LAYAR_LEBAR-43) then
    begin
      Textcolor(green);
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('$');
      Textcolor(cyan);
    end;
    if (i >= LAYAR_LEBAR-21) and (i <= LAYAR_LEBAR-18) then
    begin
      Textcolor(green);
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('$');
      Textcolor(cyan);
    end;
    if (i > LAYAR_LEBAR-10) and (i < LAYAR_LEBAR) then
    begin
      Textcolor(blue);
      gotoxy(i, LAYAR_TINGGI-1);
      write('=');
      Textcolor(cyan);
    end;
  end;

  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];

  for i := 2 to LAYAR_LEBAR+Length(KataText) do
  begin

    if i < 11 then
    begin
      Textcolor(red);
      gotoxy(i,LAYAR_TINGGI-9);
      write('O');
      if i >= 3 then
      begin
        gotoxy(i-1, LAYAR_TINGGI-9);
        write(' ');
        Textcolor(white);
      end;
    end;

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText) do 
    begin
      if (i-k >= 2) and (i-k < LAYAR_LEBAR) then
      begin
        gotoxy(i-k, 5);
        write(TextRunning[j]);
      end;
      k := k + 1;
    end;
    delay(25); 
  end; 
end;

procedure Level3;
var
  TextRunning: array[1..10000] of string;
  TextRunning1: array[1..10000] of string;
  KataText: string = '    STAGE 3    ';
  KataText1: string = ' <Go To Here!!> ';
  k, j: integer;
begin

  TextColor(cyan);
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    if i+10 <= LAYAR_LEBAR-15 then
    begin
      GotoXY(i+10, 2);  
      Write('=');
      GotoXY(i+10, 3);  
      Write('=');
      GotoXY(i+10, 4);  
      Write('=');
      GotoXY(i+10, 5);  
      Write('=');
      GotoXY(i+10, 6);  
      Write('=');
      GotoXY(i+10, 7);  
      Write('=');
      GotoXY(i+10, 8);  
      Write('=');
      GotoXY(i+10, 9);  
      Write('=');
      GotoXY(i+10, 10);  
      Write('=');
      GotoXY(i+10, 11);  
      Write('=');
    end;
    
    if (i >= LAYAR_LEBAR-5) and (i <= LAYAR_LEBAR-1) then
    begin
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-13);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-14) and (i <= LAYAR_LEBAR-10) then
    begin
      GotoXY(i, LAYAR_TINGGI-10);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-16);  
      Write('=');
    end; 

    GotoXY(i, LAYAR_TINGGI-1);  
    Write('=');
    GotoXY(i, LAYAR_TINGGI-2);  
    Write('=');
    GotoXY(i, LAYAR_TINGGI-3);  
    Write('=');

    if (i >= 18) and (i <= 21) then
    begin
      GotoXY(i, LAYAR_TINGGI-1);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write(' ');
    end; 

    if (i >= 38) and (i <= 41) then
    begin
      GotoXY(i, LAYAR_TINGGI-1);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write(' ');
    end; 

    if (i >= LAYAR_LEBAR-25) and (i <= LAYAR_LEBAR-22) then
    begin
      GotoXY(i, LAYAR_TINGGI-1);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write(' ');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write(' ');
    end; 

    Textcolor(green);
    GotoXY(22, LAYAR_TINGGI-4);  
    Write('$');
    GotoXY(37, LAYAR_TINGGI-4);  
    Write('$');
    GotoXY(48, LAYAR_TINGGI-4);  
    Write('$');
    GotoXY(49, LAYAR_TINGGI-4);  
    Write('$');
    GotoXY(LAYAR_LEBAR-3, LAYAR_TINGGI-8);  
    Write('$');
    GotoXY(LAYAR_LEBAR-3, LAYAR_TINGGI-14);  
    Write('$');
    GotoXY(LAYAR_LEBAR-12, LAYAR_TINGGI-11);  
    Write('$');
    Textcolor(cyan);

    Textcolor(white);
    GotoXY(LAYAR_LEBAR-57, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-53, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-50, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-49, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-46, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-45, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-36, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-35, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-28, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-21, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-20, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-19, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-18, LAYAR_TINGGI-8);
    Write('X');
    GotoXY(LAYAR_LEBAR-14, LAYAR_TINGGI-9);
    Write('X');
    GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-9);
    Write('X');
    GotoXY(LAYAR_LEBAR-12, LAYAR_TINGGI-9);
    Write('X');
    GotoXY(LAYAR_LEBAR-1, LAYAR_TINGGI-8);  
    Write('X');
    GotoXY(LAYAR_LEBAR-1, LAYAR_TINGGI-14);  
    Write('X');
    GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-14, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-3, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-2, LAYAR_TINGGI-4);
    Write('X');
    GotoXY(LAYAR_LEBAR-1, LAYAR_TINGGI-4);
    Write('X');
    Textcolor(cyan);
  end;

  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];
  for i := 1 to Length(KataText1) do
  TextRunning1[i] := KataText1[Length(KataText1)+1-i];

  for i := 2 to LAYAR_LEBAR+Length(KataText) do
  begin

    if i < LAYAR_TINGGI-4 then
    begin
      Textcolor(red);
      gotoxy(5, i+1);
      write('O');
      gotoxy(5, i);
      write(' ');
      Textcolor(white);
    end;

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText1) do 
    begin
      if (i-k >= 2) and (i-k < LAYAR_LEBAR) then
      begin
        gotoxy(i-k, 2);
        write(TextRunning[j]);
        gotoxy(i-k, 3);
        write(TextRunning1[j]);
      end;
      k := k + 1;
    end;
    delay(25); 
  end; 
    Textcolor(green);
    GotoXY(LAYAR_LEBAR-12, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-26, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-36, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-46, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-56, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-17);  
    Write('$');
    Textcolor(white);
    GotoXY(LAYAR_LEBAR-31, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-41, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-51, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-61, LAYAR_TINGGI-17);  
    Write('X');
    Textcolor(green);
    GotoXY(4, 9);  
    Write('$');
    GotoXY(5, 9);  
    Write('$');
    Textcolor(blue);
    GotoXY(4, 10);  
    Write('=');
    GotoXY(5, 10);  
    Write('=');
end;

procedure Level4;
var
  TextRunning: array[1..10000] of string;
  TextRunning1: array[1..10000] of string;
  KataText: string = '    STAGE 4      ';
  KataText1: string = ' <Choose One Way!!> ';
  k, j: integer;
begin

  TextColor(cyan);
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    if (i >= LAYAR_LEBAR-51) and (i <= LAYAR_LEBAR-49) then
    begin
      GotoXY(i, 6);  
      Write('=');
      GotoXY(i, 7);  
      Write('=');
      GotoXY(i, 8);  
      Write('=');
      GotoXY(i, 9);  
      Write('=');
      GotoXY(i, 10);  
      Write('=');
      GotoXY(i, 11);  
      Write('=');
      GotoXY(i, 12);  
      Write('=');
      GotoXY(i, 13);  
      Write('=');
      GotoXY(i, 14);  
      Write('=');
      GotoXY(i, 15);  
      Write('=');
      GotoXY(i, 16);  
      Write('=');
      GotoXY(i, 17);  
      Write('=');
      GotoXY(i, 18);  
      Write('=');
      GotoXY(i, 19);  
      Write('=');
      Textcolor(blue);
      GotoXY(i, 5);  
      Write('=');
      Textcolor(cyan);
    end;
    
    if (i >= LAYAR_LEBAR-52) and (i <= LAYAR_LEBAR-48) then
    begin
      Textcolor(cyan);
      GotoXY(i, 2);
      Write('=');
      Textcolor(white);
      GotoXY(LAYAR_LEBAR-52, 3);
      Write('X');
      GotoXY(LAYAR_LEBAR-52, 4);
      Write('X');
      Textcolor(blue);
      GotoXY(LAYAR_LEBAR-48, 5);
      Write('=');
      GotoXY(LAYAR_LEBAR-52, 5);
      Write('=');
      Textcolor(white);
      GotoXY(LAYAR_LEBAR-48, 3);
      Write('X');
      GotoXY(LAYAR_LEBAR-48, 4);
      Write('X');
      Textcolor(cyan);
    end;

    if (i >= LAYAR_LEBAR-47) and (i <= LAYAR_LEBAR-1) then
    begin
      GotoXY(i, LAYAR_TINGGI-18);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-48) and (i <= LAYAR_LEBAR-9) then
    begin
      GotoXY(i, LAYAR_TINGGI-14);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-40) and (i <= LAYAR_LEBAR-1) then
    begin
      GotoXY(i, LAYAR_TINGGI-10);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-79) and (i <= LAYAR_LEBAR-53) then
    begin
      GotoXY(i, LAYAR_TINGGI-18);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-79) and (i <= LAYAR_LEBAR-56) then
    begin
      GotoXY(i, LAYAR_TINGGI-10);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-8);  
      Write('=');
      GotoXY(LAYAR_LEBAR-56, LAYAR_TINGGI-9);  
      Write('=');
    end; 

    if (i >= LAYAR_LEBAR-75) and (i <= LAYAR_LEBAR-53) then
    begin
      GotoXY(i, LAYAR_TINGGI-15);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-13);  
      Write('=');
      GotoXY(LAYAR_LEBAR-52, LAYAR_TINGGI-13);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(LAYAR_LEBAR-52, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(LAYAR_LEBAR-75, LAYAR_TINGGI-14);  
      Write('=');
      Textcolor(blue);
      GotoXY(LAYAR_LEBAR-67, LAYAR_TINGGI-13);  
      Write('=');
      GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-13);  
      Write('=');
      GotoXY(LAYAR_LEBAR-65, LAYAR_TINGGI-13);  
      Write('=');
      GotoXY(LAYAR_LEBAR-67, LAYAR_TINGGI-8);  
      Write('=');
      GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-8);  
      Write('=');
      GotoXY(LAYAR_LEBAR-65, LAYAR_TINGGI-8);  
      Write('=');
      Textcolor(cyan);
    end; 

    Textcolor(white);
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-16);  
    Write('X');
    GotoXY(LAYAR_LEBAR-59, LAYAR_TINGGI-16);  
    Write('X');
    GotoXY(LAYAR_LEBAR-62, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-16);  
    Write('X');
    GotoXY(LAYAR_LEBAR-73, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-74, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-77, LAYAR_TINGGI-12);  
    Write('X');
    GotoXY(LAYAR_LEBAR-77, LAYAR_TINGGI-11);  
    Write('X');
    if (i >= LAYAR_LEBAR-74) and (i <= LAYAR_LEBAR-53) then
    begin
      GotoXY(i, LAYAR_TINGGI-14);  
      Write('X');
    end;
    if (i >= LAYAR_LEBAR-79) and (i <= LAYAR_LEBAR-57) then
    begin
      GotoXY(i, LAYAR_TINGGI-9);  
      Write('X');
    end;
    GotoXY(LAYAR_LEBAR-71, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-70, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-62, LAYAR_TINGGI-12);  
    Write('X');
    GotoXY(LAYAR_LEBAR-61, LAYAR_TINGGI-12);  
    Write('X');
    GotoXY(LAYAR_LEBAR-57, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-56, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-54, LAYAR_TINGGI-7);  
    Write('X');
    GotoXY(LAYAR_LEBAR-54, LAYAR_TINGGI-6);  
    Write('X');
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-7);  
    Write('X');
    GotoXY(LAYAR_LEBAR-63, LAYAR_TINGGI-6);  
    Write('X');
    GotoXY(LAYAR_LEBAR-71, LAYAR_TINGGI-7);  
    Write('X');
    GotoXY(LAYAR_LEBAR-75, LAYAR_TINGGI-6);  
    Write('X');
    Textcolor(green);
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-59, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-78, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-78, LAYAR_TINGGI-14);
    Write('$');
    GotoXY(LAYAR_LEBAR-72, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-55, LAYAR_TINGGI-9);
    Write('$');
    GotoXY(LAYAR_LEBAR-55, LAYAR_TINGGI-8);
    Write('$');
    Textcolor(cyan);


    Textcolor(green);
    GotoXY(LAYAR_LEBAR-38, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-38, LAYAR_TINGGI-16);
    Write('$');
    GotoXY(LAYAR_LEBAR-34, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-34, LAYAR_TINGGI-16);
    Write('$');
    GotoXY(LAYAR_LEBAR-28, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-24, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-23, LAYAR_TINGGI-17);
    Write('$');
    GotoXY(LAYAR_LEBAR-16, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-16, LAYAR_TINGGI-16);
    Write('$');
    GotoXY(LAYAR_LEBAR-10, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-9, LAYAR_TINGGI-15);
    Write('$');
    GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-7, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-14, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-31, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-32, LAYAR_TINGGI-11);
    Write('$');
    GotoXY(LAYAR_LEBAR-35, LAYAR_TINGGI-13);
    Write('$');
    GotoXY(LAYAR_LEBAR-40, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-43, LAYAR_TINGGI-13);  
    Write('$');
    GotoXY(LAYAR_LEBAR-35, LAYAR_TINGGI-7);
    Write('$');
    GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-7);
    Write('$');
    GotoXY(LAYAR_LEBAR-21, LAYAR_TINGGI-9);
    Write('$');
    GotoXY(LAYAR_LEBAR-18, LAYAR_TINGGI-7);
    Write('$');
    GotoXY(LAYAR_LEBAR-12, LAYAR_TINGGI-7);
    Write('$');
    Textcolor(white);
    GotoXY(LAYAR_LEBAR-36, LAYAR_TINGGI-16);  
    Write('X');
    GotoXY(LAYAR_LEBAR-31, LAYAR_TINGGI-15);  
    Write('X');
    GotoXY(LAYAR_LEBAR-30, LAYAR_TINGGI-15);  
    Write('X');
    GotoXY(LAYAR_LEBAR-17, LAYAR_TINGGI-17);  
    Write('X');
    GotoXY(LAYAR_LEBAR-17, LAYAR_TINGGI-16);  
    Write('X');
    GotoXY(LAYAR_LEBAR-21, LAYAR_TINGGI-11);  
    Write('X');
    GotoXY(LAYAR_LEBAR-25, LAYAR_TINGGI-12);  
    Write('X');
    GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-13);  
    Write('X');
    GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-7);  
    Write('X');
    GotoXY(LAYAR_LEBAR-26, LAYAR_TINGGI-7);  
    Write('X');
    Textcolor(cyan);
  end;

  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];
  for i := 1 to Length(KataText1) do
  TextRunning1[i] := KataText1[Length(KataText1)+1-i];

  for i := 2 to LAYAR_LEBAR+Length(KataText1) do
  begin

    
    Textcolor(red);
    gotoxy(LAYAR_LEBAR-50, 4);
    write('O');
    

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText1) do 
    begin
      if (i-k >= 2) and (i-k < LAYAR_LEBAR) then
      begin
        gotoxy(i-k, 18);
        write(TextRunning[j]);
        gotoxy(i-k, 19);
        write(TextRunning1[j]);
      end;
      k := k + 1;
    end;
    delay(25); 
  end; 

  for i := 5 to 70 do
  begin
    Textcolor(cyan);
    GotoXY(LAYAR_LEBAR-51, 18);  
    Write('=');
    GotoXY(LAYAR_LEBAR-50, 18);  
    Write('=');
    GotoXY(LAYAR_LEBAR-49, 18);  
    Write('=');
    GotoXY(i, 19);  
    Write('=');
  end;
  Textcolor(green);
  GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-2);  
  Write('$');
  GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-3);  
  Write('$');
  GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-5);  
  Write('$');
  GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-2);  
  Write('$');
  GotoXY(LAYAR_LEBAR-45, LAYAR_TINGGI-5);  
  Write('$');
  GotoXY(LAYAR_LEBAR-46, LAYAR_TINGGI-5);  
  Write('$');
  Textcolor(white);
  GotoXY(LAYAR_LEBAR-70, LAYAR_TINGGI-4);  
  Write('X');
  GotoXY(LAYAR_LEBAR-60, LAYAR_TINGGI-4);  
  Write('X');
  GotoXY(LAYAR_LEBAR-55, LAYAR_TINGGI-2);  
  Write('X');
  GotoXY(LAYAR_LEBAR-65, LAYAR_TINGGI-2);  
  Write('X');
  GotoXY(1, 30);
  Textcolor(blue);
  GotoXY(LAYAR_LEBAR-52, LAYAR_TINGGI-4);  
  Write('=');
  GotoXY(LAYAR_LEBAR-52, LAYAR_TINGGI-3);  
  Write('=');
  GotoXY(LAYAR_LEBAR-52, LAYAR_TINGGI-2);  
  Write('=');
  GotoXY(LAYAR_LEBAR-48, LAYAR_TINGGI-5);  
  Write('=');
  GotoXY(LAYAR_LEBAR-48, LAYAR_TINGGI-4);  
  Write('=');
  GotoXY(LAYAR_LEBAR-48, LAYAR_TINGGI-3);  
  Write('=');
  GotoXY(LAYAR_LEBAR-48, LAYAR_TINGGI-2);  
  Write('=');
end;

procedure level4_true;
var
  TextRunning: array[1..10000] of string;
  KataText: string = ' GOOD CHOICE!! ';
  k, j: integer;
begin
  tr4 := true;
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    Textcolor(green);
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-16);  
    Write('$');
    GotoXY(LAYAR_LEBAR-59, LAYAR_TINGGI-16);  
    Write('$');
    GotoXY(LAYAR_LEBAR-62, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-16);  
    Write('$');
    GotoXY(LAYAR_LEBAR-73, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-74, LAYAR_TINGGI-17);  
    Write('$');
    GotoXY(LAYAR_LEBAR-77, LAYAR_TINGGI-12);  
    Write('$');
    GotoXY(LAYAR_LEBAR-77, LAYAR_TINGGI-11);  
    Write('$');
    if (i >= LAYAR_LEBAR-74) and (i <= LAYAR_LEBAR-53) then
    begin
      GotoXY(i, LAYAR_TINGGI-14);  
      Write('$');
    end;
    if (i >= LAYAR_LEBAR-79) and (i <= LAYAR_LEBAR-57) then
    begin
      GotoXY(i, LAYAR_TINGGI-9);  
      Write('$');
    end;
    GotoXY(LAYAR_LEBAR-71, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-70, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-62, LAYAR_TINGGI-12);  
    Write('$');
    GotoXY(LAYAR_LEBAR-61, LAYAR_TINGGI-12);  
    Write('$');
    GotoXY(LAYAR_LEBAR-57, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-56, LAYAR_TINGGI-11);  
    Write('$');
    GotoXY(LAYAR_LEBAR-54, LAYAR_TINGGI-7);  
    Write('$');
    GotoXY(LAYAR_LEBAR-54, LAYAR_TINGGI-6);  
    Write('$');
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-7);  
    Write('$');
    GotoXY(LAYAR_LEBAR-63, LAYAR_TINGGI-6);  
    Write('$');
    GotoXY(LAYAR_LEBAR-71, LAYAR_TINGGI-7);  
    Write('$');
    GotoXY(LAYAR_LEBAR-75, LAYAR_TINGGI-6);  
    Write('$');
    Textcolor(white);
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-17);
    Write('X');
    GotoXY(LAYAR_LEBAR-59, LAYAR_TINGGI-17);
    Write('X');
    GotoXY(LAYAR_LEBAR-66, LAYAR_TINGGI-17);
    Write('X');
    GotoXY(LAYAR_LEBAR-78, LAYAR_TINGGI-15);
    Write('X');
    GotoXY(LAYAR_LEBAR-78, LAYAR_TINGGI-14);
    Write('X');
    GotoXY(LAYAR_LEBAR-72, LAYAR_TINGGI-11);
    Write('X');
    GotoXY(LAYAR_LEBAR-58, LAYAR_TINGGI-11);
    Write('X');
    GotoXY(LAYAR_LEBAR-55, LAYAR_TINGGI-9);
    Write('X');
    GotoXY(LAYAR_LEBAR-55, LAYAR_TINGGI-8);
    Write('X');
    Textcolor(cyan);
    GotoXY(LAYAR_LEBAR-48, 3);
    Write('=');
    GotoXY(LAYAR_LEBAR-48, 4);
    Write('=');
  end;
  
  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];

  for i := 1 to LAYAR_TINGGI+Length(KataText) do
  begin

    Textcolor(red);
    gotoxy(LAYAR_LEBAR-50, 4);
    write('O');

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText) do 
    begin
      if (i-k >= 1) and (i-k < LAYAR_TINGGI) then
      begin
        gotoxy(LAYAR_LEBAR+1, i-k);
        write(TextRunning[j]);
      end;
      k := k + 1;
    end;
    delay(100);
  end; 

end;

procedure level4_false;
var
  TextRunning: array[1..10000] of string;
  KataText: string = ' BAD CHOICE XD! ';
  k, j: integer;
begin
  fl4 := true;
  Textcolor(white);
  GotoXY(LAYAR_LEBAR-38, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-38, LAYAR_TINGGI-16);
  Write('X');
  GotoXY(LAYAR_LEBAR-34, LAYAR_TINGGI-17);
  Write('X');
  GotoXY(LAYAR_LEBAR-34, LAYAR_TINGGI-16);
  Write('X');
  GotoXY(LAYAR_LEBAR-28, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-24, LAYAR_TINGGI-17);
  Write('X');
  GotoXY(LAYAR_LEBAR-23, LAYAR_TINGGI-17);
  Write('X');
  GotoXY(LAYAR_LEBAR-16, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-16, LAYAR_TINGGI-16);
  Write('X');
  GotoXY(LAYAR_LEBAR-10, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-9, LAYAR_TINGGI-15);
  Write('X');
  GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-11);
  Write('X');
  GotoXY(LAYAR_LEBAR-7, LAYAR_TINGGI-11);
  Write('X');
  GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-11);  
  Write('X');
  GotoXY(LAYAR_LEBAR-14, LAYAR_TINGGI-11);  
  Write('X');
  GotoXY(LAYAR_LEBAR-31, LAYAR_TINGGI-11);
  Write('X');
  GotoXY(LAYAR_LEBAR-32, LAYAR_TINGGI-11);
  Write('X');
  GotoXY(LAYAR_LEBAR-35, LAYAR_TINGGI-13);
  Write('X');
  GotoXY(LAYAR_LEBAR-40, LAYAR_TINGGI-11);  
  Write('X');
  GotoXY(LAYAR_LEBAR-43, LAYAR_TINGGI-13);  
  Write('X');
  GotoXY(LAYAR_LEBAR-35, LAYAR_TINGGI-7);
  Write('X');
  GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-7);
  Write('X');
  GotoXY(LAYAR_LEBAR-21, LAYAR_TINGGI-9);
  Write('X');
  GotoXY(LAYAR_LEBAR-18, LAYAR_TINGGI-7);
  Write('X');
  GotoXY(LAYAR_LEBAR-12, LAYAR_TINGGI-7);
  Write('X');
  Textcolor(green);
  GotoXY(LAYAR_LEBAR-36, LAYAR_TINGGI-16);  
  Write('$');
  GotoXY(LAYAR_LEBAR-31, LAYAR_TINGGI-15);  
  Write('$');
  GotoXY(LAYAR_LEBAR-30, LAYAR_TINGGI-15);  
  Write('$');
  GotoXY(LAYAR_LEBAR-17, LAYAR_TINGGI-17);  
  Write('$');
  GotoXY(LAYAR_LEBAR-17, LAYAR_TINGGI-16);  
  Write('$');
  GotoXY(LAYAR_LEBAR-21, LAYAR_TINGGI-11);  
  Write('$');
  GotoXY(LAYAR_LEBAR-25, LAYAR_TINGGI-12);  
  Write('$');
  GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-13);  
  Write('$');
  GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-7);  
  Write('$');
  GotoXY(LAYAR_LEBAR-26, LAYAR_TINGGI-7);  
  Write('$');
  Textcolor(white);
  GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-2);  
  Write('X');
  GotoXY(LAYAR_LEBAR-13, LAYAR_TINGGI-3);  
  Write('X');
  GotoXY(LAYAR_LEBAR-27, LAYAR_TINGGI-5);  
  Write('X');
  GotoXY(LAYAR_LEBAR-29, LAYAR_TINGGI-2);  
  Write('X');
  GotoXY(LAYAR_LEBAR-45, LAYAR_TINGGI-5);  
  Write('X');
  GotoXY(LAYAR_LEBAR-46, LAYAR_TINGGI-5);  
  Write('X');
  Textcolor(white);
  Textcolor(cyan);
  GotoXY(LAYAR_LEBAR-52, 3);
  Write('=');
  GotoXY(LAYAR_LEBAR-52, 4);
  Write('=');
  
  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];

  for i := 1 to LAYAR_TINGGI+Length(KataText) do
  begin

    Textcolor(red);
    gotoxy(LAYAR_LEBAR-50, 4);
    write('O');

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText) do 
    begin
      if (i-k >= 1) and (i-k < LAYAR_TINGGI) then
      begin
        gotoxy(LAYAR_LEBAR+1, i-k);
        write(TextRunning[j]);
      end;
      k := k + 1;
    end;
    delay(100);
  end; 
end;

procedure Level5;
var
  TextRunning: array[1..10000] of string;
  KataText: string = ' STAGE 5 <LAST STAGE> ';
  k, j: integer;
begin

  TextColor(cyan);
  for i := 2 to LAYAR_LEBAR-1 do
  begin
    if i <= LAYAR_LEBAR-1 then
    begin
      GotoXY(i, 2);  
      Write('=');
      GotoXY(i, 3);  
      Write('=');
      GotoXY(i, 4);  
      Write('=');
    end;
    
    if i <= LAYAR_LEBAR-62 then
    begin
      GotoXY(i, LAYAR_TINGGI-1);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-8);  
      Write('=');
    end;

    if (i >= LAYAR_LEBAR-11) and (i <= LAYAR_LEBAR-1) then
    begin
      GotoXY(i, LAYAR_TINGGI-1);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-2);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-3);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-4);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-5);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-6);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-7);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-8);  
      Write('=');
    end;

    Textcolor(yellow);
    GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-9);  
    Write('=');
    GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-10);  
    Write('=');
    GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-11);  
    Write('=');
    GotoXY(LAYAR_LEBAR-8, LAYAR_TINGGI-12);  
    Write('=');
    GotoXY(LAYAR_LEBAR-4, LAYAR_TINGGI-9);  
    Write('=');
    GotoXY(LAYAR_LEBAR-4, LAYAR_TINGGI-10);  
    Write('=');
    GotoXY(LAYAR_LEBAR-4, LAYAR_TINGGI-11);  
    Write('=');
    GotoXY(LAYAR_LEBAR-4, LAYAR_TINGGI-12);  
    Write('=');
    GotoXY(LAYAR_LEBAR-7, LAYAR_TINGGI-13);  
    Write('=');
    GotoXY(LAYAR_LEBAR-5, LAYAR_TINGGI-13);  
    Write('=');
    GotoXY(LAYAR_LEBAR-6, LAYAR_TINGGI-14);  
    Write('=');
    Textcolor(cyan);

    if (i >= LAYAR_LEBAR-7) and (i <= LAYAR_LEBAR-5) then
    begin
      Textcolor(blue);
      GotoXY(i, LAYAR_TINGGI-9);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-10);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-11);  
      Write('=');
      GotoXY(i, LAYAR_TINGGI-12);  
      Write('=');
      Textcolor(cyan);
    end;

    Textcolor(blue);
    GotoXY(LAYAR_LEBAR-6, LAYAR_TINGGI-13);  
    Write('=');
    Textcolor(cyan);
  end;

  for i := 1 to Length(KataText) do
  TextRunning[i] := KataText[Length(KataText)+1-i];

  for i := 2 to LAYAR_LEBAR+Length(KataText) do
  begin

    if i < 11 then
    begin
      Textcolor(red);
      gotoxy(i,LAYAR_TINGGI-9);
      write('O');
      if i >= 3 then
      begin
        gotoxy(i-1, LAYAR_TINGGI-9);
        write(' ');
        Textcolor(white);
      end;
    end;

    k := 0;
    Textcolor(magenta);
    for j := 1 to Length(KataText) do 
    begin
      if (i-k >= 2) and (i-k < LAYAR_LEBAR) then
      begin
        gotoxy(i-k, 5);
        write(TextRunning[j]);
      end;
      k := k + 1;
    end;
    delay(25); 
  end; 

  repeat
    if totalskor < 200 then totalskor := 0
    else
    begin
      totalskor := totalskor - 200;
      tjmbt := tjmbt + 1;
    end;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Skor : ', totalskor);
    gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-13);
    write('PANJANG JEMBATAN : ', tjmbt);

    Textcolor(blue);
    GotoXY(LAYAR_LEBAR-62+tjmbt, LAYAR_TINGGI-6);  
    Write('=');
    GotoXY(LAYAR_LEBAR-62+tjmbt, LAYAR_TINGGI-7);  
    Write('=');
    GotoXY(LAYAR_LEBAR-62+tjmbt, LAYAR_TINGGI-8);  
    Write('=');
    Textcolor(white);

    if (totalskor < 10000) and (totalskor >= 1000) then
    begin
      gotoxy(14, LAYAR_TINGGI+1);
      write(' ');
    end
    else if (totalskor < 1000) and (totalskor >= 100) then
    begin
      gotoxy(13, LAYAR_TINGGI+1);
      write(' ');
    end
    else if (totalskor < 100) and (totalskor >= 10) then
    begin
      gotoxy(12, LAYAR_TINGGI+1);
      write(' ');
    end
    else if totalskor < 10 then
    begin
      gotoxy(11, LAYAR_TINGGI+1);
      write('    ');
    end;
    delay(50);
  until (totalskor = 0) or (tjmbt = 50);

  if tjmbt = 50 then
  begin
    gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-12);
    Textcolor(green);
    write('SELAMAT KAMU MENANG!!!');
    Textcolor(white);
  end
  else
  begin
    Textcolor(yellow);
    gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-12);
    write('MAAF PANJANG JEMBATAN KURANG');
    Textcolor(red);
    gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-11);
    write('KORBANKAN 2 NYAWA ATAU COBA LONCAT');
    Textcolor(white);
  end;

end;


procedure skour(lbr,tgg:integer);
var
  skkk: boolean;
  h, j: integer;
  tbhx: integer = 1;
  tbhy: integer = 1;
begin
  for h := 1 to 50 do
  begin
    if lbr = akhirx[h] then 
    begin
      tbhx := 0;
      break;
    end
    else if lbr <> akhirx[h] then 
    begin
      tbhx := 1;
    end;
  end;

  for j := 1 to 50 do
  begin
    if tgg = akhiry[j] then 
    begin
      tbhy := 0;
      break;
    end
    else if tgg <> akhiry[j] then 
    begin
      tbhy := 1;
    end;
  end;

  if (tbhx = 1) and (tbhy = 0) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx);
      skkk := true;
      score(skkk);
      akhirx[buatx] := lbr;
    end;
  end
  else if (tbhx = 0) and (tbhy = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buaty);
      skkk := true;
      score(skkk);
      akhiry[buaty] := tgg;
    end;
  end
  else if (tbhy = 1) and (tbhx = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx);
      Inc(buaty);
      skkk := true;
      score(skkk);
      akhirx[buatx] := lbr;
      akhiry[buaty] := tgg;
    end;
  end;
end;

procedure skour1(lbr,tgg:integer);
var
  skkk: boolean;
  h, j: integer;
  tbhx: integer = 1;
  tbhy: integer = 1;
begin
  for h := 1 to 50 do
  begin
    if lbr = akhirx1[h] then 
    begin
      tbhx := 0;
      break;
    end
    else if lbr <> akhirx1[h] then 
    begin
      tbhx := 1;
    end;
  end;

  for j := 1 to 50 do
  begin
    if tgg = akhiry1[j] then 
    begin
      tbhy := 0;
      break;
    end
    else if tgg <> akhiry1[j] then 
    begin
      tbhy := 1;
    end;
  end;

  if (tbhx = 1) and (tbhy = 0) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx1);
      skkk := true;
      score(skkk);
      akhirx1[buatx1] := lbr;
    end;
  end
  else if (tbhx = 0) and (tbhy = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buaty1);
      skkk := true;
      score(skkk);
      akhiry1[buaty1] := tgg;
    end;
  end
  else if (tbhy = 1) and (tbhx = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx1);
      Inc(buaty1);
      skkk := true;
      score(skkk);
      akhirx1[buatx1] := lbr;
      akhiry1[buaty1] := tgg;
    end;
  end;
end;

procedure skour2(lbr,tgg:integer);
var
  skkk: boolean;
  h, j: integer;
  tbhx: integer = 1;
  tbhy: integer = 1;
begin
  for h := 1 to 50 do
  begin
    if lbr = akhirx2[h] then 
    begin
      tbhx := 0;
      break;
    end
    else if lbr <> akhirx2[h] then 
    begin
      tbhx := 1;
    end;
  end;

  for j := 1 to 50 do
  begin
    if tgg = akhiry2[j] then 
    begin
      tbhy := 0;
      break;
    end
    else if tgg <> akhiry2[j] then 
    begin
      tbhy := 1;
    end;
  end;

  if (tbhx = 1) and (tbhy = 0) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx2);
      skkk := true;
      score(skkk);
      akhirx2[buatx2] := lbr;
    end;
  end
  else if (tbhx = 0) and (tbhy = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buaty2);
      skkk := true;
      score(skkk);
      akhiry2[buaty2] := tgg;
    end;
  end
  else if (tbhy = 1) and (tbhx = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(buatx2);
      Inc(buaty2);
      skkk := true;
      score(skkk);
      akhirx2[buatx2] := lbr;
      akhiry2[buaty2] := tgg;
    end;
  end;
end;

procedure rintangan(lbr,tgg:integer);
var
  h, j: integer;
  tbhx: integer = 1;
  tbhy: integer = 1;
begin
  for h := 1 to 100 do
  begin
    if lbr = rinx[h] then 
    begin
      tbhx := 0;
      break;
    end
    else if lbr <> rinx[h] then 
    begin
      tbhx := 1;
    end;
  end;

  for j := 1 to 100 do
  begin
    if tgg = riny[j] then 
    begin
      tbhy := 0;
      break;
    end
    else if tgg <> riny[j] then 
    begin
      tbhy := 1;
    end;
  end;

  if (tbhx = 1) and (tbhy = 0) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(forx);
      duri := true;
      rinx[forx] := lbr;
    end;
  end
  else if (tbhx = 0) and (tbhy = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(fory);
      duri := true;
      riny[fory] := tgg;
    end;
  end
  else if (tbhy = 1) and (tbhx = 1) then
  begin
    if (bola.x = LAYAR_LEBAR-lbr) and (bola.y = LAYAR_TINGGI-tgg) then
    begin
      Inc(forx);
      Inc(fory);
      duri := true;
      rinx[forx] := lbr;
      riny[fory] := tgg;
    end;
  end;
end;
  




procedure render;
var
  i, awalX, awalY, batasX, batasY, prX, prY, bxy: integer;
begin

  lup1 := true;
  lup2 := true;
  lup3 := true;
  lup4 := true;
  lup5 := true;
  tr4 := false;
  fl4 := false;
  totalskor := 0;
  nyowo := 5;
  winnih := false;
  utkshift := 2;
  tojump := true;
  totalnyawa := 'O O O O O';
  gotoxy(3, LAYAR_TINGGI+1);
  write('Nyawa        : '); Textcolor(red); write(totalnyawa);
  skortinggi;

  if (lup1 = true) and (nyowo <> 0) then
  begin
    stage := 1;
    bola.x := 5;
    bola.y := LAYAR_TINGGI-4;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+2);
    write('Skor         : ', totalskor);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Nyawa        : '); Textcolor(red); write(totalnyawa);
    skortinggi;
    Bingkai; Level1;
  end;

  savescore := totalskor;

  while lup1 <> false do
  begin
    if (bola.x > 1) and (bola.x < LAYAR_LEBAR-35) then
    begin
      if (bola.y <> LAYAR_TINGGI-4) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-35;
      awalY := 5;
      batasY := LAYAR_TINGGI-4;
    end
    else if bola.x = LAYAR_LEBAR-35 then
    begin
      if (bola.y <> LAYAR_TINGGI-4) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y > LAYAR_TINGGI-9 then
        batasX := LAYAR_LEBAR-35
      else if bola.y <= LAYAR_TINGGI-9 then
        batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x > LAYAR_LEBAR-35) and (bola.x <= LAYAR_LEBAR-1) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-9;
    end;

    skour(19,9);
    skour(18,9);
    skour(17,9);
    skour(16,9);
    skour(15,9);
    skour(14,9);
    skour(13,9);
    skour(12,9);
    skour(34,9);
    skour(35,9);
    skour(35,8);
    skour(35,7);
    skour(35,6);
    skour(35,5);
    skour(2,10);
    skour(2,9);
    
    Gerakan;
    if tojump = true then Lompat;
    UpdateLompatan(batasY);
    limitTmpt(awalX, batasX, awalY, batasY);
    gotoxy(bola.x, bola.y);
    bbola;
    skortinggi;
    delay(50);
    if bola.x = LAYAR_LEBAR-1 then lup1 := false; 
  end;

  hearth(nyowo);
  savescore := totalskor;

  if (lup2 = true) and (nyowo <> 0) then
  begin
    stage := 2;
    clrscr;
    bola.x := 10;
    bola.y := LAYAR_TINGGI-9;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+2);
    write('Skor         : ', totalskor);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Nyawa        : '); Textcolor(red); write(totalnyawa);
    skortinggi;
    Bingkai; Level2;
    buatx := 0;
    buaty := 0;
    for bxy := 1 to 50 do
    begin
      akhirx[bxy] := 0;
      akhiry[bxy] := 0;
    end;
  end;

  while (lup2 <> false) and (nyowo <> 0) do
  begin
    if (bola.x > 1) and (bola.x <= LAYAR_LEBAR-60) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-35;
      awalY := 5;
      batasY := LAYAR_TINGGI-9;
    end
    else if (bola.x > LAYAR_LEBAR-60) and (bola.x < LAYAR_LEBAR-55) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := LAYAR_LEBAR-59;
      if bola.y <= LAYAR_TINGGI-7 then 
        batasX := LAYAR_LEBAR-50
      else if bola.y > LAYAR_TINGGI-7 then
        batasX := LAYAR_LEBAR-56;
      awalY := 5;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x >= LAYAR_LEBAR-55) and (bola.x <= LAYAR_LEBAR-35) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-33;
      awalY := 5;
      batasY := LAYAR_TINGGI-7;
    end
    else if (bola.x > LAYAR_LEBAR-35) and (bola.x < LAYAR_LEBAR-30) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := LAYAR_LEBAR-34;
      if bola.y <= LAYAR_TINGGI-7 then 
        batasX := LAYAR_LEBAR-25
      else if bola.y > LAYAR_TINGGI-7 then
        batasX := LAYAR_LEBAR-31;
      awalY := 5;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x >= LAYAR_LEBAR-30) and (bola.x <= LAYAR_LEBAR-10) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-8;
      awalY := 5;
      batasY := LAYAR_TINGGI-5;
    end
    else if (bola.x > LAYAR_LEBAR-10) and (bola.x <= LAYAR_LEBAR-1) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := LAYAR_LEBAR-11;
      batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-1;
    end;

    skour(46,7);
    skour(45,7);
    skour(44,7);
    skour(43,7);
    skour(21,5);
    skour(20,5);
    skour(19,5);
    skour(18,5);
    skour(6,2);
    skour(5,2);
    skour(6,3);
    skour(5,3);
    skour(6,4);
    skour(5,4);
    skour(6,5);
    skour(5,5);
    
    Gerakan;
    if tojump = true then Lompat;
    UpdateLompatan(batasY);
    limitTmpt(awalX, batasX, awalY, batasY);
    gotoxy(bola.x, bola.y);
    bbola;
    skortinggi;
    hearth(nyowo);
    delay(50);
    if (bola.x > LAYAR_LEBAR-10) and (bola.y = LAYAR_TINGGI-1) then lup2 := false; 
    if (bola.y = LAYAR_TINGGI-1) and (bola.x <= LAYAR_LEBAR-10) then
    begin
      PlaySound('lostlife.wav', 0, SND_ASYNC or SND_FILENAME);
      prX := bola.x;
      prY := bola.y;
      nyowo := nyowo - 1;
      gotoxy(prX, prY);
      write(' ');
      delay(3000);
      bola.x := 10;
      bola.y := LAYAR_TINGGI-9;
      PlaySound('maintheme.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
    end;
  end;

  hearth(nyowo);
  savescore := totalskor;

  if (lup3 = true) and (nyowo <> 0) then
  begin
    stage := 3;
    clrscr;
    bola.x := 5;
    bola.y := LAYAR_TINGGI-4;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+2);
    write('Skor         : ', totalskor);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Nyawa        : '); Textcolor(red); write(totalnyawa);
    skortinggi;
    Bingkai; Level3;
    buatx := 0;
    buaty := 0;
    for bxy := 1 to 50 do
    begin
      akhirx[bxy] := 0;
      akhiry[bxy] := 0;
    end;
  end;

  while (lup3 <> false) and (nyowo <> 0) do
  begin
    if (bola.x > 1) and (bola.x <= 10) then
    begin
      if (bola.y <> LAYAR_TINGGI-4) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-68;
      awalY := 2;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x > 10) and (bola.x <= 17) and (bola.y > LAYAR_TINGGI-17) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-61;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x >= LAYAR_LEBAR-62) and (bola.x <= LAYAR_LEBAR-59) and (bola.y > LAYAR_TINGGI-17) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y < LAYAR_TINGGI-4 then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-55;
      end
      else if bola.y >= LAYAR_TINGGI-4 then
      begin
        awalX := LAYAR_LEBAR-62;
        batasX := LAYAR_LEBAR-59;
      end;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x > LAYAR_LEBAR-59) and (bola.x <= LAYAR_LEBAR-43) and (bola.y > LAYAR_TINGGI-17) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-42;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x >= LAYAR_LEBAR-42) and (bola.x <= LAYAR_LEBAR-39) and (bola.y > LAYAR_TINGGI-17) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y < LAYAR_TINGGI-4 then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-36;
      end
      else if bola.y >= LAYAR_TINGGI-4 then
      begin
        awalX := LAYAR_LEBAR-42;
        batasX := LAYAR_LEBAR-39;
      end;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x > LAYAR_LEBAR-39) and (bola.x <= LAYAR_LEBAR-26) and (bola.y > LAYAR_TINGGI-17) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-24;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x >= LAYAR_LEBAR-25) and (bola.x <= LAYAR_LEBAR-22) and (bola.y > LAYAR_TINGGI-17) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y < LAYAR_TINGGI-4 then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-18;
      end
      else if bola.y >= LAYAR_TINGGI-4 then
      begin
        awalX := LAYAR_LEBAR-25;
        batasX := LAYAR_LEBAR-22;
      end;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x > LAYAR_LEBAR-22) and (bola.x <= LAYAR_LEBAR-15) and (bola.y > LAYAR_TINGGI-17) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-8;
      batasY := LAYAR_TINGGI-4;
    end
    else if (bola.x > 10) and (bola.x <= LAYAR_LEBAR-15) and (bola.y <= LAYAR_TINGGI-17) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := 2;
      batasY := LAYAR_TINGGI-17;
    end
    else if (bola.x >= LAYAR_LEBAR-6) and (bola.x <= LAYAR_LEBAR-1) then
    begin
      awalX := LAYAR_LEBAR-7;
      if (bola.y <= LAYAR_TINGGI-8) and (bola.y >= LAYAR_TINGGI-12) then
      begin
        awalY := LAYAR_TINGGI-12;
        batasY := LAYAR_TINGGI-8;
        batasX := LAYAR_LEBAR-1;
      end
      else if bola.y = LAYAR_TINGGI-7 then
      begin
        awalX := LAYAR_LEBAR-9;
        awalY := LAYAR_TINGGI-6;
        batasX := LAYAR_LEBAR-6;
        batasY := LAYAR_TINGGI-4;
      end
      else if bola.y = LAYAR_TINGGI-13 then
      begin
        awalX := LAYAR_LEBAR-9;
        batasX := LAYAR_LEBAR-6;
      end
      else if bola.y > LAYAR_TINGGI-6 then
      begin
        awalY := LAYAR_TINGGI-6;
        batasY := LAYAR_TINGGI-4;
        batasX := LAYAR_LEBAR-1;
      end
      else if (bola.y <= LAYAR_TINGGI-14) and (bola.y >= LAYAR_TINGGI-15) then
      begin
        awalY := LAYAR_TINGGI-18;
        batasY := LAYAR_TINGGI-14;
        batasX := LAYAR_LEBAR-1;
      end;
    end
    else if (bola.x >= LAYAR_LEBAR-14) and (bola.x <= LAYAR_LEBAR-9) then
    begin
      awalX := LAYAR_LEBAR-14;
      if (bola.y <= LAYAR_TINGGI-11) and (bola.y >= LAYAR_TINGGI-15) then
      begin
        awalY := LAYAR_TINGGI-15;
        batasY := LAYAR_TINGGI-11;
        batasX := LAYAR_LEBAR-8;
      end
      else if bola.y = LAYAR_TINGGI-10 then
      begin
        awalX := LAYAR_LEBAR-8;
        awalY := LAYAR_TINGGI-11;
        batasX := LAYAR_LEBAR-7;
        batasY := LAYAR_TINGGI-4;
      end
      else if bola.y = LAYAR_TINGGI-16 then
      begin
        awalX := LAYAR_LEBAR-8;
        batasX := LAYAR_LEBAR-7;
      end
      else if bola.y > LAYAR_TINGGI-9 then
      begin
        awalY := LAYAR_TINGGI-9;
        batasY := LAYAR_TINGGI-4;
        batasX := LAYAR_LEBAR-7;
      end
      else if (bola.y <= LAYAR_TINGGI-17) and (bola.y >= LAYAR_TINGGI-19) then
      begin
        awalY := LAYAR_TINGGI-18;
        batasY := LAYAR_TINGGI-17;
        awalX := LAYAR_LEBAR-16;
        batasX := LAYAR_LEBAR-7;
      end;
    end

    else if (bola.x > LAYAR_LEBAR-9) and (bola.x < LAYAR_LEBAR-6) then
    begin
      if (bola.y <> LAYAR_TINGGI-4) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      
      if bola.y = LAYAR_TINGGI-16 then
      begin
        awalX := LAYAR_LEBAR-9;
        batasX := LAYAR_LEBAR-5;
      end
      else if bola.y = LAYAR_TINGGI-10 then
      begin
        awalX := LAYAR_LEBAR-9;
        batasX := LAYAR_LEBAR-5;
      end
      else if (bola.y >= LAYAR_TINGGI-7) and (bola.y <= LAYAR_TINGGI-6) then
      begin
        awalX := LAYAR_LEBAR-9;
        batasX := LAYAR_LEBAR-6;
      end
      else if bola.y = LAYAR_TINGGI-13 then
      begin
        awalX := LAYAR_LEBAR-9;
        batasX := LAYAR_LEBAR-6;
      end
      else if bola.y > LAYAR_TINGGI-7 then
      begin
        awalX := LAYAR_LEBAR-10;
        batasX := LAYAR_LEBAR-5;
      end
      else if bola.y < LAYAR_TINGGI-16 then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-5;
      end
      else
      begin
        awalX := LAYAR_LEBAR-10;
        batasx := LAYAR_LEBAR-5;
      end;
      awalY := 2;
      batasY := LAYAR_TINGGI-4;
    end;

    skour(58,4);
    skour(43,4);
    skour(32,4);
    skour(31,4);
    skour(3,8);
    skour(3,14);
    skour(12,11);
    skour(12,17);
    skour(26,17);
    skour(36,17);
    skour(46,17);
    skour(56,17);
    skour(66,16);
    skour(76,11);
    skour(75,11);
    
    rintangan(57,4);
    rintangan(53,8);
    rintangan(50,4);
    rintangan(49,4);
    rintangan(46,8);
    rintangan(45,8);
    rintangan(36,4);
    rintangan(35,4);
    rintangan(28,4);
    rintangan(27,4);
    rintangan(21,8);
    rintangan(20,8);
    rintangan(19,8);
    rintangan(18,8);
    rintangan(14,9);
    rintangan(13,9);
    rintangan(12,9);
    rintangan(1,8);
    rintangan(1,14);
    rintangan(13,11);
    rintangan(14,11);
    rintangan(3,4);
    rintangan(2,4);
    rintangan(1,4);
    rintangan(31,17);
    rintangan(41,17);
    rintangan(51,17);
    rintangan(61,17);
  

    Gerakan;
    if tojump = true then Lompat;
    UpdateLompatan(batasY);
    limitTmpt(awalX, batasX, awalY, batasY);
    gotoxy(bola.x, bola.y);
    bbola;
    hearth(nyowo);
    skortinggi;
    delay(50);
    if (bola.x >= LAYAR_LEBAR-76) and (bola.x <= LAYAR_LEBAR-75) and (bola.y = LAYAR_TINGGI-10) then lup3 := false; 
    if (bola.y = LAYAR_TINGGI-1) or (duri = true) then
    begin
      PlaySound('lostlife.wav', 0, SND_ASYNC or SND_FILENAME);
      prX := bola.x;
      prY := bola.y;
      nyowo := nyowo - 1;
      gotoxy(prX, prY);
      write(' ');
      delay(3000);
      bola.x := 5;
      bola.y := LAYAR_TINGGI-4;
      duri := false;
      PlaySound('maintheme.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
    end;
  end;

  hearth(nyowo);
  savescore := totalskor; 

  if (lup4 = true) and (nyowo <> 0) then
  begin
    stage := 4;
    clrscr;
    bola.x := LAYAR_LEBAR-50;
    bola.y := 4;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+2);
    write('Skor         : ', totalskor);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Nyawa        : '); Textcolor(red); write(totalnyawa);
    skortinggi;
    Bingkai; Level4;
    buatx := 0;
    buaty := 0;
    forx := 0;
    fory := 0;
    for bxy := 1 to 100 do
    begin
      akhirx[bxy] := 0;
      akhiry[bxy] := 0;
      rinx[bxy] := 0;
      riny[bxy] := 0;
    end;
  end;

  while (lup4 <> false) and (nyowo <> 0) do
  begin
    if (bola.x >= LAYAR_LEBAR-52) and (bola.x <= LAYAR_LEBAR-48) and (bola.y <= 4) then
    begin
      if tr4 = true then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-49;
      end
      else if fl4 = true then
      begin
        awalX := LAYAR_LEBAR-51;
        batasX := LAYAR_LEBAR-1;
      end
      else
      begin
        awalX := LAYAR_LEBAR-79;
        batasX := LAYAR_LEBAR-1;
      end;
      awalY := 3;
      batasY := 4;
    end
    else if (bola.x >= LAYAR_LEBAR-47) and (bola.x <= LAYAR_LEBAR-9) and (bola.y <= LAYAR_TINGGI-15) then
    begin
      if (bola.y >= LAYAR_TINGGI-17) and (bola.y <= LAYAR_TINGGI-15) then
      begin
        if (bola.y <> LAYAR_TINGGI-15) and (bola.lompat = false) then 
        begin
          prX := bola.x;
          prY := bola.y;
          gotoxy(prX, prY);
          write(' ');
          bola.y := bola.y+1;
        end;
      end;
      if bola.y < LAYAR_TINGGI-15 then 
        awalX := 2
      else if bola.y = LAYAR_TINGGI-15 then 
        awalX := LAYAR_LEBAR-47;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-17;
      batasY := LAYAR_TINGGI-15;
    end

    else if (bola.x >= LAYAR_LEBAR-8) and (bola.x <= LAYAR_LEBAR-1) and (bola.y <= LAYAR_TINGGI-11) then
    begin
      if (bola.y <> LAYAR_TINGGI-11) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y = LAYAR_TINGGI-14 then
      begin
        awalX := LAYAR_LEBAR-8;
        batasX := LAYAR_LEBAR-1;
      end
      else if (bola.y > LAYAR_TINGGI-14) or (bola.y < LAYAR_TINGGI-14) then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-1;
      end;
      awalY := LAYAR_TINGGI-18;
      batasY := LAYAR_TINGGI-11;
    end

    else if (bola.x >= LAYAR_LEBAR-40) and (bola.x <= LAYAR_LEBAR-9) and (bola.y >= LAYAR_TINGGI-13) and (bola.y <= LAYAR_TINGGI-11) then
    begin
      if (bola.y <> LAYAR_TINGGI-11) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-13;
      batasY := LAYAR_TINGGI-11;
    end

    else if (bola.x >= LAYAR_LEBAR-47) and (bola.x <= LAYAR_LEBAR-41) and (bola.y >= LAYAR_TINGGI-13) and (bola.y <= LAYAR_TINGGI-7) then
    begin
      if (bola.y <> LAYAR_TINGGI-7) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y = LAYAR_TINGGI-10 then
      begin
        awalX := LAYAR_LEBAR-47;
        batasX := LAYAR_LEBAR-41;
      end
      else if (bola.y > LAYAR_TINGGI-10) or (bola.y < LAYAR_TINGGI-10) then
      begin
        awalX := LAYAR_LEBAR-47;
        batasX := LAYAR_LEBAR-1;
      end;
      awalY := LAYAR_TINGGI-13;
      batasY := LAYAR_TINGGI-7;
    end

    else if (bola.x >= LAYAR_LEBAR-40) and (bola.x <= LAYAR_LEBAR-9) and (bola.y >= LAYAR_TINGGI-9) and (bola.y <= LAYAR_TINGGI-7) then
    begin
      if (bola.y <> LAYAR_TINGGI-7) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-9;
      batasY := LAYAR_TINGGI-7;
    end

    else if (bola.x >= LAYAR_LEBAR-8) and (bola.x <= LAYAR_LEBAR-1) and (bola.y >= LAYAR_TINGGI-9) and (bola.y <= LAYAR_TINGGI-1) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y = LAYAR_TINGGI-6 then
      begin
        awalX := LAYAR_LEBAR-8;
        batasX := LAYAR_LEBAR-1;
      end
      else if (bola.y > LAYAR_TINGGI-6) or (bola.y < LAYAR_TINGGI-6) then
      begin
        awalX := LAYAR_LEBAR-79;
        batasX := LAYAR_LEBAR-1;
      end;
      awalY := LAYAR_TINGGI-9;
      batasY := LAYAR_TINGGI-1;
    end

    else if (bola.x >= LAYAR_LEBAR-48) and (bola.x <= LAYAR_LEBAR-9) and (bola.y >= LAYAR_TINGGI-5) and (bola.y <= LAYAR_TINGGI-2) then
    begin
      if (bola.y <> LAYAR_TINGGI-2) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := LAYAR_LEBAR-48;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-5;
      batasY := LAYAR_TINGGI-2;
    end


    else if (bola.x >= LAYAR_LEBAR-75) and (bola.x <= LAYAR_LEBAR-53) and (bola.y <= LAYAR_TINGGI-16) then
    begin
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := LAYAR_TINGGI-17;
      batasY := LAYAR_TINGGI-16;
    end

    else if (bola.x >= LAYAR_LEBAR-79) and (bola.x <= LAYAR_LEBAR-76) and (bola.y <= LAYAR_TINGGI-11) then
    begin
      if (bola.y <> LAYAR_TINGGI-11) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if (bola.y >= LAYAR_TINGGI-15) and (bola.y <= LAYAR_TINGGI-13) then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-76;
      end
      else if (bola.y > LAYAR_TINGGI-15) or (bola.y < LAYAR_TINGGI-13) then
      begin
        awalX := 2;
        batasX := LAYAR_LEBAR-1;
      end;
      awalY := LAYAR_TINGGI-17;
      batasY := LAYAR_TINGGI-11;
    end

    else if (bola.x >= LAYAR_LEBAR-75) and (bola.x <= LAYAR_LEBAR-56) and (bola.y >= LAYAR_TINGGI-13) and (bola.y <= LAYAR_TINGGI-11) then
    begin
      if (bola.y <> LAYAR_TINGGI-11) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      if bola.x = LAYAR_LEBAR-66 then
        awalY := LAYAR_TINGGI-14
      else
        awalY := LAYAR_TINGGI-12;
      batasY := LAYAR_TINGGI-11;
    end
    
    else if (bola.x >= LAYAR_LEBAR-74) and (bola.x <= LAYAR_LEBAR-52) and (bola.y = LAYAR_TINGGI-14) then
    begin
      awalX := LAYAR_LEBAR-74;
      awalY := LAYAR_TINGGI-14;
      batasX := LAYAR_LEBAR-52;
      if bola.x = LAYAR_LEBAR-66 then
      begin
        if (bola.y <> LAYAR_TINGGI-11) and (bola.lompat = false) then 
        begin
          prX := bola.x;
          prY := bola.y;
          gotoxy(prX, prY);
          write(' ');
          bola.y := bola.y+1;
        end;
        batasY := LAYAR_TINGGI-11;
      end
      else
        batasY := LAYAR_TINGGI-14;
    end

    else if (bola.x >= LAYAR_LEBAR-55) and (bola.x <= LAYAR_LEBAR-52) and (bola.y >= LAYAR_TINGGI-12) and (bola.y <= LAYAR_TINGGI-6) then
    begin
      if (bola.y <> LAYAR_TINGGI-6) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if (bola.y >= LAYAR_TINGGI-10) and (bola.y <= LAYAR_TINGGI-8) then
      begin
        awalX := LAYAR_LEBAR-55;
        batasX := LAYAR_LEBAR-52;
      end
      else if (bola.y > LAYAR_TINGGI-10) or (bola.y < LAYAR_TINGGI-8) then
      begin
        awalX := LAYAR_LEBAR-79;
        batasX := LAYAR_LEBAR-52;
      end;
      awalY := LAYAR_TINGGI-12;
      batasY := LAYAR_TINGGI-6;
    end

    else if (bola.x >= LAYAR_LEBAR-75) and (bola.x <= LAYAR_LEBAR-56) and (bola.y >= LAYAR_TINGGI-8) and (bola.y <= LAYAR_TINGGI-6) then
    begin
      if (bola.y <> LAYAR_TINGGI-6) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      if bola.x = LAYAR_LEBAR-66 then
        awalY := LAYAR_TINGGI-9
      else
        awalY := LAYAR_TINGGI-7;
      batasY := LAYAR_TINGGI-6;
    end
    
    else if (bola.x >= LAYAR_LEBAR-78) and (bola.x <= LAYAR_LEBAR-57) and (bola.y = LAYAR_TINGGI-9) then
    begin
      awalX := LAYAR_LEBAR-79;
      awalY := LAYAR_TINGGI-9;
      batasX := LAYAR_LEBAR-57;
      if bola.x = LAYAR_LEBAR-66 then
      begin
        if (bola.y <> LAYAR_TINGGI-6) and (bola.lompat = false) then 
        begin
          prX := bola.x;
          prY := bola.y;
          gotoxy(prX, prY);
          write(' ');
          bola.y := bola.y+1;
        end;
        batasY := LAYAR_TINGGI-6;
      end
      else
        batasY := LAYAR_TINGGI-9;
    end

    else if (bola.x >= LAYAR_LEBAR-79) and (bola.x <= LAYAR_LEBAR-76) and (bola.y >= LAYAR_TINGGI-7) and (bola.y <= LAYAR_TINGGI-1) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      if bola.y = LAYAR_TINGGI-5 then
      begin
        awalX := LAYAR_LEBAR-79;
        batasX := LAYAR_LEBAR-76;
      end
      else if (bola.y > LAYAR_TINGGI-5) or (bola.y < LAYAR_TINGGI-5) then
      begin
        awalX := LAYAR_LEBAR-79;
        batasX := LAYAR_LEBAR-52;
      end;
      awalY := LAYAR_TINGGI-7;
      batasY := LAYAR_TINGGI-1;
    end
    
    else if (bola.x >= LAYAR_LEBAR-75) and (bola.x <= LAYAR_LEBAR-52) and (bola.y >= LAYAR_TINGGI-4) and (bola.y <= LAYAR_TINGGI-2) then
    begin
      if (bola.y <> LAYAR_TINGGI-2) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := LAYAR_LEBAR-79;
      batasX := LAYAR_LEBAR-52;
      awalY := LAYAR_TINGGI-4;
      batasY := LAYAR_TINGGI-2;
    end;

    skour(58,16);  
    skour(59,16);  
    skour(62,17);  
    skour(66,16);  
    skour(73,17);  
    skour(74,17);  
    skour(77,12);  
    skour(77,11);  
    for i := 53 to 74 do
    begin
      skour1(i,14);    
    end; 
    for i := 57 to 79 do
    begin
      skour2(i,9);    
    end; 
    skour(71,11);  
    skour(70,11);  
    skour(62,12);  
    skour(61,12);  
    skour(57,11);  
    skour(56,11);  
    skour(54,7);  
    skour(54,6);  
    skour(58,7);  
    skour(63,6);  
    skour(71,7);  
    skour(75,6);  
    rintangan(58,17);
    rintangan(59,17);
    rintangan(66,17);
    rintangan(78,15);
    rintangan(78,14);
    rintangan(72,11);
    rintangan(58,11);
    rintangan(55,9);
    rintangan(55,8);

    skour(36,16); 
    skour(31,15); 
    skour(30,15); 
    skour(17,17); 
    skour(17,16); 
    skour(21,11); 
    skour(25,12); 
    skour(29,13); 
    skour(27,7); 
    skour(26,7); 
    rintangan(38,15);
    rintangan(38,16);
    rintangan(34,17);
    rintangan(34,16);
    rintangan(28,15);
    rintangan(27,15);
    rintangan(24,17);
    rintangan(23,17);
    rintangan(16,15);
    rintangan(16,16);
    rintangan(10,15);
    rintangan(9,15);
    rintangan(8,11);
    rintangan(7,11);
    rintangan(13,11);  
    rintangan(14,11);  
    rintangan(31,11);
    rintangan(32,11);
    rintangan(35,13);
    rintangan(40,11);  
    rintangan(43,13);  
    rintangan(35,7);
    rintangan(29,7);
    rintangan(21,9);
    rintangan(18,7);
    rintangan(12,7);

    rintangan(52, 17);
    rintangan(52, 16);
    rintangan(48, 17);
    rintangan(48, 16);

    rintangan(13,2);  
    rintangan(13,3);  
    rintangan(27,5);  
    rintangan(29,2);  
    rintangan(45,5);  
    rintangan(46,5);  

    skour(13,2);  
    skour(13,3);  
    skour(27,5);  
    skour(29,2);  
    skour(45,5);  
    skour(46,5);  

    Gerakan;
    if tojump = true then Lompat;
    UpdateLompatan(batasY);
    limitTmpt(awalX, batasX, awalY, batasY);
    gotoxy(bola.x, bola.y);
    bbola;
    skortinggi;
    hearth(nyowo);
    delay(50);
    if ((bola.x = LAYAR_LEBAR-52) or (bola.x = LAYAR_LEBAR-48)) and (bola.y >= LAYAR_TINGGI-5) then lup4 := false; 
    if (bola.y = LAYAR_TINGGI-1) or (duri = true) then
    begin
      prX := bola.x;
      prY := bola.y;
      nyowo := nyowo - 1;
      gotoxy(prX, prY);
      write(' ');
      bola.x := LAYAR_LEBAR-50;
      bola.y := 4;
      duri := false;
      if (prX = LAYAR_LEBAR-52) and (prY <=LAYAR_TINGGI-16) then
      begin
        PlaySound('goodchoice.wav', 0, SND_ASYNC or SND_FILENAME);
        hearth(nyowo);
        level4_true;
      end
      else if (prX = LAYAR_LEBAR-48) and (prY <=LAYAR_TINGGI-16) then
      begin
        PlaySound('badchoice.wav', 0, SND_ASYNC or SND_FILENAME);
        hearth(nyowo);
        level4_false;
      end
      else
      begin
        PlaySound('lostlife.wav', 0, SND_ASYNC or SND_FILENAME);
        delay(3000);
      end;
      PlaySound('maintheme.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
    end;
  end;

  hearth(nyowo);
  savescore := totalskor;

  if (lup5 = true) and (nyowo <> 0) then
  begin
    stage := 5;
    clrscr;
    bola.x := 10;
    bola.y := LAYAR_TINGGI-9;
    Textcolor(white);
    gotoxy(3, LAYAR_TINGGI+2);
    write('Skor         : ', totalskor);
    gotoxy(3, LAYAR_TINGGI+1);
    write('Nyawa        : '); Textcolor(red); write(totalnyawa);
    skortinggi;
    Bingkai; Level5;
  end;

  while (lup5 <> false) and (nyowo <> 0) do
  begin
    if (bola.x > 1) and (bola.x <= LAYAR_LEBAR-62+tjmbt) then
    begin
      if (bola.y <> LAYAR_TINGGI-9) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-9;
    end
    else if (bola.x > LAYAR_LEBAR-62+tjmbt) and (bola.x < LAYAR_LEBAR-11) then
    begin
      if (bola.y <> LAYAR_TINGGI-1) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-1;
    end
    else if (bola.x >= LAYAR_LEBAR-11) and (bola.x <= LAYAR_LEBAR-1) then
    begin
      if (bola.y <> LAYAR_TINGGI-9) and (bola.lompat = false) then 
      begin
        prX := bola.x;
        prY := bola.y;
        gotoxy(prX, prY);
        write(' ');
        bola.y := bola.y+1;
      end;
      awalX := 2;
      batasX := LAYAR_LEBAR-1;
      awalY := 5;
      batasY := LAYAR_TINGGI-9;
    end;
    
    Gerakan;
    if tojump = true then Lompat;
    UpdateLompatan(batasY);
    limitTmpt(awalX, batasX, awalY, batasY);
    gotoxy(bola.x, bola.y);
    bbola;
    hearth(nyowo);
    skortinggi;
    delay(50);
    if bola.x >= LAYAR_LEBAR-8 then
    begin
      lup5 := false; 
      winnih := true;
    if bola.y = LAYAR_TINGGI-1 then
    begin
      prX := bola.x;
      prY := bola.y;
      nyowo := nyowo - 1;
      gotoxy(prX, prY);
      write(' ');
      bola.x := 10;
      bola.y := LAYAR_TINGGI-9;
      endingnyawa := endingnyawa + 1;
    end;
    if endingnyawa = 1 then
    begin
      PlaySound('lostlife.wav', 0, SND_ASYNC or SND_FILENAME);
      delay(3000);
      PlaySound('maintheme.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
    end
    else if endingnyawa = 2 then
    begin
      PlaySound('wintheme.wav', 0, SND_ASYNC or SND_FILENAME);
      Textcolor(green);
      gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-12);
      write('SELAMAT KAMU BERHASIL MENGORBANKAN NYAWA');
      gotoxy(LAYAR_LEBAR-61, LAYAR_TINGGI-11);
      write('TOMBOL RAHASIANYA ADALAH "ESC"            ');
      Textcolor(white);
    end;
  end;
end;
end;

procedure gameover;
begin
  clrscr;
  CursorOn;
  PlaySound('kalahtheme.wav', 0, SND_ASYNC or SND_FILENAME);
  Textcolor(red);
  writeln('GAME OVER');
  Textcolor(white);
  writeln('HIGH STAGE   : ', stage);
  writeln('TOTAL SCORE  : ', savescore);
  writeln('HIGH SCORE   : ', highscore);
end;

procedure gamewin;
begin
  clrscr;
  CursorOn;
  PlaySound('wintheme.wav', 0, SND_ASYNC or SND_FILENAME);
  Textcolor(green);
  writeln('GAME WIN!!!');
  Textcolor(white);
  writeln('TOTAL SCORE  : ', savescore);
  writeln('HIGH SCORE   : ', highscore);
end;




begin
  while onput <> '2' do 
  begin
    repeat
      clrscr;
      PlaySound('lobby.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
      Textcolor(yellow);
      writeln('BOUNCE BALL GAME BY ALPINN');
      Textcolor(white);
      writeln('1. Play');
      writeln('2. Exit');
      write('Pilih Input (1-2): '); readln(onput);
      if (HanyaAngka(onput) = false) or (StrToInt(onput) > 2) then
      begin
        Textcolor(red);
        writeln('Input Yang Dimasukkan Salah!!');
        delay(1000);
        Textcolor(white);
      end;
    until HanyaAngka(onput); 

    if StrToInt(onput) = 1 then
    begin
      highscore := 0;
      clrscr;
      CursorOff;
      Textcolor(green);
      writeln('MEKANISME GAME :');
      Textcolor(white);
      writeln('- Game berakhir ketika nyawa Habis');
      writeln('- Dalam permainan player akan mendapatkan 5 nyawa');
      writeln('- Raihlah Skor sebanyak-banyaknya untuk memenangkan game');
      writeln('- Capailah ujung Stage untuk melanjutkan ke Stage berikutnya');
      writeln('- Hindari tanda Rintangan / "X" supaya nyawa tidak berkurang');
      writeln('- Bila jatuh ke jurang atau terkena mengenai "X" maka nyawa berkurang 1');
      Textcolor(green);
      writeln;
      writeln('KONTROL GAME :');
      Textcolor(white);
      writeln('"W"      -> On/Off Auto Jump');
      writeln('"A"      -> Bergerak Ke Kiri');
      writeln('"D"      -> Bergerak Ke Kanan');
      writeln('"Space"  -> Lompat Secara Manual');
      delay(3500);
      Textcolor(green);
      writeln('Tekan Enter Untuk Melanjutkan...');
      readln;
      Textcolor(white);
      
      repeat
        clrscr;
        CursorOff;
        PlaySound('maintheme.wav', 0, SND_ASYNC or SND_FILENAME or SND_LOOP);
        render;
        if nyowo = 0 then
        begin
          repeat
            gameover;
            Textcolor(white);
            writeln('1. Try Again');
            writeln('2. Exit');
            write('Pilih Input (1-2): ');readln(onput);
            if (HanyaAngka(onput) = false) or (StrToInt(onput) > 2) then
            begin
              Textcolor(red);
              writeln('Input Yang Dimasukkan Salah!!');
              delay(1000);
              Textcolor(white);
            end;
          until HanyaAngka(onput);
        end;
        if winnih = true then
        begin
          repeat
            gamewin;
            Textcolor(white);
            writeln('1. Back To Main Menu');
            writeln('2. Exit');
            write('Pilih Input (1-2): ');readln(onput);
            if (HanyaAngka(onput) = false) or (StrToInt(onput) > 2) then
            begin
              Textcolor(red);
              writeln('Input Yang Dimasukkan Salah!!');
              delay(1000);
              Textcolor(white);
            end;
          until HanyaAngka(onput);
          if StrToInt(onput) = 1 then 
          begin
            Textcolor(green);
            writeln('Kembali ke Menu Utama...');
            delay(1000);
            break;
          end;
        end;
      until StrToInt(onput) = 2;
    end;
  end;
  Textcolor(green);
  writeln('Keluar Dari Game...');
  delay(1000);
end.