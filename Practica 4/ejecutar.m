function ejecutar(fname,FCS)

    nFactores = length(FCS);
    disp(sprintf('%s %d', 'FACTORES ', nFactores));

    MSE_default = zeros(nFactores);
    RC_default = zeros(nFactores);
    MSE_custom = zeros(nFactores);
    RC_custom = zeros(nFactores);
    
    [~, name, ~] = fileparts(fname);
    compHUF = strcat(name, ".huf");
    compHUC = strcat(name, ".huc");
    
    for i = 1:nFactores
        factor = FCS(i);
        
        disp(i)
        disp('--------------------------------------------------');
        disp(sprintf('%s %d', '(DEFAULT) Factor de Calidad: ', factor));

        jcom_dflt(fname,factor);
        [MSE_def,RC_def] = jdes_dflt(compHUF);
        
        disp('--------------------------------------------------');
        disp(sprintf('%s %d', '(DEFAULT) Factor de Calidad: ', factor));
        
        jcom_custom(fname,factor);
        [MSE_cus,RC_cus] = jdes_custom(compHUC);
        
        % Guardar valores para las graficas
        MSE_default(i) = MSE_def;
        RC_default(i) = RC_def;
        MSE_custom(i) = MSE_cus;
        RC_custom(i) = RC_cus;
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

