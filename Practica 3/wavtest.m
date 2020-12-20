function wavtest(fname)
    
    % Se lee el fichero de audio
    [y, Fs] = audioread(fname);
    
    [lon canales]=size(y);
    
    disp(canales);
     
    n=(0:lon-1)'; t=n/Fs;
    plot(t,y(:,1));
    xlabel('t (s)'); ylabel('y (V)');
    set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':');
    title('Senal Audio hceste.wav x(t)'); 
    
    plot(t,y(:,2));
    xlabel('t (s)'); ylabel('y (V)');
    set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':');
    title('Senal Audio hceste.wav x(t)'); 
end

