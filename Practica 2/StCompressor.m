function [scod, BITS, HUFFVAL] = StCompressor(x)

    % Se obtiene la frecuencia de aparici�n de cada uno de los caracteres
    % del texto
    FREQ = Freq256(x);
    
    % Con la funci�n HSpecTables obtenemos BITS y HUFFVAL
    %   * BITS: Lista con el n�mero de palabras codigo que se van a generar
    %           de cada tama�o.
    %   * HUFFVAL: Lista que contiene los simbolos de la fuente, ordenados
    %              por longitudes crecientes.
    [BITS, HUFFVAL] = HSpecTables(FREQ);
    
    [HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
    [EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);
    
    scod='';
    for i=1:length(x)
        index=x(i)+1;
        scod =[scod dec2bin(EHUFCO(index), EHUFSI(index))];
    end

end