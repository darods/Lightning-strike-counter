%Optimizaci�n de un sistema de control difuso proporcional mediante
%cuasi-Newton

close all
clear all
warning('off','all')

%Sistema difuso como variable global
global a

%Par�metros iniciales del sistema de inferencia
%X0=[0.2 -0.5 0.2 0 0.2 0.5 0.2 -0.5 0.2 0 0.2 0.5]; 8
X0=[21.6 3.75 21.6 36.25 21.6 83.75 21.6 116.3 21.58 183.8 21.58 216.2 -1.64e+04 -6130 2800 4915 ];

%Sistema difuso sin optimizar
a = generafis(X0);

%Simulaci�n del sistema de control sin optimizar
%[t,x,e] = sim('SistemaControlPR16');
%ys = x(:,2);
%plot(t,ys);
%pause(5)

%Optimizaci�n con gradiente
options = optimset('Display','iter','MaxIter', 2);
X = fminunc(@fobj,X0,options)

%Simulaci�n del sistema de control optimizado
a = generafis(X);
[t,x,e] = sim('SistemaControlPR16');
ys = x(:,2);
plot(t,ys);