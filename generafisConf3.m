function CdifusoPD = generafisConf3(x)

system=newfis('Lightning Strike Counter 3');

%Variable de entrada: Número de objetos
system=addvar(system,'input','#Objetos',[0 15]);
system=addmf(system,'input',1, 'entre 0 y 4','trimf', [x(1) x(2) x(3)]);
system=addmf(system,'input',1, 'entre 4 y 12','trimf',[x(4) x(5) x(6)]);
system=addmf(system,'input',1, 'mas de 12','trimf',[x(7) x(8) x(9)]);


%Variable de entrada: Area
system=addvar(system,'input','Area', [0 800]);
system=addmf(system,'input',2,'pequena','trimf', [x(10) x(11) x(12)]);
system=addmf(system,'input',2,'media','trimf', [x(13) x(14) x(15)]);
system=addmf(system,'input',2,'grande','trimf', [x(16) x(17) x(18)]);

%Variable de entrada: excentricidad
%sistema=addvar(sistema,'input','excentricidad',  [0 1]);

%{
% Configuración 1
sistema=addmf(sistema,'input',3,'no_excentrico','gaussmf', [0.289 0.261]);
sistema=addmf(sistema,'input',3,'si_excentrico','gaussmf', [0.177 0.9746]);
%plotmf(sistema,'input',3)
%}
%Variable de salida: Numero rayos
system=addvar(system,'output','numero_rayos',[0 2.5]);
system=addmf(system,'output',1, '0 rayos','trimf', [x(19) x(20) x(21)]);
system=addmf(system,'output',1, '1 rayo','trimf', [x(22) x(23) x(24)]);
system=addmf(system,'output',1, '2 rayos','trimf', [x(25) x(26) x(27)]);
%plotmf(sistema,'output',1)

%Reglas de inferencia
ruleList=[
    1 1 1 1 2 % 0 rayos
    2 3 2 1 2 % 1 rayos
    3 2 3 1 2]; % 2 rayos

system = addrule(system,ruleList);


%fuzzy(sistema)
%Actualizando la salida de la funci�n 
CdifusoPD=system;
end