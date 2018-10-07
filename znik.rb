require 'digest'
$provePrimeNumber = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1
$numberOfPointsInFeild = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
$Acurve = 0
$xcoordinate = 55066263022277343669578718895168534326250603453777594175500187360389116729240
$ycoordinate = 32670510020758816978083085130507043184471273380659243275938904335757337482424
$privKey = "A665A45920422F9D417E4867EFDC4FB8A04A1F3FFF1FA07E998E86F7F7A27AE3"
$point  = Array.new([$xcoordinate,$ycoordinate])

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
        if scalarBin[i] == '1'
            q=ECadd(q,genPoint)
        end
    end
    return [q]
end


publicKey = EccMultiply($point,hextodec($privKey))

v = 0xd90688c575782cb4970514c7623fee2d6045e5d3aa48507beb3c9804453718d2
v1 = EccMultiply($point, v)
c = generateSHA256($point[0].to_s + v.to_s + publicKey[0].to_s )
r = (v - hextodec($privKey) * c) % $numberOfPointsInFeild
final = ECadd(EccMultiply($point,r)[0],EccMultiply(publicKey[0],c)[0])
puts (v1)
puts (final) # if v1 and final are same point, this mean verifer has sucesfully verified the statement