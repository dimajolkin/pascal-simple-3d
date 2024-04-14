uses Crt, GraphABC, TCameraClass, TSceneClass;

var
  Scene: TScene;
  Camera: TCamera;
  key: char;

begin
  Scene := TScene.Create(clWhite, clRed, 500, 500);
  Camera := TCamera.Create;
  Camera.SetupMonitor(-150, 200);//Zk,Zpr
  
    ///  Scene.RandomCreateObject(5,5,50,50,50,50);
  Scene.Position_Scene(5, 50, 50, 50, 50);
     //     Scene.CreateSingleObject('Cube',100,100);  //Рyramid  And Сube
  
  Scene.MSObject[1].center; //Ставим глаз в середину 1 объекта
  Camera.X := Round(Scene.MSObject[1].TcenterX);
  Camera.Y := Round(Scene.MSObject[1].TcenterY);
  Camera.Z := Round(Scene.MSObject[1].TcenterZ);
  
    //Static:
  Camera.SetupSingleCamera(60, 'Z'); Scene.Flight(Camera);
  Camera.SetupSingleCamera(120, 'Y'); Scene.Flight(Camera);
      //Static end;
  Camera.step := 5;
  Camera.Setting_interfase(10, Scene.GCHeight - 30);
  while(true) do
  begin
    key := readkey();
    case key of
      'q': Camera.SetupSingleCamera(5, 'X');
      'a': Camera.SetupSingleCamera(-5, 'X');
      
      'w': Camera.SetupSingleCamera(5, 'Y');
      's': Camera.SetupSingleCamera(-5, 'Y');
      
      'e': Camera.SetupSingleCamera(5, 'Z');
      'd': Camera.SetupSingleCamera(-5, 'Z');
      
      'z':
        begin
          window(0, 0, 20, 20);
          textout(10, 10, '                              ');
          textout(10, 25, '                              ');
          writeln('Введите новые коодинаты точки обзора:');
          Readln(Camera.x, Camera.y, Camera.z);
          clrscr;
        end;
      '0':
        begin
          Camera.Zk := Camera.Zk + 5;
          Camera.SetupSingleCamera(0, '0');
          Scene.Flight(Camera);
        end;
      
      '9': 
      begin Camera.Zk := Camera.Zk - 5; Camera.SetupSingleCamera(0, '0'); Scene.Flight(Camera); end;
      '1':
        begin
          if (Scene.Screening) then Scene.Screening := false else Scene.Screening := true;
          Scene.DrawMassivRebock(false);
          Camera.SetupSingleCamera(0, '0');
          Scene.Flight(Camera);
        end;
      '2':
        begin
          if (Scene.perspect) then Scene.perspect := false else Scene.perspect := true;
          Camera.SetupSingleCamera(0, '0');
          Scene.Flight(Camera);
        end;
      ' ': Scene.Flight(Camera);
    end;
  end;
  
end.