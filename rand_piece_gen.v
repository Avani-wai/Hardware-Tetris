module rand_piece_gen (
    input wire clk,
    input wire rst,
    output reg [2:0] rand_piece = 3'b100 
);

    wire [2:0] reset_value = 3'b101;

    always @(posedge clk) begin
        if (rst) begin
            rand_piece <= reset_value;
        end 
        else begin
            rand_piece[2] <= rand_piece[1];
            rand_piece[1] <= rand_piece[0];
            rand_piece[0] <= rand_piece[2] ^ rand_piece[0];
        end
    end
endmodule