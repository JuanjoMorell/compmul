function xrec=DecodeString(scodrec,MINCODE,MAXCODE,VALPTR,HUFFVAL)

% Decodifica el string binario scodrec y reconstruye el string descomprimido xrec

% Entradas
%   scodrec: Vector columna tipo string con palabras codigo correspondientes
%       a los consecutivos mensajes en x
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Salidas:
%   xrec: Vector columna con la secuencia de codigos ASCII reconstruida

% Basado en ITU T.81, Anexo F
% Adaptado por Roque Marin

% Control de verbosidad
disptext=1;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion DecodeString:');
end

% Inicializacion
xrec=''; % String vacio
ptr=1; % Puntero a string scodrec
lens=length(scodrec);

% Decodifica las palabras consecutivas de scodrec y concatena en xrec
while ptr < lens
    [C, ptr]=DecodeWord(ptr, scodrec, MINCODE,MAXCODE,VALPTR,HUFFVAL);
    xrec=[xrec; C];
end

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeString');
    disp('--------------------------------------------------');
end