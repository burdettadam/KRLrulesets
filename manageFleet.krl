ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<Managing car fleet for lab 7>>
    author "Russell Smith"
    logging on
    sharing on
    use module v1_wrangler alias wrangler

  }
  global {
    vehicles = function() {
          wranglerSubscriptions = wrangler:subscriptions();
          wranglerSubscriptions;
    }
  }
  rule create_vehicle {
    select when car new_vehicle
    pre{
      vehicle_id = "Vehicle-" + ent:vehicleId.as(str);
      name = event:attr("name").defaultsTo(vehicle_id);
    }
    {
      wrangler:createChild(name);
    }
    always{
      raise pico_systems event 'ruleset_install_requested'
      with name = name;
      set ent:vehicleId 0 if not ent:vehicleId;
      set ent:vehicleId ent:vehicleId + 1;
      log("create child names " + name);
    }
  }

  rule installRulesetInChild {
    select when pico_systems ruleset_install_requested
    pre {
      rid = ["b507944x4.prod","b507937x8.prod"];
      pico_name = event:attr("name");
    }
    wrangler:installRulesets(rid) with
      name = pico_name;
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