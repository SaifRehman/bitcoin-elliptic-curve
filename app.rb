require 'digest'
$provePrimeNumber = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1
$numberOfPointsInFeild = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
$Acurve = 0
$xcoordinate = 55066263022277343669578718895168534326250603453777594175500187360389116729240
$ycoordinate = 32670510020758816978083085130507043184471273380659243275938904335757337482424
$privKey = "A665A45920422F9D417E4867EFDC4FB8A04A1F3FFF1FA07E998E86F7F7A27AE3"
$point  = Array.new([$xcoordinate,$ycoordinate])
$hashOfThingToSign = 86032112319101611046176971828093669637772856272773459297323797145286374828050 
$randLow =  100
$randHigh = 999
$m = 2**32
$a = 1103515245
$c = 12345

def dectobin(var)
    return var.to_s(2)
end

def lcg(m,a,c,val)
    ((a*val + c) % m)/m
end

def dectohex(var)
    return var.to_s(16)
end

def stringtoint(var)
    return var.to_i()
end

def hextodec(var)
    return ("0x"+var).hex
end

def generateSHA256(var)
    q = Digest::SHA256.hexdigest var
    return q.to_i(16)
end

def randomNumberGeneration ()
    seed = rand $randLow..$randHigh
    seed = seed.to_f
    iter = rand $randLow..$randHigh
    iter = iter.to_i
    lastVal = 0
    counter = 0
    while counter < iter
        seed = (($a * seed) + $c) % $m
        counter = counter + 1
        lastVal = seed/$m
    end
    numberOfChar = ((lastVal.to_s).length)-2
    numberOfChar = rand 2..numberOfChar
    numberOfChar = numberOfChar.to_i
    numberOfChar = 10**numberOfChar
    # puts (lastVal*numberOfChar)
    return (lastVal*numberOfChar).to_i
end

def modInverse (var,n)
    lm = 1
    hm = 0
    low = var % n
    high = n
    while low > 1 do
        ratio = high/low
        nm, enew = hm-lm*ratio, high-low*ratio
        lm, low, hm, high = nm, enew, lm, low
    end
    return nm % n
end

def ECadd(a,b)
    lamAdd = ((b[1]-a[1]) * modInverse(b[0]-a[0],$provePrimeNumber)) % $provePrimeNumber
    x = (lamAdd*lamAdd-a[0]-b[0]) % $provePrimeNumber
    y = (lamAdd*(a[0]-x)-a[1]) % $provePrimeNumber
    return [x,y]
end

def ECdouble(a) 
    lam = ((3*a[0]*a[0]+ $Acurve) * modInverse((2*a[1]),$provePrimeNumber)) % $provePrimeNumber
    x = (lam*lam-2*a[0]) % $provePrimeNumber
    y = (lam*(a[0]-x)-a[1]) % $provePrimeNumber
    return [x,y]
end

def hex_to_bin(s)
    return s.to_i(16).to_s(2)
end

def EccMultiply(genPoint,scalarHex)
    if scalarHex > $numberOfPointsInFeild || scalarHex === 0
        raise "error, invalid uncondition"
    end
    scalarBin = dectobin(scalarHex)
    q=genPoint
    for i in 1..scalarBin.length-1
        q=ECdouble(q) 
        # puts "DUB", q[0]
        if scalarBin[i] == '1'
            q=ECadd(q,genPoint)
            # puts "ADD", q[0]
        end
    end
    return [q]
end

def SignatureGeneration(genPoint,randomNumber,hashOfThingToSign)
    q = EccMultiply(genPoint,randomNumber)
    xRandSignPoint = q[0][0]
    yRandSignPoint = q[0][1]
    r = xRandSignPoint % $numberOfPointsInFeild;
    s = ((hashOfThingToSign + (r*hextodec($privKey)))*(modInverse(randomNumber,$numberOfPointsInFeild))) % $numberOfPointsInFeild
    return [r,s]
end

def SignatureVerification(s,r,hashOfThingToSign,publicKey)
    w = modInverse(s,$numberOfPointsInFeild)
    point1 = EccMultiply($point,((hashOfThingToSign * w) % $numberOfPointsInFeild))
    point2 = EccMultiply(publicKey,((r*w) % $numberOfPointsInFeild))
    q  = ECadd(point1[0],point2[0])
    x = q[0]
    y = q[1]
    if(x === r)
        return true
    else
        return false
    end
end


iy = modInverse($ycoordinate, $provePrimeNumber)
puts iy
puts  ECadd([$xcoordinate, iy], [$xcoordinate,$ycoordinate])
# publicKey = EccMultiply($point,hextodec($privKey))
# puts "the uncompressed public key (HEX):";
# puts "04" + publicKey[0][0].to_s(16) + publicKey[0][1].to_s(16); 
# sha256hash = generateSHA256("saif")
# r,s= SignatureGeneration($point,(randomNumberGeneration()),sha256hash)
# result = SignatureVerification(s,r,sha256hash,publicKey[0])
# puts result
# puts publicKey
# puts "the uncompressed public key (HEX):";
# puts "04" + publicKey[0][0].to_s(16) + publicKey[0][1].to_s(16); 