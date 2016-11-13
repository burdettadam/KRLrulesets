ruleset trip_store {
  meta {
    name "Trip Store"
    description <<This is for part 3>>
    author "Russell Smith"
    logging on
    sharing on
 
  }
  global {
    trips = function(){
      trips;
    }
    long_trips = function(){
      long_trips;
    }
    short_trips = function(){
      short_trips = ent:trips.filter(function(timestamp,mileage){ent:trips{timestamp} != ent:long_trips{timestamp}});
      short_trips;
    }
 
  }
  rule collect_trips {
    select when explicit processed_trip
    pre{
      input = event:attr("mileage").klog("Input was: ");
    }
    fired {
      set ent:trips{time:now()} mileage;
      log(trips);
    }
  }
  rule collect_long_trips {
    select when explicit processed_trip
    pre{
      input = event:attr("mileage").klog("Input was: ");
    }
    fired {
      set ent:longtrips{time:now()} mileage;
      log(trips);
    }
  }
  rule clear_trips {
    select when car trip_reset
    always{
      clear ent:trip_store;
      clear ent:long_trip_store;
    }
  }
}