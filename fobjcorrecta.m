

function [error]= fobjcorrecta(p)
% Esta funcion ejecuta el ODE que contiene el modelo y calcula el error a
% partir de los valores simulados y los medidos por los sensores
global tspan
global ydata
global t
global y
global tsim
global t_norm
global ydata_norm



function dy = modelmusgo(t,y)


umaxa= p(1);
Ks= p(2);
I0= 4.49;
e= p(3);
L= 0.03;
alfa= p(4);
beta=p(5);

% unidades de xmax en g/l y N0 tambien esta en g/l
%I=(I0/(e*y(1)*y(2)*L))*(1-(exp(-e*y(1)*y(2)*L)))
I=(I0/(e*y(1)*L*y(2))*(1-(exp(-e*y(1)*y(2)*L))));
ua= umaxa*I/(Ks+I);
rc=beta*ua;
rd=alfa*y(2);

%dy(1) representa el cambio de la biomasa en el tiempo
%dy(2) Producción de clorofilas

dy(1)= ua*y(1);
dy(2)=y(1)*(rc-rd);
%dy(2)=rc*y(2)-y(1)*o
%dy(2)= (n*ua)-(y(2)*ua);
dy= [dy(1); dy(2)];
 
end

%y0= [231.578947];
y0= [231.578947/max(max(ydata)) 0.0094023/min(max(ydata))]; 

tspan=[0:1:48]./48;
[tsim,y]=ode15s(@modelmusgo,tspan,y0);               % se resuelve el ODE del modelo

% NECESITO CALCULAR EL ERROR CON LOS PUNTOS QUE CORRESPONDEN A LA SITUACION MEDIDA

ydata_=[t_norm ydata_norm];         %agrego la primera columna tiempo para poder comaparar en los datos experimentales
y=[tsim y];            %agrego la primera columna tiempo para poder comaparar en los datos simulados


% MIRO DATO POR DATO LA COINCIDENCIA EN EL VECTOR TIEMPO PARA COMPARAR LOS
% DATOS 
% errortotal= (errorbiomasa)+ (errorsugar)+(errorfot)

contador=0;
errorbiomasa=zeros(size(ydata_,1),1);
errorcloro=zeros(size(ydata_,1),1);

for i=1:size(ydata_,1);
    for j=1:size(y,1) ; 
        if y(j,1)==ydata_(i,1);
            errorbiomasa(i)=(y(j,2)-ydata_(i,2))^2;
            errorcloro(i)=(y(j,3)-ydata_(i,3))^2;
            contador=contador+1;
        end
    end
end

%error=0.9*mean(errorbiomasa)/max(errorbiomasa)+0.1*mean(errorcloro)/max(errorcloro); % en la primera columna estan los datos 
error=sum(errorbiomasa)+sum(errorcloro);

 
% figure (1)
% set(gca, 'fontsize',14,'fontweight','bold'); 
% subplot(1,2,1) 
% plot(t,ydata,'r+','markersize',10) 
% hold on
% plot(t,(y(:,1)),'-r','linewidth',2.5)
% hold off
% xlabel('dias')
% ylabel('mg/L') 
% legend('Biomasa mg/L')
% 
% subplot(1,2,2) 
% plot(t,y(:,2),'-g','linewidth',2.5) 
% hold on
% plot(t,y(:,3),'-b','linewidth',2.5)
% hold off
% legend('dioxido de carbono mg/L','bicarbonato mg/L') 
% 
% pause(0.1)
end


