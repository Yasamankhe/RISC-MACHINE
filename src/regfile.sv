`define sw 3
`define s0 3'b000
`define s1 3'b001
`define s2 3'b010
`define s3 3'b011
`define s4 3'b100
`define s5 3'b101
`define s6 3'b110
`define s7 3'b111
///
module regfile(data_in,writenum,write,readnum,clk,data_out);
input [15:0] data_in;  // when we are writing
input [2:0] writenum, readnum;  // choose our registers to write in or read from 8=2^3 so only 3 bits // location
input write, clk;  // write  is our load here if it's 1 the load input of writenum (index of our chosen register) will be set to one 
output [15:0] data_out; // when we are reading 







reg [15:0] R0, R1,R2,R3,R4,R5,R6,R7,data_out,data_in;

        always @(*)  begin// for read we won't be needing a clock
         case (readnum)
         `s0 : data_out= R0;
         `s1 : data_out= R1;
         `s2 : data_out= R2;
         `s3 : data_out= R3;
         `s4 : data_out= R4;
         `s5 : data_out= R5;
         `s6 : data_out= R6;
         `s7 : data_out= R7;
      default: data_out =16'bxxxxxxxxxxxxxxxx ; // maybe there is a better way ??!!
    endcase
  end //always

//QUESTION : should I use not gate for clock like we did in lab 3 or not ??

//QUESTION : should data inalso be reg ?


 always_ff @(posedge clk)  begin// for write we are gonna deal with a ff that's why we need the clk

//if(~write) begin  // if wroite is zero all 8 enable signals are zero no regsiter is updated okk am i following this or not ?
// R0=16'b0000_0000_0000_0000 ;
// R1=16'b0000_0000_0000_0000 ;
// R2=16'b0000_0000_0000_0000 ;
// R3=16'b0000_0000_0000_0000 ;
// R4=16'b0000_0000_0000_0000 ;
// R5=16'b0000_0000_0000_0000 ;
// R6=16'b0000_0000_0000_0000 ;
// R7=16'b0000_0000_0000_0000 ;
//
//end //if
//  
//else begin 

if (write) begin
 case (writenum)   
         `s0 : R0 = data_in;
         `s1 : R1 = data_in; 
         `s2 : R2 = data_in;
         `s3 : R3 = data_in;
         `s4 : R4 = data_in;
         `s5 : R5 = data_in;
         `s6 : R6 = data_in;
         `s7 : R7 = data_in;
      //default:   // ask not sure
   
    endcase   
end // if
end //always


endmodule
