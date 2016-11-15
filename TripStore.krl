ruleset trip_store {
  meta {
    name "Trip Store"
    description <<This is for part 3>>
    author "Russell Smith"
    logging on
    sharing on
    provides trips, long_trips, short_trips

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
    long_trip = 10;
  }
  rule collect_trips {
    select when explicit processed_trip
    pre{
      mileage = event:attr("mileage").klog("Input was: ");
    }
    fired {
      raise explicit event 'found_long_trip'
      attributes event:attrs()
      if(mileage > long_trip);
      set ent:alltrips{time:now()} mileage;
      log(ent:alltrips);
    }
  }
  rule collect_long_trips {
    select when explicit found_long_trip
    pre{
      mileage = event:attr("mileage").klog("Input was: ");
    }
    fired {
      set ent:longtrips{time:now()} mileage;
      log(ent:longtrips);
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