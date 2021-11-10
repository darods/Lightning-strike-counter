function CdifusoPD = fuzzySystemStaticConf3()
%{
Fuzzy system definition
Developed by:    
    * Daniel Rodriguez-20172020009
    * Sebastián Salazar-20172020018
year: 2021
course: Cibernetica 3
%}
system=newfis('Lightning Strike Counter 3');

% Input: # of objects
system=addvar(system,'input','#Objetos',[0 15]);
system=addmf(system,'input',1, 'entre 0 y 4','trimf', [0.07245 1.532 3.172]);
system=addmf(system,'input',1, 'entre 4 y 12','trimf', [1.874 4.817 7.761]);
system=addmf(system,'input',1,'mas de 12','trimf', [7.823 11.33 14.83]);

% Input: Area
system=addvar(system,'input','Area', [0 800]);
system=addmf(system,'input',2,'pequena','trimf', [-57.77 15.44 88.65]);
system=addmf(system,'input',2,'media','trimf', [-12.03 172 356]);
system=addmf(system,'input',2,'grande','trimf', [190.4 480 769.6]);
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
system=addmf(system,'output',1,'0 rayos','trimf',  [-0.1052 0.2808 0.6668]);
system=addmf(system,'output',1,'1 rayo','trimf', [0.684 1.07 1.46]);
system=addmf(system,'output',1,'2 rayos','trimf', [1.634 2.02 2.406]);
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