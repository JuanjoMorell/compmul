function TxCompressor(nombre)
    
    % Leemos el fichero para obtener los caracteres en ASCII en x y la
    % longitud del archivo en lenx
    [x, lenx] = ReadTextFile(nombre);
    
    % Creamos el archivo comprimido
    [~, name, ~] = fileparts(nombre);
    nombrecomp = strcat(name, ".huf");
    
    % Se aplica el proceso de compresión
    [scod, BITS, HUFFVAL] = StCompressor(x);
    
    % Se transforma el string binario a una matriz de bytes.
    [sbytes, ult1] = bits2bytes(scod);
    
    % Se preparan los datos a escribir en el archivo comprimido
    ulenBITS = uint8(length(BITS));
    uBITS = uint8(BITS);
    ulenHUFFVAL = uint8(length(HUFFVAL));
    uHUFFVAL = uint8(HUFFVAL);
    ulensbytes =uint32(length(sbytes));
    uult1 = uint8(ult1);
    usbytes=sbytes;
    
    % Escribir los datos en el archivo comprimido
    fid = fopen(nombrecomp, 'w');
    fwrite(fid, ulenBITS, 'uint8');
    fwrite(fid, uBITS, 'uint8');
    fwrite(fid, ulenHUFFVAL, 'uint8');
    fwrite(fid, uHUFFVAL, 'uint8');
    fwrite(fid, ulensbytes, 'uint32');
    fwrite(fid, uult1, 'uint8');
    fwrite(fid, usbytes, 'uint8');
    fclose(fid);
    
    % Información por pantalla
    TO = lenx;
    TCabecera = length(BITS) + 1 + length(HUFFVAL) + 1;
    TDatos = 4 + 1 + length(sbytes);
    TC = TCabecera + TDatos;
    
    RCfil = 100*(TO-TC)/TO;
    
    disp('-----------------');
    fprintf('%s %s\n', 'Archivo comprimido:', nombrecomp);
    fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
    fprintf('%s %d %s %d\n', 'Tamaño cabecera y codigo =', TCabecera, 'Tamaño datos=', TDatos);
    fprintf('%s %2.2f %s\n', 'RC archivo =', RCfil, '%.');
    if RCfil<0
        disp('El archivo original es demasiado pequeño. No se comprime.');
        fprintf('%s %2.2f %s\n','La cabecera provoca un aumento de tamaño de un ', abs(RCfil), '%.');
    end
    
end