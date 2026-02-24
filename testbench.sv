// Code your testbench here
// or browse Examples
module tb();
  reg init;
  reg [3:0]opco;
  reg [7:0]a;
  reg [7:0]b;
  wire [15:0]deco;
  wire [7:0]add;
  wire [7:0]sub;
  wire [15:0]mul;
  wire [7:0]div;
  wire [7:0]andd;
  wire [7:0]orr;
  wire [7:0]nott;
  wire [7:0]nandd;
  wire [7:0]norr;
  wire [7:0]xorr;
  wire [7:0] refresh;
  wire [7:0]comp; 
  wire [7:0] sh_result;
  wire [7:0] ro_result;
  wire [7:0] s;
    wire [7:0]ccin;
  wire [3:0]cc;
  wire [4:0] rfetch;
  wire [15:0] out;
wire carryflag,logflag,zeroflag,shiftflag,doneflag;
  wire [8:0] temp_sum;
    wire [7:0] shl,shr,shll,shrr,rol,ror,roll,rorr;
   wire [7:0] g,xs3,xs5,bcd;
  wire xs3tens_bit,xs5tens_bit,bcdtens_bit;
  wire arth_flag, logi_flag, comp_flag, shft_flag, code_flag;
  alu uut(init,opco,a,b,deco,add,sub,mul,div,andd,orr,nott,nandd,norr,xorr,refresh,comp,sh_result,ro_result,s,ccin,cc,xs3tens_bit,xs5tens_bit,bcdtens_bit,rfetch,out,carryflag,logflag,zeroflag,shiftflag,doneflag);
  initial begin
       $dumpfile("waveform.vcd");
    $dumpvars(0, tb);
    
     init=1'b0;
    #5
  a = 8'b11100010;  
  b = 8'b10001100;
    init=1'b1;
  // a=8'b10001000;
 //  b=8'b10001000;
 //  a=8'b01000110;
 //   b=8'b11100000;
 
    #5;
    opco=4'b0000;
    #5;
    opco=4'b0001;
    #5;
    opco=4'b0010;
    #5;
    opco=4'b0011;
    #5;
    opco=4'b0100;
     #5;
    opco=4'b0101;
    #5;
    opco=4'b0110;
    #5;
    opco=4'b0111;
    #5;
    opco=4'b1000;
    #5;
    opco=4'b1001;
    #5;
    opco=4'b1010;
     #5;
    opco=4'b1011;
    #5;
    opco=4'b1100;
    #5;
    opco=4'b1101;
    #5;
    opco=4'b1110;
    #5;
    opco=4'b1111;
    #5;
     $finish();
  end
  initial 
    $monitor("init=%b opco=%b a=%b b=%b deco=%b add=%b sub=%b mul=%b div=%b andd=%b orr=%b nott=%b nandd=%b norr=%b xorr=%b refresh=%b comp=%b sh_result=%b ro_result=%b s=%b ccin=%b cc=%b xs3tens_bit=%b xs5tens_bit=%b bcdtens_bit=%b rfetch=%b out=%b carryflag=%b logflag=%b zeroflag=%b shiftflag=%b doneflag=%b",init,opco,a,b,deco,add,sub,mul,div,andd,orr,nott,nandd,norr,xorr,refresh,comp,sh_result,ro_result,s,ccin,cc,xs3tens_bit,xs5tens_bit,bcdtens_bit,rfetch,out,carryflag,logflag,zeroflag,shiftflag,doneflag);
endmodule