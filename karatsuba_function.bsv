package karatsuba_function;
  import Vector :: * ;
  function Bit#(128) fmul_k64(Bit#(64) x, Bit#(64) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(32) x0 = x[31:0];
    Bit#(32) x1 = x[63:32];
    Bit#(32) y0 = y[31:0];
    Bit#(32) y1 = y[63:32];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(64) x0y0 = fmul_k32(x0,y0);
    Bit#(64) x1y1 = fmul_k32(x1,y1);
    Bit#(33) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(33) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(66) xsumysum = fmul_k34 ({1'b0,x0plusx1},{1'b0,y0plusy1})[65:0];
    Bit#(65) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(128) v1 = {x1y1,x0y0};
    Bit#(128) v3 = zeroExtend(xsumysum)<<(32);
    Bit#(128) v4 = ~(zeroExtend(x0y0plusx1y1)<<(32))+1;
    Bit#(128) xy = v1+v3+v4;
    return xy;
  endfunction
  
  function Bit#(64) fmul_k32(Bit#(32) x, Bit#(32) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(16) x0 = x[15:0];
    Bit#(16) x1 = x[31:16];
    Bit#(16) y0 = y[15:0];
    Bit#(16) y1 = y[31:16];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(32) x0y0 = fmul_k16(x0,y0);
    Bit#(32) x1y1 = fmul_k16(x1,y1);
    Bit#(17) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(17) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(34) xsumysum = fmul_k18 ({1'b0,x0plusx1},{1'b0,y0plusy1})[33:0];
    Bit#(33) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(64) v1 = zeroExtend(x0y0);
    Bit#(64) v2 = zeroExtend(x1y1)<<(32);
    Bit#(64) v3 = zeroExtend(xsumysum)<<(16);
    Bit#(64) v4 = ~(zeroExtend(x0y0plusx1y1)<<(16))+1;
    
    Bit#(64) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(32) fmul_k16(Bit#(16) x, Bit#(16) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(8) x0 = x[7:0];
    Bit#(8) x1 = x[15:8];
    Bit#(8) y0 = y[7:0];
    Bit#(8) y1 = y[15:8];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(16) x0y0 = fmul_k8(x0,y0);
    Bit#(16) x1y1 = fmul_k8(x1,y1);
    Bit#(9) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(9) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(18) xsumysum = fmul_k10 ({1'b0,x0plusx1},{1'b0,y0plusy1})[17:0];
    Bit#(17) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(32) v1 = zeroExtend(x0y0);
    Bit#(32) v2 = zeroExtend(x1y1)<<(16);
    Bit#(32) v3 = zeroExtend(xsumysum)<<(8);
    Bit#(32) v4 = ~(zeroExtend(x0y0plusx1y1)<<(8))+1;
    
    Bit#(32) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(20) fmul_k10(Bit#(10) x, Bit#(10) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(5) x0 = x[4:0];
    Bit#(5) x1 = x[9:5];
    Bit#(5) y0 = y[4:0];
    Bit#(5) y1 = y[9:5];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(10) x0y0 = fmul_k6({1'b0,x0},{1'b0,y0})[9:0];
    Bit#(10) x1y1 = fmul_k6({1'b0,x1},{1'b0,y1})[9:0];
    Bit#(6) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(6) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(12) xsumysum = fmul_k6 (x0plusx1,y0plusy1);
    Bit#(11) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(20) v1 = zeroExtend(x0y0);
    Bit#(20) v2 = zeroExtend(x1y1)<<(10);
    Bit#(20) v3 = zeroExtend(xsumysum)<<(5);
    Bit#(20) v4 = ~(zeroExtend(x0y0plusx1y1)<<(5))+1;
    
    Bit#(20) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(16) fmul_k8(Bit#(8) x, Bit#(8) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(4) x0 = x[3:0];
    Bit#(4) x1 = x[7:4];
    Bit#(4) y0 = y[3:0];
    Bit#(4) y1 = y[7:4];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(8) x0y0 = fmul_k4(x0,y0);
    Bit#(8) x1y1 = fmul_k4(x1,y1);
    Bit#(5) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(5) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(10) xsumysum = fmul_k6 ({1'b0,x0plusx1},{1'b0,y0plusy1})[9:0];
    Bit#(9) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(16) v1 = zeroExtend(x0y0);
    Bit#(16) v2 = zeroExtend(x1y1)<<(8);
    Bit#(16) v3 = zeroExtend(xsumysum)<<(4);
    Bit#(16) v4 = ~(zeroExtend(x0y0plusx1y1)<<(4))+1;
    
    Bit#(16) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(12) fmul_k6(Bit#(6) x, Bit#(6) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(3) x0 = x[2:0];
    Bit#(3) x1 = x[5:3];
    Bit#(3) y0 = y[2:0];
    Bit#(3) y1 = y[5:3];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(6) x0y0 = fmul_k4({1'b0,x0},{1'b0,y0})[5:0];
    Bit#(6) x1y1 = fmul_k4({1'b0,x1},{1'b0,y1})[5:0];
    Bit#(4) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(4) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(8) xsumysum = fmul_k4 (x0plusx1,y0plusy1);
    Bit#(7) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(12) v1 = zeroExtend(x0y0);
    Bit#(12) v2 = zeroExtend(x1y1)<<(6);
    Bit#(12) v3 = zeroExtend(xsumysum)<<(3);
    Bit#(12) v4 = ~(zeroExtend(x0y0plusx1y1)<<(3))+1;
    
    Bit#(12) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(8) fmul_k4(Bit#(4) x, Bit#(4) y);
    //solving 4*4 in karatsuba method is not effective, lets do it in classic partial product way
    
    Bit#(6) partial_product1 = zeroExtend(x&signExtend(y[0]));
    Bit#(6) partial_product2 = {1'b0,x&signExtend(y[1]),1'b0};
    Bit#(6) partial_product3 = {x&signExtend(y[2]),2'b0};
    Bit#(7) partial_product4 = {x&signExtend(y[3]),3'b0};
    
    //sending first 3 partial products through a CSA
    Bit#(6) sum = partial_product1^partial_product2^partial_product3;
    Bit#(6) carry = ((partial_product1&partial_product2)|(partial_product2&partial_product3)|(partial_product1&partial_product3))<<1;
    
    //sending sum.carry and 4th partial product through a CSA
    Bit#(8) sum_1 = {2'b0,sum}^{2'b0,carry}^{1'b0,partial_product4};
    Bit#(8) carry_1 = (({2'b0,sum}&{2'b0,carry})|({2'b0,carry}&{1'b0,partial_product4})|({2'b0,sum}&{1'b0,partial_product4}))<<1;
    
    return sum_1+carry_1;
  endfunction
  
  function Bit#(68) fmul_k34(Bit#(34) x, Bit#(34) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(17) x0 = x[16:0];
    Bit#(17) x1 = x[33:17];
    Bit#(17) y0 = y[16:0];
    Bit#(17) y1 = y[33:17];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(34) x0y0 = fmul_k18({1'b0,x0},{1'b0,y0})[33:0];
    Bit#(34) x1y1 = fmul_k18({1'b0,x1},{1'b0,y1})[33:0];
    Bit#(18) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(18) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(36) xsumysum = fmul_k18 (x0plusx1,y0plusy1);
    Bit#(35) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(68) v1 = zeroExtend(x0y0);
    Bit#(68) v2 = zeroExtend(x1y1)<<(34);
    Bit#(68) v3 = zeroExtend(xsumysum)<<(17);
    Bit#(68) v4 = ~(zeroExtend(x0y0plusx1y1)<<(17))+1;
    
    Bit#(68) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
  function Bit#(36) fmul_k18(Bit#(18) x, Bit#(18) y);
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(9) x0 = x[8:0];
    Bit#(9) x1 = x[17:9];
    Bit#(9) y0 = y[8:0];
    Bit#(9) y1 = y[17:9];
    
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    Bit#(18) x0y0 = fmul_k10({1'b0,x0},{1'b0,y0})[17:0];
    Bit#(18) x1y1 = fmul_k10({1'b0,x1},{1'b0,y1})[17:0];
    Bit#(10) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(10) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    Bit#(20) xsumysum = fmul_k10 (x0plusx1,y0plusy1);
    Bit#(19) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(36) v1 = zeroExtend(x0y0);
    Bit#(36) v2 = zeroExtend(x1y1)<<(18);
    Bit#(36) v3 = zeroExtend(xsumysum)<<(9);
    Bit#(36) v4 = ~(zeroExtend(x0y0plusx1y1)<<(9))+1;
    
    Bit#(36) xy = v1+v2+v3+v4;
    
    return xy;
  endfunction
  
endpackage
