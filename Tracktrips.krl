ruleset track_trips {
  meta {
    name "Track Trips"
    description <<This is for part 1>>
    author "Russell Smith"
    logging on
    sharing on
 
  }
  global {
    long_trip = 10
  }
  rule process_trip {
    select when car new_trip
    pre{
      input = event:attr("mileage").klog("Input was: ");
    }
    {
      send_directive("trip") with
        length = milage;
    }
    always {
      raise explicit event 'trip_processed'
      attributes event:attrs();
      log ("FINISHED process_trip MESSAGE!");
    }
  }
  rule find_long_trips {
    select when explicit trip_processed
    pre{
      input = event:attr("mileage");
    }
    always {
      raise explicit event 'found_long_trip'
      attributes event:attrs()
      if(input > long_trip);
      log ("FINISHED find_long_trips MESSAGE!");
    }
  }
  rule found_long_trips {
    select when explicit found_long_trip
    pre{
      input = event:attr("mileage");
    }
    always {
        log ("FINISHED Found_long_trips MESSAGE!");
    }
  }
}