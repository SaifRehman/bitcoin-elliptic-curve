var bigInt = require("big-integer");
 
var jsHigh = Math.pow(2,256),
jsLow = 1,
 
bigHigh = bigInt(2).pow(256),
bigLow = bigInt(1);
console.log(bigHigh.toString())
// console.log(jsHigh === jsHigh + jsLow); // true
 
// console.log(bigHigh.equals(  bigHigh.add( bigLow ) )) // false
 
// console.log(jsHigh);
// // 1.157920892373162e+77
// console.log(jsHigh + 1);
// // 1.157920892373162e+77
 
// console.log(bigHigh.toString());
// 115792089237316195423570985008687907853269984665640564039457584007913129639936
console.log(bigHigh.add(bigLow).toString());
// 115792089237316195423570985008687907853269984665640564039457584007913129639937
