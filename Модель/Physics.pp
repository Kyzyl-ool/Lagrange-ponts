Unit Physics;
{$mode objfpc}

Interface
Uses Points;
Const
	KT=864000;
	KR=1.496e9;
	KM=5.94e28;
	wsx=10; wsy=10;
	
Var
	KG, k, k2, px, py, dt: real;
	

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
							glVertex2f(k*x+wsx/2+cos(l)*radius*k+px, k*y+wsy/2+sin(l)*radius*k+py);
						end
				end
			else
				begin
					glBegin(GL_POINTS);
						glColor3f(r, g, b);
						glVertex2f(k*x+wsx/2, k*y+wsy/2);
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
