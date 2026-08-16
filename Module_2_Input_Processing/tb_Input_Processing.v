`timescale 1ns / 1ps

module tb_Input_Processing();
    reg clk;
    reg rst;
    reg [4:0] btn_press_raw;
    wire [4:0] btn_press_proc;
    Input_Processing uut (
        .clk(clk),
        .rst(rst),
        .btn_press_raw(btn_press_raw),
        .btn_press_proc(btn_press_proc)
    );

    // 1. Generate 25.175 MHz Clock (~39.72 ns period)
    // Toggle every 19.86 ns
    always #19.86 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btn_press_raw = 5'b00000;

        // Hold reset for 100 ns, then release
        #100;
        rst = 0;
        #50;

        // --- TEST 1: Glitch / Bounce Test (Button 0) ---
        // Rapid toggling to simulate mechanical contact bounce (< 20 ms)
        $display("[%0t ns] Test 1: Simulating Mechanical Bounce...", $time);
        btn_press_raw[0] = 1; #1000;  // High for 1 us
        btn_press_raw[0] = 0; #500;   // Drops back down (glitch!)
        btn_press_raw[0] = 1; #2000;  // High again
        btn_press_raw[0] = 0; #100;   // Drops back down
        
        // Ensure no pulse was generated during glitches
        if (btn_press_proc[0] == 0) 
            $display("[%0t ns] PASS: Glitch successfully filtered!", $time);
        else 
            $display("[%0t ns] FAIL: Glitch triggered a pulse!", $time);

        #1000;

        // --- TEST 2: Valid Press Test (Button 0 held for > 20 ms) ---
        // 20 ms = 20,000,000 ns
        $display("[%0t ns] Test 2: Valid Press (Holding Button 0 for > 20 ms)...", $time);
        btn_press_raw[0] = 1;
        
        // Wait 20.01 ms for debouncer counter to hit 503,500
        #20010000; 

        // Release Button 0
        btn_press_raw[0] = 0;
        #1000;

        // --- TEST 3: Parallel Button Press (Button 2 and 4) ---
        $display("[%0t ns] Test 3: Pressing Buttons 2 and 4 together...", $time);
        btn_press_raw[2] = 1;
        btn_press_raw[4] = 1;
        
        #20010000; // Hold past 20 ms
        
        btn_press_raw = 5'b00000;
        #5000;

        $display("[%0t ns] Simulation Complete!", $time);
        $finish;
    end

endmodule