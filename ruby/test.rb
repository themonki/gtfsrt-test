#!/usr/bin/ruby

#gem install ruby_protobuf

#https://code.google.com/p/ruby-protobuf/
#https://developers.google.com/protocol-buffers/docs/downloads
#https://github.com/google/protobuf

require "optparse"
require File.dirname(__FILE__) + '/gtfs-realtime.pb.rb'
include TransitRealtime

options = {trip: "F_TRIP", vehicle: "F_VEHICLE", alert: "F_ALERT"}
OptionParser.new do |opts|
	opts.banner = "Usage: #{$0} [options]"
	opts.on('-t', '--trip FILE', 'File from tripUpdates') { |v| options[:trip] = v }
	opts.on('-v', '--vehicle FILE', 'File from vehicles') { |v| options[:vehicle] = v }
	opts.on('-a', '--alert FILE', 'File from alerts') { |v| options[:alert] = v }

end.parse!

#WRITE MESSAGE
feed_message_w_trip = FeedMessage.new
feed_message_w_trip.parse_from_file options[:trip] if File.exist? options[:trip]

feed_message_w_vehicle = FeedMessage.new
feed_message_w_vehicle.parse_from_file options[:vehicle] if File.exist? options[:vehicle]

feed_message_w_alert = FeedMessage.new
feed_message_w_alert.parse_from_file options[:alert] if File.exist? options[:alert]

feed_header = FeedHeader.new
feed_header.gtfs_realtime_version = '1.0'
feed_header.timestamp = Time.now.to_i
feed_header.incrementality = FeedHeader::Incrementality::FULL_DATASET

#trip ##########################################################################
feed_entity_trip_update = FeedEntity.new
feed_entity_trip_update.id = 'test_trip'
feed_entity_trip_update.is_deleted = false
feed_entity_trip_update.trip_update = TripUpdate.new

trip_descriptor1 = TripDescriptor.new
trip_descriptor1.trip_id = '1'
trip_descriptor1.route_id = '2'
trip_descriptor1.start_time = '3'
trip_descriptor1.start_date = '4'
trip_descriptor1.schedule_relationship = TripDescriptor::ScheduleRelationship::SCHEDULED

vehicle_descriptor1 = VehicleDescriptor.new
vehicle_descriptor1.id = '1'
vehicle_descriptor1.label = 'MC1234'
vehicle_descriptor1.license_plate = 'VCL123'


arrival = TripUpdate::StopTimeEvent.new
arrival.delay = 1
arrival.time = Time.now.to_i
arrival.uncertainty = 0
departure = TripUpdate::StopTimeEvent.new
departure.delay = 0
departure.time = Time.now.to_i
departure.uncertainty = 2

stop_time_update = TripUpdate::StopTimeUpdate.new
stop_time_update.stop_sequence = 1
stop_time_update.stop_id = '23'
stop_time_update.arrival = arrival
stop_time_update.departure = departure
stop_time_update.schedule_relationship = TripUpdate::StopTimeUpdate::ScheduleRelationship::SKIPPED


feed_entity_trip_update.trip_update.trip = trip_descriptor1
feed_entity_trip_update.trip_update.vehicle = vehicle_descriptor1
feed_entity_trip_update.trip_update.stop_time_update << stop_time_update
feed_entity_trip_update.trip_update.timestamp = Time.now.to_i


#end trip ######################################################################


#vehicle #######################################################################
feed_entity_vehicle = FeedEntity.new
feed_entity_vehicle.id = 'test_vehicle'
feed_entity_vehicle.is_deleted = false
feed_entity_vehicle.vehicle = VehiclePosition.new

trip_descriptor2 = TripDescriptor.new
trip_descriptor2.trip_id = '2'
trip_descriptor2.route_id = '1'
trip_descriptor2.start_time = '5'
trip_descriptor2.start_date = '7'
trip_descriptor2.schedule_relationship = TripDescriptor::ScheduleRelationship::SCHEDULED

vehicle_descriptor2 = VehicleDescriptor.new
vehicle_descriptor2.id = '2'
vehicle_descriptor2.label = 'MC15678'
vehicle_descriptor2.license_plate = 'VML456'

position = Position.new
position.latitude = 12312.12312
position.longitude = 12141.12312
position.bearing = 23451.1212
position.odometer = 234.12
position.speed = 56.1

feed_entity_vehicle.vehicle.trip = trip_descriptor2
feed_entity_vehicle.vehicle.vehicle = vehicle_descriptor2
feed_entity_vehicle.vehicle.position = position
feed_entity_vehicle.vehicle.current_stop_sequence = 10
feed_entity_vehicle.vehicle.stop_id = '23'
feed_entity_vehicle.vehicle.current_status = VehiclePosition::VehicleStopStatus::STOPPED_AT
feed_entity_vehicle.vehicle.timestamp = Time.now.to_i
feed_entity_vehicle.vehicle.congestion_level = VehiclePosition::CongestionLevel::CONGESTION

#end vehicle ###################################################################

#alert #########################################################################
feed_entity_alert = FeedEntity.new
feed_entity_alert.id = 'test_alert'
feed_entity_alert.is_deleted = false
feed_entity_alert.alert = Alert.new

active_period = TimeRange.new
active_period.start = Time.now.to_i
active_period.end = Time.now.to_i

trip_descriptor3 = TripDescriptor.new
trip_descriptor3.trip_id = '1'
trip_descriptor3.route_id = '2'
trip_descriptor3.start_time = '3'
trip_descriptor3.start_date = '4'
trip_descriptor3.schedule_relationship = TripDescriptor::ScheduleRelationship::SCHEDULED

informed_entity = EntitySelector.new
informed_entity.agency_id = 'Metro Cali S.A.'
informed_entity.route_id = '4'
informed_entity.route_type = 1
informed_entity.trip = trip_descriptor3
informed_entity.stop_id = '67'

tran_es1 = TranslatedString::Translation.new
tran_es1.text = 'http://www.mipagina.com/es/infoalerta.html'
tran_es1.language = 'es'
tran_en1 = TranslatedString::Translation.new
tran_en1.text = 'http://www.mipagina.com/en/infoalerta.html'
tran_en1.language = 'en'

tran_es2 = TranslatedString::Translation.new
tran_es2.text = 'Demoras'
tran_es2.language = 'es'
tran_en2 = TranslatedString::Translation.new
tran_en2.text = 'Delay'
tran_en2.language = 'en'

tran_es3 = TranslatedString::Translation.new
tran_es3.text = 'El servicio se esta demorando por problema de apertura de puertas'
tran_es3.language = 'es'
tran_en3 = TranslatedString::Translation.new
tran_en3.text = 'The services have delay because a problem with open doors'
tran_en3.language = 'en'

url = TranslatedString.new
url.translation << tran_es1
url.translation << tran_en1

header_text = TranslatedString.new
header_text.translation << tran_es2
header_text.translation << tran_en2

description_text = TranslatedString.new
description_text.translation << tran_es3
description_text.translation << tran_en3

feed_entity_alert.alert.active_period << active_period
feed_entity_alert.alert.informed_entity << informed_entity
feed_entity_alert.alert.cause = Alert::Cause::TECHNICAL_PROBLEM
feed_entity_alert.alert.effect = Alert::Effect::REDUCED_SERVICE
feed_entity_alert.alert.url = url
feed_entity_alert.alert.header_text = header_text
feed_entity_alert.alert.description_text = description_text

#end alert #####################################################################

feed_message_w_trip.header = feed_header
feed_message_w_trip.entity << feed_entity_trip_update

feed_message_w_vehicle.header = feed_header
feed_message_w_vehicle.entity << feed_entity_vehicle

feed_message_w_alert.header = feed_header
feed_message_w_alert.entity << feed_entity_alert

#WRITE TO FILE ON INPUT
feed_message_w_trip.serialize_to_file(options[:trip])
feed_message_w_vehicle.serialize_to_file(options[:vehicle])
feed_message_w_alert.serialize_to_file(options[:alert])

#READ MESSAGE FROM INPUT FILE
feed_message_r_trip = FeedMessage.new
feed_message_r_trip.parse_from_file options[:trip]
feed_message_r_vehicle = FeedMessage.new
feed_message_r_vehicle.parse_from_file options[:vehicle]
feed_message_r_alert = FeedMessage.new
feed_message_r_alert.parse_from_file options[:alert]

puts ""
puts feed_message_w_trip.inspect
puts "*************************************************************************"
puts feed_message_w_vehicle.inspect
puts "*************************************************************************"
puts feed_message_w_alert.inspect
puts ""

puts Time.at(feed_message_r_trip.header.timestamp)
