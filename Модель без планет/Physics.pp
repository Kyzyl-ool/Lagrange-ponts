Unit Physics;
{$mode objfpc}

Interface
Uses Points;
Const
	KT=864000;
	KR=1.496e11;
	KM=5.94e28;
	wsx=10; wsy=10;
	
Var
	KG, k, k2, px, py, dt: real;
	phi: real;
	affin: boolean;
	time_for_second: boolean;
	time_for_second_ended: boolean;

Type MatPoint = class(Point)
	Public
		m: real;
		Vx, Vy: real;
		ax, ay: real;
		radius: real;
					
		Constructor Create;
		Destructor Destroy; override;
					
		Procedure Init_DL(ix, iy, ir, ig, ib, iradius, im, iVx, iVy: real);
		Procedure GetAcceleration(iax, iay: real);
		Procedure MakeStep;
		Procedure Show;
		Procedure AddVelocity(dp_x, dp_y: real);
		
		Function GetVx: real;
		Function GetVy: real;
		Function GetX: real;
		Function GetY: real;
		Function GetMass: real;
end;

Implementation
Uses gl, glut;

Constructor MatPoint.Create;
begin
	inherited;
end;

Destructor MatPoint.Destroy;
begin
	inherited;
end;

Procedure MatPoint.MakeStep;
begin
	Vx:=Vx+ax*dt;
	Vy:=Vy+ay*dt;
	x:=x+Vx*dt;
	y:=y+Vy*dt;
end;

Procedure MatPoint.Show;
Var l: real; i: byte;
	_x, _y: real;
	__x, __y: real;
begin
		if k*radius>5e-2
			then
				begin
					glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
					glBegin(GL_POLYGON);
					glColor3f(r, g, b);
					for i:=1 to 20 do
						begin
							l:=i*2*pi/20;
{
							_x:=k*x+wsx/2+cos(l)*radius*k+px;
							_y:=k*y+wsy/2+sin(l)*radius*k+py;
}
							_x:=k*x+cos(l)*radius*k+px;
							_y:=k*y+sin(l)*radius*k+py;
							
							__x:=_x*cos(phi)-_y*sin(phi);
							__y:=_x*sin(phi)+_y*cos(phi);
							__x:=__x + wsx/2;
							__y:=__y + wsy/2;
							
							if affin
								then
									glVertex2f(__x, __y)
								else
									glVertex2f(_x + wsx/2, _y + wsy/2);
						end;
					glEnd();
				end
			else
				begin
					glBegin(GL_POINTS);
						glColor3f(r, g, b);
{
						_x:=k*x+wsx/2;
						_y:=k*y+wsy/2;
}						_x:=k*x;
						_y:=k*y;
						__x:=_x*cos(-phi)-_y*sin(-phi);
						__y:=_x*sin(-phi)+_y*cos(-phi);
						__x:=__x + wsx/2;
						__y:=__y + wsy/2;
						if affin
							then
								begin
									glVertex2f(__x, __y);
								end
							else
								glVertex2f(_x + wsx/2, _y + wsy/2);
						if ((__y + 2 < wsy/2) and (not time_for_second_ended))
										then
											time_for_second:= true;
					glEnd;
				end;

	
		

	glEnd;
end;

Procedure MatPoint.Init_DL(ix, iy, ir, ig, ib, iradius, im, iVx, iVy: real);
begin
	inherited Init(ix/KR, iy/KR, ir, ig, ib);
	m:=im/KM;
	Vx:=iVx/KR*KT;
	Vy:=iVy/KR*KT;
	radius:=iradius;
end;

Procedure MatPoint.GetAcceleration(iax, iay: real);
begin
	ax:=iax;
	ay:=iay;
end;

Function MatPoint.GetVx: real;
begin
	GetVx:=Vx;
end;

Function MatPoint.GetVy: real;
begin
	GetVy:=Vy;
end;

Function MatPoint.GetX: real;
begin
	GetX:=x;
end;

Function MatPoint.GetY: real;
begin
	GetY:=y;
end;

Function MatPoint.GetMass: real;
begin
	GetMass:=m;
end;

Procedure MatPoint.AddVelocity(dp_x, dp_y: real);
begin
	Vx:=Vx + dp_x;
	Vy:=Vy + dp_y;
end;

end.
