# Contador de rayos
Cuenta cuantos rayos hay en imágenes de tormentas eléctricas usando dos tipos de algoritmos, redes neuronales convoluciones y un algoritmo de lógica difusa optimizado con una técnica de algoritmos genéticos.

## ¿Para que sirve?
Las tormentas eléctricas son uno de los fenómenos naturales mas devastadores que existen, cada año se pieden millones de dolares en reparar los daños que causan los rayos en las zonas donde caen, ya sea por perdida de equipos, infraestructura o mismos daños a la naturaleza que se requieren mitigar, como es el caso de los incendios forestales.

Este contador de rayos tiene como propósito ser implementado en un dispositivo IoT que capture fotos de tormentas eléctricas, para que sea capaz de determinar la cantidad de rayos que han caído en cierto momento, y de esta manera servir como complemento a las soluciones meteorológicas ya en uso.

## ¿Que tipo de imágenes evalúa?
La entrada son imágenes binarias de 150x150 px de tamaño. Para obtener el conjunto de datos se pasaron imágenes de internet por un procesamiento que las volvía imágenes binarias y luego se recortaron segmentos del tamaño especificado para pasarlos por los contadores de rayos que usan lógica difusa o RNN.

* `imgOriginal`: Conjunto de imagenes originales.
* `imgOriginalBinary`: Conjunto de imagenes binarias.
* `imgBinary`: Conjunto de imagenes binarias de 150x150 px.

## ¿Como funciona?

### Procesamiento de imágenes
El algoritmo de procesamiento de imágenes consiste en tomar como entrada alguna de las imágenes de la carpeta `imgOriginal`, cambiarla a escala de grises, luego a binaria y pasarla por dos llenados de agujeros. El código de esto se encuentra en el archivo `generateBinaryImage.m`.

### Opción 1: Algoritmo de lógica difusa
Este consiste el desarrollo de un sistema de lógica difusa que sea capaz de decir cuantos rayos hay en una imagen basado en  estadisticas obtenidas de las imagenes de la carpeta `imgBinary`.

#### Obtención de estadísticas
El código está en `getImagesInformation.m`, lo que hace es que crea una estructura en la que se almacena la información de las estadísticas obtenidas por el método `regionprops` de cada imagen. Esta estructura luego es consultada por el algoritmo de lógica difusa.

#### Contador de rayos estatico
El código está en `FuzzyLogicCounter.m`, y lo que hace es que coge las imágenes de la carpeta `imgBinary`,y las separa en 90% para entrenamiento, 5% para validación y prueba. Esto se hizo así porque realmente utiliza las mismas imágenes de "entrenamiento" como prueba mas adelante. 

Luego llama a un sistema de lógica difusa, crea la estructura con la información estadística de las imágenes de entrenamiento y empieza a comparar las etiquetas de las imágenes de esta estructura con las que va calculando con el sistema de lógica difusa.

Finalmente se calcula que tan acertado fue la predicción haciendo la división entre el número de imágenes cuyas etiquetas de predicción y validación fueron iguales sobre el número total de imágenes analizadas.


#### Optimización por algoritmo genético
El código está en `OptimizedCounterAG.m`, y hace técnicamente lo mismo que el contador de rayos estático, pero a diferencia de este, el carga una de las configuraciones de sistemas de lógica difusa (que tienen de nombre `generafisConfX.m`, donde X es un número del 1 al 4), y lo optimiza por medio de una función objetivo, que está definida en el archivo `fobj.m`. El proceso de optimización va variando los valores del sistema de lógica difusa (que varían en cantidad entre cada una de las configuraciones) para luego obtener un conjunto de valores con el que se obtiene el menor error. Todo esto ocurre en la línea:

`X = ga(@fobj,Y,optionsga)` Donde Y es el número de variables de alguna de las configuraciones.

Luego el código evalúa la configuración con este conjunto de datos para obtener las gráficas de error y predicción.

**El algoritmo genético utilizó una población de 50 individuos por 20 generaciones para hacer la optimización**.

##### Configuraciones
La idea de los archivos `generafisConf1.m`, `generafisConf2.m`, `generafisConf3.m` y `generafisConf4.m` es plantear diferentes funciones de pertenencia, valores limite y hasta diferente número de reglas, para luego comparar los resultados de las configuraciones y determinar cual tuvo menos error. Para cada una de las configuraciones se hicieron 10 ejecuciones, generando sistemas que están almacenados en la carpeta `resultadosOptimizacion`.


### Opción 2: Contador con redes neuronales convolucionales (RNC)
El el archivo `CNNCounter.m` contiene el algoritmo que cuenta cuantos rayos en una imagen usando redes neuornales. Este archivo no depende de ningún otro, por lo que  puede ser ejecutado de forma normal.

#### Datos de entrenamiento
Para el entrenamiento de la red neuronal se toman las imágenes de la carpeta `imgBinary`, la cual contiene subcarpetas cuyo nombre le sirve a matlab como etiqueta de clasificación. Se separan las imágenes en 60% para entrenamiento, 20% para validación y 20% para pruebas.

#### Estrcutura de la red neuronal
La capa de entrada es alguna de las imágenes de 150x150 px que
utiliza para el entrenamiento. Dado que sería muy difícil analizar cada píxel de forma individual, se utiliza un filtro convolucional de 5x5 de 10 capas, este se encarga de analizar la imagen en segmentos de tamaño 5x5.

Luego pasa por una capa que reduce el tamaño de la imagen y despues pasa por otro filtro convolucional de 5x5 de 10 capas.

La capa final da el resultado de la clasificación, si la imagen contiene 0, 1 o 2 rayos.

#### Precisión
Se crea la variable `YPred` en las que se añaden las imágenes clasificadas por la red neuronal del conjunto de datos `imdsTest`, y se crea la variable `YTest` que contiene las etiquetas que corresponden al conjunto de datos con las que se está verificando. La precisión está dada por la cantidad de veces en las que la etiqueta de las imágenes predichas sean iguales a las etiquetas originales, sobre el número total de imágenes que analiza, siendo 1 (0 100%) el máximo, y 0 el peor valor posible.

#### Imágenes que no cuadran
Finalmente se muestra un gráfico en el que se muestran las imágenes cuya etiqueta sobre cuantos rayos se presentan no pudieron ser predichas por la red neuronal.

## Resultados
Los resultados obtenidos por este sistema, así como una explicación teórica del funcionamiento del algoritmo se encuentra en el archivo `paper_final.pdf`.