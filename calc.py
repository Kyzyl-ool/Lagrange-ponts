from math import *

L_Earth = 1.4959e11
M_Sun = 1.989e30
M_Earth = 5.97e24
V = 29783
Omega = 2*pi/365.25/86400
G = 6.67*(10**(-11))


beta = (M_Sun - M_Earth)/(M_Sun + M_Earth)

r4_x = L_Earth/2*beta
r4_y = (3/4)**0.5*L_Earth

rC_x = M_Earth*L_Earth/(M_Earth + M_Sun)
rC_y = 0

r_L4_x = r4_x + rC_x
r_L4_y = r4_y + rC_y

L4 = ((r_L4_x)**2 + (r_L4_y)**2)**0.5w

print('L4 =', (((Omega*V)**2+G*M_Sun)**0.5-V*Omega)**0.5)

u = V*L4/L_Earth

u_x = u*cos(30/360*2*pi)
u_y = u*sin(30/360*2*pi)

print(r_L4_x, r_L4_y, sep = ', ')
print(u_x, u_y, sep = ', ')
