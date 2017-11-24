function dy = ODEmusgo_GA_clor(t,y);
global param
global U_PS_clor


Ks=0.0031191;
e =328.75;
I0= 4.49;
L= 0.03;
umaxa= 3.9076;
B= param(1,1);
C= param(2,1);


% unidades de xmax en g/l y N0 tambien esta en g/l

I=I0*exp(-e*y(1)*L);
ua= umaxa*I/(Ks+I);


dy(1)= (umaxa*(I0*exp(-e*y(1)*L))/(Ks+(I0*exp(-e*y(1)*L))))*y(1);
dy(2)=y(1)*B*(-C/(I0*exp(-e*y(1)*L))+umaxa*(I0*exp(-e*y(1)*L))/(Ks+(I0*exp(-e*y(1)*L))));

dy=[dy(1); dy(2)];
end