package karatsuba_csa_multiplier128_pipelined.bsv;
import karatsuba_function ::*;
import int_multiplier_csa ::*;
`define XHLEN 64
`define XLEN 128
`define X2LEN 256
interface Ifc_karatsuba_multiplier;
  (*always_ready*)
	method Action send(Bit#(`XLEN) in1, Bit#(`XLEN) in2 );
	method Bit#(`X2LEN) receive;
endinterface
	
(*synthesize*)
module mk_karatsuba_multiplier_128(Ifc_karatsuba_multiplier);
  
  Reg#(Bit#(`XLEN)) rg_op1 <- mkReg(0);
  Reg#(Bit#(`XLEN)) rg_op2 <- mkReg(0);
  Reg#(Bit#(`X2LEN)) rg_out <- mkReg(0);
  
  //regs for stage 0 yo 1
  Reg#(Bit#(128)) rg_x <- mkReg(0);
  Reg#(Bit#(128)) rg_y <- mkReg(0);  
  Reg#(Bit#(65)) rg_x0plusx1 <- mkReg(0);
  Reg#(Bit#(65)) rg_y0plusy1 <- mkReg(0);
    
  //regs for stage 1 to 2
  Reg#(Bit#(128)) rg_pp_4[14];
  Reg#(Bit#(128)) rg_pp1_4[14];
  Reg#(Bit#(130)) rg_pp2_4[14];
  for (Integer i=0; i<14; i=i+1) begin
      rg_pp_4[i] <- mkReg(0);
      rg_pp1_4[i] <- mkReg(0);
      rg_pp2_4[i] <- mkReg(0);
      end
    
  //regs for stage 2 to 3  
  Reg#(Bit#(128)) rg_pp_9[3];
  Reg#(Bit#(128)) rg_pp1_9[3];
  Reg#(Bit#(130)) rg_pp2_9[3];
  for (Integer i=0; i<3; i=i+1) begin
      rg_pp_9[i] <- mkReg(0);
      rg_pp1_9[i] <- mkReg(0);
      rg_pp2_9[i] <- mkReg(0);
      end
  
  //regs from stage 3 to 4
  Reg#(Bit#(128)) rg_x0y0 <- mkReg(0);
  Reg#(Bit#(128)) rg_x1y1 <- mkReg(0);
  Reg#(Bit#(130)) rg_xsumysum <- mkReg(0);
    
  //regs from stage 3 to 4
  Reg#(Bit#(256)) rg_v1 <- mkReg(0);
  Reg#(Bit#(256)) rg_v2 <- mkReg(0);
  Reg#(Bit#(256)) rg_v3 <- mkReg(0);
  
  rule rl_karatsuba_multiplier_stage0;
    Bit#(`XLEN) x = rg_op1;
    Bit#(`XLEN) y = rg_op2;
    
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(64) x0 = x[63:0];
    Bit#(64) x1 = x[127:64];
    Bit#(64) y0 = y[63:0];
    Bit#(64) y1 = y[127:64];
    Bit#(65) x0plusx1 = zeroExtend(x0)+zeroExtend(x1);
    Bit#(65) y0plusy1 = zeroExtend(y0)+zeroExtend(y1);
    
    rg_x <= x;
    rg_y <= y;
    rg_x0plusx1 <= x0plusx1;
    rg_y0plusy1 <= y0plusy1;
  endrule
  
  rule rl_karatsuba_multiplier_stage1;
    Bit#(`XLEN) x = rg_x;
    Bit#(`XLEN) y = rg_y;
    
    //x0,x1 y0,y1 are lower and upper halves of inputs (x,y)
    Bit#(64) x0 = x[63:0];
    Bit#(64) x1 = x[127:64];
    Bit#(64) y0 = y[63:0];
    Bit#(64) y1 = y[127:64];
    Bit#(65) x0plusx1 = rg_x0plusx1;
    Bit#(65) y0plusy1 = rg_y0plusy1;
    //Karatsuba Algorithm : x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1)
    // so first calculate the products x0.y0 , x1.y1 , (x0+x1).(y0+y1)
    
    //csa64 to calculate x0y0
    Bit#(128) pp_0[64],pp_1[43],pp_2[29],pp_3[20],pp_4[14];
  
    for (Integer i=0; i<64; i=i+1) begin
      pp_0[i] = zeroExtend(x0&signExtend(y0[i]))<<i;
      end
    for (Integer i=0; i<21; i=i+1) begin
      pp_1[2*i] = fn_csa_128(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[0];
      pp_1[2*i+1] = fn_csa_128(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[1];
      end
    pp_1[42]=pp_0[63];
    for (Integer i=0; i<14; i=i+1) begin
      pp_2[2*i] = fn_csa_128(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[0];
      pp_2[2*i+1] = fn_csa_128(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[1];
      end
    pp_2[28]=pp_1[42];
    for (Integer i=0; i<9; i=i+1) begin
      pp_3[2*i] = fn_csa_128(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[0];
      pp_3[2*i+1] = fn_csa_128(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[1];
      end
    pp_3[18]=pp_2[27];
    pp_3[19]=pp_2[28];
    for (Integer i=0; i<6; i=i+1) begin
      pp_4[2*i] = fn_csa_128(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[0];
      pp_4[2*i+1] = fn_csa_128(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[1];
      end
    pp_4[12]=pp_3[18];
    pp_4[13]=pp_3[19];
    
   
    //csa64 to calculate x1y1
    Bit#(128) pp1_0[64],pp1_1[43],pp1_2[29],pp1_3[20],pp1_4[14];
  
    for (Integer i=0; i<64; i=i+1) begin
      pp1_0[i] = zeroExtend(x1&signExtend(y1[i]))<<i;
      end
    for (Integer i=0; i<21; i=i+1) begin
      pp1_1[2*i] = fn_csa_128(pp1_0[3*i],pp1_0[3*i+1],pp1_0[3*i+2])[0];
      pp1_1[2*i+1] = fn_csa_128(pp1_0[3*i],pp1_0[3*i+1],pp1_0[3*i+2])[1];
      end
    pp1_1[42]=pp1_0[63];
    for (Integer i=0; i<14; i=i+1) begin
      pp1_2[2*i] = fn_csa_128(pp1_1[3*i],pp1_1[3*i+1],pp1_1[3*i+2])[0];
      pp1_2[2*i+1] = fn_csa_128(pp1_1[3*i],pp1_1[3*i+1],pp1_1[3*i+2])[1];
      end
    pp1_2[28]=pp1_1[42];
    for (Integer i=0; i<9; i=i+1) begin
      pp1_3[2*i] = fn_csa_128(pp1_2[3*i],pp1_2[3*i+1],pp1_2[3*i+2])[0];
      pp1_3[2*i+1] = fn_csa_128(pp1_2[3*i],pp1_2[3*i+1],pp1_2[3*i+2])[1];
      end
    pp1_3[18]=pp1_2[27];
    pp1_3[19]=pp1_2[28];
    for (Integer i=0; i<6; i=i+1) begin
      pp1_4[2*i] = fn_csa_128(pp1_3[3*i],pp1_3[3*i+1],pp1_3[3*i+2])[0];
      pp1_4[2*i+1] = fn_csa_128(pp1_3[3*i],pp1_3[3*i+1],pp1_3[3*i+2])[1];
      end
    pp1_4[12]=pp1_3[18];
    pp1_4[13]=pp1_3[19];
    
    
    //csa65 for x0plusx1*y0plusy1
    Bit#(130) pp2_0[65],pp2_1[44],pp2_2[30],pp2_3[20],pp2_4[14];
  
    for (Integer i=0; i<65; i=i+1) begin
      pp2_0[i] = zeroExtend(x0plusx1&signExtend(y0plusy1[i]))<<i;
      end
    for (Integer i=0; i<21; i=i+1) begin
      pp2_1[2*i] = fn_csa_130(pp2_0[3*i],pp2_0[3*i+1],pp2_0[3*i+2])[0];
      pp2_1[2*i+1] = fn_csa_130(pp2_0[3*i],pp2_0[3*i+1],pp2_0[3*i+2])[1];
      end
    pp2_1[42]=pp2_0[63];
    pp2_1[43]=pp2_0[64];
    for (Integer i=0; i<14; i=i+1) begin
      pp2_2[2*i] = fn_csa_130(pp2_1[3*i],pp2_1[3*i+1],pp2_1[3*i+2])[0];
      pp2_2[2*i+1] = fn_csa_130(pp2_1[3*i],pp2_1[3*i+1],pp2_1[3*i+2])[1];
      end
    pp2_2[28]=pp2_1[42];
    pp2_2[29]=pp2_1[43];
    for (Integer i=0; i<10; i=i+1) begin
      pp2_3[2*i] = fn_csa_130(pp2_2[3*i],pp2_2[3*i+1],pp2_2[3*i+2])[0];
      pp2_3[2*i+1] = fn_csa_130(pp2_2[3*i],pp2_2[3*i+1],pp2_2[3*i+2])[1];
      end
    for (Integer i=0; i<6; i=i+1) begin
      pp2_4[2*i] = fn_csa_130(pp2_3[3*i],pp2_3[3*i+1],pp2_3[3*i+2])[0];
      pp2_4[2*i+1] = fn_csa_130(pp2_3[3*i],pp2_3[3*i+1],pp2_3[3*i+2])[1];
      end
    pp2_4[12]=pp2_3[18];
    pp2_4[13]=pp2_3[19];
      
    
    for (Integer i=0; i<14; i=i+1) begin
      rg_pp_4[i] <= pp_4[i];
      rg_pp1_4[i] <= pp1_4[i];
      rg_pp2_4[i] <= pp2_4[i];
      end
    
  endrule
  
  rule rl_karatsuba_multiplier_stage2;
  
    Bit#(128) pp_4[14],pp_5[10],pp_6[7],pp_7[5],pp_8[4],pp_9[3];
    for (Integer i=0; i<14; i=i+1) begin
      pp_4[i] = rg_pp_4[i];
      end
    
    for (Integer i=0; i<4; i=i+1) begin
      pp_5[2*i] = fn_csa_128(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[0];
      pp_5[2*i+1] = fn_csa_128(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[1];
      end
    pp_5[8]=pp_4[12];
    pp_5[9]=pp_4[13];
    for (Integer i=0; i<3; i=i+1) begin
      pp_6[2*i] = fn_csa_128(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[0];
      pp_6[2*i+1] = fn_csa_128(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[1];
      end
    pp_6[6]=pp_5[9];
    for (Integer i=0; i<2; i=i+1) begin
      pp_7[2*i] = fn_csa_128(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[0];
      pp_7[2*i+1] = fn_csa_128(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[1];
      end
    pp_7[4]=pp_6[6];
    for (Integer i=0; i<1; i=i+1) begin
      pp_8[2*i] = fn_csa_128(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[0];
      pp_8[2*i+1] = fn_csa_128(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[1];
      end
    pp_8[2]=pp_7[3];
    pp_8[3]=pp_7[4];
    for (Integer i=0; i<1; i=i+1) begin
      pp_9[2*i] = fn_csa_128(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[0];
      pp_9[2*i+1] = fn_csa_128(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[1];
      end
    pp_9[2]=pp_8[3];
    
    
    Bit#(128) pp1_4[14],pp1_5[10],pp1_6[7],pp1_7[5],pp1_8[4],pp1_9[3];
    for (Integer i=0; i<14; i=i+1) begin
      pp1_4[i] = rg_pp1_4[i];
      end
      
    
    for (Integer i=0; i<4; i=i+1) begin
      pp1_5[2*i] = fn_csa_128(pp1_4[3*i],pp1_4[3*i+1],pp1_4[3*i+2])[0];
      pp1_5[2*i+1] = fn_csa_128(pp1_4[3*i],pp1_4[3*i+1],pp1_4[3*i+2])[1];
      end
    pp1_5[8]=pp1_4[12];
    pp1_5[9]=pp1_4[13];
    for (Integer i=0; i<3; i=i+1) begin
      pp1_6[2*i] = fn_csa_128(pp1_5[3*i],pp1_5[3*i+1],pp1_5[3*i+2])[0];
      pp1_6[2*i+1] = fn_csa_128(pp1_5[3*i],pp1_5[3*i+1],pp1_5[3*i+2])[1];
      end
    pp1_6[6]=pp1_5[9];
    for (Integer i=0; i<2; i=i+1) begin
      pp1_7[2*i] = fn_csa_128(pp1_6[3*i],pp1_6[3*i+1],pp1_6[3*i+2])[0];
      pp1_7[2*i+1] = fn_csa_128(pp1_6[3*i],pp1_6[3*i+1],pp1_6[3*i+2])[1];
      end
    pp1_7[4]=pp1_6[6];
    for (Integer i=0; i<1; i=i+1) begin
      pp1_8[2*i] = fn_csa_128(pp1_7[3*i],pp1_7[3*i+1],pp1_7[3*i+2])[0];
      pp1_8[2*i+1] = fn_csa_128(pp1_7[3*i],pp1_7[3*i+1],pp1_7[3*i+2])[1];
      end
    pp1_8[2]=pp1_7[3];
    pp1_8[3]=pp1_7[4];
    for (Integer i=0; i<1; i=i+1) begin
      pp1_9[2*i] = fn_csa_128(pp1_8[3*i],pp1_8[3*i+1],pp1_8[3*i+2])[0];
      pp1_9[2*i+1] = fn_csa_128(pp1_8[3*i],pp1_8[3*i+1],pp1_8[3*i+2])[1];
      end
    pp1_9[2]=pp1_8[3];
    
    
    Bit#(130) pp2_4[14],pp2_5[10],pp2_6[7],pp2_7[5],pp2_8[4],pp2_9[3];
    for (Integer i=0; i<14; i=i+1) begin
      pp2_4[i] = rg_pp2_4[i];
      end
      
    
    for (Integer i=0; i<4; i=i+1) begin
      pp2_5[2*i] = fn_csa_130(pp2_4[3*i],pp2_4[3*i+1],pp2_4[3*i+2])[0];
      pp2_5[2*i+1] = fn_csa_130(pp2_4[3*i],pp2_4[3*i+1],pp2_4[3*i+2])[1];
      end
    pp2_5[8]=pp2_4[12];
    pp2_5[9]=pp2_4[13];
    for (Integer i=0; i<3; i=i+1) begin
      pp2_6[2*i] = fn_csa_130(pp2_5[3*i],pp2_5[3*i+1],pp2_5[3*i+2])[0];
      pp2_6[2*i+1] = fn_csa_130(pp2_5[3*i],pp2_5[3*i+1],pp2_5[3*i+2])[1];
      end
    pp2_6[6]=pp2_5[9];
    for (Integer i=0; i<2; i=i+1) begin
      pp2_7[2*i] = fn_csa_130(pp2_6[3*i],pp2_6[3*i+1],pp2_6[3*i+2])[0];
      pp2_7[2*i+1] = fn_csa_130(pp2_6[3*i],pp2_6[3*i+1],pp2_6[3*i+2])[1];
      end
    pp2_7[4]=pp2_6[6];
    for (Integer i=0; i<1; i=i+1) begin
      pp2_8[2*i] = fn_csa_130(pp2_7[3*i],pp2_7[3*i+1],pp2_7[3*i+2])[0];
      pp2_8[2*i+1] = fn_csa_130(pp2_7[3*i],pp2_7[3*i+1],pp2_7[3*i+2])[1];
      end
    pp2_8[2]=pp2_7[3];
    pp2_8[3]=pp2_7[4];
    for (Integer i=0; i<1; i=i+1) begin
      pp2_9[2*i] = fn_csa_130(pp2_8[3*i],pp2_8[3*i+1],pp2_8[3*i+2])[0];
      pp2_9[2*i+1] = fn_csa_130(pp2_8[3*i],pp2_8[3*i+1],pp2_8[3*i+2])[1];
      end
    pp2_9[2]=pp2_8[3];
    
    for (Integer i=0; i<3; i=i+1) begin
      rg_pp_9[i] <= pp_9[i];
      rg_pp1_9[i] <= pp1_9[i];
      rg_pp2_9[i] <= pp2_9[i];
      end
    
  endrule
  
  rule rl_karatsuba_multiplier_stage3;
  
    Bit#(128) pp_9[3],pp_10[2];
    
    for (Integer i=0; i<3; i=i+1) begin
      pp_9[i] = rg_pp_9[i];
      end
      
    pp_10[0]=fn_csa_128(pp_9[0],pp_9[1],pp_9[2])[0];
    pp_10[1]=fn_csa_128(pp_9[0],pp_9[1],pp_9[2])[1];
    
    Bit#(128) x0y0 = pp_10[0]+pp_10[1];
    
    Bit#(128) pp1_9[3],pp1_10[2];
    
    for (Integer i=0; i<3; i=i+1) begin
      pp1_9[i] = rg_pp1_9[i];
      end
      
    pp1_10[0]=fn_csa_128(pp1_9[0],pp1_9[1],pp1_9[2])[0];
    pp1_10[1]=fn_csa_128(pp1_9[0],pp1_9[1],pp1_9[2])[1];
    
    Bit#(128) x1y1 =  pp1_10[0]+pp1_10[1];
    
    Bit#(130) pp2_9[3],pp2_10[2];
    
    for (Integer i=0; i<3; i=i+1) begin
      pp2_9[i] = rg_pp2_9[i];
      end
      
    pp2_10[0]=fn_csa_130(pp2_9[0],pp2_9[1],pp2_9[2])[0];
    pp2_10[1]=fn_csa_130(pp2_9[0],pp2_9[1],pp2_9[2])[1];
    
    Bit#(130) xsumysum = pp2_10[0]+pp2_10[1];
    
  
    rg_x0y0 <= x0y0;
    rg_x1y1 <= x1y1;
    rg_xsumysum <= xsumysum;
  endrule
  
  rule rl_karatsuba_multiplier_stage4;
    
    Bit#(128) x0y0 = rg_x0y0;
    Bit#(128) x1y1 = rg_x1y1;
    Bit#(130) xsumysum = rg_xsumysum;
    
    Bit#(129) x0y0plusx1y1 = zeroExtend(x0y0)+zeroExtend(x1y1);
    
    //x.y = x0.y0 + (2^2k).x1.y1 + (2^k).((x0+x1).(y0+y1)) - (2^k).(x0.y0+x1.y1) 
    // 4 operands undergo addition : v1,v2,v3,v4 : all should be extended to X2LEN bit widths
    Bit#(256) v1 = {x1y1,x0y0};
    Bit#(256) v2 = zeroExtend(xsumysum)<<(64);
    Bit#(256) v3 = ~(zeroExtend(x0y0plusx1y1)<<(64))+1;
    
    rg_v1 <= v1;
    rg_v2 <= v2;
    rg_v3 <= v3;
    
    
  endrule
  
  rule rl_karatsuba_multiplier_stage5;
    Bit#(256) v1,v2,v3;
    v1 = rg_v1; v2 = rg_v2; v3 = rg_v3;
    Bit#(256) xy = v1+v3+v2;
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
