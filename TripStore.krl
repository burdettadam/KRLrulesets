ruleset trip_store {
  meta {
    name "Trip Store"
    description <<This is for part 3>>
    author "Russell Smith"
    logging on
    sharing on
 
  }
  global {

    long_trip = 10
 
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