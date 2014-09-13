
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

Parse.Cloud.define("newGroup", function(request, response){
  /*
    request {
      [User IDs], Name
    }
  */
   var HuddlGroup = Parse.Object.extend("HuddlGroup");
   var huddlGroup = new HuddlGroup();

   huddlGroup.set("Name", request.name);
   huddlGroup.set("Members", request.users);
   huddlGroup.set("HuddlInstance",[]);

   huddlGroup.save(null, {
       success: function(huddlGroup){},
       error: function(huddlGroup, error){}
   });

    huddlGroup.save();
    response.success();
});

Parse.Cloud.define("leaveGroup", function(request, response){
  /*
    request {
      UserID, GroupID
    }
  */
    var HuddlGroup = Parse.Object.extend("HuddlGroup");
    var huddlGroup = new Parse.Query(HuddlGroup);

    huddlGroup.get(request.id,{
      success: function(huddlGroup){
        var mbrs = huddlGroup.get("Users");
        var index = a.indexOf(request.userId);
        if ( index > -1) {
          array.splice( index, 1);
        }
      },
      error: function(){}
    });
    
    huddlGroup.save();
    response.success();
});

Parse.Cloud.define("groupAddUser", function(request, response){
  /*
    request {
      UserID, GroupID
    }
  */
    var HuddlGroup = Parse.Object.extend("HuddlGroup");
    var huddlGroup = new Parse.Query(HuddlGroup);

    huddlGroup.get(request.id,{
      success: function(huddlGroup){
        var mbrs = huddlGroup.get("Users");
        mbrs.push(request.userId);
      },
      error: function(){}
    });
    
    huddlGroup.save();
    response.success();
});


Parse.Cloud.define("newHuddl", function(request, response){
  /*
  request {
    groupId, time, topic, location
  }
  response {
    [suggestions]
  }
  */
  var HuddlGroup = Parse.Object.extend("HuddlGroup");
  var huddlGroup = new Parse.Query(HuddlGroup);
  huddlGroup.get(request.groupId);

  var HuddlInstance = Parse.Object.extend("HuddlInstance");
  var huddlInstance = new parse.Query(HuddlInstance);
  huddlInstance.set("Time", request.time);
  huddlInstance.set("Topic", request.topic);
  huddlInstance.set("Suggestions", []);

  Parse.Cloud.httpRequest({
    url: "https://api.foursquare.com/v2/venues/explore",
    params: {
      client_id: "GXHC20OCJLQPNYSMEDZBATGWSZMPMRWR1SMSG1TIHSR0KELY",
      client_secret: "5XZ5CHX1YE3WFZHL2EM3BAJXPLHDXWWCXFTXZQNWEKQWBHFB",
      v: 20130815,
      near: request.location,
      query: request.topic,
    },
    success: function(httpResponse){
      var a = httpResponse;
      var groups = a.response.groups[0].items;
      

    },
    error: function(httpResponse){}
  });


//Save HuddlInstance to its group
  var a = huddlGroup.get("HuddlInstance");
  var a.push(huddlInstance);
  huddlGroup.set("HuddlInstance", a);
  huddlInstance.save();


  response.success();
});

Parse.Cloud.define

Parse.Cloud.define("getSuggestion", function(request, response){
  /*
    request
  */
  var huddl

});