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
      attr = {}
        .put(["Prototype_rids"],"b507782x4.dev"
        .put(["name"], child_name) 
        .put(["parent_eci"],"E444036C-AEA8-11E6-9438-DCCCE71C24E1");

    }
    {
      noop();
    }
    always{
      raise wrangler event "child_creation"
      attributes attr.klog("attributes: ");
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
          log("auto accepted subcription.");
    }
  }
}