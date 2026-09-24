module piece_buffer (
    input  wire       rst,
    input  wire       clk,
    input  wire [2:0] rand_piece,
    input  wire       spawn_pulse,
    input  wire       btn_press_proc_swap,

    output reg  [2:0] active_piece,
    output reg  [2:0] next_piece,
    output reg  [2:0] hold_piece,
    output reg        hold_empty,
    output reg        hold_lock
);

    // Piece IDs are 3 bits: 1..7, with 0 used as "empty/not valid"
    // This module assumes a piece lock triggers a spawn, and a hold/swap
    // is only allowed once until the next spawn.

    always @(posedge clk) begin
        if (rst) begin
            active_piece <= 3'd0;
            next_piece   <= 3'd0;   // or set to rand_piece if you want immediate random init
            hold_piece   <= 3'd0;
            hold_empty   <= 1'b1;
            hold_lock    <= 1'b0;
        end
        else if (spawn_pulse) begin
            // A locked piece is replaced by the stored next piece
            active_piece <= next_piece;
            next_piece   <= rand_piece;
            hold_lock    <= 1'b0;   // allow another hold swap after a new piece spawns
        end
        else if (btn_press_proc_swap && !hold_lock) begin
            if (hold_empty) begin
                // First hold: save the active piece, then bring in the next piece
                hold_piece   <= active_piece;
                active_piece <= next_piece;
                next_piece   <= rand_piece;
                hold_empty   <= 1'b0;
                hold_lock    <= 1'b1;
            end
            else begin
                // Swap active piece with held piece
                hold_piece   <= active_piece;
                active_piece <= hold_piece;
                hold_lock    <= 1'b1;
            end
        end
    end

endmodule
