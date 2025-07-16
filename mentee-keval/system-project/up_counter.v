module up_counter(
    input wire clk,
    input wire reset,
    input wire slow_clk,
    output wire [3:0] val,
    output wire [6:0] seg
);
	
    reg [3:0] count = 0;
    assign val = count;

    mux u0 (.val(count), .seg(seg));

    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;
        else if (slow_clk)
            count <= (count == 4'd15) ? 4'd0 : count + 1;
    end
    
endmodule
