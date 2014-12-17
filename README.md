gtfsrt-mio
==
Pruebas de GTFS-realtime para el SITM-MIO.

# Preparación

Se ha ejecutado y realizado pruebas en Ubuntu 14.04. Antes de ejecutar cualquier comando es necesario tener instalado los siguientes programas:

* make
* java > 1.7.0_51
* javac > 1.7.0_51
* ruby > 1.9.3
* [protoc](https://github.com/google/protobuf "Generador Protocol Buffer de Google")
* [rprotoc](https://code.google.com/p/ruby-protobuf/ "Generador de Protocolo Buffer para Ruby") (comando de instalación mas abajo *ruby_protobuf*)

# Iniciando

## Empleando make
Utilizando la herramienta make se puede  generar y utilizar los comandos para la generación de los archivos GTFS-realtime.

Si tiene diferentes versiones del archivo gtfs-realtime.proto, puede manejar la sintaxis
`gtfs-realtime-{version}.proto` y colocar en el archivo **proto-version** la versión que desea emplear, por ejemplo **v1.0**.

### ruby

Para generar el archivo ruby con la especificación GTFS-realtime:
```sh
make generateruby
```
Crea como resultado el archivo `ruby/gtfs-realtime.pb.rb`. Para ejecutar una prueba del gtfs-realtime:
```sh
make runruby
```
Esto genera los archivos compilados **F_TRIP**, **F_VEHICLE** Y **F_ALERT**. Para eliminar estos archivos puede ejecutar:
```sh
make cleanruby
```
### java
Para generar el archivo java con la especificación GTFS-realtime:
```sh
make generatejava
```
Crea como resultado el archivo `java/com/google/transit/realtime/GtfsRealtime.java`. Para ejecutar una prueba del gtfs-realtime:
```sh
make runjava
```
*En el momento en desarrollo...*

## Manualmente

### ruby
Generar el archivo con la definición de las clases para ruby:
```sh
rprotoc -o ruby/ gtfs-realtime.proto
```
Crea como resultado el archivo `ruby/gtfs-realtime.pb.rb`.
Realizar una prueba del gtfs-realtime:
```sh
ruby ./ruby/test.rb
```
Esto genera los archivos compilados **F_TRIP**, **F_VEHICLE** Y **F_ALERT** y los muestra en terminal en formato JSON.

### java
Generar el archivo con la definición de las clases para java:
```sh
protoc  -I=./ --java_out=./java ./gtfs-realtime.proto
```
Crea como resultado el archivo `java/com/google/transit/realtime/GtfsRealtime.java`.
