function error= fobj_clor(p)
% Esta funcion ejecuta el ODE que contiene el modelo y calcula el error a
% partir de los valores simulados y los medidos por los sensores

global ydata_norm
global t_clor_norm
global t 
global param
global tspan_clor
global ydata_clor_norm


function dy = modelmusgo(t,y)

Ks=0.0031191;
e =328.75;
I0= 4.49;
L= 0.03;
umaxa= 3.9076;
B= p(1);
C= p(2);


% unidades de xmax en g/l y N0 tambien esta en g/l

I=I0*exp(-e*y(1)*L);
ua= umaxa*I/(Ks+I);


dy(1)= (umaxa*(I0*exp(-e*y(1)*L))/(Ks+(I0*exp(-e*y(1)*L))))*y(1);
dy(2)=y(1)*B*(-C/(I0*exp(-e*y(1)*L))+uma xa*(I0*exp(-e*y(1)*L))/(Ks+(I0*exp(-e*y(1)*L))));

dy=[dy(1); dy(2)];
end


y0=[min(ydata_norm) 0.6245] ;

tspan_clor=[0:0.1:28]./28;
[tsim, y]=ode15s(@modelmusgo,tspan_clor,y0);               % se resuelve el ODE del modelo

% NECESITO CALCULAR EL ERROR CON LOS PUNTOS QUE CORRESPONDEN A LA SITUACION MEDIDA

ydata_=[t_clor_norm ydata_clor_norm] ;        %agrego la primera columna tiempo para poder comaparar en los datos experimentales
y=[tsim y];                          %agrego la primera columna tiempo para poder comaparar en los datos simulados


% MIRO DATO POR DATO LA COINCIDENCIA EN EL VECTOR TIEMPO PARA COMPARAR LOS


contador=0;
errorclor=zeros(size(ydata_,1),1);

for i=1:size(ydata_,1);
    for j=1:size(y,1) ; 
        if y(j,1)==ydata_(i,1);
            errorclor(i)=(y(j,3)-ydata_(i,2))^2;
            contador=contador+1;
        end
    end
end

 
error=sum(errorclor)/size(errorclor,1); % error medio cuadrado EMC

 

end