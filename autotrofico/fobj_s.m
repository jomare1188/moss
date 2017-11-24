function error= fobj_s(p)
% Esta funcion ejecuta el ODE que contiene el modelo y calcula el error a
% partir de los valores simulados y los medidos por los sensores

global ydata
global ydata_norm
global t_norm
global t 
global param
global tspan



function dy = modelmusgo(t,y)


umaxa= p(1);
Ks= p(2);
I0= 4.49;
e= p(3);
L= 0.03;


% unidades de xmax en g/l y N0 tambien esta en g/l

I=I0*exp(-e*y(1)*L);
ua= umaxa*I/(Ks+I);

%dy representa el cambio de la biomasa en el tiempo
dy= ua*y(1);

 
end


y0= min(ydata_norm) ;

tspan=[0:1:68]./68;
[tsim,y]=ode15s(@modelmusgo,tspan,y0);               % se resuelve el ODE del modelo

% NECESITO CALCULAR EL ERROR CON LOS PUNTOS QUE CORRESPONDEN A LA SITUACION MEDIDA

ydata_=[t_norm ydata_norm];         %agrego la primera columna tiempo para poder comaparar en los datos experimentales
y=[tsim y];                          %agrego la primera columna tiempo para poder comaparar en los datos simulados


% MIRO DATO POR DATO LA COINCIDENCIA EN EL VECTOR TIEMPO PARA COMPARAR LOS


contador=0;
errorbiomasa=zeros(size(ydata_,1),1);

for i=1:size(ydata_,1);
    for j=1:size(y,1) ; 
        if y(j,1)==ydata_(i,1);
            errorbiomasa(i)=(y(j,2)-ydata_(i,2))^2;
            contador=contador+1;
        end
    end
end

 
error=sum(errorbiomasa)/size(errorbiomasa,1); % error medio cuadrado EMC

 

end