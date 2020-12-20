function RC = jcom_dflt(fname,caliQ)
    
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
    
    % Crear archivo comprimido
    [~, name, ~] = fileparts(fname);
    nombrecomp = strcat(name, ".huf");
    
    % Preparar datos
    ulenCodedY = uint8(length(CodedY));
    uCodedY = uint8(CodedY);
    ulenCodedCb = uint8(length(CodedCb));
    uCodedCb = uint8(CodedCb);
    ulenCodedCr = uint8(length(CodedCr));
    uCodedCr = uint8(CodedCr);
    amp = [mamp, namp];
    ulenAmp = uint8(length(amp));
    uAmp = uint8(amp);
    
    % Escribir datos en fichero
    fid = fopen(nombrecomp, 'w');
    fwrite(fid, ulenCodedY, 'uint8');
    fwrite(fid, uCodedY, 'uint8');
    fwrite(fid, ulenCodedCb, 'uint8');
    fwrite(fid, uCodedCb, 'uint8');
    fwrite(fid, ulenCodedCr, 'uint8');
    fwrite(fid, uCodedCr, 'uint8');
    fwrite(fid, ulenAmp, 'uint8');
    fwrite(fid, uAmp, 'uint8');
    fclose(fid);
    
end

