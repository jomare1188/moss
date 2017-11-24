function dy = ODEmusgo_PaS(t,y);
global param
global U_PaS


umaxa= param(1,3);
Ks= param(2,3);
I0= 4.49;
e= param(3,3);
L= 0.03;


% unidades de xmax en g/l y N0 tambien esta en g/l

I=I0*exp(-e*y(1)*L);
ua= umaxa*I/(Ks+I);

%dy representa el cambio de la biomasa en el tiempo
dy= ua*y(1);
U_PaS=[U_PaS;I,ua,dy(1),y(1),t];
end