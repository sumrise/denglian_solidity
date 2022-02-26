const { assert } = require("console");

var Counter = artifacts.require("Counter");

contract("Counter", function(accounts) {
    var _instance;
    it ("Counter", function(){
        return Counter.deployed()
        .then(function(instance){
            _instance = instance;
            return _instance.incr();
        }).then(function(){
            return _instance.read();
        }).then(function(count){
            console.log(`count:${count}`)
            assert.equal(count,1);
        });
    });
});