% Carlos Marin Lora
% Hito 2 - Percepcion Visual
% Master Sistemas Inteligentes - 2017
% UJI
%--------------------------------------------------------------------------

% El problema planteado consiste en la fusion
% de dos imagenes, cada una de ellas correspondiente
% a un personaje famoso. La imagen resultante debe
% conseguir el siguiente efecto visual: mientras
% que vista de cerca se podran apreciar mas claramente
% los detalles de una de las caras, al observarla
% de mas lejos se apreciaran mejor los detalles de 
% la otra.

% A partir de la pista del ejemplo de resultado mostrada
% en el enunciado del hito, basada en un repositorio
% del MIT, esta implementacion se ha basado integramente
% en el paper de 2006 Hybrid images de Aude Oliva et al.
% sobre el que se origina este tipo de Hybrid Images.

function caraFusion = fusionar(cara1, cara2)

    % Mostramos las imagenes originales (descomentar)
    %----------------------------------------------------------------------
    % figure, imshow(cara1);
    % figure, imshow(cara2);

    % A partir de las imagenes almacenadas en memoria
    % generamos sus versiones en escala de grises y las
    % convertimos al espacio de precision doble.
    %----------------------------------------------------------------------
    I1 = im2double(cara1);
    I2 = im2double(cara2);
    
    % En el paper, se especifica que este tipo de imagenes se construyen a
    % partir de la combinacion de dos imagenes, una filtrada a con un
    % filtro paso bajo y otra con un filtro paso alto. Y mediante
    % operaciones basadas en el dominio de Fourier.
    
    % Para esta implementacion, vamos a construir dos funciones de filtrado
    % paso baso y paso alto. En un principio estaban construidas en sendos
    % ficheros .m externos para tener un codigo mas limpio, pero como se 
    % indica en la tarea: sólo debe enviarse un fichero con la funcion
    % FUSIONAR, se ha procedido de la manera que se presenta a
    % continuacion.
    
    
    % FILTRO PASO BAJO:
    % Eliminamos los componentes de alta frecuencia mediante un filtrado
    % gaussiano.
    %----------------------------------------------------------------------
    sigma = 1;                          % Desviacion pequeña para acceder a las altas frecuencias
    anchuraGaussiana = 6 * sigma - 1;   % Kernel gaussiano. https://en.wikipedia.org/wiki/Gaussian_filter

    tfbI1  = fft2(I1);          % Obtenemos la transformada de Fourier bidimensional para la I1.
    stfbI1 = fftshift(tfbI1);   % Generamos su version desplazada 

    [i,j] = size(tfbI1);        % Obtenemos las dimensiones de la imagen.. 
    
    X = 0:j-1;
    Y = 0:i-1;
    
    [X,Y] = meshgrid(X, Y);     % ..y generamos un meshgrid sobre el que determinar la funcion gaussiana.
    
    puntoMedioX = 0.5 * j;      % Determinamos el punto medio de la funcion para ambas dimensiones y
    puntoMedioY = 0.5 * i;      % tener asi el punto central donde se encuentran los valores maximos

    % Calculamos la funcion gaussiana bidimensional con la expresion de la
    % funcion gaussiana bidimensional, todo ello punto a punto, y centrada
    % en los maximos.
    G1 = exp(-((X - puntoMedioX).^2 + (Y - puntoMedioY).^2)./(2 * anchuraGaussiana).^2);

    fstbI1 = stfbI1.*G1;            % Aplicamos el filtrado calculado a la imagen desplazada
    sfstbI1 = ifftshift(fstbI1);    % Deshacemos el desplazamiento..
    lowPassImage = ifft2(sfstbI1);  % ..y deshacemos la transformada al espacio de Fourier

    % figure, imshow(real(lowPassImage)); % Mostramos la imagen (descomentar)
    
    
    % FILTRO PASO ALTO:
    % Conservamos los componentes de alta frecuencia mediante un filtrado
    % gaussiano.
    %----------------------------------------------------------------------
    sigma = 5;                         % Desviacion más alta para conservar las altas frecuencias
    anchuraGaussiana = 6 * sigma - 1;   % Kernel gaussiano. https://en.wikipedia.org/wiki/Gaussian_filter
    
    tfbI2  = fft2(I2);          % Obtenemos la transformada de Fourier bidimensional para la I2.
    stfbI2 = fftshift(tfbI2);   % Generamos su version desplazada 

    [i,j] = size(tfbI2);        % Obtenemos las dimensiones de la imagen.. 
    
    X = 0:j-1;
    Y = 0:i-1;
    
    [X,Y] = meshgrid(X, Y);     % ..y generamos un meshgrid sobre el que determinar la funcion gaussiana.
    
    puntoMedioX = 0.5 * j;      % Determinamos el punto medio de la funcion para ambas dimensiones y
    puntoMedioY = 0.5 * i;      % tener asi el punto central donde se encuentran los valores maximos
    
    % Calculamos la funcion gaussiana bidimensional con la expresion de la
    % funcion gaussiana bidimensional, todo ello punto a punto, y centrada
    % en los maximos. En este caso, buscando conservar las altas
    % frecuencias mediante la resta sobre la funcion unitaria.
    G2 = 1 - exp(-((X - puntoMedioX).^2 + (Y - puntoMedioY).^2)./(2 * anchuraGaussiana).^2);
    
    fstbI2 = stfbI2.*G2;            % Aplicamos el filtrado calculado a la imagen desplazada
    sfstbI2 = ifftshift(fstbI2);    % Deshacemos el desplazamiento..
    highPassImage = ifft2(sfstbI2); % ..y deshacemos la transformada al espacio de Fourier
    
    % figure, imshow(real(highPassImage)); % Mostramos la imagen (descomentar)
    
    
    % HYBRID IMAGE:
    % Por ultimo, combinamos ambas fuentes de informacion en una sola
    % imagen, dando resultado a la imagen hibrida generada a partir de dos
    % filtros gaussianos: low-pass y high pass.
    %----------------------------------------------------------------------
    caraFusion = lowPassImage + highPassImage;
    
    figure, imshow(real(caraFusion)); % Mostramos la imagen
    
    imwrite(real(caraFusion), 'caraFusion.pgm');
    
end
