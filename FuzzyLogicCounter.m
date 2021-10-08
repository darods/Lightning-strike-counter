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
imgFolder = 'img';
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
%sistema=fuzzySystemStatic;
%fuzzy(sistema)
sistema = readfis('Lightning_strike_counter_GA_optimized_2.fis');



%% Get statistical data from training data
comparationMatrix = [];
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
error = 1 - accuracy 
mse = 1/total*sum((YPred-YTest).^2)
%{ 
(Optional) show wrong predicted images
ind = find(YPred ~= YTest);
figure; 
for ii = 1:length(ind)
    subplot(3,3,ii);
    imagesc(imdsValidation.readimage(ind(ii)));
    title([num2str(double(YPred(ind(ii)))-1), ' predicted, ', ... 
        num2str(double(YTest(ind(ii)))-1), ' actual'])
end
%}