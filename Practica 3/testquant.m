function testquant(fname,caliQ)
    
    [X, Xamp, ~, m, n, ~, ~, ~] = imlee(fname);
    
    Xtrans = imdct(Xamp);
    Xlab = quantmat(Xtrans,caliQ);
    Xtransrec = desquantmat(Xlab, caliQ);
    
    Xamprec = imidct(Xtransrec, m, n);
    
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

