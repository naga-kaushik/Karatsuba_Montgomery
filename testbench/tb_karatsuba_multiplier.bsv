package tb_karatsuba_multiplier;
  import karatsuba_multiplier_128 ::*;
  import Randomizable ::*;
  
  module mk_tb_karatsuba_multiplier();
    
    Reg#(Bit#(32)) cycle <- mkReg(0);
    Reg#(Bit#(32)) count <- mkReg(0);
    Reg#(Bit#(32)) feed <- mkReg(0);
    Reg#(Bit#(128)) rand1 <- mkReg(0);
    Reg#(Bit#(128)) rand2 <- mkReg(0);
    Reg#(Bit#(256)) prod <- mkReg(0);
    Reg#(Bit#(256)) prod1 <- mkReg(0);
    Reg#(Bit#(256)) prod2 <- mkReg(0);
    Reg#(Bit#(256)) prod3 <- mkReg(0);
    Reg#(Bit#(256)) prod4 <- mkReg(0);
    Reg#(Bit#(256)) prod5 <- mkReg(0);
    Reg#(Bit#(256)) prod6 <- mkReg(0);
    
    Ifc_karatsuba_multiplier ifc <- mk_karatsuba_multiplier_128();
    
    Randomize#(Bit#(128)) rand_in1 <- mkConstrainedRandomizer(128'd0,128'hffffffffffffffffffffffffffffffff);
    Randomize#(Bit#(128)) rand_in2 <- mkConstrainedRandomizer(128'd0,128'hffffffffffffffffffffffffffffffff);
    
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
      prod2 <= prod1;
      prod3 <= prod2;
      prod4 <= prod3;
      prod5 <= prod4;
      prod6 <= prod5;
      ifc.send(rand1,rand2);
    endrule
    
    rule rl_recieve;
      match .out = ifc.receive();
      //$display(out,prod1);
      if (out != prod6) count <= count + 1 ;
    endrule
    
    rule cycling;          //generating cycles
      cycle <= cycle +1;
      if (cycle == 19999) $display(count);
      if(cycle>20000)
          $finish(0);
    endrule
  endmodule
  
endpackage
