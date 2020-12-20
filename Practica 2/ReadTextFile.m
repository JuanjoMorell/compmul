function [x, lenx] = ReadTextFile(nombre)

% Lee un archivo de texto ASCII 
% El archivo debe contener una secuencia de numeros entre 0 y 255
% Para usarlo con otro tipo de archivos, puede necesitar ser adaptado.

% Entradas
%   nombre: Nombre de archivo (ej. 'test.txt')

% Salidas:
%   x: Vector columna con la secuencia de codigos ASCII leida
%   lenx: Nº de caracteres leidos 

% Control de verbosidad
disptext=1;             % Flag de verbosidad
if disptext
    tc=cputime;         % Instante inicial
    disp('--------------------------------------------------');
    disp('Funcion GenSecDDP:');
end

% Lee archivo
fid = fopen(nombre,'r');
[x, lenx] = fread(fid); % Vector columna x con lenx codigos ASCII [0, 255]
fclose(fid);

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado ReadTextFile');
    disp('--------------------------------------------------');
end