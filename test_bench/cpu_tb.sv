module cpu_tb;
	reg clk, reset, s, load;
	reg [15:0] in;
	wire [15:0] out;
	wire N, V, Z, w;

	reg err = 0;

	cpu DUT(.clk(clk),.reset(reset),.s(s),.load(load),.in(in),.out(out),.N(N),.V(V),.Z(Z),.w(w));


initial begin
clk = 0; #5;
forever begin
clk = 1; #5;
clk = 0; #5;
end
end

task load_and_s;
    begin
        load = 1;
        #10;
        load = 0;
        #5;
        // Start s
        s = 1;
        #10;
        s = 0;
    end
endtask
	
 initial begin
        err = 0;
        reset = 1; s = 0; load = 0; in = 16'b0;
        #15; 
        reset = 0; 
        #10;

        // Test MOV R0, #3
        in = 16'b110_10_000_000_00_011;
        load_and_s;
        @(posedge w); // Wait for positive edge of w
        #20;
        if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'd3) begin
            err = 1;

        end

  @(negedge clk); //middle //first //last
    in = 16'b11010_001_000_00_010;
    load_and_s;
    @(posedge w); 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd2) begin
      err = 1;

     
    end

    @(negedge clk); //middle //first //last
    in = 16'b101_00_001_010_01_000;
   load_and_s;
    @(posedge w); 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd8) begin
      err = 1;

    end

@(negedge clk); //middle //first //last
    in = 16'b110_10_011_000_00_111;
   load_and_s;
    @(posedge w); 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'd7) begin
      err = 1;

      
    end

@(negedge clk); //middle //first //last
    in = 16'b110_10_100_000_00_001;
   load_and_s;
    @(posedge w); 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd1) begin
      err = 1;
      
    end


 @(negedge clk); //middle //first //last
    in = 16'b101_10_100_101_00_011;
   load_and_s;
    @(posedge w); 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== 16'd1) begin
      err = 1;
      
    end


@(negedge clk);
       in = 16'b101_11_010_011_00_010; // MVN R3, R2
        load_and_s;
        @(posedge w); // Wait for positive edge of w
        #20;
        if (cpu_tb.DUT.DP.REGFILE.R3 !== ~cpu_tb.DUT.DP.REGFILE.R2) begin
            err = 1;
            
        end


 

@(negedge clk);
in = 16'b101_11_001_111_01_001; // MVN R7, R1, LSL #1
        load_and_s;
        @(posedge w); // Wait for positive edge of w
        #20;
        if (cpu_tb.DUT.DP.REGFILE.R7 !== ~(cpu_tb.DUT.DP.REGFILE.R1 << 1)) begin
            err = 1;
            
        end


     @(negedge clk);   
        in = 16'b101_01_001_000_00_010; // CMP R1, R2  r1=2 r2=8s
        load_and_s;
        @(posedge w); // Wait for positive edge of w
        #20;
        if (N !== 1) begin
            err = 1;
            
        end

@(negedge clk); 
in = 16'b101_01_000_000_00_000; // CMP R0, R0
        load_and_s;
        @(posedge w); 
        #20;
        if (Z !== 1) begin
            err = 1;
            
     end
 
    $stop;
  end
endmodule
