`timescale 1ns / 1ps

module tb_counter;

    // 1. Declare signals
    reg clk;
    reg rst_n;
    reg en;
    wire [3:0] count;

    counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Setup file for GTKWave
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_counter);

        // Initialize Inputs
        rst_n = 0;
        en = 0;

        // Apply Reset
        #20 rst_n = 1;

        // Enable Counter
        #10 en = 1;

        // Let it count for 200ns
        #200;

        // Pause counting (hold value)
        en = 0;
        #40;
        
        // Resume counting
        en = 1;
        #50;

        // End simulation
        $finish;
    end

    // Optional: Print values to console
    initial begin
        $monitor("Time=%0t | rst_n=%b en=%b | count=%d", $time, rst_n, en, count);
    end

endmodule