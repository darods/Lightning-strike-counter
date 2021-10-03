%{ 
Lightning strike counter with fuzzy logic
Developed by:    
    * Daniel Rodriguez-20172020009
    * Sebastián Salazar-20172020018
year: 2021
course: Cibernetica 3
%}
% Adapted from Matlab tutorial
close all
clear all
clc

%% Fuzzy logic definition
warning('off')
%sistema = newfis('conteo_rayos');

%Variable de entrada: Número de objetos
%sistema=addvar(sistema,'input','n_objetos',[0 200]);

%{ 
% Configuración 1
sistema=addmf(sistema,'input',1,' entre_0_y_20','gaussmf', [35.4 20]);
sistema=addmf(sistema,'input',1,' entre_20_y_100','gaussmf',[35.4 100]);
sistema=addmf(sistema,'input',1,' mas_de_100','gaussmf',[35.37 200]);
%plotmf(sistema,'input',1)

% Configuración 2
sistema=addmf(sistema,'input',1,' entre_0_y_20','gauss2mf', [21.6 3.75 21.6 36.25]);
sistema=addmf(sistema,'input',1,' entre_20_y_100','gauss2mf',[21.6 83.75 21.6 116.3]);
sistema=addmf(sistema,'input',1,' mas_de_100','gauss2mf',[21.58 183.8 21.58 216.2]);


%Variable de entrada: Area
sistema=addvar(sistema,'input','Area', [0 5e+04]);
%{
% Configuración 1
sistema=addmf(sistema,'input',2,'pequena','trapmf', [-1.64e+04 -6130 2800 4915]);
sistema=addmf(sistema,'input',2,'media','gaussmf', [6677 1.534e+04]);
sistema=addmf(sistema,'input',2,'grande','trapmf', [1.312e+04 2.977e+04 5.057e+04 5.067e+04]);
%plotmf(sistema,'input',2)
%}
% Configuración 2
sistema=addmf(sistema,'input',2,'pequena','gauss2mf', [3073 -4385 3073 239.2]);
sistema=addmf(sistema,'input',2,'media','gauss2mf', [4074 1.227e+04 4074 1.841e+04]);
sistema=addmf(sistema,'input',2,'grande','gauss2mf', [5656 2.81e+04 42.47 5.058e+04]);

%Variable de entrada: excentricidad
sistema=addvar(sistema,'input','excentricidad',  [0 1]);

%{
% Configuración 1
sistema=addmf(sistema,'input',3,'no_excentrico','gaussmf', [0.289 0.261]);
sistema=addmf(sistema,'input',3,'si_excentrico','gaussmf', [0.177 0.9746]);
%plotmf(sistema,'input',3)
%}
% Configuración 2
sistema=addmf(sistema,'input',3,'no_excentrico','gauss2mf', [0.1763 0.1283 0.1763 0.39371]);
sistema=addmf(sistema,'input',3,'si_excentrico','gauss2mf', [0.108 0.8933 0.108 1.056]);


%Variable de salida: Numero rayos
sistema=addvar(sistema,'output','numero_rayos',[0 2.5]);

%Funciones de pertenencia
sistema=addmf(sistema,'output',1,'0_rayos','gbellmf', [0.6158 3.278 0.06342]);
sistema=addmf(sistema,'output',1,'1_rayo','trimf', [0.9327 1.014 1.095]);
sistema=addmf(sistema,'output',1,'mas_de_1_rayo','gbellmf', [0.7022 3.28 2.19]);
%plotmf(sistema,'output',1)

%Reglas de inferencia
ruleList=[
    1 1 1 1 1 2 % 0 rayos
    1 1 2 1 1 2 % 0 rayos
    1 2 2 1 1 2 % 0 rayos
    1 3 2 2 1 2 % 1 rayo
    2 1 1 1 1 2 % 0 rayos
    2 2 1 1 1 2 % 0 rayos
    2 2 2 1 1 2 % 0 rayos
    2 3 2 2 1 2 % 1 rayo
    3 1 1 1 1 2 % 0 rayos
    3 2 1 1 1 2 % 0 rayos
    3 2 2 1 1 2 % 0 rayos
    3 3 2 3 1 2]; % + de 1 rayo

sistema = addrule(sistema,ruleList);
%}
%Fuzzy logic system call
sistema=generafis;
fuzzy(sistema)


%% Use labeled images for testing
imgFolder = 'img';
imds = imageDatastore(imgFolder,...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% divede 60% for training, 20% validation and 20% testing
fracTrainFiles = 0.6;
fracValFiles = 0.2;
fracTestFiles = 0.2;

[imdsTrain, imdsValidation, imdsTest] = splitEachLabel(imds, ...
    fracTrainFiles, fracValFiles, fracTestFiles, 'randomize');

comparationMatrix = [];

% Get statistical data from training data
for i=1:numel(imdsTrain.Files)
    imgOpenned = readimage(imdsTrain,i);
    Iregion = regionprops(imgOpenned, 'centroid');
    [labeled,numObjects] = bwlabel(imgOpenned,4);
    stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
    areas = [stats.Area];
    eccentricities = [stats.Eccentricity];

%% Count Lightning strikes ing images
    
    output_fis = zeros (numObjects, 2);
    for j = 1:numObjects
        cuadro = [numObjects stats(j).Area stats(j).Eccentricity];
        Y = evalfis(cuadro, sistema);
        output_fis(j) = Y;
    end
    output_fis(:, 2) = floor(output_fis(:,1));
    numero_rayos = sum(output_fis(:,2));
    resultVector = [double(imdsTrain.Labels(i)), numero_rayos];
    comparationMatrix = [comparationMatrix; resultVector];
end
%% get results
total = numel(comparationMatrix(:,1));
YPred = comparationMatrix(:,1);
YTest = comparationMatrix(:,2);
accuracy = sum(YPred == YTest)/total

%% (Optional) show wrong predicted images
ind = find(YPred ~= YTest);
figure; 
for ii = 1:length(ind)
    subplot(3,3,ii);
    imagesc(imdsValidation.readimage(ind(ii)));
    title([num2str(double(YPred(ind(ii)))-1), ' predicted, ', ... 
        num2str(double(YTest(ind(ii)))-1), ' actual'])
end