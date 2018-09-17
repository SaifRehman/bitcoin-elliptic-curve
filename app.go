package main

import (
	"fmt"
)

func main() {
	provePrimeNumber := 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1 // proven prime number value
	numberOfPointsInFeild = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
	numberOfPointsInFeild = parseInt(numberOfPointsInFeild,16)
	ACurveCoeff = 0
	BCurveCoeff = 7
	Xcoordinate = 55066263022277343669578718895168534326250603453777594175500187360389116729240
	Ycoordinate = 32670510020758816978083085130507043184471273380659243275938904335757337482424
	point = [Xcoordinate,Ycoordinate]
	privKey = "96DFA54348E574186C386F76D05B03C49016ED286FCFE06E7C58FD2509DC77AB"
	fmt.Println("Hello, playground")
}
