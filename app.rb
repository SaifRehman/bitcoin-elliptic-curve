require 'digest'

$provePrimeNumber = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1
$numberOfPointsInFeild = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
$Acurve = 0
$xcoordinate = 55066263022277343669578718895168534326250603453777594175500187360389116729240
$ycoordinate = 32670510020758816978083085130507043184471273380659243275938904335757337482424
$privKey = "A0DC65FFCA799873CBEA0AC274015B9526505DAAAED385155425F7337704883E"
$point  = Array.new([$xcoordinate,$ycoordinate])
$hashOfThingToSign = 86032112319101611046176971828093669637772856272773459297323797145286374828050 
$randLow =  1000000000000000000000000000000000000000000000000000000000000000000000000000
$randHigh = 9999999999999999999999999999999999999999999999999999999999999999999999999999

def generateSHA256(var)
    q = Digest::SHA256.hexdigest var
    return q.to_i(16)
end

def randomNumberGeneration
    return rand $randLow..$randHigh 
end

def modInverse (var)
    lm = 1
    hm = 0
    low = var % $provePrimeNumber
    high = $provePrimeNumber
    while low > 1 do
        ratio = high/low
        nm, enew = hm-lm*ratio, high-low*ratio
        lm, low, hm, high = nm, enew, lm, low
    end
    return nm % $provePrimeNumber
end

def ECadd(a,b)
    lamAdd = ((b[1]-a[1]) * modInverse(b[0]-a[0])) % $provePrimeNumber
    x = (lamAdd*lamAdd-a[0]-b[0]) % $provePrimeNumber
    y = (lamAdd*(a[0]-x)-a[1]) % $provePrimeNumber
    return [x,y]
end

def ECdouble(a) 
    lam = ((3*a[0]*a[0]+ $Acurve) * modInverse((2*a[1]))) % $provePrimeNumber
    x = (lam*lam-2*a[0]) % $provePrimeNumber
    y = (lam*(a[0]-x)-a[1]) % $provePrimeNumber
    return [x,y]
end

def hex_to_bin(s)
    return s.to_i(16).to_s(2)
end

def EccMultiply(genPoint,scalarHex)
    scalarBin = hex_to_bin(scalarHex)
    q=genPoint
    for i in 1..scalarBin.length-1
        q=ECdouble(q) # 
        puts "DUB", q[0]
        if scalarBin[i] == '1'
            q=ECadd(q,genPoint)
            puts "ADD", q[0]
        end
    end
    return [q]
end

def SignatureGeneration(genPoint,randomNumber)
    q = EccMultiply(genPoint,randomNumber)
    xRandSignPoint = q[0]
    yRandSignPoint = q[1]
    r = xRandSignPoint % $numberOfPointsInFeild;
    s = (($hashOfThingToSign + r*$privKey)*(modInverse(randomNumber))) % $numberOfPointsInFeild
    return [r,s]
end

def SignatureVerification(s,r)
    w = modinv(s)
    point1 = EccMultiply(Gx,Gy,($hashOfThingToSign * w) % $numberOfPointsInFeild)
    point2 = EccMultiply(publicKey,(r*w) % $numberOfPointsInFeild)
    q  = ECadd(point1,point2)
    x = q[0]
    y = q[1]
    if(x == r)
        return true
    else
        return false
    end
end

puts generateSHA256("saif")
# publicKey = EccMultiply($point,$privKey)
# puts "the uncompressed public key (HEX):";
# puts publicKey
# puts "04" + publicKey[0][0].to_s(16) + publicKey[0][1].to_s(16); 
# print "the official Public Key - compressed:"; 
# if PublicKey[1] % 2 == 1: # If the Y value for the Public Key is odd.
#     print "03"+str(hex(PublicKey[0])[2:-1]).zfill(64)
# else: # Or else, if the Y value is even.
#     print "02"+str(hex(PublicKey[0])[2:-1]).zfill(64)