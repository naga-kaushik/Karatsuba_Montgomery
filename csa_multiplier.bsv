package csa_multiplier;
import csa_functions ::*;
`define XHLEN 128
`define XLEN 256
`define X2LEN 512
interface Ifc_csa_multiplier;
  (*always_ready*)
	method Action send(Bit#(`XLEN) in1, Bit#(`XLEN) in2 );
	method Bit#(`X2LEN) receive;
endinterface
	
(*synthesize*)
module mk_csa_multiplier_256(Ifc_csa_multiplier);
  
  Reg#(Bit#(`XLEN)) rg_op1 <- mkReg(0);
  Reg#(Bit#(`XLEN)) rg_op2 <- mkReg(0);
  Reg#(Bit#(`X2LEN)) rg_out <- mkReg(0);
  
  rule rl_csa_multiplier;
    Bit#(`XLEN) x = rg_op1;
    Bit#(`XLEN) y = rg_op2;
    
    rg_out <= fmul_csa256(x,y);
    
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
