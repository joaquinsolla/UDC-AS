# Implementación de una arquitectura _pipeline_

En esta práctica he implementado una arquitectura _pipeline_ modelando una 
secuencia de instrucciones. La documentación de la arquitectura
se puede consultar en el pdf: [pipeline_echo_doc.pdf](pipeline_echo_doc.pdf).

## Descripción informal

**Este ejercicio ha tomado base del ejercicio 7 'servidor echo'.**

En el ejercicio 7 implementé una arquitectura C/S (Cliente/Servidor). En esta nueva 
implementación en _pipeline_ se crea un camino o secuencia de instrucciones modeladas como procesos 
que conforman el comportamiento de un servidor echo. El paso por dicho camino se lleva a cabo 
mediante el intercambio de mensajes entre procesos.

Se inicia el servidor con la función _start(n)_, siendo **n** el número de mensajes que se 
van a generar. Tras iniciarse el servidor echo se pasa a _msg_creation_, en donde se crean
los mensajes. Tras crearse cada mensaje, este pasa a _msg_processing_ para ser procesado, 
lo que se traduce en este caso en concatenarse el propio mensaje inverso. Una vez se ha procesado el 
mensaje, se envía a _msg_print_, donde finalmente se muestra en terminal. Una vez el servidor echo ha 
terminado, lo indica por terminal y devuleve **:ok**.

La secuencia de instrucciones queda de la siguiente manera:

_start -> start_aux -> msg_creation -> msg_processing -> msg_print_

En el pdf [pipeline_echo_doc.pdf](pipeline_echo_doc.pdf) se proporcionan los diagramas C4 
correspondientes y un ejemplo de salida por terminal. 
