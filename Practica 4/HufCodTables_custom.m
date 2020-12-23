function [ehuf, BITS, HUFFVAL] = HufCodTables_custom(datos)

% Genera tablas de codificacion por defecto
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Kingsbury, Treece & Rosten, 2011, University of Cambridge

% Entradas:
%   datos: Tabla de valores
% Salidas
%   ehuf: Es la concatenacion [EHUFCO EHUFSI], donde;
%     EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%     EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)

% Se calcula la frecuencia
FREQ = Freq256(datos);

% Carga tablas de especificacion Huffman por defecto
[BITS,HUFFVAL] = HSpecTables(FREQ);

% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);

ehuf=[EHUFCO EHUFSI];


