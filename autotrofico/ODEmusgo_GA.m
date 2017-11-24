function dy = ODEmusgo_GA(t,y);
global param
global U_GA


umaxa= param(1,1);
Ks= param(2,1);
I0= 4.49;
e= param(3,1);
L= 0.03;


% unidades de xmax en g/l y N0 tambien esta en g/l

I=I0*exp(-e*y(1)*L);
ua= umaxa*I/(Ks+I);

%dy representa el cambio de la biomasa en el tiempo
dy= ua*y(1);
U_GA=[U_GA;I,ua,dy(1),y(1),t];
end