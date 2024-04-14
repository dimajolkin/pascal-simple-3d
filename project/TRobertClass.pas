unit TRobertClass;

interface

uses TMatrix;

type
  TRobert = class
    Size: integer;
    GDraw: array[1..100] of boolean;
    Plos: array[1..10, 1..3] of integer;
    V: array[1..100, 1..100] of integer;
    Result: array[1..10] of real;
    SizePlos: integer;
    
    constructor Create(TSize: integer);
    procedure Add_to_Matrix(a: matrix; v1, v2, v3, NumSt: integer);
    procedure RVisibleGran(outMAtrix: MAtrix; X, Y, Z, P: integer);
  end;

implementation

constructor TRobert.Create(TSize: integer);
begin
  Size := TSize;
  if (Size = 8) then
  begin
    SizePlos := 6;
    Plos[1, 1] := 1; Plos[1, 2] := 2; Plos[1, 3] := 3;
    Plos[2, 1] := 2; Plos[2, 2] := 3; Plos[2, 3] := 7;
    Plos[3, 1] := 6; Plos[3, 2] := 7; Plos[3, 3] := 8;
    Plos[4, 1] := 5; Plos[4, 2] := 8; Plos[4, 3] := 4;
    Plos[5, 1] := 1; Plos[5, 2] := 2; Plos[5, 3] := 6;
    Plos[6, 1] := 4; Plos[6, 2] := 3; Plos[6, 3] := 7;
  end;
  if Size = 4 then begin
    SizePlos := 4;
    Plos[1, 1] := 1; Plos[1, 2] := 2; Plos[1, 3] := 3;
    Plos[2, 1] := 1; Plos[2, 2] := 3; Plos[2, 3] := 4;
    Plos[3, 1] := 1; Plos[3, 2] := 2; Plos[3, 3] := 4;
    Plos[4, 1] := 3; Plos[4, 2] := 2; Plos[4, 3] := 4;
  end;
  
end;

procedure TRobert.RVisibleGran(outMAtrix: MAtrix; X, Y, Z, P: integer);
var
  i, j, k, xc, yc, zc: integer;
  bv: real;
  Look, center: array[1..4] of integer;
begin
  
  for i := 1 to SizePlos do Add_to_Matrix(outMAtrix, Plos[i, 1], Plos[i, 2], Plos[i, 3], i);
  Look[1] := X; Look[2] := Y; Look[3] := Z; Look[4] := P;
  
  for i := 1 to Size do xc := round(xc + outMAtrix[i, 1]);
  for i := 1 to Size do yc := round(yc + outMAtrix[i, 2]);
  for i := 1 to Size do zc := round(zc + outMAtrix[i, 3]);
  xc := Round(xc / Size);
  yc := Round(yc / Size);
  zc := Round(zc / Size);
  
  center[1] := xc; center[2] := yc; center[3] := zc; center[4] := 1;
  
  for i := 1 to SizePlos do
  begin
    bv := 0;
    for j := 1 to 4 do bv := bv + V[i, j] * center[j];
    if (bv < 0) then for k := 1 to 4 do V[i, k] := V[i, k] * (-1);
  end;
  
  for i := 1 to SizePlos do
  begin
    bv := 0;
    for j := 1 to 4 do bv := bv + V[i, j] * Look[j];
    if(bv > 0) then begin GDraw[i] := true; end else GDraw[i] := false;
  end;
  
end;

procedure TRobert.Add_to_Matrix(a: Matrix; v1, v2, v3, NumSt: integer);
var
  x1, x2, x3, y1, y2, y3, z1, z2, z3: real;
begin
  x1 := a[v1, 1]; y1 := a[v1, 2]; z1 := a[v1, 3];
  x2 := a[v2, 1]; y2 := a[v2, 2]; z2 := a[v2, 3];
  x3 := a[v3, 1]; y3 := a[v3, 2]; z3 := a[v3, 3];
  
  V[NumSt, 1] := Round((y2 - y1) * (z3 - z1) - (z2 - z1) * (y3 - y1));  // ' A
  V[NumSt, 2] := Round((z2 - z1) * (x3 - x1) - (x2 - x1) * (z3 - z1));  // ' B
  V[NumSt, 3] := Round((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1));  // ' C
  V[NumSt, 4] := -Round((V[NumSt, 1] * x1 + V[NumSt, 2] * y1 + V[NumSt, 3] * z1));
end;



end.