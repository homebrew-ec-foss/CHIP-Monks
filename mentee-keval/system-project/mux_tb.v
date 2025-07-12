module mux_tb;
	reg [3:0]	val;
	wire [6:0]	seg;
	integer		i;
	
	mux DUT (.val(val), .seg(seg));
	
	initial begin
		for (i = 0; i < 20;i = i + 1) begin
			val = i;
			$display("val=%d seg=%b",val,seg);
			#10;
		end

		#10 $finish;
	end
endmodule
