function [mse, dmaxdifer] = testdct(fname)

% Aplica la transformada DCT y la transformada inversa de DCT
% sobre una imagen.

% ENTRADAS:
%   fname : Nombre de la imagen a transformar.
% SALIDAS:
%   mse : Error cuadratico medio entre matrices original y reconstruida.
%   dmaxdifer : Maxima diferencia entre pixeles homologos.

    % Se lee el archivo de imagen y se genera la matriz truecolor RGB.
    % Se convierte el espacio RGB a un espacio YCbCr.
    % Se amplia la matriz a dimensiones multiplo de 8.
    [X, Xamp, ~, m, n, ~, ~, ~] = imlee(fname);
    
    % Aplica DCT sobre la matriz ampliada.
    % Se obtiene la matriz transformada XTRANS.
    Xtrans = imdct(Xamp);
    
    % Aplica iDCT sobre XTRANS
    % Se obtiene la reconstruccion de la matriz 
    % original ampliada, XAMPREC.
    Xamprec = imidct(Xtrans, m, n);
    
    % Se convierte XAMPREC al espacio de color RGB.
    % Se reduce sus dimensiones al espacio original.
    % Se obtiene la matriz reconstruida XREC.
    % Se almacena en una imagen del tipo BMP.
    [Xrec, ~] = imescribe(Xamprec, m, n, fname);
    
    %Calcular el error cuadratico medio MSE
    mse = (sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);
    disp("Error cuadratico medio (MSE)");
    disp(mse);
    
    % Calcular maxima diferencia entre pixeles
    ddifer=abs(double(Xrec)-double(X));
    dmaxdifer=max(max(max(ddifer)));
    disp("Máxima diferencia entre pixeles");
    disp(dmaxdifer);
    
    % Test visual
    % Se visualiza la imagen X
    [m,n,~] = size(X);
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(X);
    set(gcf,'Name','Imagen original X');
    
    % Se visualiza la imagen XREC
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec);
    set(gcf,'Name','Imagen reconstruida Xrec');
    
end
