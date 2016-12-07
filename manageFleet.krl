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

  }
  rule create_vehicle {
    select when car new_vehicle
    pre{
      vehicle_id = "Vehicle-" + ent:vehicleId.as(str);
      rid = "b507937x6.prod";
      name = event:attr("name").defaultsTo(vehicle_id);
    }
    {
      wrangler:createChild(name);
      wrangler:installRulesets(rid) with
      name = name;
    }
    always{
      set ent:vehicleId 0 if not ent:vehicleId;
      set ent:vehicleId ent:vehicleId + 1;
      log("create child names " + name);
    }
  }

  rule installRulesetInChild {
    select when pico_systems ruleset_install_requested
    pre {
      rid = "b507937x6.prod";
      pico_name = event:attr("name");
    }
    wrangler:installRulesets(rid) with
      name = pico_name
  }

}