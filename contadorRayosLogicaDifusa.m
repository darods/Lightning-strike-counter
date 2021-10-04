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
%Fuzzy logic system call
sistema=sisdifuso;
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