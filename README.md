# Contador de rayos
Cuenta cuantos rayos hay en imagenes de tormentas eĺetricas usando dos tipos de algoritmos, redes neuronales convolucionales y un algoritmo de lógica difusa optimizado con tecnicas de algoritmos geneticos.

## ¿Para que sirve?
Las tormentas electricas son uno de los fenomenos naturales mas devastadores que existen, cada año se pieden millones de dolares en reparar los daños que causan los rayos en las zonas donde caen, ya sea por perdida de equipos, infraestructura o mismos daños a la naturaleza que se requieren mitigar, como es el caso de los incendios forestales.

Este contador de rayos tiene como proposito ser implementado en un dispositivo IoT que capture fotos de tormentas electricas, para que sea capaz de determinar la cantidad de rayos que han caido en cierto momento, y de esta manera servir como complemento a las soluciones meteorologicas ya en uso.

## ¿Que tipo de imagenes evalua?
La entrada son imgenes binarias de 150x150 px de tamaño. Para obtener el conjunto de iomagenes se pasaron imagenes de internet por un procesamiento de imagenes que las volvía en formato binario y luego se recortaron segmentos del tamaño especificado para luego pasarlos por el algoritmo de lógica difusa o RNN.

* Conjunto de imagenes originales en la carpeta `imgOriginal`.
* Conjunto de imagenes binarias en la carpeta `imgOriginalBinary`.
* Conjunto de imagenes binarias de 150x150 px en la carpeta `imgBinary`.

## Procesamiento de imagenes
El algoritmo de procesamiento de imagenes consiste en tomar como entrada alguna de las imagenes de la carpeta `imgOriginal`, cambiarla a escala de grises, luego a binaria y pasarla por dos llenados de agujeros. El código de esto se encuentra en el archivo `generateBinaryImage.m`.

## Entrenamiento con redes neuronales convolucionales (RNC)
El el archivo `contadorRNC.m` contiene el algoritmo para el entrenamiento de una red neuronal, que tiene como capa de entrada una imagen de la carpeta `imgBinary`, luego una capa convolucional que analiza una matriz de 5x5 px. La explicación a profundidad de este algoritmo se encuentra el el poster que está en la carpeta `documentacion`.

## Alagoritmo de lógica difusa
Este consiste en obtener unas estadisticas de las imagenes de la carpeta `imgBinary` (cuyo código está en `getImagesInformation`), luego pasar esta información por un sistema de lógica difusa (que se puede ver tanto en el archivo `FuzzyLogicIndividualCounter.m`, `FuzzyLogicCounter.m`, cualquiera de los archivos `fuzzySystemSaticConfX.m`, o `generaFisConfX.m` para el caso de la optimización con algoritmo genetico). Mas información se puede encontrar en el paper escrito que se encuentra en la carpeta `documentacion`.