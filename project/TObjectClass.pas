unit TObjectClass;

interface

uses GraphABC, TRobertClass, TMatrix;

type
  TObject = class
    MatrixObject: Matrix;
    BMatrixObject: Matrix;
    Size: integer;
    Robert: TRobert;
    TcenterX, TcenterY, TcenterZ: real;
    BuferDraw: boolean;
    constructor Create(ObjectType: String; Width, Height: Real);
    procedure Center;
    procedure Draw(Color: System.Drawing.Color);
    procedure Rect(v1, v2, v3, v4: byte);
    procedure Treg(v1, v2, v3: byte);
    
    procedure Add(S1: Matrix);begin BMatrixObject := S1; end;
    
    procedure App(S1: Matrix);begin MatrixObject := S1; end;
  end;


implementation

constructor TObject.Create(ObjectType: String; Width, Height: Real);
var
  T, W: real;
  i: integer;
begin
  T := Height;
  W := Width;
  
  if (ObjectType = 'Cube') then begin
    Size := 8;
    MatrixObject[1, 1] := 0; MatrixObject[2, 1] := Width; MatrixObject[3, 1] := Width; MatrixObject[4, 1] := 0;
    MatrixObject[1, 2] := 0; MatrixObject[2, 2] := 0; MatrixObject[3, 2] := Width; MatrixObject[4, 2] := Width;
    MatrixObject[1, 3] := 0; MatrixObject[2, 3] := 0; MatrixObject[3, 3] := 0; MatrixObject[4, 3] := 0;
    MatrixObject[1, 4] := 1; MatrixObject[2, 4] := 1; MatrixObject[3, 4] := 1; MatrixObject[4, 4] := 1;
    
    MatrixObject[5, 1] := 0; MatrixObject[6, 1] := Width; MatrixObject[7, 1] := Width; MatrixObject[8, 1] := 0;
    MatrixObject[5, 2] := 0; MatrixObject[6, 2] := 0; MatrixObject[7, 2] := Width; MatrixObject[8, 2] := Width;
    MatrixObject[5, 3] := T; MatrixObject[6, 3] := T; MatrixObject[7, 3] := T; MatrixObject[8, 3] := T;
    MatrixObject[5, 4] := 1; MatrixObject[6, 4] := 1; MatrixObject[7, 4] := 1; MatrixObject[8, 4] := 1;
  end;
  if (ObjectType = 'Рyramid') then begin
    Size := 4;
    MatrixObject[1, 1] := 0; MatrixObject[2, 1] := W; MatrixObject[3, 1] := -W; MatrixObject[4, 1] := Round((MatrixObject[1, 1] + MatrixObject[2, 1] + MatrixObject[3, 1]) / 4);
    MatrixObject[1, 2] := W; MatrixObject[2, 2] := -W; MatrixObject[3, 2] := -W; MatrixObject[4, 2] := Round((MatrixObject[1, 2] + MatrixObject[2, 2] + MatrixObject[3, 2]) / 4);
    MatrixObject[1, 3] := 0; MatrixObject[2, 3] := 0; MatrixObject[3, 3] := 0; MatrixObject[4, 3] := T;
    MatrixObject[1, 4] := 1; MatrixObject[2, 4] := 1; MatrixObject[3, 4] := 1; MatrixObject[4, 4] := 1;
  end;
  Robert := TRobert.Create(Size);
end;

procedure TObject.Center;
var
  i: integer;
begin
  for i := 1 to Size do TcenterX := TcenterX + MatrixObject[i, 1];
  for i := 1 to Size do TcenterY := TcenterY + MatrixObject[i, 2];
  for i := 1 to Size do TcenterZ := TcenterZ + MatrixObject[i, 3];
  TCenterX := (TcenterX / Size);
  TCenterY := (TCenterY / Size);
  TCenterZ := (TCenterZ / Size);
end;

procedure TObject.Rect(v1, v2, v3, v4: byte);
var
  x1, y1, x2, y2, x3, y3, x4, y4: real;
begin
  if BuferDraw then begin
    x1 := BMatrixObject[v1, 1]; y1 := BMatrixObject[v1, 2];
    x2 := BMatrixObject[v2, 1]; y2 := BMatrixObject[v2, 2];
    x3 := BMatrixObject[v3, 1]; y3 := BMatrixObject[v3, 2];
    x4 := BMatrixObject[v4, 1]; y4 := BMatrixObject[v4, 2];
  end else begin
    x1 := MatrixObject[v1, 1]; y1 := MatrixObject[v1, 2];
    x2 := MatrixObject[v2, 1]; y2 := MatrixObject[v2, 2];
    x3 := MatrixObject[v3, 1]; y3 := MatrixObject[v3, 2];
    x4 := MatrixObject[v4, 1]; y4 := MatrixObject[v4, 2];
  end;
  
  Line(Round(x1), Round(y1), Round(x2), Round(y2));
  Line(Round(x2), Round(y2), Round(x3), Round(y3));
  Line(Round(x3), Round(y3), Round(x4), Round(y4));
  Line(Round(x4), Round(y4), Round(x1), Round(y1));
end;

procedure TObject.Treg(v1, v2, v3: byte);
var
  x1, y1, x2, y2, x3, y3: real;
begin
  if BuferDraw then begin
    x1 := BMatrixObject[v1, 1]; y1 := BMatrixObject[v1, 2];
    x2 := BMatrixObject[v2, 1]; y2 := BMatrixObject[v2, 2];
    x3 := BMatrixObject[v3, 1]; y3 := BMatrixObject[v3, 2];
  end else begin
    x1 := MatrixObject[v1, 1]; y1 := MatrixObject[v1, 2];
    x2 := MatrixObject[v2, 1]; y2 := MatrixObject[v2, 2];
    x3 := MatrixObject[v3, 1]; y3 := MatrixObject[v3, 2];
  end;
  Line(Round(x1), Round(y1), Round(x2), Round(y2));
  Line(Round(x2), Round(y2), Round(x3), Round(y3));
  Line(Round(x3), Round(y3), Round(x1), Round(y1));
end;

procedure TObject.Draw(Color: System.Drawing.Color);
var
  i: integer;
begin
  SetPenColor(Color);
  if (Size = 8) then begin
    if (not (Robert.GDraw[1])) then Rect(1, 2, 3, 4);
    if (not (Robert.GDraw[2])) then Rect(2, 3, 7, 6);
    if (not (Robert.GDraw[3])) then Rect(6, 7, 8, 5);
    if (not (Robert.GDraw[4])) then Rect(5, 8, 4, 1);
    if (not (Robert.GDraw[5])) then Rect(1, 2, 6, 5);
    if (not (Robert.GDraw[6])) then Rect(4, 3, 7, 8);
  end;
  if (Size = 4) then begin
    if (not (Robert.GDraw[1])) then Treg(1, 2, 3);
    if (not (Robert.GDraw[2])) then Treg(1, 3, 4);
    if (not (Robert.GDraw[3])) then Treg(1, 2, 4);
    if (not (Robert.GDraw[4])) then Treg(3, 2, 4);
    
  end;
end;

end.