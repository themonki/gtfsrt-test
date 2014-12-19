# Makefile para pruebas de GTFS-realtime
# Soporta ruby y java generadores de proto
# Edgar Moncada
# Create 17-12-2014

VERSION_PROTO:=$(shell cat ./proto-version)
PROTO_FILE=gtfs-realtime-$(VERSION_PROTO).proto
PROTO_CURRENT_FILE=gtfs-realtime.proto

runall: runruby runjava

cleanall: cleanfile cleanruby cleanjava

cleanfile:
	rm -rf F_*

generateall: currentproto generateruby generatejava

currentproto:
	rm -f $(PROTO_CURRENT_FILE)
	cp $(PROTO_FILE) $(PROTO_CURRENT_FILE)

#ruby###########################################################
runruby: generateruby
	ruby ./ruby/test.rb

generateruby: currentproto cleanruby
	rprotoc -o ruby/ $(PROTO_CURRENT_FILE)
#mv  ./ruby/gtfs-realtime-$(VERSION_PROTO).pb.rb ./ruby/gtfs-realtime.pb.rb

cleanruby:
	rm -rf ./ruby/gtfs-realtime*

#JAVA###########################################################
runjava: generatejava
	tree ./java/src

generatejava: currentproto
	protoc  -I=./ --java_out=./java/src ./$(PROTO_CURRENT_FILE)

cleanjava:
	rm -rf java/src/com/google/transit/realtime
