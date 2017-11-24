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
 
%% defino datos experimentales  defino el tiempo de muestreo 
t= [0:4:48]';      % defino el tiempo 
t_norm= t./max(t); % NORMALIZO

% defino los datos experimentales para el crecimiento de biomasa
ydata= [231.57 271.05 373.68 518.42 526.31 647.36 734.21 810.52 890 970 998 1003 1000]'; % set de datos experimentales para la biomasa 810.52 es el ultimo dato real
ydata_norm =ydata./max(ydata);

% defino los datos experimentales para la clorofila específica 
ydatacl=[0.009402343 0.011578521 0.012774913 0.015056132 0.008601718 0.008653187 0.0083 0.008313557 0.008313557 0.008313557 0.008313557 0.008313557 0.008313557]';
ydatacl_norm=ydatacl./max(ydatacl);
ydata= [ydata ydatacl]; % primer columna para biomasa segunda para clorofila
ydata_norm=[ydata_norm ydatacl_norm];




%% opciones globales para los algoritmos de optimización

lb=[1e-5; 1e-5; 1e-5; 1e-5; 1e-5];  
ub=[1; 1; 1; 1; 1]; 
fun=@fobjcorrecta; 
nvars=5;
x0=ones(5,1)*0.5;  %% initial guess
% opciones vacias 
A=[]; 
b=[]; 
Aeq=[]; 
beq=[]; 
nonlcon=[];
IntCon=[];
 
%%  ALGORITMO GENETICO 

options = optimoptions('ga','PlotFcn',@gaplotbestf,'MaxGenerations',50);
tic
[paramGA,Fval,~,Output] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,options);
toc 
fprintf('GA The number of generations was : %d\n', Output.generations);
fprintf('GA The number of function evaluations was : %d\n', Output.funccount);
fprintf('GA The best function value found was : %g\n', Fval);
ERROR(2)=Fval;

%% PATTERN SEARCH 
 
options = optimoptions(@patternsearch,'PlotFcn',{@psplotbestf,@psplotfuncount});

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

table(paramGA ,paramPS,paramPaS,'RowNames',{'Umax_aut';'Ks';'e';'alfa';'beta';'Error'})

%% EJECUTO EL SCRIPT CON LAS GRAFICAS 

slnmusgo





