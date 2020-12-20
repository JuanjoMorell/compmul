function TxDecompressor(nombre)

    % Lee archivo comprimido
    fid = fopen(nombre,'r');
    lenBITS = double(fread(fid,1,'uint8'));
    BITS = double(fread(fid, lenBITS, 'uint8'));
    lenHUFFVAL = double(fread(fid, 1, 'uint8'));
    HUFFVAL = double(fread(fid, lenHUFFVAL, 'uint8'));
    lensbytes = double(fread(fid, 1, 'uint32'));
    ultl = double(fread(fid, 1, 'uint8'));
    sbytes = double(fread(fid, lensbytes, 'uint8'));
    fclose(fid);
    
    % Genera nombre archivo descomprimido <nombre>_des.txt
    [~,name,~] = fileparts(nombre);
    nombrecomp=strcat(name,'_des','.txt');
    
    % Convierte sbytes a string binario codificado
    scodrec=bytes2bits(sbytes, ultl);

    % Decodifica mediante la funcion StDecompressor
    x=StDecompressor(BITS,HUFFVAL,scodrec);
    
    % Guarda archivo descomprimido
    xdes=char(x');
    fid = fopen(nombrecomp,'w');
    fwrite(fid,xdes,'uchar');
    fclose(fid);
    
end

