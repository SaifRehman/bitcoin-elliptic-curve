var hexToBinary = require('hex-to-binary');
var converter = require('hex2dec');
var BigNumber = require('big-number');
var bigInt = require("big-integer");
var _256 = bigInt(2).pow(256)
var _32 = bigInt(2).pow(32)
var _9 = bigInt(2).pow(9)
var _8 = bigInt(2).pow(8)
var _7 = bigInt(2).pow(7)
var _6 = bigInt(2).pow(6)
var _4 = bigInt(2).pow(4)
var _1 = bigInt(1)
provePrimeNumber = bigInt(bigInt(_256).minus(_32).minus(_9).minus(_8).minus(_7).minus(_6).minus(_4).minus(_1))
numberOfPointsInFeild = "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"
numberOfPointsInFeild = converter.hexToDec(numberOfPointsInFeild);
numberOfPointsInFeild = bigInt(numberOfPointsInFeild)
ACurveCoeff = 0
BCurveCoeff = 7
Xcoordinate = bigInt("55066263022277343669578718895168534326250603453777594175500187360389116729240");
Ycoordinate = bigInt("32670510020758816978083085130507043184471273380659243275938904335757337482424")
point = [Xcoordinate,Ycoordinate]
privKey = "96DFA54348E574186C386F76D05B03C49016ED286FCFE06E7C58FD2509DC77AB"

function modinv(a){
    a = bigInt(a)
    var lm = bigInt(1)
    var hm = bigInt(0)
    var low = bigInt(a).mod(numberOfPointsInFeild)
    var high = bigInt(numberOfPointsInFeild)
    while(bigInt(low).greater(1)){
        var ratio = bigInt(bigInt(high).divide(low))
        var nm =  bigInt((bigInt(hm).minus(lm)))
        nm = bigInt(bigInt(nm).multiply(ratio))
        var newe = bigInt((bigInt(high).minus(low)))
        newe = bigInt((bigInt(newe).minus(ratio)))
        lm = nm
        low = newe
        hm = lm
        high = low
        console.log("vallll",ratio.toString(),nm.toString(),hm.toString(),lm.toString(),high.toString(),low.toString(),newe.toString())
    }
    return bigInt(lm).mod(numberOfPointsInFeild)
}

function ECadd(a,b){
    a = bigInt(a)
    b = bigInt(b)
    LamAdd = bigInt(bigInt(b[1]).minus(a[1]).multiply(modinv(bigInt(b[0]).minus(a[0].multiply(provePrimeNumber)))))
    LamAdd = bigInt(LamAdd).mod(provePrimeNumber)
    x = bigInt(bigInt(LamAdd.multiply(LamAdd).minus(a[0]).minus(b[0])))
    x = bigInt(x).mod(provePrimeNumber)
    y = bigInt(bigInt(LamAdd.multiply(bigInt(a[0]).minus(x)).minus(a[1])))
    y = bigInt(y).mod(provePrimeNumber)
    return [x,y]
}

function ECdouble(a){
    a = bigInt(a)
    Lam = bigInt(((bigInt(3).multiply(a[0]).multiply(a[0]).multiply(ACurveCoeff))))
    Lam = bigInt(Lam).multiply(modinv(bigInt(2).multiply(a[1]),provePrimeNumber))
    Lam = bigInt(Lam).mod(provePrimeNumber)
    x = bigInt(bigInt(Lam).multiply(Lam)).minus(bigInt(2).multiply(a[0]))
    x = bigInt(x).mod(provePrimeNumber)
    y = bigInt(bigInt(Lam).multiply(bigInt(a[0]).minus(x)))
    y = bigInt(y).minus(a[1])
    y = bigInt(y).multiply(provePrimeNumber)
    return[x,y]
}

function EccMultiple(GenPoint,ScalarHex){
    GenPoint = bigInt(GenPoint)
    if(ScalarHex>numberOfPointsInFeild){
        throw 'Error2'
    }
    ScalarBin = hexToBinary(ScalarHex)
    ScalarBin = ScalarBin.toString()
    ScalarBin = ScalarBin.slice(2,ScalarBin.length)
    Q = GenPoint
    var i;
    for(i = 1; i<ScalarBin.length; i++){
        Q = ECdouble(Q)
        // console.log("DUB",Q[0].toString())
        if(ScalarBin[i]=='1'){
            Q = ECadd(Q,GenPoint)
            // console.log("ADD",Q[0].toString())
        }
    }
    return Q
}

PublicKey = EccMultiple(point,privKey)
compressedKey = PublicKey[0].toString().substring(2)
compressedKey = compressedKey.slice(0, -1);
// console.log(compressedKey)
// console.log(PublicKey[0].toString())