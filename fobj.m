function esm=fobj(P)
%Funci�n para calcular el �ndice de desempe�o


%Sistema difuso como variable global
global a
global imdsTrain imdsValidation imdsTest
%Controlador difuso
a = generafis(P);

%Simulaci�n de la planta
%%[t,x,e] = sim('SistemaControlPR16');

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
accuaracy = sum(YPred == YTest)/total
e = 1-accuaracy
%�ndice de desempe�o
%esm = 1/length(e)*sum(e.^2);
esm = e;
