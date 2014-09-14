
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

Parse.Cloud.define("newGroup", function(request, response){
  Parse.Cloud.useMasterKey();
  /*
    request {
      [User IDs], Name
    }
  */
    var UserQueue = Parse.Object.extend("User");
    var name = request.params.name,
        users = request.params.users,
        sender = request.params.user_id;

    users.push(sender);

    var huddlGroup = new HuddlGroup();
    huddlGroup.set("name", name);
    huddlGroup.set("users", users);

    huddlGroup.save({
      users: users,
      name: name

    }, {
      success: function(huddlGroup){
        var cnt = 0;

        for (var i=0; i < users.length; i++){

          var queue = new Parse.Query(UserQueue);
          var userID;
          Parse.Cloud.run("getUserByFacebook", {user: users[i]}, {
            success: function(result){
              Parse.Cloud.run( "addGroupToUserGroupList", {groupId: huddlGroup.id, user: result},
                {
                  success: function(result){
                    ++cnt;
                    if( cnt == users.length){
                      response.success(huddlGroup.id);
                    }
                  }

              });              
            }
          });  
        }
        
      },
      error: function(huddlGroup, error){
        response.error("That didn't seem to work");
      }
  });
    
});


//Request {userID: <users objectId>}
//Response {groupList}
Parse.Cloud.define("getGroups", function(request, response){
  Parse.Cloud.useMasterKey();

  var usersId = request.params.userId;
  var Users = Parse.Object.extend("User");
  var userQueue = new Parse.Query(Users);
  userQueue.equalTo("objectId", usersId);
  userQueue.first({
    success: function(user) {
      var ListKeyObject = user.get('listOfObjects');
      var groupListId = ListKeyObject.groupListKey;

      var GroupList = Parse.Object.extend("groupList");
      var queue = new Parse.Query(GroupList);
      queue.equalTo("objectId", groupListId);
      queue.first({
        success: function(result){
          var array = [];
          var cnt = 0;
            for(var i = 0; i < result.get('array').length; i++){
              var a = result.get('array');

              Parse.Cloud.run("getGroupByID", {group: a[i]}, {
                success: function(group){
                  array.push(group);

                  
                  if(cnt == a.length-1){
                    response.success(array);
                  }
                  cnt++;
                  
                }
              });
            }
        }
      });    
    }, error: function(error){response.error(error)}
  });
});



// Parse.Cloud.define("groupAddUser", function(request, response){
//   /*
//     request {
//       UserID, GroupID
//     }
//   */
//     var HuddlGroup = Parse.Object.extend("HuddlGroup");
//     var huddlGroup = new Parse.Query(HuddlGroup);

//     huddlGroup.get(request.id,{
//       success: function(huddlGroup){
//         var mbrs = huddlGroup.get("Users");
//         mbrs.push(request.userId);
//       },
//       error: function(){}
//     });
    
//     huddlGroup.save();
//     response.success();
// });

// Parse.Cloud.define("getSuggestion", function(request, response){
//   /*
//     request
//   */
//   var huddl

// });

// fourSquareJSON = function(a){

//   var HuddlSuggestion = Parse.Object.extend("SuggestedHuddl");
//   var SuggestionCollection = Parse.Collection.extend({
//     model: huddlSuggstion;
//   });

//   var suggestionCollection = new SuggestionCollection();

//   _.each( a, function(object){
//     suggestionCollection.add( new HuddlSuggestion()
//   });

// }

//Request {groupId: <groups objectID>, userID: <users objectId>}
//Response none
// Parse.Cloud.define("leaveGroup", function(request, response){
//  Parse.Cloud.useMasterKey();
//   var groupID = request.params.groupId;
//   var userID = request.params.user;

//   var HuddlUser = Parse.Object.extend("User");
//   var queue = new Parse.Query(HuddlUser);
//   queue.get(userID, {
//     success: function(result){
//       var groupList = result.get("groupList");
      
//       Parse.Cloud.run("getUserGroupList", {groupListId: groupList}, {
//         success: function (result){
//           //remove group from user group list
//           response.success("Succesfully left the group");
//         }
//       })
//     }
//   });

//   response.success("Group id added to groupList in User");
// });

/**
          HELPER FUNCTIONS
**/



//Request {user: <facebook id>}
//Reponse user's objectId
Parse.Cloud.define("getUserByFacebook", function(request, response){
 Parse.Cloud.useMasterKey();
  var UserQueue = Parse.Object.extend("User");
  var queue = new Parse.Query(UserQueue);
  queue.equalTo("facebookId" , ""+request.params.user);

  queue.find({
    success: function(results) {
      for( var i = 0; i < results.length; i++){
        var object = results[i];
        response.success( object.id );
      }
    },
    error: function(error){
      response.error('A various error:' + error);
    }
  });
});

//Request {group: <group objectId>}
//Response {id: <group objectId>, name: <group name>, length<size of group>}
Parse.Cloud.define("getGroupByID", function(request, response){
 Parse.Cloud.useMasterKey();
  var HuddleGroup = Parse.Object.extend("HuddlGroup");
  var queue = new Parse.Query(HuddlGroup);
  queue.get(request.params.group, {
    success: function(result){
        var object = result;
        console.log(object);
        response.success( {id: object.id, name: object.get('name'), length: ""+object.get('users').length} );
    },
    error: function(error) {
      response.error('A various error: ');
    }
  });
});



//Request {groupId: <groups objectID>, userID: <users objectId>}
//Response none
Parse.Cloud.define("addGroupToUserGroupList", function(request, response){
 Parse.Cloud.useMasterKey();

  var groupID = request.params.groupId;
  var userID = request.params.user;

  var HuddlUser = Parse.Object.extend("User");
  var queue = new Parse.Query(HuddlUser);
  queue.equalTo("objectId", userID);
  queue.first({
    success: function(user){

      var ListKeyObject = user.get("listOfObjects");
      var groupListId = ListKeyObject.groupListKey;
      
      var GroupList = Parse.Object.extend("groupList");
      var queue = new Parse.Query(GroupList);
      queue.equalTo("objectId", groupListId);
      queue.first({
        success: function(result){

            var array = result.get("array");
            array.push(groupID);
            result.set("array", array);
            result.save();
            response.success("Done");
          }
      });    
    }
  });
});


/**

          OBJECTS

**/
var HuddlGroup = Parse.Object.extend("HuddlGroup", {
    initialize: function(attrs, options) {
      this.huddlInstance = [];
    }
  },
  {
    setUser: function(user) {
      this.users = attrs.users;
    },
    setName: function(name) {
      this.name = attrs.name;
    },
    addHuddlInstance: function(huddl) {
      this.huddlInstace.push(huddl);
      return huddl;
    },
    addUser: function(user){
      this.users.push(user);
    },
    removeUser: function(user){
      var index = user;
        if ( index > -1) {
          array.splice( index, 1);
        }
    }
});

Parse.Cloud.define("createHuddl", function(request, response){
  var _ = require('underscore');
  var huddlInstance = Parse.Object.extend("HuddlInstance", {
    initialize: function(attrs, options){
      this.suggestedHuddls = [];
    }
  },
  {
    joinToGroup: function(groupID){
      Parse.Cloud.run("getGroupByID", {group: groupID}, {
        success: function(group){
          this.HuddlGroup = group;
        }
      });
    },
    setTopic: function(topic){
      this.topic = topic;
    },
    setTime: function(time){
      this.time = time; 
    },
    setLocation: function(location){
      this.location = location;
    },
    pullSuggestedHuddls: function() {
      var fourSqrData, 
        topic = this.topic,
        location = this.location;

    Parse.Cloud.httpRequest({
        url: "https://api.foursquare.com/v2/venues/explore",
        params: {
          client_id: "GXHC20OCJLQPNYSMEDZBATGWSZMPMRWR1SMSG1TIHSR0KELY",
          client_secret: "5XZ5CHX1YE3WFZHL2EM3BAJXPLHDXWWCXFTXZQNWEKQWBHFB",
          v: 20130815,
          near: location,
          query: topic,
        },

        success: function(httpResponse){
          response.success(huddlInstance.filterHuddlData(httpResponse));
        },
        error: function(httpResponse){}
      });
    },
    getRawData: function(data){
      return this.rawData;
    },
    filterHuddlData: function(rawJSON){
      var a = rawJSON.response;
      console.log(_.isObject(a));
      // var ranking = [];
      // var i =0;
      // for (a in rawJSON.response.groups[0].items){
      //   var rank  = a.venue.rating                     ;
      //   var name  = a.venue.name                       ;
      //   var price = a.venue.price.currency             ;
      //   var cat   = a.venue.categories[0].shortName    ;
      //   var venue = new Array[rank,name,icon,price,cat];
      //   ranking[i]=venue;
      //   i++;
      // }
    return a;  // this
    }  
  });

  var  params = request.params,
  groupID = params.groupID,
  topic = params.topic,
  time = params.time,
  location = params.location; 

  huddlInstance.joinToGroup(groupID);
  huddlInstance.setTopic(topic);
  huddlInstance.setTime(time);
  huddlInstance.setLocation(location);
  huddlInstance.pullSuggestedHuddls();
  });



var HuddlSuggestion = Parse.Object.extend("HuddlSuggestion", {}, {});