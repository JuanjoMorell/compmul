function [MSE, RC] = jdes_dflt(fname)

% Descomprime un archivo huf, aplicando una  
% simplificaci�n del m�todo JPEG. 

% ENTRADA
%   fname : Fichero de entrada tipo huf.
% SALIDA
%   MSE: Error cuadratico medio.
%   RC: Relacion de compresion.
    
    disptext = 1;
    
    % Leer el archivo
    fid = fopen(fname,'r');
    
    % Leer datos de Cabecera
    caliQ = double(fread(fid,1,'uint32'));
    m = double(fread(fid,1,'uint32'));
    n = double(fread(fid,1,'uint32'));
    mamp = double(fread(fid,1,'uint32'));
    namp = double(fread(fid,1,'uint32'));
    
    % Leer archivos del cuerpo del archivo.
    % CodedY
    lenCodedY = double(fread(fid,1,'uint32'));
    ultlCodedY = double(fread(fid,1,'uint8'));
    sbytesCodedY = double(fread(fid, lenCodedY, 'uint8'));
    % CodedCb
    lenCodedCb = double(fread(fid,1,'uint32'));
    ultlCodedCb = double(fread(fid,1,'uint8'));
    sbytesCodedCb = double(fread(fid, lenCodedCb, 'uint8'));
    % CodedCr
    lenCodedCr = double(fread(fid,1,'uint32'));
    ultlCodedCr = double(fread(fid,1,'uint8'));
    sbytesCodedCr = double(fread(fid, lenCodedCr, 'uint8'));
    
    fclose(fid);
    
    % Se convierten las matrices binarias a strings binarias
    CodedY = bytes2bits(sbytesCodedY, ultlCodedY);
    CodedCb = bytes2bits(sbytesCodedCb, ultlCodedCb);
    CodedCr = bytes2bits(sbytesCodedCr, ultlCodedCr);

    % Decodifica los tres Scans a partir de strings binarios
    XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr, [mamp namp]);

    % Recupera matrices de etiquetas en orden natural
    %  a partir de orden zigzag
    Xlabrec=invscan(XScanrec);

    % Descuantizacion de etiquetas
    Xtransrec=desquantmat(Xlabrec, caliQ);

    % Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
    % Como resultado, reconstruye una imagen YCbCr con tama�o ampliado
    Xamprec = imidct(Xtransrec,m, n);

    % Convierte a espacio de color RGB
    % Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
    Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
    Xrec=uint8(Xrecrd);

    % Repone el tama�o original
    Xrec=Xrec(1:m,1:n, 1:3);
    
    % Guardamos el archivo con la imagen reconstruida.
    [~,name,~] = fileparts(fname);
    imagenRecuperada=strcat(name,'_des_def.bmp');
    imwrite(Xrec, imagenRecuperada, 'bmp');
    % Recuperacion de la imagen original
    nameOriginal = strcat(name, '','.bmp');
    [X, ~, ~, ~, ~, ~, ~, TO] = imlee(nameOriginal);
    
    % Calculo de MSE y RC
    TC = dir(fname);
    TC = TC.bytes;
    MSE=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);
    RC = 100*(TO-TC)/TO;
    
    disp("Error cuadratico medio");
    disp(MSE);
    disp("Relacion de compresion");
    disp(RC);
    
    % Test visual
     if disptext
         [m,n,~] = size(X);
         figure('Units','pixels','Position',[100 100 n m]);
         set(gca,'Position',[0 0 1 1]);
         image(X); 
         set(gcf,'Name','Imagen original X');
         figure('Units','pixels','Position',[100 100 n m]);
         set(gca,'Position',[0 0 1 1]);
         image(Xrec);
         set(gcf,'Name','Imagen reconstruida Xrec');
     end
    
end

