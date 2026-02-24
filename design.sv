// Code your design here
module alu #(parameter V=8)
  (input init,
                            input [3:0]opco,
                            input [V-1:0]a,
                            input [V-1:0]b,
                            output reg [15:0]deco,
   
                            output reg [V-1:0]add,
                            output reg [V-1:0]sub,
                            output reg [15:0]mul,
                            output reg [V-1:0]div,
   
                            output reg [V-1:0]andd,
                            output reg [V-1:0] orr,
                            output reg [V-1:0] nott,
                            output reg [V-1:0]nandd,
                            output reg [V-1:0]norr,
                            output reg [V-1:0]xorr,
   
                            output reg [V-1:0]refresh,
   
                            output reg [V-1:0]comp,
   
                            output reg [V-1:0] sh_result,
                            output reg [V-1:0]ro_result,
                            output reg [V-1:0]s,
   
                            output reg [V-1:0] ccin,
   
                            output reg [3:0] cc,
                            output reg xs3tens_bit,
                            output reg xs5tens_bit,
                            output reg bcdtens_bit,
                            output reg [4:0]rfetch,
                            output reg [15:0] out,
               output reg carryflag,logflag,zeroflag,shiftflag,doneflag);
  reg [8:0] temp_sum;
   wire s1,s2;
  reg [V-1:0] shl,shr,shll,shrr,rol,ror,roll,rorr;
  reg [V-1:0] g,xs3,xs5,bcd;
   reg arth_flag, logi_flag, comp_flag, shft_flag, code_flag;
 always@(*)
    begin
      if (!init) begin   
        deco       = 16'b0;
        add        = 8'b0;
        sub        = 8'b0;
        mul        = 16'b0;
        div        = 16'b0;
        andd       = 8'b0;
        orr        = 8'b0;
        nott       = 8'b0;
        nandd      = 8'b0;
        norr       = 8'b0;
        xorr       = 8'b0;
        refresh    = 8'b0;
        carryflag=1'b0;
        logflag=1'b0;
    end
      else begin
     case(opco)
       4'b0000: begin
         deco=16'b0000000000000000;
       end
        4'b0001:begin
          deco=16'b0000000000000001;
          temp_sum= a + b;          
          add = temp_sum[7:0]; 
          carryflag = temp_sum[8];  
        end
        4'b0010:begin
          deco=16'b0000000000000010;
          sub=a-b;
          carryflag=(a<b)?1'b1:1'b0;
        end
          4'b0011:begin
            deco=16'b0000000000000100;
            mul=a*b;
            carryflag=(mul>16'hffff)?1'b1:1'b0;
          end
            4'b0100:begin
              deco=16'b0000000000001000;
              if(b==0)begin
              div=8'b0;
              carryflag=1'b1;
              end
             else begin
              div=a/b;
              carryflag=1'b0; 
              end
            end
        4'b0101:begin
          deco=16'b0000000000010000;
          andd=a&b;
          logflag=1'b1;
        end
        4'b0110:begin
        deco=16'b0000000000100000;
        orr=a|b;
        logflag=1'b1;
        end
        4'b0111:begin
          deco=16'b0000000001000000;
          nott=~a;
          logflag=1'b1;
        end
        4'b1000:begin
          deco=16'b0000000010000000;
          nandd=~(a & b);
          logflag=1'b1;
        end
        4'b1001:begin
          deco=16'b0000000100000000;
          norr=~(a | b);
          logflag=1'b1;
        end
        4'b1010:begin
          deco=16'b0000001000000000;
          xorr=a^b;
          logflag=1'b1;
        end
       4'b1011: begin
        deco=16'b0000010000000000;
        carryflag=1'b0;
        logflag=1'b0;
         refresh=8'b00000000;
      end
     default:begin
        deco=16'b0000000000000000;
         carryflag=1'b0;
          logflag=1'b0;
       refresh=8'b00000000;
      end
      endcase
      end
      end  
assign s1=a>b;
assign s2=a<b;
 always @(*) begin
   if (!init) begin
     deco=16'b0;
     comp=8'b00000000;
     carryflag=1'b0;
     zeroflag=1'b0;
   end
   else begin
     if(opco == 4'b1100)begin
    case (opco)
        4'b1100: begin
        deco = 16'b0000100000000000;
          if ({s1,s2}==2'b00) begin
                comp = 8'b0;
                carryflag  = 1'b0;
                zeroflag   = 1'b1;
            end 
          else if (s1==1) begin
                comp  = 8'b10000000; 
                carryflag  = 1'b0;
                zeroflag   = 1'b0;
            end 
          else if(s2==1)begin
                comp   = 8'b00000001; 
                carryflag  = 1'b1;
                zeroflag   = 1'b0;
            end
        end

        default: begin
            deco      = 16'b0000000000000000;
            carryflag = 1'b0;
            zeroflag=1'b0;
        end
    endcase
   end
   end
 end
  always @(*) begin
    if(!init) begin
    shl        = 8'b0;
    shr        = 8'b0;
    shll       = 8'b0;
    shrr       = 8'b0;
    rol        = 8'b0;
    ror        = 8'b0;
    roll       = 8'b0;
    rorr       = 8'b0;
    sh_result  = 8'b0;
    ro_result  = 8'b0;
    s          = 8'b0;
    shiftflag  = 1'b0;
    end
    else begin
      case(opco) 
        4'b1101: begin
      deco = 16'b0001_0000_0000_0000;
      if (!b[0]) begin
        shl = a << 1;       
        shiftflag = 1'b1;
      end
      if (!b[1]) begin
        shr = a >> 1;        
        shiftflag = 1'b1;
      end
      if (!b[2]) begin
        shll = a << b[3:0];    
        shiftflag = 1'b1;
      end
      if (!b[3]) begin
        shrr = a >> b[3:0];    
        shiftflag = 1'b1;
      end
      sh_result = shl | shr | shll | shrr;

   if (!b[4]) begin
     rol = {a[6:0], a[7]}; 
   //  rol = (A << 1) | (A >> (N - 1))
     shiftflag = 1'b1;
      end
   if (!b[5]) begin
     ror = {a[0], a[7:1]};
     shiftflag = 1'b1;
      end
   if (!b[6]) begin
     roll = (a << (b[7:4]&3'b111)) | (a >> (8 - (b[7:4]&3'b111)));                
      shiftflag = 1'b1;
      end
      if (!b[7]) begin
        rorr = (a >> (b[7:4]&3'b111)) | (a << (8 - (b[7:4]&3'b111)));        
        shiftflag = 1'b1;
      end
    ro_result = rol | ror | roll | rorr;
    s = sh_result | ro_result;
    end
      endcase
  end
  end
  always@(*) begin
     if(!init) begin
       ccin=8'b0;
     end
  else begin
     if(shiftflag)
            ccin=s;
          else
            ccin=b;
        end
     end
 always @(*) begin
        if (!init) begin
            cc        = 4'b0000;
            xs3tens_bit  = 1'b0;
            xs5tens_bit=1'b0;
            bcdtens_bit=1'b0;
            doneflag  = 1'b0;
            deco      = 16'b0;
            g         = 4'b0;
            xs3       = 4'b0;
            xs5       = 4'b0;
            bcd       = 4'b0;
        end
        else begin
          case (opco)
                4'b1110: begin
                    deco = 16'b0010_0000_0000_0000;  
                    if (!ccin[0]) begin
                        g[3] = ccin[7];
                        g[2] = ccin[7] ^ ccin[6];
                        g[1] = ccin[6] ^ ccin[5];
                        g[0] = ccin[5] ^ ccin[4];
                        doneflag = 1'b1;
                    end
                 if (!ccin[1]) begin
                   if(ccin[7:4] <10)begin
                     xs3 = ccin[7:4] + 4'b0011;  
                       xs3tens_bit=0;
                     doneflag=1;
                   end
                   else begin
                    // xs3ones_bits=cccin[7:4]%10;
                     xs3=((ccin[7:4]%10)+4'b0011);
                     xs3tens_bit=1;
                     doneflag = 1'b1;
                   end
                    end
                if (!ccin[2]) begin
                  if(ccin[7:4] <10)begin
                    xs5 = ccin[7:4] + 4'b0101;
                        xs5tens_bit=0;
                        doneflag = 1'b1;
                  end
                  else begin
                     //xs5ones_bits=ccin[7:4]%10;
                    xs5=((ccin[7:4]%10)+4'b0101);
                     xs5tens_bit=1;
                     doneflag = 1'b1;
                  end
                    end
                 if (!ccin[3]) begin
                   if (ccin[7:4] < 4'b1001) begin
                            bcd = ccin[7:4];
                            bcdtens_bit = 1'b0;
                        end 
                        else begin
                            bcd = ccin[7:4] - 4'b1010;
                            bcdtens_bit = 1'b1;
                        end
                        doneflag = 1'b1;
                    end
                     cc = g | xs3 | xs5 | bcd;
                end
                default: begin
                   xs3tens_bit=1'b0;
                  xs5tens_bit=1'b0;
                    bcdtens_bit  = 1'b0;
                    doneflag  = 1'b0;
                end
            endcase
        end
    end
always@(*) begin
    if(!init) begin
      deco=16'b0;
    arth_flag=1'b0;
    logi_flag=1'b0;
    comp_flag=1'b0;
    shft_flag=1'b0;
    code_flag=1'b0;
      rfetch=5'b0;
    end
    else begin
    case(opco)
        4'b1111: begin
       deco = 16'b0100_0000_0000_0000; 

   arth_flag=(add != 0 || sub != 0 || mul != 0 || div != 0) ? 1'b1 : 1'b0;
   logi_flag=(andd != 0 || orr != 0 || nott != 0 || nandd != 0 || norr != 0 || xorr != 0) ? 1'b1 : 1'b0;
   comp_flag=(comp != 0)?1'b1:1'b0;
   shft_flag=(s != 0)?1'b1:1'b0;
   code_flag=(cc != 0)?1'b1:1'b0;
   rfetch = {arth_flag, logi_flag, comp_flag, shft_flag, code_flag};
end
      default: begin
      rfetch=5'b00000;
      end
    endcase
  end
  end
always@(*)
    begin
      if(!init) begin
        out=16'b0;
      end
      else begin
      case(opco)
        4'b0000: begin
          out=16'b0000000000000000;
        end
        4'b0001: begin
          out=add;
        end
        4'b0010: begin
          out=sub;
        end
        4'b0011: begin
          out=mul;
        end
        4'b0100: begin
          out=div;
        end
        4'b0101: begin
          out=andd;
        end
        4'b0110: begin
          out=orr;
        end
        4'b0111: begin
          out=nott;
        end
          4'b1000: begin
            out=nandd;
          end
        4'b1001: begin
          out=norr;
        end
        4'b1010: begin
          out=xorr;
        end
        4'b1011: begin
          out=refresh;
        end
        4'b1100: begin
          out=comp;
        end
        4'b1101: begin
          out=s;
        end
       
        4'b1110: begin
          out=cc;
        end
        4'b1111: begin
          out=rfetch;
        end
        default: begin
          out=16'b0000000000000000;
        end
      endcase
    end
    end
endmodule
