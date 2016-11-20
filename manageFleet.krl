ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<Managing car fleet for lab 7>>
    author "Russell Smith"
    logging on
    sharing on
    use module b507199x5 alias wrangler

  }
  global {

  }
  rule create_vehicle {
    select when car new_vehicle
    pre {
      vehicle_id = "Vehicle-" + ent:vehicleId.as(str);
      attributes = {}
        .put(["Prototype_rids"],"b507944x4.prod")
        .put(["name"], vehicle_id) 
        .put(["parent_eci"],"E444036C-AEA8-11E6-9438-DCCCE71C24E1");
    }
    {
      // wrangler api event for child creation. meta:eci() provides the eci of this Pico
      event:send({"cid":meta:eci()}, "wrangler", "child_creation") 
      with attrs = attributes.klog("attributes: ");
  
    } 
    always{
  
      //Not required but does show an example of persistent variable instantiation
      //This entity variable creates a subscription between the child to parent with "name"
      //and the meta:eci() which provides the eci of the current rules set (in this case the parent's eci)
      set ent:subscriptions{"name"} meta:eci();
       
      set ent:vehicleId 0 if not ent:vehicleId;
      set ent:vehicleId ent:vehicleId + 1;
      //this shows up in the pico logs
      log("Create child item for " + child);
    }
  }



  rule autoAccept {
    select when wrangler inbound_pending_subscription_added
    pre{
      attributes = event:attrs().klog("subcription :");
    }
    {
      noop();
    }
    always{
      raise wrangler event 'pending_subscription_approval'
          attributes attributes;       
          log("auto accepted subscription.");
    }
  }
}