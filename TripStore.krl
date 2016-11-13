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
    {
      send_directive("Trips") with
        time = time:now;
    }
    always {
      set ent:mileages input;
      set ent:timestamps time:now();
      log ("FINISHED process_trip MESSAGE!");
    }
  }
}