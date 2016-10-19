// File testBench.v
// Instantiates and tests a simulated gas station (gasStation.v) by toggling its inputs.
// No inputs/outputs (top-level test bench)
//	-Wesley Chavez, 10/3/15
//
//

`timescale 1ns/1ns  //1ns time resolution
module testBench ();



reg clock, UNLEADED, MONEY, TANKFULL, EMERGENCY_STOP, CARWASH_I;  //gasStation inputs, 1 bit
wire [1:0] state;  //gasStation output, 2 bits
wire READY, FEEDME, DELIVERGAS, CARWASH_O;  //gasStation outputs, 1 bit

gasStation dut (state, READY, FEEDME, DELIVERGAS, CARWASH_O, clock, UNLEADED, MONEY, TANKFULL, EMERGENCY_STOP, CARWASH_I);  //Instantiate gasStation

always  //toggles clock @ 500MHz
begin
	clock = 0;
	#1;
	clock = 1;
	#1;
end

initial  //toggle inputs for testing
begin
	UNLEADED = 0;
	MONEY = 0;
	TANKFULL = 0;
	EMERGENCY_STOP = 0;
	CARWASH_I = 0;
	
	$dumpfile("testBench.vcd");
	$dumpvars(0,testBench);
	
	#20
	UNLEADED = 1;
	#3
	UNLEADED = 0;
	#20
	MONEY = 1;
	#2
	MONEY = 0;
	#20
	CARWASH_I = 1;
	#5
	CARWASH_I = 0;
	UNLEADED = 1;
	TANKFULL = 1;
	#5	
	UNLEADED = 0;
	#20
	CARWASH_I = 1;
	#5
	CARWASH_I = 0;

	$finish;
end
endmodule

