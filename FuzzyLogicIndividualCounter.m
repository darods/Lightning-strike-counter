%{ 
Lightning strike counter with fuzzy logic
Developed by:    
    * Daniel Rodriguez-20172020009
    * Sebastián Salazar-20172020018
year: 2021
course: Cibernetica 3
%}
close all
clear all
clc

%% Step 1: Fuzzy logic system call
warning('off')
sistema=fuzzySystemStatic; %Fuzzy logic system call
fuzzy(sistema) % Show fuzzy logic configuration
imgIndex = 19; % Image index that is analized by the FL system


%% Step 2: Prepare labeled images for testing
imgFolder = 'img';
imds = imageDatastore(imgFolder,...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% divide 60% for training, 20% validation and 20% testing
fracTrainFiles = 0.9;
fracValFiles = 0.05;
fracTestFiles = 0.05;

[imdsTrain, imdsValidation, imdsTest] = splitEachLabel(imds, ...
    fracTrainFiles, fracValFiles, fracTestFiles, 'randomize');

%% Step 3: Get statistical data from training data
imgOpenned = readimage(imdsTrain,imgIndex);
Iregion = regionprops(imgOpenned, 'centroid');
[labeled,numObjects] = bwlabel(imgOpenned,4);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];

%% Step 4: Count Lightning strikes in images
comparationMatrix = [];    
output_fis = zeros (numObjects, 2);
for j = 1:numObjects
    cuadro = [numObjects stats(j).Area stats(j).Eccentricity];
    Y = evalfis(cuadro, sistema);
    output_fis(j) = Y;
end
output_fis(:, 2) = floor(output_fis(:,1));
numero_rayos = sum(output_fis(:,2));
resultVector = [double(imdsTrain.Labels(imgIndex)), numero_rayos];
comparationMatrix = [comparationMatrix; resultVector];

%% Step 5: get results
total = numel(comparationMatrix(:,1));
YPred = comparationMatrix(:,1);
YTest = comparationMatrix(:,2);
accuracy = sum(YPred == YTest)/total

%% Step 6 (Optional): show wrong predicted images
ind = find(YPred ~= YTest);
figure; 
for ii = 1:length(ind)
    subplot(3,3,ii);
    imagesc(imdsValidation.readimage(ind(ii)));
    title([num2str(double(YPred(ind(ii)))-1), ' predicted, ', ... 
        num2str(double(YTest(ind(ii)))-1), ' actual'])
end