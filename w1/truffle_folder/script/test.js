var Counter = artifacts.require("Counter");

module.exports = async function(callback){
    var counter = await Counter.deployed();
    await counter.incr();
    let value = await counter.read();

    console.log(`current counter value:${value}`);
    
}