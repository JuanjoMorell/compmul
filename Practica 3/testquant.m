function testquant(fname,caliQ)

% Funcion que cuantiza y descuantiza la transformada DCT de una imagen.

% ENTRADAS:
%   fname: Imagen de entrada
%   caliQ: Factor de calidad (entero positivo >= 1)
% SALIDAS:
%   mse : Error cuadratico medio entre matrices original y reconstruida.
%   dmaxdifer : Maxima diferencia entre pixeles homologos.

    % Se lee el archivo de imagen y se genera la matriz truecolor RGB.
    % Se convierte el espacio RGB a un espacio YCbCr.
    % Se amplia la matriz a dimensiones multiplo de 8.
    [X, Xamp, ~, m, n, ~, ~, ~] = imlee(fname);
    
    % --- PROCESO DE CUANTIZACION ---
    
    % Aplica DCT sobre la matriz ampliada.
    % Se obtiene la matriz transformada XTRANS.    
    Xtrans = imdct(Xamp);
    
    % Se cuantiza la matriz transformada XTRANS, mediante dos matrices
    % de cuantizacion, llamadas QY y QC, multiplicadas por CALIQ.
    % Se obtiene la matriz cuantizada XLAB.
    Xlab = quantmat(Xtrans,caliQ);
    
    % --- PROCESO DE DESCUANTIZACION ---
    
    % Se descuantiza la matriz XLAB, aplicando el proceso inverso
    % que en la cuantizacion.
    % Se obtiene la matriz descuantizada XTRANSREC, aun transformada.
    Xtransrec = desquantmat(Xlab, caliQ);
    
    % Aplica iDCT sobre XTRANS
    % Se obtiene la reconstruccion de la matriz 
    % original ampliada, XAMPREC.
    Xamprec = imidct(Xtransrec, m, n);
    
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
