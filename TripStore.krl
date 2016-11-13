ruleset trip_store {
  meta {
    name "Track Trips"
    description <<This is for part 1>>
    author "Russell Smith"
    logging on
    sharing on
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };

    long_trip = 10
 
  }
  rule collect_trips {
    select when explicit processed_trip
    pre{
      input = event:attr("mileage").klog("Input was: ");
    }
    always {
      set ent:mileages input;
      set ent:timestamps time:now();
      log ("FINISHED process_trip MESSAGE!");
    }
  }
}