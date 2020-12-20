function [val,ptr]=DecodeWord(ptr, scodrec, MINCODE,MAXCODE,VALPTR,HUFFVAL)

% Decodifica la siguiente palabra de scodrec y avanza el puntero ptr

% Entradas:
%   ptr: Puntero a scodrec
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
%   val: Valor decodificado 
%   ptr: Nuevo puntero a scodrec

% Basado en ITU T.81, Anexo F
% Adaptado por Roque Marin

% Control de verbosidad
disptext=0;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion DecodeWord:');
end

% Decodificar siguiente palabar en scodrec, bit a bit
i=1; % Contador de bits de palabra
code=scodrec(ptr);
while bin2dec(code) > MAXCODE(i)
    ptr=ptr+1;
    code=[code scodrec(ptr)];
    i=i+1;
end
j=VALPTR(i);
j=j+bin2dec(code)-MINCODE(i);
val=HUFFVAL(j);
ptr=ptr+1;

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeWord');
    disp('--------------------------------------------------');
end