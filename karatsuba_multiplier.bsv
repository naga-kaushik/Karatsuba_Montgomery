package karatsuba_multiplier;
import karatsuba_function ::*;
`define XHLEN 32
`define XLEN 64
`define X2LEN 128
interface Ifc_karatsuba_multiplier;
  (*always_ready*)
	method Action send(Bit#(`XLEN) in1, Bit#(`XLEN) in2 );
	method Bit#(`X2LEN) receive;
endinterface
	
(*synthesize*)
module mk_karatsuba_multiplier(Ifc_karatsuba_multiplier);
  
  Reg#(Bit#(`XLEN)) rg_op1 <- mkReg(0);
  Reg#(Bit#(`XLEN)) rg_op2 <- mkReg(0);
  Reg#(Bit#(`X2LEN)) rg_out <- mkReg(0);
  
  rule rl_karatsuba_multiplier;
    Bit#(`XLEN) x = rg_op1;
    Bit#(`XLEN) y = rg_op2;
    
    rg_out <= fmul_k64(x,y);
    
  endrule
  
  method Action send(Bit#(`XLEN) in1, Bit#(`XLEN) in2 );
    rg_op1 <= in1;
    rg_op2 <= in2;
  endmethod
  
  method Bit#(`X2LEN) receive;
    return rg_out;
  endmethod

endmodule
 
endpackage
