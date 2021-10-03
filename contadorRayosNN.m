% NN Contador de rayos
% Daniel Alejandro Rodriguez Suarez
% Sebastian Salazar
% https://youtu.be/lK9YyX-q32k
close all
clear all
clc

imgFolder = 'img';
imds = imageDatastore(imgFolder,...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% separa en 60% entrenamiento, 20% validación y 20% pruebas
fracTrainFiles = 0.6;
fracValFiles = 0.2;
fracTestFiles = 0.2;

[imdsTrain, imdsValidation, imdsTest] = splitEachLabel(imds, ...
    fracTrainFiles, fracValFiles, fracTestFiles, 'randomize');

layers = [
    imageInputLayer([150 150 1])
    
    convolution2dLayer(5,10,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,10,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer
    ];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');


net = trainNetwork(imdsTrain,layers,options);

%%

YPred = classify(net,imdsTest);
YTest = imdsTest.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)


%%
ind = find(YPred ~= YTest);
figure; 
for ii = 1:length(ind)
    subplot(3,3,ii);
    imagesc(imdsValidation.readimage(ind(ii)));
    title([num2str(double(YPred(ind(ii)))-1), ' predicted, ', ... 
        num2str(double(YTest(ind(ii)))-1), ' actual'])
end
