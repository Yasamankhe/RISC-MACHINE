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


// how the code should work :

//                        TO WRITE
//1.Suppose we want ?j? to have the value 42 before we start executing our code. 
//2.To put 42 in R3 you would place the 16-bit value 0000000000101010 (binary for 42) on data_in,
//3. set the 3-bit input writenum to 011 (binary for 3), 
//4.set write to 1 to indicate we wish to save, or write, the value 42 into location 3 in theregister file, and input a rising edge on clk.

// This causes, the output of the upper 3:8 decoder to be driven to
//00001000. Each output bit of the decoder is AND?ed with write. As write is 1, the load input to R3 is set
//to 1. On the rising edge of clk 0000000000101010 will be copied to the 16-bit Q output of R3

//                        TO READ
//To read, the value of ?j?, which is in R3, we set the 3-bit bus readnum to 011. The 8-bit output of the
//lower 3:8 decoder will be 00001000 and this will cause the 8-input one-hot select mux to copy the value of
//R3 to data_out.


//This register file has two ports: one write port and one read port.  // 2 always block  only one clock dependant  


// The read is combinational: whenever readnum changes, the value from the indicated register is driven out of the register file after some combinational delay.
//THE REGISTER READS ARE NOT COORDINATED TO THE CLOCK! 


//The register write, however, is coordinated to the clock. At each rising clock edge, 
//if write is 1, the value on the 16-bit register file input data_in is written into the register indicated by the value on writenum. 

//This write only happens on the rising clock edge. 
//If,at the clock edge, write is 0, no register is updated. 

//To be compatible with the autograder, your register file must contain signals named R0, R1, R2, R3, R4, R5, R6, R7







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
