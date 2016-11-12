    ruleset track_trips {
  meta {
    name "Track Trips"
    description <<This is for part 1>>
    author "Russell Smith"
    logging on
    sharing on
    provides hello
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
 
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
        log ("FINISHED MESSAGE!");
    }
  }
 
}