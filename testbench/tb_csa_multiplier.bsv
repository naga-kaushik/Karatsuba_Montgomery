package tb_csa_multiplier;
  import csa_multiplier ::*;
  import Randomizable ::*;
  
  module mk_tb_csa_multiplier();
    
    Reg#(Bit#(32)) cycle <- mkReg(0);
    Reg#(Bit#(32)) count <- mkReg(0);
    Reg#(Bit#(32)) feed <- mkReg(0);
    Reg#(Bit#(256)) rand1 <- mkReg(0);
    Reg#(Bit#(256)) rand2 <- mkReg(0);
    Reg#(Bit#(512)) prod <- mkReg(0);
    Reg#(Bit#(512)) prod1 <- mkReg(0);
    
    Ifc_csa_multiplier ifc <- mk_csa_multiplier_256();
    
    Randomize#(Bit#(256)) rand_in1 <- mkConstrainedRandomizer(256'd0,256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    Randomize#(Bit#(256)) rand_in2 <- mkConstrainedRandomizer(256'd0,256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    
    rule init(feed == 0);            //initializing the 2 random values
      rand_in1.cntrl.init();
      rand_in2.cntrl.init();
      feed <= 1;
    endrule
    
    rule rl_stage1(feed==1);              //feeding random inputs in MUL mode to both baseline multiplier and pipelined version
      let a <- rand_in1.next();
      let b <- rand_in2.next();
      rand1 <= a;
      rand2 <= b;
      prod <= zeroExtend(rand1)*zeroExtend(rand2);
      prod1 <= prod;
      ifc.send(rand1,rand2);
    endrule
    
    rule rl_recieve;
      match .out = ifc.receive();
      //$display(out,prod1);
      if (out != prod1) count <= count + 1 ;
    endrule
    
    rule cycling;          //generating cycles
      cycle <= cycle +1;
      if (cycle == 6) $display(count);
      if(cycle>7)
          $finish(0);
    endrule
  endmodule
  
endpackage
