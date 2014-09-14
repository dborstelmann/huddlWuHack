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
    }
    addUser: function(user){
    	this.users.push(user);
    }
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
	      this.suggestedHuddls.push(this.filterHuddlData(fourSqrData));
	    },
	    error: function(httpResponse){}
	  });
	}

	filterHuddlData: function(huddlArray){
		_.each(huddl, function(obj){

		}, this);
	}
	
},
});

var HuddlSuggestion = Parse.Object.extend("HuddlSuggestion", {}, {});