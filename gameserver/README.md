# template-practica-final

La práctica final consite en la propuesta, diseño, implementación y
presentación de un sistema propuesto por vosotros. El sistema debe
presentar alguna de las arquitecturas distribuidas vistas durante el
cuatrimestre, o una combinación de las mismas.

Para justificar la propuesta (especificación del sistema), ésta debe
incluir la descripción de los requisitos no funcionales. La propuesta
debe ser validad por el profesorado de la asignatura. Como parte del
proceso de validación, se establecerá uno de los tres requisitos no
funcionales (rendimiento, disponibilidad, seguridad) para la
aplicación de tácticas.

El proyecto incluye una checklist que os sirve tanto para guiar el
desarrollo, como para una autoevaluación del mismo.

__Este readme debe incluir, al menos, la siguiente información__:


# Grupo

Se trata de una práctica en grupo. Debeis dejar constancia de la/os
integrantes del grupo en este README.

Formato del listado:

- Apellidos, Nombre (login udc)
- Vázquez Fernández, Diego (diego.vazquez.fernandez@udc.es)
- Campos Camiña, Lucas (lucas.campos@udc.es)
- Solla Vázquez, Joaquín (joaquin.solla@udc.es)
- Rodríguez Seoane, Sergio (sergio.rodriguez.seoane@udc.es)
- Pardo López, Jose Luis (jose.luis.pardo@udc.es)
  


# Presentación del proyecto _GameServer_ (arquitectura _Cliente-Servidor_)

Este proyecto consiste en un servidor de juegos online multijugador. Hemos implementado tanto
los servicios como un pequeño cliente de terminal para poder hacer uso de los mismos. Para dar este servicio
hemos elegido una arquitectura cliente-servidor distribuida que consta de un directorio,
un servicio de login, y 2 juegos, cada uno de estos elementos se arranca en un nodo distinto,
y cada nodo con un supervisor monitorizando el servicio.<br><br>
La elección de arquitectura se basa que queremos exponer al cliente varios servicios de juegos multijugador
a traves de una página o servidor. También esta arquitectura nos facilita la inclusión en el futuro, de nuevos
juegos o servicios, siendo todo transparente para el cliente. Por otra parte también, el requisito no funcional
en el que nos hemos centrado ha sido la _disponibilidad_, haciendo uso de supervisores,
 ya que creemos que para un servidor de juegos que está empezando, lo más importante ofrecer un buen servicio,
 que no tenga caídas de los servidores y sea robusto ante posibles errores. <br><br>

# Despliegue y uso<br>

Instrucciones para instalar, desplegar y ejecutar la aplicación.

Podremos compilar el cliente desde la carpeta principal del proyecto mediante el comando `mix compile`.<br>
Una vez compilado y desde la carpeta del proyecto `_build/dev/lib/gamserver/ebin`, podremos desplegar 
la arquitectura de la siguiente forma (los nombres dados a las terminales no son obligatoriamente estos): <br><br>
## **Directorio**<br>
Abrimos una terminal, iniciamos el intérprete de comandos de elixir, nombrando la terminal con el comando
`iex --sname directorio`. A continuación levantaremos el directorio escribiendo `DirectorySupervisor.start_link([])`<br><br>
## **Servicio de Login**<br>
Abrimos otra terminal, iniciamos también el intérprete de comandos mediante `iex --sname login`. A continuación
iniciamos del servicio de login excribiendo `LoginSupervisor.start_link([])`<br><br>
## **Servicio de Piedra Papel Tijeras**<br>
Abrimos otra terminal, iniciamos el intérprete con `iex --sname game1`. Luego iniciaremos el servicio del juego
mediante el comando `PiedraPapelTijerasSupervisor.start_link([])`<br><br>
## **Servicio de Pares o Nones**<br>
Abriremos otra terminal, iniciando el intérprete con `iex --sname game2`.Luego levantamos el servidio del juego
mediante el comando `ParesNonesSupervisor.start_link([])`.<br><br>

## **Comunicación**<br>
Una vez desplegada la arquitectura, tenemos que hacer que los nodos sean visibles entre ellos. Para esto desde la 
terminal del directorio podemos hacer ping al resto de servicios levantados mediante el comando `Node.ping`. Para esto
haremos:<br>`Node.ping(:login@nombre_máquina)`<br>`Node.ping(:game1@nombre_maquina)`<br>`Node.ping(:game2@nombre_maquina)`<br>
En estos casos,`nombre_maquina` lo sustituiremos por el nombre de la máquina ejecutando el código, saldrá indicado en 
el nombre del interprete de comandos en la terminal.

## **Clientes**<br>
Una vez tenemos toda la arquitectura desplegada podemos ejecutar los tests o abrir clientes para probar el funcionamiento
del proyecto. Para esto, podemos abrir 2 terminales más llamandoles `iex --sname cli1` y `iex --sname cli2` y hacer uso
desde ellas de la pequeña interfaz de terminal para los clientes. Primero haremos desde ambas `Node.ping(:directorio@nombre_maquina)`
para tener comunicación cón el GameServer. Una vez hecho esto, esto ejecutaremos en las 2 terminales `Client.main()` y se iniciará
el cliente de terminal. Ya que la finalidad del proyecto era programar y desplegar la arquitectura, no hemos implementado
un control exhaustivo de errores en las entradas de los clientes, por lo que será necesario seguir la instrucciones indicadas por
el cliente para un correcto funcionamiento. Introducir entradas incorrectas no afectará a la disponibilidad de los servicios pero sí
impedirá hacer un uso adecuado de la aplicación.<br><br>

