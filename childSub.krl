ruleset childSub {
  meta {
    name "ChildSub"
    description <<subscribe child to parent>>
    author "Russell Smith"
    logging on
    sharing on
    use module v1_wrangler alias wrangler

  }
  global {

  }
  rule subscribe {
    select when wrangler init_events
      pre {
         // find parant
         // place  "use module  b507199x5 alias wrangler_api" in meta block!!
         parent_results = wrangler:parent();
         parent = parent_results{'parent'};
         parent_eci = parent[0]; // eci is the first element in tuple
         attrs = {}.put(["name"],event:attr("name"))
          .put(["name_space"],"VehicleFleet_Subscriptions")
          .put(["my_role"],"Vehicle")
          .put(["your_role"],"Fleet")
          .put(["target_eci"],parent_eci.klog("target Eci: "))
          .put(["channel_type"],"VehicleFleet")
          .put(["attrs"], meta:eci());
      }
      {
       noop();
      }
      always {
        raise wrangler event "subscription"
        attributes attrs;
      }
  }
}