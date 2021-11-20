function CdifusoPD = generafisConf2(x)

sistema=newfis('Lightning_strike_counter');

%Variable de entrada: Número de objetos
sistema=addvar(sistema,'input','#Objetos',[0 50]);
sistema=addmf(sistema,'input',1, 'entre 0 y 4','gbellmf', [x(1) x(2) x(3)]);
sistema=addmf(sistema,'input',1, 'entre 4 y 12','gbellmf',[x(4) x(5) x(6)]);
sistema=addmf(sistema,'input',1, 'mas de 12','gbellmf',[x(7) x(8) x(9)]);


%Variable de entrada: Area
sistema=addvar(sistema,'input','Area', [0 200]);
sistema=addmf(sistema,'input',2,'pequena','gbellmf', [x(10) x(11) x(12)]);
sistema=addmf(sistema,'input',2,'media','gbellmf', [x(13) x(14) x(15)]);
sistema=addmf(sistema,'input',2,'grande','gbellmf', [x(16) x(17) x(18)]);

%Variable de salida: Numero rayos
sistema=addvar(sistema,'output','numero_rayos',[0 2]);
sistema=addmf(sistema,'output',1, '0 rayos','gbellmf', [x(19) x(20) x(21)]);
sistema=addmf(sistema,'output',1, '1 rayo','gbellmf', [x(22) x(23) x(24)]);
sistema=addmf(sistema,'output',1, '2 rayos','gbellmf', [x(25) x(26) x(27)]);
%plotmf(sistema,'output',1)

%Reglas de inferencia
ruleList=[
    1 1 1 1 2 % 0 rayos
    2 3 2 1 2 % 1 rayos
    3 2 3 1 2]; % 2 rayos

sistema = addrule(sistema,ruleList);


%fuzzy(sistema)
%Actualizando la salida de la funcion 
CdifusoPD=sistema;

end