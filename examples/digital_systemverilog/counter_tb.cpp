#include "Vcounter.h" 
#include "verilated.h"
#include "/tools/include/verilator/testbench.h" // Your custom header

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    
    // Initialize Testbench with the DUT class (Vcounter)
    Testbench<Vcounter> tb("Counter_Test");

    // Initial signals
    tb.dut->rst_n = 0;
    tb.dut->en = 0;
    
    // Reset Sequence
    tb.reset(); // Assuming this toggles clock/reset lines
    tb.dut->rst_n = 1;
    tb.dut->en = 1;

    // Run for 16 cycles
    for (int i = 0; i < 16; i++)
    {
        tb.tick();
        
        // Assert value
        tb.check_equality((unsigned int)tb.dut->count, (unsigned int)((i + 1) % 0x10), "counter_val");
    }

    return tb.get_return();
}