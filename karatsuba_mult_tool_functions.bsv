package karatsuba_multiplier;

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
  
  function Bit#(`XLEN) fmul_XHLEN (Bit#(`XHLEN) x,Bit#(`XHLEN) y);
    return zeroExtend(x)*zeroExtend(y);
  endfunction
  
  function Bit#(TAdd#(1, `XHLEN)) fadd_XHLEN (Bit#(`XHLEN) x,Bit#(`XHLEN) y);
    return zeroExtend(x)+zeroExtend(y);
  endfunction
  
  function Bit#(TAdd#(2, `XLEN)) fmul_XHLEN_1 (Bit#(TAdd#(1, `XHLEN)) x,Bit#(TAdd#(1, `XHLEN)) y);
    return zeroExtend(x)*zeroExtend(y);
  endfunction
  
  function Bit#(TAdd#(1, `XLEN)) fadd_XLEN (Bit#(`XLEN) x,Bit#(`XLEN) y);
    return zeroExtend(x)+zeroExtend(y);
  endfunction
  
  function Bit#(`X2LEN) fadd_X2LEN_4 (Bit#(`X2LEN) v1,Bit#(`X2LEN) v2,Bit#(`X2LEN) v3,Bit#(`X2LEN) v4);
    return v1+v2+v3+v4;
  endfunction
  
  rule rl_karatsuba_multiplier;
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(`XLEN) x = rg_op1;
    Bit#(`XLEN) y = rg_op2;
    Bit#(`XHLEN) x0 = x[`XHLEN-1:0];
    Bit#(`XHLEN) x1 = x[`XLEN-1:`XHLEN];
    Bit#(`XHLEN) y0 = y[`XHLEN-1:0];
    Bit#(`XHLEN) y1 = y[`XLEN-1:`XHLEN];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(`XLEN) x0y0 = fmul_XHLEN(x0,y0);
    Bit#(`XLEN) x1y1 = fmul_XHLEN(x1,y1);
    Bit#(TAdd#(1, `XHLEN)) x0plusx1 = fadd_XHLEN(x0,x1);
    Bit#(TAdd#(1, `XHLEN)) y0plusy1 = fadd_XHLEN(y0,y1);
    Bit#(TAdd#(2, `XLEN)) xsumysum = fmul_XHLEN_1 (x0plusx1,y0plusy1);
    Bit#(TAdd#(1, `XLEN)) x0y0plusx1y1 = fadd_XLEN(x0y0,x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(`X2LEN) v1 = zeroExtend(x0y0);
    Bit#(`X2LEN) v2 = zeroExtend(x1y1)<<(`XLEN);
    Bit#(`X2LEN) v3 = zeroExtend(xsumysum)<<(`XHLEN);
    Bit#(`X2LEN) v4 = ~(zeroExtend(x0y0plusx1y1)<<(`XHLEN))+1;
    
    Bit#(`X2LEN) xy = fadd_X2LEN_4 (v1,v2,v3,v4);
    
    rg_out <= xy;
    
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
