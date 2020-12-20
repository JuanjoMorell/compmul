function scod = EncodeString(x, EHUFCO, EHUFSI)

% Codifica el string x en un string binario s aplicando las tablas EHUFCO y EHUFSI

% Entradas
%   x: Vector columna con la secuencia de codigos ASCII leida
%   EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%   EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)

% Salidas:
%   scod: Vector columna tipo string con palabras codigo correspondientes
%       a los consecutivos mensajes en x

% Control de verbosidad
disptext=1;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion EncodeString:');
end

% Codifica
% Corrige offset: Hay que sumar 1 a los indices a EHUFCO y EHUFSI 
scod=''; %String vacio
for i=1:length(x)
    index=x(i)+1;
    scod=[scod dec2bin(EHUFCO(index), EHUFSI(index))];
end

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado EncodeString');
    disp('--------------------------------------------------');
end