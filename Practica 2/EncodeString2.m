function scod = EncodeString2(x, EHUFCO, EHUFSI)

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

% Inicializacion
% Maxima longitud de palabra
MaxCodeLen=max(EHUFSI);
% Longitud de la secuencia
xLen=length(x);
% Inicializa xcode: 
%   Cada fila i sera la palabra codigo asociada a x(i)
%   Se inicializa a palabras vacias
EmptyCode=blanks(MaxCodeLen);
xcode=repmat(EmptyCode, [xLen 1]);

% Recorre las 256 palabras codigo y las busca en x
% Tiene en cuenta offset 1
for i=0:255
    j=find(x==i);
    % Introduce en las posiciones j de xcod la palabra codigo correspondiente
    if length(j)>0
        xcode(j,:)=repmat([dec2bin(EHUFCO(i+1),EHUFSI(i+1)) blanks(MaxCodeLen-EHUFSI(i+1))], [length(j) 1]);
    end
end

% Compacta los strings en las filas de xcode en un string
%   eliminado espacios en blanco al final de cada palabra
scod=strrep(reshape(xcode',1, xLen*MaxCodeLen),' ','');

% Presentacion de verbosidad
if disptext
    e=cputime-tc;       % Tiempo de ejecucion
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado EncodeString');
    disp('--------------------------------------------------');
end