%% Codigo que calibra los parametros del modelo para que su resultado sea el medido por los sensores
clear all
clc
close all

%% defino variables globales que se usan para el ODE de la funcion objetivo
global ydata
global ydata_norm
global t_norm
global t
global param
global U_PS
global U_GA
global U_PaS
global tspan
global t_clor_norm
global ydata_clor_norm
 
%% defino datos experimentales  defino el tiempo de muestreo 
t= [0:4:68]';      % defino el tiempo 
t_norm= t./max(t); % NORMALIZO

% defino los datos experimentales para el crecimiento de biomasa
ydata= [231.57 271.05 373.68 518.42 526.31 647.36 734.21 810.52 890 970 998 1003 1000 1005 1003 1002 1003 1004]'; % set de datos experimentales para la biomasa 810.52 es el ultimo dato real
ydata_norm =ydata./max(ydata);


%% opciones globales para los algoritmos de optimización

lb=[3.8; 1e-3; 280];  
ub=[4.3; 1e-1; 400]; 
fun=@fobj_s; 
nvars=3;
x0=[3.9612; 0.004071; 320];  %% initial guess
% opciones vacias 
A=[]; 
b=[]; 
Aeq=[]; 
beq=[]; 
nonlcon=[];
IntCon=[];
 
%%  ALGORITMO GENETICO 


%options = optimoptions('ga','PlotFcn',@gaplotbestf,'MaxGenerations',500);
options = optimoptions('ga','MaxGenerations',500);
tic
[paramGA,Fval,~,Output] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,options);
toc 
fprintf('GA The number of generations was : %d\n', Output.generations);
fprintf('GA The number of function evaluations was : %d\n', Output.funccount);
fprintf('GA The best function value found was : %g\n', Fval);
ERROR(2)=Fval;

%% PATTERN SEARCH 
 
options = optimoptions(@patternsearch);

tic;
[paramPS,fval,flag,Output] = patternsearch(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
toc

fprintf('Pattern Search The number of iterations was : %d\n', Output.iterations);
fprintf('Pattern Search The number of function evaluations was : %d\n', Output.funccount);
fprintf('Pattern Search The best function value found was : %g\n', fval);
ERROR(1)=fval;

%%   PARTICLE SWARM

options = optimoptions(@particleswarm,'HybridFcn',@fmincon );
rng default 
tic
[paramPaS,fval,~,Output] = particleswarm(fun,nvars,lb,ub,options);
toc
fprintf('The number of function evaluations was : %d\n', Output.funccount);
fprintf('Particle Swarm The number of iterations was : %d\n', Output.iterations);
fprintf('Particle Swarm The number of function evaluations was : %d\n', Output.funccount);
fprintf('Particle Swarm The best function value found was : %g\n', fval);
ERROR(3)=fval;

%% ORGANIZO LA INFORMACIÓN PARA METERLA EN LA TABLA 

n=size(paramPS,1);
paramPS(n+1)=ERROR(1);
paramPS=paramPS;

paramGA(n+1)=ERROR(2);
paramGA=paramGA';

paramPaS(n+1)=ERROR(3);
paramPaS=paramPaS';

param=[paramGA paramPS paramPaS];

table(paramGA ,paramPS,paramPaS,'RowNames',{'Umax_aut';'Ks';'e';'Error'})

%% EJECUTO EL SCRIPT CON LAS GRAFICAS 
%% PATTERN SEARCH
                       
y0= 231.578947/max(ydata); 
[tsim_PS,y_PS]=ode15s(@ODEmusgo_PS,tspan,y0);               % se resuelve el ODE del modelo
figure
subplot (2,3,1)
plot(tsim_PS,y_PS(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('Pattern search')
xlabel('tiempo')
ylabel('biomasa')


                                     

%% ALGORITMO GENÉTICO

[tsim_GA,y_GA]=ode15s(@ODEmusgo_GA,tspan,y0);               % se resuelve el ODE del modelo
subplot(2,3,2)
plot(tsim_GA,y_GA(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'-',t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('GA')
xlabel('tiempo')
ylabel('biomasa')


%% PARTICLE SWARM X VS T

[tsim_PaS,y_PaS]=ode15s(@ODEmusgo_PaS,tspan,y0);               % se resuelve el ODE del modelo
subplot(2,3,3)
plot(tsim_PaS,y_PaS(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'-',t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('Particle Swarm')
legend ('biomasa vs t_norm')
xlabel('tiempo')
ylabel('biomasa')
%% PARTICLE SWARM I VS X
subplot(2,3,6)
plot(U_PaS(:,4),U_PaS(:,1))

legend ('biomasa vs I')
title('Particle Swarm')
legend ('biomasa vs I')
xlabel('Biomasa')
ylabel('Intensidad')
%% PATTERN SEARCH I VS X


subplot(2,3,4)
plot(U_PS(:,4),U_PS(:,1))

legend ('biomasa vs I')
title('Pattern search')
legend ('biomasa vs I')
xlabel('Biomasa')
ylabel('Intensidad')
%% Genetic algorithm I VS X


subplot(2,3,5)
plot(U_GA(:,4),U_GA(:,1))

legend ('biomasa vs I')
title('Genetic algorithm')
legend ('biomasa vs I')
xlabel('Biomasa')
ylabel('Intensidad')

%% VALIDACION 1

yval=[58.11965812; 73.68421053; 131.5789474; 194.7368421; 305.2631579; 373.6842105; 371.0526316; 443.8596491; 584.2105263; 710.5263158; 1021.052632; 1178.947368];
yval_norm=yval./max(yval);

tval=[0:3:33]';
tval_norm=tval./max(tval);
tspan_val1=[0:0.1:33]./33;

y0_val=min(yval)/max(yval);
[tsim_val,ysim_val]=ode15s(@ODEmusgo_val,tspan_val1,y0_val); 

yval_norm_=[tval_norm yval_norm];         %agrego la primera columna tiempo para poder comaparar en los datos experimentales
y=[tsim_val ysim_val];                          %agrego la primera columna tiempo para poder comaparar en los datos simulados


% MIRO DATO POR DATO LA COINCIDENCIA EN EL VECTOR TIEMPO PARA COMPARAR LOS


contador=0;
errorbiomasa=zeros(size(yval_norm_,1),1);

for i=1:size(yval_norm_,1);
    for j=1:size(y,1) ; 
        if y(j,1)==yval_norm_(i,1);
            errorbiomasa(i)=(y(j,2)-yval_norm_(i,2))^2;
            contador=contador+1;
        end
    end
end

 
error_val1=sum(errorbiomasa)/size(errorbiomasa,1); % error medio cuadrado
%%  figura validacion 1
figure           
subplot(1,2,1)
plot(tsim_val,ysim_val(:,1))
hold on 
plot(tval_norm,yval_norm(:,1),'-',tval_norm,yval_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title(['Pattern search validación 1 EMC: %', num2str(100*error_val1)])
legend ('biomasa vs tval_norm')
xlabel('tiempo')
ylabel('biomasa')


%% VALIDACION 2

yval2=[28.07017544; 73.68421053; 128.9473684; 145.6140351; 265.7894737; 352.6315789; 507.8947368; 528.0701754; 544.7368421; 815.7894737; 807.8947368];
yval2_norm=yval2./max(yval2);




tval2=[0:3:30]';
tval2_norm=tval2./max(tval2);
tspan_val2=[0:0.1:30]./30;

y0_val2=min(yval2)/max(yval2);
[tsim_val2,ysim_val2]=ode15s(@ODEmusgo_val,tspan_val2,y0_val2); 

yval2_norm_=[tval2_norm yval2_norm];         %agrego la primera columna tiempo para poder comaparar en los datos experimentales
y=[tsim_val2 ysim_val2];                          %agrego la primera columna tiempo para poder comaparar en los datos simulados


% MIRO DATO POR DATO LA COINCIDENCIA EN EL VECTOR TIEMPO PARA COMPARAR LOS


contador=0;
errorbiomasa=zeros(size(yval2_norm_,1),1);

for i=1:size(yval2_norm_,1);
    for j=1:size(y,1) ; 
        if y(j,1)==yval2_norm_(i,1);
            errorbiomasa(i)=(y(j,2)-yval2_norm_(i,2))^2;
            contador=contador+1;
        end
    end
end

 
error_val2=sum(errorbiomasa)/size(errorbiomasa,1); % error medio cuadrado
%%  figura validacion 2
       
subplot(1,2,2)
plot(tsim_val2,ysim_val2(:,1))
hold on 
plot(tval2_norm,yval2_norm(:,1),'-',tval2_norm,yval2_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title(['Pattern search validación 2 EMC: %', num2str(100*error_val2)])
xlabel('tiempo')
ylabel('biomasa')

%% ADICION DINAMICA CLOROFILA 

% defino datos experimentales  defino el tiempo de muestreo 
t_clor= [0; 4; 8; 12; 16; 20; 28];      % defino el tiempo 
t_clor_norm= t_clor./max(t_clor); % NORMALIZO

% defino los datos experimentales para el crecimiento de biomasa
ydata_clor= [9402.342857; 11578.52149; 12774.9135; 15056.13243; 8601.71777; 8653.186667; 8313.557193]; % set de datos experimentales para la biomasa 810.52 es el ultimo dato real
ydata_clor_norm =ydata_clor./max(ydata_clor);

%% opciones globales agloritmos optimizacion 
lb=[1e-6; 1e-6];  
ub=[1; 1]; 
fun=@fobj_clor; 
nvars=2;
x0=[3.9612; 0.004071];  %% initial guess
% opciones vacias 
A=[]; 
b=[]; 
Aeq=[]; 
beq=[]; 
nonlcon=[];
IntCon=[];

%%  ALGORITMO GENETICO 

options = optimoptions('ga','MaxGenerations',500);
tic
[paramGA_clor,Fval,~,Output] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,options);
toc 
fprintf('GA The number of generations was : %d\n', Output.generations);
fprintf('GA The number of function evaluations was : %d\n', Output.funccount);
fprintf('GA The best function value found was : %g\n', Fval);
ERROR(2)=Fval;
%% PATTERN SEARCH 
 
options = optimoptions(@patternsearch);

tic;
[paramPS_clor,fval,flag,Output] = patternsearch(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
toc

fprintf('Pattern Search The number of iterations was : %d\n', Output.iterations);
fprintf('Pattern Search The number of function evaluations was : %d\n', Output.funccount);
fprintf('Pattern Search The best function value found was : %g\n', fval);
ERROR(1)=fval;

%%   PARTICLE SWARM

options = optimoptions(@particleswarm,'HybridFcn',@fmincon );
rng default 
tic
[paramPaS_clor,fval,~,Output] = particleswarm(fun,nvars,lb,ub,options);
toc
fprintf('The number of function evaluations was : %d\n', Output.funccount);
fprintf('Particle Swarm The number of iterations was : %d\n', Output.iterations);
fprintf('Particle Swarm The number of function evaluations was : %d\n', Output.funccount);
fprintf('Particle Swarm The best function value found was : %g\n', fval);
ERROR(3)=fval;

%% ORGANIZO LA INFORMACIÓN PARA METERLA EN LA TABLA 

n=size(paramPS_clor,1);
paramPS_clor(n+1)=ERROR(1);
paramPS_clor=paramPS_clor;

paramGA_clor(n+1)=ERROR(2);
paramGA_clor=paramGA_clor';

paramPaS_clor(n+1)=ERROR(3);
paramPaS_clor=paramPaS_clor';

param=[paramGA_clor paramPS_clor paramPaS_clor];

table(paramGA_clor ,paramPS_clor,paramPaS_clor,'RowNames',{'B';'C'; 'Error'})

%% EJECUTO EL SCRIPT CON LAS GRAFICAS 
%% PATTERN SEARCH                    
y0=[min(ydata_norm) 0.6245]; 
[tsim_PS_clor,y_PS_clor]=ode15s(@ODEmusgo_PS_clor,tspan,y0);               % se resuelve el ODE del modelo
figure
subplot (1,3,1)
plot(tsim_PS_clor,y_PS_clor(:,2))
hold on 
plot(t_clor_norm,ydata_clor_norm(:,1),'-',t_clor_norm,ydata_clor_norm(:,1),'*')
hold off
legend ('ug/g vs t_norm')
title(['Particle Swarm ajuste clorofila EMC: %', num2str(100*ERROR(1))])
xlabel('tiempo')
ylabel('clorofila especifica')


                                     

%% ALGORITMO GENÉTICO

[tsim_GA_clor,y_GA_clor]=ode15s(@ODEmusgo_GA_clor,tspan,y0);               % se resuelve el ODE del modelo
subplot(1,3,2)
plot(tsim_GA_clor,y_GA_clor(:,2))
hold on 
plot(t_clor_norm,ydata_clor_norm(:,1),'-',t_clor_norm,ydata_clor_norm(:,1),'*')
hold off
legend ('ug/g vs t_norm')
title(['GA ajuste clorofila EMC: %', num2str(100*ERROR(2))])
xlabel('tiempo')
ylabel('clorofila especifica')


%% PARTICLE SWARM X VS T

[tsim_PaS_clor,y_PaS_clor]=ode15s(@ODEmusgo_PaS_clor,tspan,y0);               % se resuelve el ODE del modelo
subplot(1,3,3)
plot(tsim_PaS_clor,y_PaS_clor(:,2))
hold on 
plot(t_clor_norm,ydata_clor_norm(:,1),'-',t_clor_norm,ydata_clor_norm(:,1),'*')
hold off
legend ('ug/g vs t_norm')
title(['Particle Swarm ajuste clorofila EMC: %', num2str(100*ERROR(3))])
legend ('biomasa vs t_norm')
xlabel('tiempo')
ylabel('clorofila especifica')
