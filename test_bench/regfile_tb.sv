`define sw 3
`define s0 3'b000
`define s1 3'b001
`define s2 3'b010
`define s3 3'b011
`define s4 3'b100
`define s5 3'b101
`define s6 3'b110
`define s7 3'b111

module regfile_tb();

reg [15:0] data_in_tb;  // when we are writing // should this also be a wire ??
reg [2:0] writenum_tb, readnum_tb;  // choose our registers to write in or read from 8=2^3 so only 3 bits // location
reg write_tb, clk_tb;  // write  is our load here if it's 1 the load input of writenum (index of our chosen register) will be set to one 
wire [15:0] data_out_tb; // when we are reading 

reg  err ;

initial #500 $finish;  // what is the exact unit ????
 
regfile DUT (.data_in(data_in_tb),.writenum(writenum_tb),.readnum(readnum_tb), .write(write_tb), .clk(clk_tb),.data_out(data_out_tb));
 
initial begin 
clk_tb=0; #5;
forever begin 
clk_tb=1 ; #5;
clk_tb=0 ;  #5;
end 
end


task my_checker ;
 

input[15:0] expected_data_in;

begin
 
if(data_out_tb !== expected_data_in) begin
$display("wrong! data_ output is %b , expected %b" ,data_out_tb,expected_data_in);
err=1'b1 ;
end
end
endtask


initial begin 


err=1'b0 ;

#5;
data_in_tb=16'b0000_0000_0000_0000;
writenum_tb=`s0 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s0 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0010_0000_0000_0000;
writenum_tb=`s0 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s0 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0000_0000_0000_1010;
writenum_tb=`s1 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s1 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0000_0000_1111_0000;
writenum_tb=`s2 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s2 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0000_0000_0000_0000;
writenum_tb=`s3 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s3 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b1111_0000_0000_0000;
writenum_tb=`s4 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s4 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0000_1010_0000_0000;
writenum_tb=`s5 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s5 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0100_0011_0000_0110;
writenum_tb=`s6 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s6 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0111_0000_0000_1110;
writenum_tb=`s7 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s7 ;
#10;
my_checker(data_in_tb);


#5;
data_in_tb=16'b0111_0000_0000_0010;
writenum_tb=`s1 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s1 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0111_0110_0000_0000;
writenum_tb=`s7 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s7 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b0111_0000_0000_0110;
writenum_tb=`s5 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s5 ;
#10;
my_checker(data_in_tb);



#5;
data_in_tb=16'b1111_1111_1111_1111;
writenum_tb=`s0 ;
write_tb=1'b1;
#10;
write_tb=1'b0;
#10;
readnum_tb=`s0 ;
#10;
my_checker(data_in_tb);








end

endmodule : regfile_tb