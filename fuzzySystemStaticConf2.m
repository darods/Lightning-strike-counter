function CdifusoPD = fuzzySystemStaticConf2()
%{
Fuzzy system definition
Developed by:    
    * Daniel Rodriguez-20172020009
    * Sebastián Salazar-20172020018
year: 2021
course: Cibernetica 3
%}
system=newfis('Lightning_strike_counter');

% Input: # of objects
system=addvar(system,'input','#Objetos',[0 20]);
system=addmf(system,'input',1, 'entre 0 y 4','gaussmf', [1.036 0.2284]);
system=addmf(system,'input',1, 'entre 4 y 12','gaussmf', [1.668 3.933]);
system=addmf(system,'input',1,'mas de 12','gaussmf', [6.557 14.76]);

% Input: Area
system=addvar(system,'input','Area', [0 800]);
system=addmf(system,'input',2,'pequena','gaussmf', [41.45 20.59]);
system=addmf(system,'input',2,'media','gaussmf', [104.2 229.3]);
system=addmf(system,'input',2,'grande','gaussmf', [164 640]);
%plotmf(sistema,'input',2)

% Input: eccentricity
%system=addvar(system,'input','excentricidad',  [0 1]);


%{ 
First setting
system=addmf(system,'input',3,'no excentrico','gbellmf', [0.55 3.28 0.334]);
system=addmf(system,'input',3,'si excentrico','gbellmf', [0.164 4.1 1.008]);
%plotmf(sistema,'input',3)
%}


% Output: # of lightning rays
system=addvar(system,'output','numero_rayos',[0 2.5]);
system=addmf(system,'output',1,'0 rayos','gbellmf',  [0.193 1 0.2808]);
system=addmf(system,'output',1,'1 rayo','gbellmf', [0.193 1 0.9624]);
system=addmf(system,'output',1,'2 rayos','gbellmf', [0.193 1 2.02]);
%plotmf(sistema,'output',1)

% Inference rules
ruleList=[
    1 1 1 1 2 % 0 rayos
    2 3 2 1 2 % 1 rayos
    3 2 3 1 2]; % 2 rayos

system = addrule(system,ruleList);

%Actualizando la salida de la función 
CdifusoPD=system;

end