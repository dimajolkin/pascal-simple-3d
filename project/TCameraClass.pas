unit TCameraClass;

interface

uses GraphABC;

type
  TCamera = class     //класс Камеры Содержит точки обзора  и настройки
    X, Y, Z: integer;
    XRot, YRot, ZRot: boolean;
    Step: integer;
    Access: boolean;
    
    Zk, Zpr: real;
  private
    st: string;
    X0, Y0: integer;
  
  public
    constructor Create;
    begin
      x := 250;
      y := 250;
      
      Zk := -90;
      Zpr := 100;
      
      z := 0;
      Access := true;
      Step := 5;
      XRot := True;
      YRot := False;
      ZRot := False;
    end;
    
    procedure Setting_interfase(X, Y: integer);
    begin
      X0 := X; Y0 := Y;
    end;
    
    procedure SetupMonitor(Z1, Z2: real);begin Zk := Z1; Zpr := Z2; end;
    
    procedure SetupSingleCamera(Step_loka: integer; Line: String);
    begin
      textout(x0, y0, '   ');
      St := ' X=' + IntToStr(X) + ' Y=' + IntToStr(Y) + ' Z=' + IntToStr(Z);
      textout(x0, y0 - 15, St);
      if (Line = 'X') then begin
        XRot := True;
        YRot := False;
        ZRot := False;
        if (Access and (Step_loka > 0)) then textout(X0, Y0, ' OX');
        if (Access and (Step_loka < 0)) then textout(X0, Y0, '-OX');
        
      end;
      if (Line = 'Y') then begin
        XRot := False;
        YRot := True;
        ZRot := False;
        if (Access and (Step_loka > 0)) then textout(X0, Y0, ' OY');
        if (Access and (Step_loka < 0)) then textout(X0, Y0, '-OY');
        
      end;
      if (Line = 'Z') then begin
        XRot := False;
        YRot := False;
        ZRot := True;
        if (Access and (Step_loka > 0)) then textout(X0, Y0, ' OZ');
        if (Access and (Step_loka < 0)) then textout(X0, Y0, '-OZ');
      end;
      if (Line = '0') then begin
        XRot := False;
        YRot := False;
        ZRot := False;
        if (Access and (Step_loka > 0)) then textout(X0, Y0, ' OZ');
        if (Access and (Step_loka < 0)) then textout(X0, Y0, '-OZ');
        
      end;
      Step := Step_loka;
    end;
  end;//Конец класса Камеры

implementation



end.