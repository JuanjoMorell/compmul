function RC = jcom_dflt(fname,caliQ)
    
% Comprime y descomprime un archivo de imagen BMP, aplicando una  
% simplificación del método JPEG. 

% ENTRADA
%   fname: Imagen de entrada. Admite BMP y JPEG, indexada y true color
%   caliQ: Factor de calidad. (Entero positivo >= 1)
% SALIDA
%   RC: Relacion de compresion. 
%   Guarda informacion en un archivo <fname>.huf

    % Lee archivo de imagen
    % Convierte a espacio de color YCbCr
    % Amplia dimensiones a multiplos de 8
    %  X: Matriz original de la imagen en espacio RGB
    %  Xamp: Matriz ampliada de la imagen en espacio YCbCr
    [X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);

    % Calcula DCT bidimensional en bloques de 8 x 8 pixeles
    Xtrans = imdct(Xamp);

    % Cuantizacion de coeficientes
    Xlab=quantmat(Xtrans, caliQ);

    % Genera un scan por cada componente de color
    %  Cada scan es una matriz mamp x namp
    %  Cada bloque se reordena en zigzag
    XScan=scan(Xlab);

    % Codifica los tres scans, usando Huffman por defecto
    [CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan); 
    
    % Conversion a matrices binarias
    % Matriz CodedY
    [sbytesCodedY, ultlCodedY] = bits2bytes(CodedY);
    % Matriz CodedCb
    [sbytesCodedCb, ultlCodedCb] = bits2bytes(CodedCb);
    % Matriz CodedCr
    [sbytesCodedCr, ultlCodedCr] = bits2bytes(CodedCr);
    
    % Crear archivo comprimido
    [~, name, ~] = fileparts(fname);
    nombrecomp = strcat(name, ".huf");
    
    % Se preparan los archivos para su escritura en el archivo comprimido.
    % Datos de cabecera.
    % caliQ, m, n, mmap, nmap.
    uCaliQ = uint32(caliQ);
    uM = uint32(m);
    uN = uint32(n);
    uMamp = uint32(mamp);
    uNamp = uint32(namp);
    
    % Cuerpo del archivo.
    % CodedY: lenCodedY, sbytesCodedY, ultlCodedY.
    % CodedCb: lenCodedCb, sbytesCodedCb, ultlCodedCb.
    % CodedCr: lenCodedCr, sbytesCodedCr, ultlCodedCr.
    ulenCodedY = uint32(length(sbytesCodedY));
    ultlCodedY = uint8(ultlCodedY);
    
    ulenCodedCb = uint32(length(sbytesCodedCb));
    ultlCodedCb = uint8(ultlCodedCb);
    
    ulenCodedCr = uint32(length(sbytesCodedCr));
    ultlCodedCr = uint8(ultlCodedCr);
    
    % Escribir datos en fichero
    fid = fopen(nombrecomp, 'w');
    % Escribir datos de cabecera
    fwrite(fid, uCaliQ, 'uint32');
    fwrite(fid, uM, 'uint32');
    fwrite(fid, uN, 'uint32');
    fwrite(fid, uMamp, 'uint32');
    fwrite(fid, uNamp, 'uint32');
    
    % Escribir datos del cuerpo
    % CodedY
    fwrite(fid, ulenCodedY, 'uint32');
    fwrite(fid, ultlCodedY, 'uint8');
    fwrite(fid, sbytesCodedY, 'uint8');
    % CodedCb
    fwrite(fid, ulenCodedCb, 'uint32');
    fwrite(fid, ultlCodedCb, 'uint8');
    fwrite(fid, sbytesCodedCb, 'uint8');
    % CodedCr
    fwrite(fid, ulenCodedCr, 'uint32');
    fwrite(fid, ultlCodedCr, 'uint8');
    fwrite(fid, sbytesCodedCr, 'uint8');
    
    fclose(fid);
    
    % Calculo de la Relacion de Compresion.
    % Tamaño de la Cabecera: caliQ, m, n, mamp, namp.
    sizeCabecera = 4 + 4 + 4 + 4 + 4;
    % Tamaño del cuerpo: (sumandole 1 por el offset)
    % CodedY
    sizeDatos = 1 + length(ulenCodedY) + 1 + length(ultlCodedY) + length(sbytesCodedY);
    % CodedCb
    sizeDatos = sizeDatos + 1 + length(ulenCodedCb) + 1 + length(ultlCodedCb) + length(sbytesCodedCb);
    % CodedCr
    sizeDatos = sizeDatos + 1 + length(ulenCodedCr) + 1 + length(ultlCodedCr) + length(sbytesCodedCr);
    
    % Tamaño del archivo comprimido
    TC = sizeCabecera + sizeDatos;
    
    % Relacion de compresion
    RC = 100 * ((TC - TO) / TO);
    
    disp("Relacion de compresion");
    disp(RC);
    
end

