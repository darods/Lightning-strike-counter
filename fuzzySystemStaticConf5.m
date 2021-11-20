function CdifusoPD = fuzzySystemStaticConf4()
%{
Fuzzy system definition
Developed by:    
    * Daniel Rodriguez-20172020009
    * Sebastián Salazar-20172020018
year: 2021
course: Cibernetica 3
%}
system=newfis('Lightning Strike Counter 4');

% Input: # of objects
system=addvar(system,'input','#Objetos',[0 15]);
system=addmf(system,'input',1, 'entre 0 y 4','zmf', [1.269 3.138]);
system=addmf(system,'input',1, 'entre 4 y 12','gauss2mf', [0.7627 4.243 0.7627 5.391]);
system=addmf(system,'input',1,'mas de 12','gauss2mf', [1.19 9.47 1.19 14.6]);

% Input: Area
system=addvar(system,'input','Area', [0 600]);
system=addmf(system,'input',2,'pequena','zmf', [22.76 81.33]);
system=addmf(system,'input',2,'media','gauss2mf', [31.9 118 35.8 221]);
system=addmf(system,'input',2,'grande','gauss2mf', [57.3 405 17.1 603]);
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
system=addvar(system,'output','numero Rayos',[0 2.5]);
system=addmf(system,'output',1,'0 rayos','zmf',  [0.2422 0.8598]);
system=addmf(system,'output',1,'1 rayo','gauss2mf',  [0.131 0.7077 0.131 1.264]);
system=addmf(system,'output',1,'2 rayos','gauss2mf', [0.0786 1.69 0.113 2.56]);
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