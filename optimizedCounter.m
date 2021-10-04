%Optimización de un sistema de control difuso proporcional mediante GA
close all
clear all
warning('off','all')

%Sistema difuso como variable global
global a

% datos de entrenamiento
%% Use labeled images for testing
imgFolder = 'img';
imds = imageDatastore(imgFolder,...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% divede 60% for training, 20% validation and 20% testing
fracTrainFiles = 0.6;
fracValFiles = 0.2;
fracTestFiles = 0.2;

global imdsTrain imdsValidation imdsTest

[imdsTrain, imdsValidation, imdsTest] = splitEachLabel(imds, ...
    fracTrainFiles, fracValFiles, fracTestFiles, 'randomize')


%% Optimizaci�n con algoritmos gen�ticos
% optionsga = gaoptimset('Display','iter');
optionsga = gaoptimset('PopulationSize',50,'Generations',10,'PopInitRange',...
    [-0.5;2],'EliteCount',2,'CrossoverFraction',0.8,'PopulationType','doubleVector','TimeLimit',2000,'Display','iter');

%Opciones del algoritmo gen�tico
X = ga(@fobj,33,optionsga)
%[mejor,fval,reason,output,poblacion] = ga(@fobj,33,optionsga);
%Sistema difuso optimizado
a = generafis(X);
fuzzy(a)
%[t,x,e] = sim('SistemaControlPR16');
%ys = x(:,2);
%plot(t,ys);
