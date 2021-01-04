function ejecutar(fname,FCS)

    nFactores = length(FCS);
    disp(sprintf('%s %d', 'FACTORES ', nFactores));

    MSE_default = zeros(nFactores,1);
    RC_default = zeros(nFactores,1);
    MSE_custom = zeros(nFactores,1);
    RC_custom = zeros(nFactores,1);
    
    [~, name, ~] = fileparts(fname);
    compHUF = strcat(name, ".huf");
    compHUC = strcat(name, ".huc");
    
    for i = 1:nFactores
        factor = FCS(i);
        
        disp(i)
        disp('--------------------------------------------------');
        disp(sprintf('%s %d', '(DEFAULT) Factor de Calidad: ', factor));

        jcom_dflt(fname,factor);
        [MSE_default(i),RC_default(i)] = jdes_dflt(compHUF);
        
        disp('--------------------------------------------------');
        disp(sprintf('%s %d', '(CUSTOM) Factor de Calidad: ', factor));
        
        jcom_custom(fname,factor);
        [MSE_custom(i),RC_custom(i)] = jdes_custom(compHUC);
       
    end
    
    % GRAFICAS
    figure
    semilogy(RC_default, MSE_default, '-*', RC_custom, MSE_custom, '-*');

    xlabel('RC %');
    ylabel('MSE');

    legend('Matlab dflt', 'Matlab custom');

    titulo = strcat('MSE vs RC para:  ', fname);
    subtitulo = 'Factores de Calidad: ';
    subtitulo = strcat(subtitulo, int2str(FCS));

    title({titulo, subtitulo});
    
end

