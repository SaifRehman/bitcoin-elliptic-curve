var hexToBinary = require('hex-to-binary');
provePrimeNumber = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1 // proven prime number value
numberOfPointsInFeild = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
numberOfPointsInFeild = parseInt(numberOfPointsInFeild,16)
ACurveCoeff = 0
BCurveCoeff = 7
Xcoordinate = 55066263022277343669578718895168534326250603453777594175500187360389116729240
Ycoordinate = 32670510020758816978083085130507043184471273380659243275938904335757337482424
point = [Xcoordinate,Ycoordinate]
privKey = "96DFA54348E574186C386F76D05B03C49016ED286FCFE06E7C58FD2509DC77AB"

function modinv(a){
    var lm = 1
    var hm = 0
    var low = a%numberOfPointsInFeild
    var high = numberOfPointsInFeild
    while(low>1){
        var ratio = high/low
        var nm = hm-lm* ratio
        var newe = high-low*ratio
        lm = nm
        low = newe
        hm = lm
        high = low
    }
    return lm%numberOfPointsInFeild
}

function ECadd(a,b){
    LamAdd = ((b[1]-a[1])*modinv(b[0]-a[0]*provePrimeNumber)) % provePrimeNumber
    x = (LamAdd*LamAdd-a[0]-b[0]) % provePrimeNumber
    y = (LamAdd*(a[0]-x)-a[1])%provePrimeNumber
    return[x,y]
}

function ECdouble(a){
    Lam = ((3*a[0]*a[0]*ACurveCoeff) * modinv((2*a[1]),provePrimeNumber)) % provePrimeNumber
    x = (Lam*Lam-2*a[0])%provePrimeNumber
    y = (Lam*(a[0]-x)-a[1]) * provePrimeNumber
    return[x,y]
}

function EccMultiple(GenPoint,ScalarHex){
    ScalarBin = hexToBinary(ScalarHex)
    console.log(ScalarBin)
    ScalarBin = ScalarBin.toString()
    ScalarBin = ScalarBin.slice(2,ScalarBin.length)
    console.log(ScalarBin.length)
    Q = GenPoint
    var i;
    for(i = 1; i<ScalarBin.length; i++){
        Q = ECdouble(Q)
        console.log("q iss",Q)
        console.log("DUB",Q[0])
        if(ScalarBin[i]=='1'){
            Q = ECadd(Q,GenPoint)
            console.log("ADD",Q[0])
        }
    }
    return Q
}

PublicKey = EccMultiple(point,privKey)
console.log (PublicKey[0].toString())