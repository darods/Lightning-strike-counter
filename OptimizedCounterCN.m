%Optimización de un sistema de control difuso proporcional mediante
%cuasi-Newton

close all
clear all
warning('off','all')

%Sistema difuso como variable global
global a

%Parámetros iniciales del sistema de inferencia

X0=[3.05 3.16 0.571 ...
    4.91 3.84 9.833 ...
    19.3 2.5 36.9 ...
    91.5 3.16 38.6 ...
    230 3.84 430 ...
    362 2.5 1.2e+03 ...
    0.55 3.28 0.334 ...
    0.164 4.1 1.008 ...
    0.193 1 0.2808 ...
    0.193 1 0.9624 ...
    0.193 1 2.02 ...  
    ];
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


%% Sistema difuso sin optimizar
a = generafis(X0);
fuzzy(a);

%% Optimización con gradiente
options = optimset('Display','iter','MaxIter', 10);
X = fminunc(@fobj,X0,options);

%% Simulaci�n del sistema de control optimizado
a = generafis(X);
fuzzy(a)

%% comprobación resultados sistema optimizado
comparationMatrix = [];

% Get statistical data from training data
for i=1:numel(imdsTrain.Files)
    imgOpenned = readimage(imdsTrain,i);
    Iregion = regionprops(imgOpenned, 'centroid');
    [labeled,numObjects] = bwlabel(imgOpenned,4);
    stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
    areas = [stats.Area];
    eccentricities = [stats.Eccentricity];

% Count Lightning strikes ing images
    
    output_fis = zeros (numObjects, 2);
    for j = 1:numObjects
        cuadro = [numObjects stats(j).Area stats(j).Eccentricity];
        Y = evalfis(cuadro, a);
        output_fis(j) = Y;
    end
    output_fis(:, 2) = floor(output_fis(:,1));
    numero_rayos = sum(output_fis(:,2));
    if(numero_rayos>2)
        numero_rayos = 2;
    end
    resultVector = [str2num(char(imdsTrain.Labels(i))), numero_rayos];
    comparationMatrix = [comparationMatrix; resultVector];
end
%% get results
total = numel(comparationMatrix(:,1));
YPred = comparationMatrix(:,1);
YTest = comparationMatrix(:,2);
accuracy = sum(YPred == YTest)/total
