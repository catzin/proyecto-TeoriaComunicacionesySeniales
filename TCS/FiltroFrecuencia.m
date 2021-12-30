% function J = IMG05_FiltroFrecuencia(I,H,show)
%
% Filtrado de una imagen I utilizando un filtro H. La imagen I esta en el
% dominio del espacio, el filtro H en el dominio de la frecuencia.
%
% El tamano de H debe ser igual al tamano de I (NxM)
%
% J es la imagen de salida (en el dominio del espacio) de las mismas
% dimensiones de la imagen I.
%
% D.Mery, DCC-PUC, Octubre 2018
% http://dmery.ing.puc.cl
%

%recibe la imagen y la mascara H
function J = FiltroFrecuencia(I,H,show)

if not(exist('show','var'))
    show = 0;
end

[N,M] = size(I);


[Nh,Mh] = size(H);
if Nh~=N
    error('Numero de filas de H debe ser igual al numero de filas de I');
end

if Mh~=M
    error('Numero de columnas de H debe ser igual al numero de columnas de I');
end

% Intercambio de cuadrantes
Hf = fftshift(H);


if show==1
   
    figure(3)
    subplot(1,2,1),mesh(H),title('H: Filtro en el dominio de la frecuencia'); hold on
    subplot(1,2,2),mesh(Hf),title('Hf: Intercambio de cuadrantes de H'); hold off
end


% Transformada de Fourier en 2D
F = fft2(I);


 

% Convolucion = multiplicacion en el dominio de la frecuencia
G = Hf.*F;

% Transformada inversa de fourier
Jp = ifft2(G);

J = real(Jp);

if show==1
    figure(2)
    subplot(2,2,1),imshow(log(abs(F)+1),[]),title('F: Tranformada de Fourier de I'); hold on
    subplot(2,2,2),imshow(log(abs(fftshift(F))+1),[]),title('Intercambio de cuadrantes de F');hold on
    subplot(2,2,3),imshow(log(abs(G)+1),[]),title('G: Tranformada de Fourier de I filtrado');hold on
    subplot(2,2,4),imshow(log(abs(fftshift(F))+1),[]),title('Intercambio de cuadrantes de G'); hold off
    
    
    figure(1)
    subplot(1,2,1),imshow(I,[]),title('I: Imagen Original'); hold on
    subplot(1,2,2),imshow(J,[]),title('J: Imagen Filtrada'); hold off
end

end