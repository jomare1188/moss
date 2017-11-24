function dy = ODEmusgo_PaS(t,y)

global param
global U_PaS



umaxa= param(1,2);
Ks= param(2,2);
I0= 4.49;
e= param(3,2);
L= 0.03;
alfa= param(4,2);
beta=param(5,2);




% U_PSnidades de xmax en g/l y N0 tambien esta en g/l
%I=(I0/(e*y(1)*y(2)*L))*(1-(exp(-e*y(1)*y(2)*L)))
I=(I0/(e*y(1)*L))*(1-(exp(-e*y(1)*L)));
ua= umaxa*I/(Ks+I);
rc=beta*ua;
rd=alfa*y(1);

%dy(1) representa el cambio de la biomasa en el tiempo
%dy(2) ProdU_PScción de clorofilas

dy(1)= ua*y(1);
dy(2)=y(1)*(rc-rd);
%dy(2)=rc*y(2)-y(1)*o
%dy(2)= (n*U_PSa)-(y(2)*U_PSa);
dy= [dy(1); dy(2)];
U_PaS=[U_PaS;I,ua,rc,rd,dy(1),dy(2), t];
end