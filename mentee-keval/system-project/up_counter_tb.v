module up_counter_tb;
	reg		clk = 0; // please initiate it
	reg		slow_clk;
	reg 		reset;
	wire [3:0]	val;
	wire [6:0]	seg;
	
	up_counter DUT (.clk(clk),
			.reset(reset),
			.slow_clk(slow_clk),
			.val(val),
			.seg(seg));
	
	always #5 clk = ~clk; 

	initial begin 
		$display ("time clk slowclock reset  val      seg");
		$monitor ("%0t\t%b\t%b\t%b\t%h\t%b",$time,clk,slow_clk,reset,val,seg);
		
		#10 reset = 0;
		
		repeat (20) begin
			#5 slow_clk = 1;
			#15 slow_clk = 0;
		end
	#50 $finish;
	end
endmodule
