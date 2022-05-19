package csa_functions;
function Vector#(2, Bit#(128)) fn_csa_128 (Bit#(128) x, Bit#(128) y,Bit#(128) z);
    Vector#(2, Bit#(128)) csa;
    csa[0] = x^y^z;
    csa[1] = ((x&y)|(y&z)|(z&x))<<1;
    return csa;
  endfunction
  
  function Bit#(128) fmul_csa64(Bit#(64) x, Bit#(64) y);
  
    Bit#(128) pp_0[64],pp_1[43],pp_2[29],pp_3[20],pp_4[14],pp_5[10],pp_6[7],pp_7[5],pp_8[4],pp_9[3],pp_10[2];
  
    for (Integer i=0; i<64; i=i+1) begin
      pp_0[i] = zeroExtend(x&signExtend(y[i]))<<i;
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
    pp_10[0]=fn_csa_128(pp_9[0],pp_9[1],pp_9[2])[0];
    pp_10[1]=fn_csa_128(pp_9[0],pp_9[1],pp_9[2])[1];
    
    return pp_10[0]+pp_10[1];
  endfunction
  
  function Vector#(2, Bit#(130)) fn_csa_130 (Bit#(130) x, Bit#(130) y,Bit#(130) z);
    Vector#(2, Bit#(130)) csa;
    csa[0] = x^y^z;
    csa[1] = ((x&y)|(y&z)|(z&x))<<1;
    return csa;
  endfunction
  
  function Bit#(130) fmul_csa65(Bit#(65) x, Bit#(65) y);
  
    Bit#(130) pp_0[65],pp_1[44],pp_2[30],pp_3[20],pp_4[14],pp_5[10],pp_6[7],pp_7[5],pp_8[4],pp_9[3],pp_10[2];
  
    for (Integer i=0; i<65; i=i+1) begin
      pp_0[i] = zeroExtend(x&signExtend(y[i]))<<i;
      end
    for (Integer i=0; i<21; i=i+1) begin
      pp_1[2*i] = fn_csa_130(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[0];
      pp_1[2*i+1] = fn_csa_130(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[1];
      end
    pp_1[42]=pp_0[63];
    pp_1[43]=pp_0[64];
    for (Integer i=0; i<14; i=i+1) begin
      pp_2[2*i] = fn_csa_130(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[0];
      pp_2[2*i+1] = fn_csa_130(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[1];
      end
    pp_2[28]=pp_1[42];
    pp_2[29]=pp_1[43];
    for (Integer i=0; i<10; i=i+1) begin
      pp_3[2*i] = fn_csa_130(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[0];
      pp_3[2*i+1] = fn_csa_130(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[1];
      end
    for (Integer i=0; i<6; i=i+1) begin
      pp_4[2*i] = fn_csa_130(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[0];
      pp_4[2*i+1] = fn_csa_130(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[1];
      end
    pp_4[12]=pp_3[18];
    pp_4[13]=pp_3[19];
    for (Integer i=0; i<4; i=i+1) begin
      pp_5[2*i] = fn_csa_130(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[0];
      pp_5[2*i+1] = fn_csa_130(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[1];
      end
    pp_5[8]=pp_4[12];
    pp_5[9]=pp_4[13];
    for (Integer i=0; i<3; i=i+1) begin
      pp_6[2*i] = fn_csa_130(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[0];
      pp_6[2*i+1] = fn_csa_130(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[1];
      end
    pp_6[6]=pp_5[9];
    for (Integer i=0; i<2; i=i+1) begin
      pp_7[2*i] = fn_csa_130(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[0];
      pp_7[2*i+1] = fn_csa_130(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[1];
      end
    pp_7[4]=pp_6[6];
    for (Integer i=0; i<1; i=i+1) begin
      pp_8[2*i] = fn_csa_130(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[0];
      pp_8[2*i+1] = fn_csa_130(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[1];
      end
    pp_8[2]=pp_7[3];
    pp_8[3]=pp_7[4];
    for (Integer i=0; i<1; i=i+1) begin
      pp_9[2*i] = fn_csa_130(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[0];
      pp_9[2*i+1] = fn_csa_130(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[1];
      end
    pp_9[2]=pp_8[3];
    pp_10[0]=fn_csa_130(pp_9[0],pp_9[1],pp_9[2])[0];
    pp_10[1]=fn_csa_130(pp_9[0],pp_9[1],pp_9[2])[1];
    
    return pp_10[0]+pp_10[1];
  endfunction
  
  function Vector#(2, Bit#(256)) fn_csa_256 (Bit#(256) x, Bit#(256) y,Bit#(256) z);
    Vector#(2, Bit#(256)) csa;
    csa[0] = x^y^z;
    csa[1] = ((x&y)|(y&z)|(z&x))<<1;
    return csa;
  endfunction
  
  function Bit#(256) fmul_csa128(Bit#(128) x, Bit#(128) y);
  
    Bit#(256) pp_0[128],pp_1[86],pp_2[56],pp_3[38],pp_4[26],pp_5[18],pp_6[12],pp_7[8],pp_8[6],pp_9[4],pp_10[3],pp_11[2];
  
    for (Integer i=0; i<128; i=i+1) begin
      pp_0[i] = zeroExtend(x&signExtend(y[i]))<<i;
      end
    for (Integer i=0; i<42; i=i+1) begin
      pp_1[2*i] = fn_csa_256(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[0];
      pp_1[2*i+1] = fn_csa_256(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[1];
      end
    pp_1[84]=pp_0[126];
    pp_1[85]=pp_0[127];
    for (Integer i=0; i<27; i=i+1) begin
      pp_2[2*i] = fn_csa_256(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[0];
      pp_2[2*i+1] = fn_csa_256(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[1];
      end
    pp_2[54]=pp_1[84];
    pp_2[55]=pp_1[85];
    for (Integer i=0; i<18; i=i+1) begin
      pp_3[2*i] = fn_csa_256(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[0];
      pp_3[2*i+1] = fn_csa_256(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[1];
      end
    pp_3[36]=pp_2[54];
    pp_3[37]=pp_2[55];
    for (Integer i=0; i<12; i=i+1) begin
      pp_4[2*i] = fn_csa_256(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[0];
      pp_4[2*i+1] = fn_csa_256(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[1];
      end
    pp_4[16]=pp_3[36];
    pp_4[17]=pp_3[37];
    for (Integer i=0; i<8; i=i+1) begin
      pp_5[2*i] = fn_csa_256(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[0];
      pp_5[2*i+1] = fn_csa_256(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[1];
      end
    for (Integer i=0; i<6; i=i+1) begin
      pp_6[2*i] = fn_csa_256(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[0];
      pp_6[2*i+1] = fn_csa_256(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[1];
      end
    for (Integer i=0; i<4; i=i+1) begin
      pp_7[2*i] = fn_csa_256(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[0];
      pp_7[2*i+1] = fn_csa_256(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[1];
      end
    for (Integer i=0; i<2; i=i+1) begin
      pp_8[2*i] = fn_csa_256(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[0];
      pp_8[2*i+1] = fn_csa_256(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[1];
      end
    pp_8[4]=pp_7[3];
    pp_8[5]=pp_7[4];
    for (Integer i=0; i<2; i=i+1) begin
      pp_9[2*i] = fn_csa_256(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[0];
      pp_9[2*i+1] = fn_csa_256(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[1];
      end
    pp_10[0]=fn_csa_256(pp_9[0],pp_9[1],pp_9[2])[0];
    pp_10[1]=fn_csa_256(pp_9[0],pp_9[1],pp_9[2])[1];
    pp_10[2]=pp_9[3];
    
    pp_11[0]=fn_csa_256(pp_10[0],pp_10[1],pp_10[2])[0];
    pp_11[1]=fn_csa_256(pp_10[0],pp_10[1],pp_10[2])[1];
    
    return pp_11[0]+pp_11[1];
  endfunction
  
  
  function Vector#(2, Bit#(512)) fn_csa_512 (Bit#(512) x, Bit#(512) y,Bit#(512) z);
    Vector#(2, Bit#(512)) csa;
    csa[0] = x^y^z;
    csa[1] = ((x&y)|(y&z)|(z&x))<<1;
    return csa;
  endfunction
  
  function Bit#(512) fmul_csa256(Bit#(256) x, Bit#(256) y);
  
    Bit#(512) pp_0[256],pp_1[171],pp_2[114],pp_3[76],pp_4[51],pp_5[34],pp_6[23],pp_7[16],pp_8[11],pp_9[8],pp_10[6],pp_11[4],pp_12[3],pp_13[2];
  
    for (Integer i=0; i<256; i=i+1) begin
      pp_0[i] = zeroExtend(x&signExtend(y[i]))<<i;
      end
    for (Integer i=0; i<85; i=i+1) begin
      pp_1[2*i] = fn_csa_512(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[0];
      pp_1[2*i+1] = fn_csa_512(pp_0[3*i],pp_0[3*i+1],pp_0[3*i+2])[1];
      end
    pp_1[170]=pp_0[255];
    for (Integer i=0; i<57; i=i+1) begin
      pp_2[2*i] = fn_csa_512(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[0];
      pp_2[2*i+1] = fn_csa_512(pp_1[3*i],pp_1[3*i+1],pp_1[3*i+2])[1];
      end
    for (Integer i=0; i<38; i=i+1) begin
      pp_3[2*i] = fn_csa_512(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[0];
      pp_3[2*i+1] = fn_csa_512(pp_2[3*i],pp_2[3*i+1],pp_2[3*i+2])[1];
      end
    for (Integer i=0; i<25; i=i+1) begin
      pp_4[2*i] = fn_csa_512(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[0];
      pp_4[2*i+1] = fn_csa_512(pp_3[3*i],pp_3[3*i+1],pp_3[3*i+2])[1];
      end
    pp_4[50]=pp_3[75];
    for (Integer i=0; i<17; i=i+1) begin
      pp_5[2*i] = fn_csa_512(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[0];
      pp_5[2*i+1] = fn_csa_512(pp_4[3*i],pp_4[3*i+1],pp_4[3*i+2])[1];
      end
    for (Integer i=0; i<11; i=i+1) begin
      pp_6[2*i] = fn_csa_512(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[0];
      pp_6[2*i+1] = fn_csa_512(pp_5[3*i],pp_5[3*i+1],pp_5[3*i+2])[1];
      end
    pp_6[22]=pp_5[33];
    for (Integer i=0; i<7; i=i+1) begin
      pp_7[2*i] = fn_csa_512(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[0];
      pp_7[2*i+1] = fn_csa_512(pp_6[3*i],pp_6[3*i+1],pp_6[3*i+2])[1];
      end
    pp_7[14]=pp_6[21];
    pp_7[15]=pp_6[22];
    for (Integer i=0; i<5; i=i+1) begin
      pp_8[2*i] = fn_csa_512(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[0];
      pp_8[2*i+1] = fn_csa_512(pp_7[3*i],pp_7[3*i+1],pp_7[3*i+2])[1];
      end
    pp_8[10]=pp_7[15];
    for (Integer i=0; i<3; i=i+1) begin
      pp_9[2*i] = fn_csa_512(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[0];
      pp_9[2*i+1] = fn_csa_512(pp_8[3*i],pp_8[3*i+1],pp_8[3*i+2])[1];
      end
    pp_9[6]=pp_8[9];
    pp_9[7]=pp_8[10];
    for (Integer i=0; i<2; i=i+1) begin
      pp_10[2*i] = fn_csa_512(pp_9[3*i],pp_9[3*i+1],pp_9[3*i+2])[0];
      pp_10[2*i+1] = fn_csa_512(pp_9[3*i],pp_9[3*i+1],pp_9[3*i+2])[1];
      end
    pp_10[4]=pp_9[6];
    pp_10[5]=pp_9[7];
    for (Integer i=0; i<2; i=i+1) begin
      pp_11[2*i] = fn_csa_512(pp_10[3*i],pp_10[3*i+1],pp_10[3*i+2])[0];
      pp_11[2*i+1] = fn_csa_512(pp_10[3*i],pp_10[3*i+1],pp_10[3*i+2])[1];
      end
    pp_12[0]=fn_csa_512(pp_11[0],pp_11[1],pp_11[2])[0];
    pp_12[1]=fn_csa_512(pp_11[0],pp_11[1],pp_11[2])[1];
    pp_12[2]=pp_11[3];
    pp_13[0]=fn_csa_512(pp_12[0],pp_12[1],pp_12[2])[0];
    pp_13[1]=fn_csa_512(pp_12[0],pp_12[1],pp_12[2])[1];
    
    return pp_13[0]+pp_13[1];
  endfunction
  
  

endpackage
