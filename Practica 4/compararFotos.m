function compararFotos(fOriginal,fComprimidas, MSE_default, RC_default, MSE_custom, RC_custom)

    [X, ~, ~, m, n, ~, ~, TO] = imlee(fOriginal);
    
    fotos = length(fComprimidas);
    
    MSE_ps = zeros(fotos,1);
    RC_ps = zeros(fotos,1);
    
    for i = 1:fotos
        fComprimida = fComprimidas(i);
        
        [Xrec, ~, ~, ~, ~, ~, ~, TC] = imlee(fComprimida);
        
        MSE_ps(i)=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);
        RC_ps(i) = 100*(TO-TC)/TO;
    end
    
    % Grafica
    % GRAFICAS
    figure
    semilogy(RC_default, MSE_default, '-*', RC_custom, MSE_custom, '-*', RC_ps, MSE_ps, '-*');

    xlabel('RC %');
    ylabel('MSE');

    legend('Matlab dflt', 'Matlab custom', 'Photoshop');
    
    

end

