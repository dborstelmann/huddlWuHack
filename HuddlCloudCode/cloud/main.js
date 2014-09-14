
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

    var huddlGroup = new HuddlGroup({users: users, name: name});
    huddlGroup.set("name", name);
    huddlGroup.set("users", users);

    huddlGroup.save({
      users: users,
      name: name

    }, {
      success: function(huddlGroup){
      

        for (var i=0; i < users.length; i++){

          var queue = new Parse.Query(UserQueue);
          var userID;

          Parse.Cloud.run( "getUserByFacebook", { user: users[i] },{
            success: function(result){
             
              Parse.Cloud.run( "addGroupToUserGroupList", {groupId: huddlGroup.id, user: result},
                {
                  success: function(result){
                  response.success(huddlGroup.id);
                }
              });

            },
            error: function(error){
              response.error("Issue")
            }
          });   
        }
      },
      error: function(huddlGroup, error){
        response.error("That didn't seem to work");
      }
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

/**
          HELPER FUNCTIONS
**/

// Parse.Cloud.define("createHuddl", function(request, response){
//   var 

// });

//Request {user: <facebook id>}
//Reponse user's objectId
Parse.Cloud.define("getUserByFacebook", function(request, response){
 Parse.Cloud.useMasterKey();
  var UserQueue = Parse.Object.extend("User");
  var queue = new Parse.Query(UserQueue);
  queue.equalTo("facebookId" , ""+request.params.user);

  queue.find({
    success: function(results) {
      for( var i=0; i < results.length; i++){
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
        response.success( {id: object.id, name: object.get('name'), } );
    },
    error: function(error) {
      response.error('A various error: ');
    }
  });
});

//Request {groupId: <groups objectID>, userID: <users objectId>}
//Response none
Parse.Cloud.define("leaveGroup", function(request, response){
 Parse.Cloud.useMasterKey();
  var groupID = request.params.groupId;
  var userID = request.params.user;

  var HuddlUser = Parse.Object.extend("User");
  var queue = new Parse.Query(HuddlUser);
  queue.get(userID, {
    success: function(result){
      var groupList = result.get("groupList");
      
      Parse.Cloud.run("getUserGroupList", {groupListId: groupList}, {
        success: function (result){
          //remove group from user group list
          response.success("Succesfully left the group");
        }
      })
    }
  });

  response.success("Group id added to groupList in User");
});

//Request {groupId: <groups objectID>, userID: <users objectId>}
//Response none
Parse.Cloud.define("addGroupToUserGroupList", function(request, response){
 Parse.Cloud.useMasterKey();
  var groupID = request.params.groupId;
  var userID = request.params.user;

  var HuddlUser = Parse.Object.extend("User");
  var queue = new Parse.Query(HuddlUser);
  queue.get(userID, {
    success: function(user){
      var groupList = user.get("groupList");
      
      Parse.Cloud.run("getUserGroupList", {groupListId: groupList}, {
        success: function (list){
          var groupArray = result.get('array');

          response.success("Added group to groupsList");
        }
      })
    }
  });

  response.success("Group id added to groupList in User");
});

//Request {userID: <users objectId>}
//Response {groupList}
Parse.Cloud.define("getUserGroupList", function(request, response){
  Parse.Cloud.useMasterKey();
  var usersId = request.params.userId;
  var Users = Parse.Object.extend("Users");
  var userQueue = new Parse.Query(Users);
  userQueue.equalTo("objectId", usersId);
  userQueue.find({
    success: function(user) {

    for ( var i = 0; i < user.length; i++){
      console.log("recieved " + user.length + " users.");
      var current = user[i];
      var ListKeyObject = current.get('listOfObjects');
      var groupListId = ListKeyObject.groupListKey;

      var GroupList = Parse.Object.extend("groupList");
      var queue = new Parse.Query(GroupList);
      queue.equalTo("objectId", usersId);
      queue.find({
        success: function(result){
          for ( var a = 0; a < result.length; a++){
            
            response.success(result[a]);
          }
        }
      });

      }    
    }, error: function(error){response.error(error)}
  });
});

//Request {userID: <facebook id>}
// Return groupList
Parse.Cloud.define("getGroups", function(request, response){
   Parse.Cloud.useMasterKey();
  var fbID = request.params.userId;
  Parse.Cloud.run("getUserByFacebook", {user: fbID}, {
    success: function(user){
      Parse.Cloud.run("getUserGroupList", {userId: user}, {
        success: function(result){
          response.success(result);
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
      this.users = attrs.users;
      this.name = attrs.name;
    this.huddlInstance = [];
    }
  },{
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

var HuddlInstance = Parse.Object.extend("HuddlInstance", {
  initialize: function(attrs, options){
    this.huddlGroup = attrs.groupID;
    this.topic = attrs.topic;
    this.time = attrs.time;
    this.location = attrs.location;
    this.suggestedHuddls = [];

    Parse.Cloud.run("getGroupByID", {group: groupID}, {
      success: function(group){

      }
    });
  }
},
{
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
        fourSqrData = httpResponse.response.groups[0].items;
        console.log(fourSqrData);
      },
      error: function(httpResponse){}
    });
  },

  filterHuddlData: function(huddlArray){
  },
  
});

var HuddlSuggestion = Parse.Object.extend("HuddlSuggestion", {}, {});