Program SunSystem;

{$DEFINE SPEED_SHOW}

Uses crt, gl, glut, Physics, Points;

Const
	constant = 0.3411;

Var planets: array[0..2] of MatPoint;
tabbed, take: boolean;
time: Extended;
dVx, dVy: Extended;
V: Extended;
prev: Extended;

Procedure glWrite(x, y: Extended; Font: Pointer; Text: string); // процедура рисования строки на графическом экране
Var i: word;
begin
	glRasterPos2f(x, y);
	for i:=1 to length(text) do
		begin
			glutBitmapCharacter(Font, Integer(Text[i]));
		end;
end;

Procedure take_impulse;
begin
	take:=true;
	planets[2].AddVelocity(dVx, dVy);
end;

Procedure draw; cdecl;
Var i: byte; bufer: string;
	_x, _y, __x, __y: Extended;
begin
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
	glPointSize(2);
	glEnable(GL_POINT_SMOOTH);
	for i:=0 to 2 do planets[i].Show;
	
	glColor3f(1, 1, 1);
	glWrite(0.2, 0.2, GLUT_BITMAP_9_BY_15, 'Press "Esc" for exit');
	glWrite(0.2, 0.6, GLUT_BITMAP_9_BY_15, 'Press "Tab" to see names');
	glWrite(0.2, 0.4, GLUT_BITMAP_9_BY_15, 'Press "+" and "-" for resizing');
	str(time/365.2563/86400:6:2, bufer);
	glWrite(0.2, 0.8, GLUT_BITMAP_9_BY_15, 'Time: '+bufer+' years');
{
	str(phi/2/pi*360:6:2, bufer);
	glWrite(0.2, 1.0, GLUT_BITMAP_9_BY_15, 'Angle: '+bufer+'.');
}
	
	if tabbed
		then
			begin
				glWrite(planets[0].GetX*k+wsx/2, planets[0].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Sun');
				glWrite(planets[1].GetX*k+wsx/2, planets[1].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Earth');
{
				glWrite(planets[1].GetX*k+wsx/2, planets[1].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Mercury');
				glWrite(planets[2].GetX*k+wsx/2, planets[2].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Venus');
				
				glWrite(planets[4].GetX*k+wsx/2, planets[4].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Mars');
				glWrite(planets[5].GetX*k+wsx/2, planets[5].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Jupiter');
				glWrite(planets[6].GetX*k+wsx/2, planets[6].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Saturn');
				glWrite(planets[7].GetX*k+wsx/2, planets[7].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Uranus');
				glWrite(planets[8].GetX*k+wsx/2, planets[8].GetY*k+wsy/2, GLUT_BITMAP_8_BY_13, 'Neptune');
}
			end;
	
	{$IFDEF SPEED_SHOW}
	for i:=0 to 2 do
		begin
			glBegin(GL_LINES);
			glColor3f(1, 0, 0);
			
			glVertex2f(wsx/2+planets[i].x*k, wsy/2+planets[i].y*k);
			glVertex2f(wsx/2+planets[i].x*k + planets[i].Vx*k, wsy/2+planets[i].y*k + planets[i].Vy*k);
	
		end;
		
	
	glColor3f(0, 1, 0);
	glVertex2f(wsx/2+planets[2].x*k, wsy/2+planets[2].y*k);
	glVertex2f(wsx/2+planets[2].x*k + dVx*k, wsy/2+planets[2].y*k + dVy*k);
	glEnd();
	{$ENDIF}
	
	glBegin(GL_POINTS);
	glColor3f(1, 0, 0);
	_x:=1*k/2;
	_y:=-129557400406.15/KR*k;
	__x:=_x*cos(phi)-_y*sin(phi);
	__y:=_x*sin(phi)+_y*cos(phi);
	if affin
		then
			glVertex2f(_x + wsx/2, _y + wsy/2)
		else
			glVertex2f(__x + wsx/2, __y + wsy/2);
	glEnd;
	
	
	if (take) and (sqr(__x/k - planets[2].x)+sqr(__y/k - planets[2].y) - prev > 0)
		then
			begin
				take_impulse;
				take := false;
				writeln('eps = ', sqr(__x/k - planets[2].x)+sqr(__y/k - planets[2].y):20:10);
			end;
	
	prev:=sqr(__x/k - planets[2].x)+sqr(__y/k - planets[2].y);
	
	glFlush;
end;

Procedure refresh; cdecl;
Var i, j: shortint; r, sx, sy, bufer: Extended;
begin
	time:=time+KT*dt;
	for i:=1 to 2 do
		begin
			sx:=0; sy:=0;
				for j:=0 to 2 do if i<>j then
				begin
					r:=sqrt(
							sqr(planets[i].GetX-planets[j].GetX)
						   +sqr(planets[i].GetY-planets[j].GetY));
					bufer:=KG/r/r/r*planets[j].GetMass;
					sx:=sx-bufer*(planets[i].GetX-planets[j].GetX);
					sy:=sy-bufer*(planets[i].GetY-planets[j].GetY);
			
				end;
				planets[i].GetAcceleration(sx, sy);
				planets[i].MakeStep;
		end;
	
	phi:=phi+KT*dt*2*pi/365.2563/86400;
	V:=2*pi/365.2563/86400*KT*sqrt(sqr(planets[2].x)+sqr(planets[2].y));
	
	if not take
		then
			begin
				dVx:= -(planets[2].Vx) + constant*(planets[1].x - planets[2].x);
				dVy:= -(planets[2].Vy) + constant*(planets[1].y - planets[2].y);
			end
		else
			begin
				dVx:= -(planets[2].Vx) - V*planets[2].y/sqrt(sqr(planets[2].x)+sqr(planets[2].y));
				dVy:= -(planets[2].Vy) + V*planets[2].x/sqrt(sqr(planets[2].x)+sqr(planets[2].y));
			end;
	
	
{
	dVx:= planets[1].x - planets[2].x;
	dVy:= planets[1].y - planets[2].y;
}
	
	glutPostRedisplay()
end;

Procedure kbd(key: byte; x, y: longint); cdecl;
begin
	Case key of
			27: halt(1);
			61: k:=k*2;
			45: k:=k/2;
			9:  if not tabbed then tabbed:=true else tabbed:=false;
			95: dt:=dt/1.2;
			43: dt:=dt*1.2;
			96: take_impulse;
			32: affin:=not affin;
		else writeln(key);
	end;
end;

Var i: shortint;
Begin
	dt:=0.001;
	k:=3;
	KG:=6.67e-11;
	px:=0; py:=0;
	time:=0;
	phi:=0;
	KG:=KG/KR/KR/KR*KM*KT*KT;
	tabbed:=false;
	affin:=false;
	take:=false;
	
	//Инициализации
	
	//Солнце
	planets[0]:=MatPoint.Create;
	planets[0].Init_DL(0, 0, 1, 1, 0, 696000*10e3/KR, 1.989e30, 0, 0);
	
{
	//Меркурий
	planets[1]:=MatPoint.Create;
	planets[1].Init_DL(5.791e10, 0, 170/255, 120/255, 90/255, 2440000/KR, 3.285e23, 0, 47.36e3);
	
	//Венера
	planets[2]:=MatPoint.Create;
	planets[2].Init_DL(1.082e11, 0, 220/255, 200/255, 170/255, 6052000/KR, 4.8685e24, 0, 35.02e3);
}
	
	//Земля
	planets[1]:=MatPoint.Create;
	planets[1].Init_DL(1.4959e11, 0, 0, 0, 1, 6400000/KR, 5.97e24, 0, 29783);
	
{
	//Марс
	planets[4]:=MatPoint.Create;
	planets[4].Init_DL(2.253e11, 0, 0.5, 0, 0, 3390000/KR, 6.4185e23, 0, 24.13e3);
	
	//Юпитер
	planets[5]:=MatPoint.Create;
	planets[5].Init_DL(7.785e11, 0, 100/255, 60/255, 50/255, 69911000/KR, 1.89e27, 0, 13.07e3);
	
	//Сатурн
	planets[6]:=MatPoint.Create;
	planets[6].Init_DL(1.433e12, 0, 0.5, 0.5, 0, 58232000/KR, 5.68e26, 0, 9.69e3);
	
	//Уран
	planets[7]:=MatPoint.Create;
	planets[7].Init_DL(2.877e12, 0, 200/255, 244/255, 244/255, 25362000/KR, 8.6832e25, 0, 6.81e3);
	
	//Нептун
	planets[8]:=MatPoint.Create;
	planets[8].Init_DL(4.498e12, 0, 0, 0, 1, 24622000/KR, 1.0243e26, 0, 5.43e3);
	
}
	//Тело в L4
	planets[2]:=MatPoint.Create;
	planets[2].Init_DL(KR/2, 129557400406.15, 1, 1, 1, 24622000/KR, 1e3, -25792.834600911938, 14891.499999999998);
	
	glutInit(@argc, argv);
	glutInitWindowSize(650, 650);
	glutInitWindowPosition(30, 30);
	glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB);
	glutCreateWindow('Solar System');
	
	glClearColor(0, 0, 0, 0);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrtho(0, 10, 0, 10, -1, 1);
	
	
	glutDisplayFunc(@draw);
	glutIdleFunc(@refresh);
	glutKeyboardFunc(@kbd);
	
	glutMainLoop();
	
	for i:=0 to 2 do planets[i].Destroy;
End.
