function [MSE, RC] = jdes_dflt(fname)
    
    % Leer el archivo
    fid = fopen(fname,'r');
    ulenCodedY = double(fread(fid,1,'uint8'));
    uCodedY = double(fread(fid, ulenCodedY, 'uint8'));
    ulenCodedCb = double(fread(fid, 1, 'uint8'));
    uCodedCb = double(fread(fid, ulenCodedCb, 'uint8'));
    ulenCodedCr = double(fread(fid, 1, 'uint8'));
    uCodedCr = double(fread(fid, ulenCodedCr, 'uint8'));
    ulenAmp = double(fread(fid, 1, 'uint8'));
    uAmp = double(fread(fid, ulenAmp, 'uint8'));
    fclose(fid);

    % Decodifica los tres Scans a partir de strings binarios
    XScanrec=DecodeScans_dflt(uCodedY,uCodedCb,uCodedCr, uAmp);

    % Recupera matrices de etiquetas en orden natural
    %  a partir de orden zigzag
    Xlabrec=invscan(XScanrec);

    % Descuantizacion de etiquetas
    Xtransrec=desquantmat(Xlabrec, caliQ);

    % Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
    % Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
    Xamprec = imidct(Xtransrec,m, n);

    % Convierte a espacio de color RGB
    % Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
    Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
    Xrec=uint8(Xrecrd);

    % Repone el tamaño original
    Xrec=Xrec(1:m,1:n, 1:3);
    
    [m,n,p] = size(Xrec);
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec); 
    set(gcf,'Name','Imagen descomprimida');
end

