ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<Managing car fleet for lab 7>>
    author "Russell Smith"
    logging on
    sharing on
    use module v1_wrangler alias wrangler
    use module b507199x5 alias wrangler_api

  }
  global {

  }
  rule create_vehicle {
    select when car new_vehicle
    pre {
      child_name = event:attr("name");
      attributes = {}
        .put(["Prototype_rids"],"b507944x4.prod;b507944x5.prod")
        .put(["name"], child_name) 
        .put(["parent_eci"],"E444036C-AEA8-11E6-9438-DCCCE71C24E1");
    }
    {
    // wrangler api event for child creation. meta:eci() provides the eci of this Pico
    event:send({"cid":meta:eci()}, "wrangler", "child_creation") with attrs = attributes.klog("attributes: ");
  
    //send_directives are sent out via API
    //Output to Kynetx Event Console - Response body
    //or API call - response body
        send_directive("Child was created") with attributes = "#{attributes}" and name = "#{name}" ;
    }
    always{
  
      //Not required but does show an example of persistent variable instantiation
      //This entity variable creates a subscription between the child to parent with "name"
      //and the meta:eci() which provides the eci of the current rules set (in this case the parent's eci)
      set ent:subscriptions{"name"} meta:eci();
       
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