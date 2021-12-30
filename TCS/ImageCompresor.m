classdef ImageCompresor 
    
    properties
        img %img path
        imgGray %imagen para escala de grises
    end
    
    methods 
        
        function Compressor = ImageCompresor(imgPath)
            Compressor.img = imgPath;
        end
        
         function doCompression(Compressor)
            
             
             %leer la imagen
             %en forma de matriz RGB (r,g,b)
            A = imread(Compressor.img);
            
            figure(1);
   
            imshow(A);
         
            Compressor.imgGray = rgb2gray(A);
            
            %pasar la matrix a 2D osea a escala de grises
            %obtenemos tamaño de la matriz en gray
            %filas cols
            [nx,ny] = size(Compressor.imgGray ); 
            figure(2)
            subplot(2,2,1)
            imshow(Compressor.imgGray )
            title('Imagen original','FontSize',18)
            
            %seccion FFT
            
            tic;
            %aqui se tiene que pasar del dominio de los pixeles al dominio
            %de la frecuencia
            %B es la escala de grises
            %Bt es la imagen en el dominido de fourier osea de la frecuencia
            At = fft2(Compressor.imgGray);
            
            %disp(At);
            
            %matlab acomoda  distinto los coeficientes. Pondra los de frecuencia 
            %mas baja en el origen y los de frecuencia mas alta en las esquinas

            %necesito plotearlos , pero esos valores son muy pequeñitos
            % ncesitamos tomar el abs por que son numeros complejos
            % y se toma el una escala logaritmica para poder plotearlos
            %algunos de ellos pueden ser casi zeros, entonces por eso se agrega un uno 
            %para compensar esta escala logaritmica
            F = log(abs(fftshift(At))+1); %plot de la FFT
            %disp(F);
            F = mat2gray(F); % pasamos esa escala logaritmica y ploteamos 
            figure(3)
            imshow(F,[]);
            %%Zero out all small coefficients and inverse transform
            count_pic = 2;
            
          
            
            
            %Aqui lo que estamos haciendo es ordenar por magnitud
            %la FFT es una matriz de numeros complejos y con abs logramos
            %separar solo la parte real
            
            for thresh = .1*[0.001 0.005 0.01] * max(max(abs(At)))
                
                ind = abs(At) > thresh;
                count = nx * ny - sum(sum(ind));
                
                %convolucion
                Atlow = At.*ind;
                
                percent = 100 - count/(nx*ny)*100;
                
                Alow = uint8(ifft2(Atlow));
                figure(2) 
                subplot(2,2,count_pic), hold on;
                imshow(Alow); 
                count_pic = count_pic+1;
                
                drawnow
                title([num2str(percent) '% FFT compression'],'FontSize',18); hold on
                
            end
            
        end
        
    end
    
  
end