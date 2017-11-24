global ydata_norm
global t
global tspan
global U_PS
global U_GA
global U_PaS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %PATTERN SEARCH
%y0= [231.578947];                       
y0= [231.578947/max(max(ydata)) 0.0094023/min(max(ydata))]; 
[tsim_PS,y_PS]=ode15s(@ODEmusgo_PS,tspan,y0);               % se resuelve el ODE del modelo

figure

subplot(2,4,1)
plot(tsim_PS,y_PS(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('Pattern search')
xlabel('tiempo')
ylabel('biomasa')

subplot(2,4,2)
plot(tsim_PS,y_PS(:,2))
hold on 
plot(t_norm,ydata_norm(:,2),'*')
hold off
legend ('clorofila g/g vs t_norm')
xlabel('tiempo')
ylabel('clorofila')


subplot(2,4,3)
plot(U_PS(:,7),U_PS(:,1))
legend ('I vs t_norm')
xlabel('tiempo')
ylabel('Intesidad')

subplot(2,4,4)
plot(U_PS(:,5)./U_PS(:,2),U_PS(:,1))
legend ('I vs X')
xlabel('Biomasa')
ylabel('Intesidad luz')

subplot(2,4,5)
plot(U_PS(:,1),U_PS(:,2))
legend ('I vs ua')
xlabel('Intensidad')
ylabel('ua')

subplot(2,4,6)
plot(U_PS(:,5)./U_PS(:,2),U_PS(:,2))
legend ('ua vs X')
xlabel('X')
ylabel('ua')

subplot(2,4,7)
plot(U_PS(:,7),U_PS(:,5)./U_PS(:,2))
legend ('ua vs t')
xlabel('tiempo')
ylabel('ua')

subplot(2,4,8)
plot(U_PS(:,2),U_PS(:,6)./(U_PS(:,5)./U_PS(:,2)))
legend ('qc vs ua')
xlabel('ua')
ylabel('qc')
                                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %ALGORITMO GENETICO


[tsim_GA,y_GA]=ode15s(@ODEmusgo_GA,tspan,y0);               % se resuelve el ODE del modelo

figure

subplot(2,4,1)
plot(tsim_GA,y_GA(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'-',t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('GA')

subplot(2,4,2)
plot(tsim_GA,y_GA(:,2))
hold on 
plot(t_norm,ydata_norm(:,2),'-',t_norm,ydata_norm(:,2),'*')
hold off
legend ('clorofila g/g vs t_norm')
title('GA')

subplot(2,4,3)
plot(U_GA(:,7),U_GA(:,1))
legend ('I vs t_norm')
xlabel('tiempo')
ylabel('Intesidad')

subplot(2,4,4)
plot(U_GA(:,5)./U_GA(:,2),U_GA(:,1))
legend ('I vs X')
xlabel('Biomasa')
ylabel('Intesidad luz')

subplot(2,4,5)
plot(U_GA(:,1),U_GA(:,2))
legend ('I vs ua')
xlabel('Intensidad')
ylabel('ua')

subplot(2,4,6)
plot(U_GA(:,5)./U_GA(:,2),U_GA(:,2))
legend ('ua vs X')
xlabel('X')
ylabel('ua')

subplot(2,4,7)
plot(U_GA(:,7),U_GA(:,5)./U_GA(:,2))
legend ('ua vs t_norm')
xlabel('tiempo')
ylabel('ua')

subplot(2,4,8)
plot(U_GA(:,2),U_GA(:,6)./(U_GA(:,5)./U_GA(:,2)))
legend ('qc vs ua')
xlabel('ua')
ylabel('qc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %PARTICLE SWARM


[tsim_PaS,y_PaS]=ode15s(@ODEmusgo_PaS,tspan,y0);               % se resuelve el ODE del modelo

figure

subplot(2,4,1)
plot(tsim_PaS,y_PaS(:,1))
hold on 
plot(t_norm,ydata_norm(:,1),'-',t_norm,ydata_norm(:,1),'*')
hold off
legend ('biomasa vs t_norm')
title('Particle Swarm')

subplot(2,4,2)
plot(tsim_PaS,y_PaS(:,2))
hold on 
plot(t_norm,ydata_norm(:,2),'-',t_norm,ydata_norm(:,2),'*')
hold off
legend ('clorofila g/g vs t_norm')

subplot(2,4,3)
plot(U_GA(:,7),U_GA(:,1))
legend ('I vs t_norm')
xlabel('tiempo')
ylabel('Intesidad')

subplot(2,4,4)
plot(U_GA(:,5)./U_GA(:,2),U_GA(:,1))
legend ('I vs X')
xlabel('Biomasa')
ylabel('Intesidad luz')

subplot(2,4,5)
plot(U_PaS(:,1),U_PaS(:,2))
legend ('I vs ua')
xlabel('Intensidad')
ylabel('ua')

subplot(2,4,6)
plot(U_PaS(:,5)./U_PaS(:,2),U_PaS(:,2))
legend ('ua vs X')
xlabel('X')
ylabel('ua')

subplot(2,4,7)
plot(U_PaS(:,7),U_PaS(:,5)./U_PaS(:,2))
legend ('ua vs t_norm')
xlabel('tiempo')
ylabel('ua')

subplot(2,4,8)
plot(U_PaS(:,2),U_PaS(:,6)./(U_PaS(:,5)./U_PaS(:,2)))
legend ('qc vs ua')
xlabel('ua')
ylabel('qc')




