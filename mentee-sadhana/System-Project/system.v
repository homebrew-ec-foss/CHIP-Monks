//Mux
module mux2 ( input wire [7:0] A, input wire [7:0] B, input wire sel, output wire [7:0] y);
    assign y = sel ? b : a; // if sel is high, y=B else y=A
endmodule

//Register
module regfile2 ( input wire clk, input wire rst_n, input wire w, input wire reg_sel, input wire [7:0]  data_in, output wire [7:0] ra, output wire [7:0] rb );

    reg [7:0] reg0;
    reg [7:0] reg1;

    always @(posedge clk or negedge rst_n) begin // reacts to positive edge of clock and negative edge of rst_n 
    
        if (!rst_n) begin // Asynchronous reset of reg0 and reg1 to 0
            reg0 <= 8'b0; 
            reg1 <= 8'b0; 
        end 
        else if (w) begin // Synchronous write reg0
            if (reg_sel == 1'b0) begin 
                reg0 <= data_in;
            end 
            else begin // Write reg1
                reg1 <= data_in;
            end
        end
    end

    assign ra = reg0;
    assign rb = reg1;

endmodule

// ALU
module alu3 ( input wire [7:0]  operand_a, input wire [7:0]  operand_b, input wire [1:0]  opcode, output reg [7:0]  result );

    //re-evaluate logic when input changes
    always @(*) begin
        case (opcode)
            2'b00: begin // ADD
                result = operand_a + operand_b;
            end
            
            2'b01: begin // SUBTRACT
                result = operand_a - operand_b;
            end
            
            2'b10: begin // AND
                result = operand_a & operand_b;
            end
            
            2'b11: begin // XOR
                result = operand_a ^ operand_b;
            end
        endcase
end
endmodule

