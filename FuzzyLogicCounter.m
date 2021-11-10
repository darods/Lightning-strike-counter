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
%% Use labeled images for testing
imgFolder = 'imgBinary';
imds = imageDatastore(imgFolder,...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% divede 60% for training, 20% validation and 20% testing
fracTrainFiles = 0.9;
fracValFiles = 0.05;
fracTestFiles = 0.05;

[imdsTrain, imdsValidation, imdsTest] = splitEachLabel(imds, ...
    fracTrainFiles, fracValFiles, fracTestFiles, 'randomize');

%% Fuzzy logic definition
warning('off')
%Fuzzy logic system call
%sistema=fuzzySystemStaticConf3;
%fuzzy(sistema)
sistema = readfis('optimizacion6Conf3.fis');

%% Get statistical data from training data
superStructure=getImagesInformation(imdsTrain);

%% Count Lightning strikes ing images
comparationMatrix = [];
for j = 1:numel(superStructure)
    output_fis = zeros (superStructure(j).numObj, 2);
    for h=1:superStructure(j).numObj
        cuadro = [superStructure(j).numObj ... 
                  superStructure(j).imgStats(h).Area ...
                  superStructure(j).imgStats(h).Eccentricity];
        Y = evalfis(cuadro, sistema);
        output_fis(h) = Y;
    end
    output_fis(:, 2) = floor(output_fis(:,1));
    numero_rayos = sum(output_fis(:,2));
    if(numero_rayos>2)
        numero_rayos = 2;
    end
    resultVector = [superStructure(j).Rays, numero_rayos];
    comparationMatrix = [comparationMatrix; resultVector];
end

%% get results
total = numel(comparationMatrix(:,1));
YPred = comparationMatrix(:,1);
YTest = comparationMatrix(:,2);
accuracy = sum(YPred == YTest)/total


figure
t = [1:total];
plot(t,comparationMatrix(:,1),t,comparationMatrix(:,2))
legend('Reales', 'Simulados')
title('Comparación')
xlabel('# de imagen'); ylabel('Cantidad de rayos')

figure
plot(t, YPred - YTest)
title('Error')
xlabel('# de imagen'); ylabel('Error en cantidad de rayos')

