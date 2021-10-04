%Optimización de un sistema de control difuso proporcional mediante GA
close all
clear all
warning('off','all')

%Sistema difuso como variable global
global a

% datos de entrenamiento


%% Optimizaci�n con algoritmos gen�ticos
optionsga = gaoptimset('Display','iter');

%Opciones del algoritmo gen�tico
%optionsga = gaoptimset('PopulationSize',50,'Generations',10,'PopInitRange',...
%    [-0.5;2],'EliteCount',2,'CrossoverFraction',0.8,'PopulationType','doubleVector','TimeLimit',2000,'Display','iter');

X = ga(@fobj,33,optionsga)

%Sistema difuso optimizado
%a = generafis(X);
%[t,x,e] = sim('SistemaControlPR16');
%ys = x(:,2);
%plot(t,ys);
