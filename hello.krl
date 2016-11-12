ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
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
  rule hello_name {
    select when echo name
    pre{
      name = event:attr("name").klog("our passed in Name: ");
    }
    {
      send_directive("say") with
        something = "Hello #{name}";
    }
    always {
        log ("LOG says Hello " + name);
    }
  }

  rule hello {
    select when echo hello
    pre{
      name = event:attr("name").klog("our passed in Name: ");
    }
    {
      send_directive("say") with
        something = "Hello World";
    }
    always {
        log ("LOG says Hello " + name);
    }
  }
    rule message {
    select when echo message
    pre{
      name = event:attr("input").klog("Input was: ");
    }
    {
      send_directive("say") with
        something = input;
    }
    always {
        log ("LOG says Hello " + name);
    }
  }
 
}