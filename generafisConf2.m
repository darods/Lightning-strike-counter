function CdifusoPD = generafisConf2(x)
system=newfis('Lightning Strike Counter conf2');

% Input: # of objects
system=addvar(system,'input','#Objetos',[0 20]);
system=addmf(system,'input',1, 'entre 0 y 4','gaussmf', [x(1) x(2)]);
system=addmf(system,'input',1, 'entre 4 y 12','gaussmf', [x(3) x(4)]);
system=addmf(system,'input',1,'mas de 12','gaussmf', [x(5) x(6)]);

% Input: Area
system=addvar(system,'input','Area', [0 800]);
system=addmf(system,'input',2,'pequena','gaussmf', [x(7) x(8)]);
system=addmf(system,'input',2,'media','gaussmf', [x(9) x(10)]);
system=addmf(system,'input',2,'grande','gaussmf', [x(11) x(12)]);
%plotmf(sistema,'input',2)
%Variable de salida: Numero rayos
system=addvar(system,'output','numero_rayos',[0 2.5]);
system=addmf(system,'output',1, '0 rayos','gbellmf', [x(13) x(14) x(15)]);
system=addmf(system,'output',1, '1 rayo','gbellmf', [x(16) x(17) x(18)]);
system=addmf(system,'output',1, '2 rayos','gbellmf', [x(19) x(20) x(21)]);
%plotmf(sistema,'output',1)

%Reglas de inferencia
ruleList=[
    1 1 1 1 2 % 0 rayos
    2 3 2 1 2 % 1 rayos
    3 2 3 1 2]; % 2 rayos

system = addrule(system,ruleList);

% Input: eccentricity
%system=addvar(system,'input','excentricidad',  [0 1]);
CdifusoPD=system;
end