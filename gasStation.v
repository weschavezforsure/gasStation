// File gasStation.v
// Simulates a gas station as a Moore State Machine.
//
// - Wesley Chavez, 10/3/15
//
// 6 inputs:
//
//	clock (to change states synchronously)
//	UNLEADED (the customer wants unleaded gas)
//	MONEY (the customer input the correct amount of money)
// 	TANKFULL (the gas tank is full)
//	EMERGENCY_STOP (stop dispensing gas)
//	CARWASH_I (the customer wants a carwash)
//
// 5 outputs:
//
//	state (finite state used as an output for testing)
//	READY (drives a green LED (asserted high) when gas machine is ready for customer to select gas)
//	FEEDME (drives a red LED (asserted high) until customer inputs the correct amount of money)
//	DELIVERGAS (delivers gas)
//	CARWASH_O (drives a green LED (asserted high) asking the customer if they want a carwash)
//
// Assumptions: 
//	Unleaded gas is the only type dispensed here.
//	The customer always inputs the correct amount of money.
//	Gas is dispensed as soon as the customer inserts money.
//	The customer always wants a carwash, even if his/her car is already clean.
//	If the gas machine is stuck in one state, it must receive the correct inputs to transition to the next. 
//		(EX: Customer inputs money, presses UNLEADED.  Customer MUST input money again and pay twice for the gas. C'est la vie.)
//	A 500 MHz clock is fast enough for a Moore Machine (vs Mealy). Gas will stop dispensing a maximum 2 ns after EMERGENCY_STOP is asserted,
//		which is suitable for this application.
//

module gasStation (state, READY, FEEDME, DELIVERGAS, CARWASH_O, clock, UNLEADED, MONEY, TANKFULL, EMERGENCY_STOP, CARWASH_I);
input clock, UNLEADED, MONEY, TANKFULL, EMERGENCY_STOP, CARWASH_I;  //inputs, 1 bit
output reg [1:0] state;  //output, 2 bits
output reg READY, FEEDME, DELIVERGAS, CARWASH_O;  //outputs, 1 bit

parameter needgastype = 2'b00, needmoney = 2'b01, delivering = 2'b10, wantcarwash = 2'b11;  //abstractions to specify state
	
initial  //Initialize state, outputs
begin
	state = needgastype;
	READY = 0;
	FEEDME = 0;
	DELIVERGAS = 0;
	CARWASH_O = 0;
end

always @ (state)  //Is called when state changes
	case (state)
		needgastype:  //Waiting for customer to select unleaded
		begin
			CARWASH_O = 0;
			READY = 1;
		end
		needmoney:  //Waiting for customer to input money
		begin
			READY = 0;
			FEEDME = 1;

		end
		delivering:  //Delivering gas
		begin
			FEEDME = 0;
			DELIVERGAS = 1;

		end
		wantcarwash:  //Prompts the customer to select a carwash
		begin
			DELIVERGAS = 0;
			CARWASH_O = 1;

		end
	endcase
always @ (posedge clock)  //Checks inputs at positive edge of the clock and transitions states if inputs fulfill state change requirements
	case (state)
		needgastype:	
			if (UNLEADED)  //If customer selects unleaded in the needgastype state, transition to needmoney state
				state = needmoney;
		needmoney: 
			if (MONEY)  //If customer inputs money in the needmoney state, transition to delivering state to deliver gas
				state = delivering;
		delivering: 
			if (TANKFULL || EMERGENCY_STOP)  //If the tank is full or the emergency stop input is asserted in the delivering state, transition to wantcarwash state
				state = wantcarwash;
		wantcarwash: 
			if (CARWASH_I)  //If customer pushes the carwash button in the wantcarwash state, transition to needgastype state
				state = needgastype;
	endcase
			


endmodule

