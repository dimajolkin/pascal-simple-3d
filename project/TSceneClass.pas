unit TSceneClass;

interface

uses GraphABC, TObjectClass, TCameraClass, TRobertClass, TMatrix;

const
  M_PI = pi;

type  //Класс Нашей Сцены
  TScene = class
    Scene: integer;
    GMove, GRotation, GRersp: Matrix;
    GMBufer, GMBufer2, GMBufer3: Matrix;
    Size: integer;
    Screening, perspect: boolean;
    
    ObjectColor: System.Drawing.Color;
    SceneColor: System.Drawing.Color;
    
    GSizeMatrix: integer;
    GPosIndexObject: integer;
    GCWidth, GCHeight: integer;
    MSObject: array[1..100] of TObject;
    constructor Create(Color, ColorObj: System.Drawing.Color; ClientWidth, ClientHeight: integer);
    procedure Create_GRotation(a: Real; X, Y, Z: boolean);
    procedure Create_GMove(dx, dy, dz: real);
    procedure Create_GRersp(Zk, Zpr, Z: real);
    procedure CreateSingleObject(Name: String; Widtch, Heigcht: integer);
    procedure RandomCreateObject(C, P, Widtch, Heigch, CWidtch, CHeigch: integer);
    procedure GWrite(T: TObject);
    procedure GWrite(T: Matrix);
    procedure Position_Scene(Index, CHeigh, CWidth, CenteHight, CenteWidtch: integer);
    procedure Flight(Camera: TCamera);
    procedure DrawMassivRebock(Flag: boolean);
    procedure Mult(a, b: Matrix);
  end;
//====================================ОПИСАНИЕ ПРОЦЕДУР И ФУНЦКИЙ КЛАССОВ TScene and TObject=================
implementation

constructor TScene.Create(Color, ColorObj: System.Drawing.Color; ClientWidth, ClientHeight: integer);

begin
  Clearwindow(Color);
  SceneColor := Color;
  ObjectColor := ColorObj;
  setwindowsize(ClientWidth, ClientHeight);
  GCWidth := ClientWidth;
  GCHeight := ClientHeight;
  
  
end;

procedure TScene.RandomCreateObject(C, P, Widtch, Heigch, CWidtch, CHeigch: integer);
var
  i, k1, k2, x, y, x0, y0: integer;
  S1, S2: String;
begin
  randomize;
  S1 := 'Cube';
  S2 := 'Рyramid';
  GPosIndexObject := C + P;
  x0 := Round(GCWidth / 2);
  y0 := Round(GCHeight / 2);
  k1 := 0; k2 := 0;
  for i := 1 to GPosIndexObject do
  begin
    x := random(GCWidth);
    y := random(GCHeight);
    int(k1); inc(k2);
    if (k1 <= P) then MSObject[i] := TObject.Create(S1, Widtch, Heigch);
    if (k2 <= C) then MSObject[i] := TObject.Create(S2, CWidtch, CHeigch);
    Size := MSObject[i].Size;
    MSObject[i].center;
    Create_GMove(x - MSObject[i].TcenterX, y - MSObject[i].TcenterY, 0);
    Mult(MSObject[i].MatrixObject, GMove);
    MSObject[i].App(GMBufer);
    
    
  end;
  
end;

procedure TScene.CreateSingleObject(Name: String; Widtch, Heigcht: integer);
var
  x0, y0: integer;
begin
  GPosIndexObject := 1;
  x0 := Round(GCWidth / 2);
  y0 := Round(GCHeight / 2);
  MSObject[1] := TObject.Create(Name, Widtch, Heigcht);
  Size := MSObject[1].Size;
  MSObject[1].center;
  Create_GMove(x0 - MSObject[1].TcenterX, y0 - MSObject[1].TcenterY, 0);
  Mult(MSObject[1].MatrixObject, GMove);
  MSObject[1].App(GMBufer);
end;

procedure TScene.DrawMassivRebock(Flag: boolean);
var
  i, j: byte;
begin
  for i := 1 to GPosIndexObject do
    for j := 1 to 10 do
      MSObject[i].Robert.GDraw[j] := flag;
end;

procedure TScene.Flight(Camera: TCamera);
begin
  Create_GRotation(Camera.Step, Camera.XRot, Camera.YRot, Camera.ZRot);
  Clearwindow(SceneColor);
  for var i: integer := 1 to GPosIndexObject do
  begin
    MSObject[i].Draw(SceneColor);
    Size := MSObject[i].Size;
    Create_GMove(-Camera.x, -Camera.y, -Camera.z);
    Mult(MSObject[i].MatrixObject, GMove);
    MSObject[i].Add(GMBufer);
    Mult(MSObject[i].BMatrixObject, GRotation);
    GMBufer3 := GMBufer;
    Create_GMove(Camera.x, Camera.y, Camera.z);
    Mult(GMBufer, GMove);
    MSObject[i].App(GMBufer);
    if perspect then begin
      for var k: integer := 1 to Size do
      begin
        Create_GRersp(Camera.Zk, Camera.Zpr, GMBufer3[k, 3]);
        Mult(GMBufer3, GRersp);
        GMBufer2[k, 1] := GMBufer[k, 1];
        GMBufer2[k, 2] := GMBufer[k, 2];
        GMBufer2[k, 3] := GMBufer[k, 3];
        GMBufer2[k, 4] := GMBufer[k, 4];
      end;
      if Screening then MSObject[i].Robert.RVisibleGran(GMBufer2, 0, 0, -10, 0); //Модуль Экранирования
      Create_GMove(Camera.x, Camera.y, Camera.z);
      Mult(GMBufer2, GMove);
      MSObject[i].Add(GMBufer);
      MSObject[i].BuferDraw := true;
    end else begin          
      MSObject[i].BuferDraw := false;
      if Screening then MSObject[i].Robert.RVisibleGran(MSObject[i].MatrixObject, 0, 0, -10, 0);
    end;
    
    MSObject[i].Draw(ObjectColor);
  end;
  
end;

procedure TScene.GWrite(T: TObject);
var
  i, j: integer;
begin
  writeln('Size:  ', T.Size);
  for i := 1 to 4 do
  begin
    writeln;
    for j := 1 to T.Size do write(T.MatrixObject[j, i], ' ');
  end;
  writeln;
end;

procedure TScene.GWrite(T: Matrix);
var
  i, j: integer;
begin
  for i := 1 to 4 do
  begin
    writeln;
    for j := 1 to GSizeMatrix do write(T[j, i], ' ');
  end;
  writeln;
end;
//==================================
procedure TScene.Position_Scene(Index, CHeigh, CWidth, CenteHight, CenteWidtch: integer);
var
  i, x0, y0, x1, y1: integer;
  Step, Angl, R: real;
begin
  GPosIndexObject := Index;
  x0 := Round(GCWidth / 2);
  y0 := Round(GCHeight / 2);
  if Index <> 1 then begin
    R := GCHeight / 2 - 100;
    Step := 360 / (Index - 1);
    for i := 2 to Index do
    begin
      MSObject[i] := TObject.Create('Cube', CHeigh, CWidth);
      Size := MSObject[i].Size;
      x1 := Round(R * cos(angl * M_PI / 180)) + x0;
      y1 := Round(R * sin(angl * M_PI / 180)) + y0;
      angl := angl + step;
      Create_GMove(x1, y1, 0);
      Mult(MSObject[i].MatrixObject, GMove);
      MSObject[i].App(GMBufer);
    end; end;
  
                                   //
  MSObject[1] := TObject.Create('Рyramid', CenteHight, CenteWidtch);
  Size := MSObject[1].Size;
  Create_GMove(x0 + MSObject[1].MatrixObject[4, 1], y0 + MSObject[1].MatrixObject[4, 2], 0);
  Mult(MSObject[1].MatrixObject, GMove);
  MSObject[1].App(GMBufer);
end;
//===============================

procedure TScene.Mult(a, b: Matrix);
var
  bv: real;
  i, j, l: integer;
begin
  for i := 1 to Size do
  begin
    for j := 1 to 4 do
    begin
      bv := 0;
      for l := 1 to 4 do bv := bv + a[i, l] * b[l, j];
      GMBufer[i, j] := bv;
    end; end;
  
end;

procedure TScene.Create_GRersp(Zk, Zpr, Z: real);
var
  P: real;
begin
  if (Zk - Z <> 0) then begin
    P := (Zk - Zpr) / (Zk - Z);
    GSizeMatrix := 4;
    GRersp[1, 1] := P; GRersp[2, 1] := 0; GRersp[3, 1] := 0; GRersp[4, 1] := 0;
    GRersp[1, 2] := 0; GRersp[2, 2] := P; GRersp[3, 2] := 0; GRersp[4, 2] := 0;
    GRersp[1, 3] := 0; GRersp[2, 3] := 0; GRersp[3, 3] := 1; GRersp[4, 3] := -Zpr;
    GRersp[1, 4] := 0; GRersp[2, 4] := 0; GRersp[3, 4] := 0; GRersp[4, 4] := 1;
    end;
end;

procedure TScene.Create_GMove(dx, dy, dz: real);
begin
  GSizeMatrix := 4;
  GMove[1, 1] := 1; GMove[2, 1] := 0; GMove[3, 1] := 0; GMove[4, 1] := dx;
  GMove[1, 2] := 0; GMove[2, 2] := 1; GMove[3, 2] := 0; GMove[4, 2] := dy;
  GMove[1, 3] := 0; GMove[2, 3] := 0; GMove[3, 3] := 1; GMove[4, 3] := dz;
  GMove[1, 4] := 0; GMove[2, 4] := 0; GMove[3, 4] := 0; GMove[4, 4] := 1;
end;

procedure TScene.Create_GRotation(a: Real; X, Y, Z: boolean);
begin
  GSizeMatrix := 4;
  if (Y) then begin
    GRotation[1, 1] := 1; GRotation[2, 1] := 0; GRotation[3, 1] := 0; GRotation[4, 1] := 0;
    GRotation[1, 2] := 0; GRotation[2, 2] := cos(a * M_PI / 180); GRotation[3, 2] := sin(a * M_PI / 180); GRotation[4, 2] := 0;
    GRotation[1, 3] := 0; GRotation[2, 3] := -sin(a * M_PI / 180); GRotation[3, 3] := cos(a * M_PI / 180); GRotation[4, 3] := 0;
    GRotation[1, 4] := 0; GRotation[2, 4] := 0; GRotation[3, 4] := 0; GRotation[4, 4] := 1;
  end;
  if (X) then begin
    GRotation[1, 1] := cos(a * M_PI / 180); GRotation[2, 1] := 0; GRotation[3, 1] := sin(a * M_PI / 180); GRotation[4, 1] := 0;
    GRotation[1, 2] := 0; GRotation[2, 2] := 1; GRotation[3, 2] := 0; GRotation[4, 2] := 0;
    GRotation[1, 3] := -sin(a * M_PI / 180); GRotation[2, 3] := 0; GRotation[3, 3] := cos(a * M_PI / 180); GRotation[4, 3] := 0;
    GRotation[1, 4] := 0; GRotation[2, 4] := 0; GRotation[3, 4] := 0; GRotation[4, 4] := 1;
  end;
  if (Z) then begin
    GRotation[1, 1] := cos(a * M_PI / 180); GRotation[2, 1] := -sin(a * M_PI / 180); GRotation[3, 1] := 0; GRotation[4, 1] := 0;
    GRotation[1, 2] := sin(a * M_PI / 180); GRotation[2, 2] := cos(a * M_PI / 180); GRotation[3, 2] := 0; GRotation[4, 2] := 0;
    GRotation[1, 3] := 0; GRotation[2, 3] := 0; GRotation[3, 3] := 1; GRotation[4, 3] := 0;
    GRotation[1, 4] := 0; GRotation[2, 4] := 0; GRotation[3, 4] := 0; GRotation[4, 4] := 1;
  end;
  if (not (Z) and not (Y) and not (X)) then begin
    GRotation[1, 1] := 1; GRotation[2, 1] := 0; GRotation[3, 1] := 0; GRotation[4, 1] := 0;
    GRotation[1, 2] := 0; GRotation[2, 2] := 1; GRotation[3, 2] := 0; GRotation[4, 2] := 0;
    GRotation[1, 3] := 0; GRotation[2, 3] := 0; GRotation[3, 3] := 1; GRotation[4, 3] := 0;
    GRotation[1, 4] := 0; GRotation[2, 4] := 0; GRotation[3, 4] := 0; GRotation[4, 4] := 1;
  end;
  
end;


end.