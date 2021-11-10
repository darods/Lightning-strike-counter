function error=fobj(P)
%Función para calcular el �ndice de desempe�o


%Sistema difuso como variable global
global sistema
global imdsTrain imdsValidation imdsTest
%Controlador difuso
sistema = generafisConf5(P);

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
accuaracy = sum(YPred == YTest)/total;
e = 1-accuaracy;
%índice de desempeño
%esm = 1/length(e)*sum(e.^2);
error = e;
end