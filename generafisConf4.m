function CdifusoPD = generafisConf4(x)
system=newfis('Lightning Strike Counter 4');

% Input: # of objects
system=addvar(system,'input','#Objetos',[0 15]);
system=addmf(system,'input',1, 'entre 0 y 4','zmf', [x(1) x(2)]);
system=addmf(system,'input',1, 'entre 4 y 12','gauss2mf', [x(3) x(4) x(5) x(6)]);
system=addmf(system,'input',1,'mas de 12','gauss2mf', [x(7) x(8) x(9) x(10)]);

% Input: Area
system=addvar(system,'input','Area', [0 600]);
system=addmf(system,'input',2,'pequena','zmf', [x(11) x(12)]);
system=addmf(system,'input',2,'media','gauss2mf', [x(13) x(14) x(15) x(16)]);
system=addmf(system,'input',2,'grande','gauss2mf', [x(17) x(18) x(19) x(20)]);
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
system=addmf(system,'output',1,'0 rayos','zmf',  [x(21) x(22)]);
system=addmf(system,'output',1,'1 rayo','gauss2mf',  [x(23) x(24) x(25) x(26)]);
system=addmf(system,'output',1,'2 rayos','gauss2mf', [x(27) x(28) x(29) x(30)]);
%plotmf(sistema,'output',1)

% Inference rules
ruleList=[
    1 1 1 1 2 % 0 rayos
    2 3 2 1 2 % 1 rayos
    3 2 3 1 2]; % 2 rayos

system = addrule(system,ruleList);


CdifusoPD=system;
end