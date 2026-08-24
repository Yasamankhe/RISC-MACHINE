module datapath_tb();

reg [15:0]datapath_in;
reg clk , write,vsel, loada, loadb, asel, bsel, loadc, loads;
reg[2:0] writenum, readnum ;
reg[1:0] shift, ALUop; 



wire Z_out;
wire [15:0] datapath_out;

reg err ;

initial #500 $finish; 

datapath DUT (.clk(clk), .datapath_in(datapath_in),
.write(write), .vsel(vsel), .loada(loada), .loadb(loadb), .asel(asel), .bsel(bsel), .loadc(loadc), .loads(loads),
.readnum(readnum), .writenum(writenum),
.shift(shift), .ALUop(ALUop),
.datapath_out(datapath_out),
.Z_out(Z_out));

  wire [15:0] R0 = DUT.REGFILE.R0;
  wire [15:0] R1 = DUT.REGFILE.R1;
  wire [15:0] R2 = DUT.REGFILE.R2;
  wire [15:0] R3 = DUT.REGFILE.R3;
 wire [15:0] R4 = DUT.REGFILE.R4;
  wire [15:0] R5 = DUT.REGFILE.R5;
  wire [15:0] R6 = DUT.REGFILE.R6;
  wire [15:0] R7 = DUT.REGFILE.R7;

task my_checker;
	 
        input [15:0] out_expected;
        input Z_expected;
	begin
	   
	if(datapath_out != out_expected) begin
        $display ("Wrong got %b , expected %b",datapath_out,out_expected);
         err=1'b1 ;
	 
	end

        if(Z_out != Z_expected) begin
        $display ("Wrong got %b , expected %b",Z_out,Z_expected);
         err=1'b1;
	 
	end
	end
	endtask


initial begin 
clk=0; #5;
forever begin 
 clk =1 ; #5;
 clk =0 ; #5;
end 
end

initial begin
   
    DUT.A = 16'd0;
    DUT.in = 16'd0;
   
    DUT.datapath_out = 16'd0;
end

initial begin

		

err=1'b0;


    datapath_in = 0;
    write = 0; vsel=0; loada=0; loadb=0; asel=0; bsel=0; loadc=0; loads=0;
    readnum = 0; writenum=0;
    shift = 0; ALUop=0;

    #10; 

        
   
//MOV R0 #7

datapath_in = 16'd7; 
    writenum = 3'd0;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 
    write = 1'b0; // done set to zero

    //  if MOV was executed correctly
    if (R0 !== 16'd7) begin
      err = 1'b1; 
    end



// MOV R1 #2
    datapath_in = 16'd2; 
    writenum = 3'd1;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 
    write = 1'b0; // done set to zero

    //  if MOV was executed correctly
    if (R1 !== 16'd2) begin
      err = 1;     
    end   


    //Load R1 
readnum=3'd1;
loada=1'b1;
   #10;
loada=1'b0;

   //Load R0 
readnum=3'd0;
loadb=1'b1;
   #10;
loadb=1'b0;


  shift=2'b01;  //LSL
  asel=1'b0;
  bsel=1'b0;

 // Addition

   ALUop=2'b00;
   loadc=1'b1;
   loads=1'b1;
#10;
 loadc=1'b0;
   loads=1'b0;

//R2 =16

writenum = 3'd2;
    write = 1'b1;
    #10; // wait for clock 
    write = 1'b0; // done set to zero
readnum=3'd2 ;


my_checker(16'd16,1'b0);


    

end // initial




endmodule :datapath_tb
