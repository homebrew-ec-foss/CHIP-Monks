module chip8_display (
    input wire clk,
    input wire reset,	//Collision
    input wire draw,    // Process sprite data
    input wire [5:0] x, 
    input wire [4:0] y,
    input wire [3:0] row_index,
    input wire [7:0] sprite_data,
    input wire [2047:0] display_in,
    output reg  [2047:0] display_out,
    output reg collision  
);

    reg [2047:0] next_display;
    reg collision_next;
    reg [5:0] wrapped_x;
    reg [4:0] wrapped_y;
    reg [10:0] pixel_index;
    reg current_pixel;
    reg new_pixel;

    // Drawing and collision detection
    always @(*) begin
        next_display = display_in;
        collision_next = 1'b0;

        if (draw) begin
            for (integer i = 0; i < 8; i = i + 1) begin
                if (sprite_data[7-i] == 1'b1) begin
                    wrapped_x = (x + i) % 64;
                    wrapped_y = (y + row_index) % 32;

                    pixel_index = wrapped_y * 64 + wrapped_x;
                    current_pixel = display_in[pixel_index];
                    new_pixel = current_pixel ^ 1'b1;

                    // Collision detection
                    if (current_pixel == 1'b1 && new_pixel == 1'b0) begin
                        collision_next = 1'b1;
                    end

                    next_display[pixel_index] = new_pixel;
                end
            end
        end
    end

    // Update state
    always @(posedge clk) begin
        if (reset) begin
            display_out <= 2048'b0;
            collision <= 1'b0;
        end 
        else if (draw) begin
            display_out <= next_display;
            collision <= collision_next;
        end
    end
endmodule
