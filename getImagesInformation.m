function imagesInformation=getImagesInformation(imdsTrain)
%% Get statistical data from training data
superStructure=[];
    for i=1:numel(imdsTrain.Files)
        imgOpenned = readimage(imdsTrain,i);
        Iregion = regionprops(imgOpenned, 'centroid');
        [labeled,numObjects] = bwlabel(imgOpenned,4);
        stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');

        % get vector of the image index
        exStruct = struct('imgIndex',i,...
                          'Rays',str2num(char(imdsTrain.Labels(i))),...
                          'numObj', numObjects,... 
                          'imgStats',stats);

        superStructure=[superStructure;exStruct];
    end
imagesInformation = superStructure;
end