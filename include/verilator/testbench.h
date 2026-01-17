/**
 * @file    utils/testbench.h
 *
 * @author  l.heywang <leonard.heywang@proton.me>
 * @date    22/10/2025
 *
 * @brief   Provide an abstraction layer over the Verilator interface, to make the testbench
 * existence simpler.
 */

/*
 * ===========================================================================================
 * INCLUDES
 * ===========================================================================================
 */

#pragma once

#include <iomanip>
#include <iostream>
#include <stdint.h>
#include <string>
#include <string_view>
#include <type_traits>

#include "verilated.h"
#include "verilated_vcd_c.h"

#include "/tools/include/colors.h"

/*
 * ===========================================================================================
 * PARAMETERS
 * ===========================================================================================
 */

constexpr int STATUS_WIDTH = 10;
constexpr int CYCLE_WIDTH = 6;
constexpr int NAME_WIDTH = 14;
constexpr int TIME_WIDTH = 10;
constexpr int SIGNAL_WIDTH = 8;

constexpr char STATUS_FILL = ' ';
constexpr char CYCLE_FILL = ' ';
constexpr char NAME_FILL = ' ';
constexpr char TIME_FILL = ' ';
constexpr char SIGNAL_FILL = ' ';

static const std::string HEADER = std::string(
    "============================================================================================="
    "====================");

/*
 * ===========================================================================================
 * HELPER CLASS
 * ===========================================================================================
 */
template <typename Enum> class EnumIterator
{
  public:
    using underlying = typename std::underlying_type<Enum>::type;

    constexpr EnumIterator(Enum current) : value(current) {}

    constexpr Enum operator*() const { return value; }
    constexpr bool operator!=(const EnumIterator &other) const { return value != other.value; }
    constexpr EnumIterator &operator++()
    {
        value = static_cast<Enum>(static_cast<underlying>(value) + 1);
        return *this;
    }

  private:
    Enum value;
};

template <typename Enum> class EnumRange
{
  public:
    constexpr EnumRange(Enum begin, Enum end)
        : _begin(begin), _end(static_cast<typename std::underlying_type<Enum>::type>(end) + 1)
    {
    }

    constexpr EnumIterator<Enum> begin() const { return EnumIterator<Enum>(_begin); }
    constexpr EnumIterator<Enum> end() const { return EnumIterator<Enum>(static_cast<Enum>(_end)); }

  private:
    Enum _begin;
    typename std::underlying_type<Enum>::type _end;
};

// ---------------- Optional: generic get_name overload template ----------------
// Fallback for unknown enums
template <typename Enum> constexpr std::string get_name(Enum)
{
    return "UNKNOWN";
}

/*
 * ===========================================================================================
 * MAIN CLASS
 * ===========================================================================================
 */

/**
 *  @class  Testbench
 *
 *  @brief  Provide an abstraction layer above the standard Verilator one.
 *          Wrap some utility functions and others elements into a more practical way.
 *          Also provide some way to make the output console a bit cleaner.
 *
 *  @tparam MODULE  A verilated module type (Vxxxx...). Enable to share a single class between all
 * of them.
 *
 *  @details
 *          Usage : First, open the class (after calling the argument parser of Verilator)
 *
 *                      Verilated::commandArgs(argc, argv);
 *                      Testbench<Valu2> tb("ALU2");
 *
 *          Then, perform a reset of the DUT to ensure a consistent state :
 *
 *                      tb.reset();
 *
 *          Finally, you can start applying inputs, and checking for outputs !
 *
 *              Applying inputs, both options work the same
 *
 *                      tb.set(&tb.dut->clear, 1);
 *                      tb.dut->clear = 1
 *
 *              Checking outputs :
 *
 *                       tb.check_equality(&tb.dut->busy, 0, "busy");
 *
 *          And, if the testbench need some clocks cycles. Different options to performa single edge
 * (stick), a whole period (tick) or until a condition is valid (run_until).
 *
 *              tb.stick();
 *              tb.tick();
 *              int count = tb.run_until(&tb.dut->valid, 1);
 *
 *          Read the doc for the full usage !
 *
 *          These aren't complicated, and can be easily auto-generated (that's actually the case).
 *          Theses will make the integration between C++ and SV much, much easier.
 */
template <class MODULE> class Testbench
{
  public:
    /*
     * ===========================================================================================
     * CONSTRUCTORS and DESTRUCTORS
     * ===========================================================================================
     */

    /**
     *  @brief  Construct a new testbench class, with the right type passed a template parameter :
     *
     *      Testbench<Vxxx> env;
     *
     *      No parameters are used, the testbench will fetch the name from the Verilog /
     * SystemVerilog module directly.
     *
     *  @return the class itself.
     */
    Testbench()
    {
        this->name = std::string("default");
        this->verilator_init();
        return;
    }

    /**
     *  @brief  Construct a new testbench class, with the right type passed a template parameter :
     *
     *      Testbench<Vxxx> env(name);
     *
     *  @param  module_name (std::string) A custom name for the module.
     *
     *  @return the class itself.
     */
    Testbench(std::string module_name)
    {
        this->name = module_name;
        this->verilator_init();
        return;
    }

    /**
     *  @brief  Construct a new testbench class, with the right type passed a template parameter :
     *
     *      Testbench<Valu2> env;
     *
     *  No parameters are used, the testbench will fetch the name from the Verilog / SystemVerilog
     *  module directly.
     *
     *  @return None
     */
    ~Testbench()
    {
        final_print();

        this->tfp->close();
        delete this->dut;
        delete this->tfp;
        return;
    }

    /*
     * ===========================================================================================
     * SIMULATION
     * ===========================================================================================
     */

    /**
     *  @brief  Make the testbench sim_time to advance of a single tick (one inversion of the
     * clock).
     *
     *  @arg    trace   Enable the tracing into the VCD file (default = true)
     *
     *  @return None
     */
    void stick(bool trace = true)
    {
        // Toggling the clock and evalutating changes
        this->dut->eval();
        this->dut->clk = !this->dut->clk;
        this->dut->eval();

        // If needed, dump into the VCD file
        if (trace)
        {
            this->tfp->dump(this->sim_time);
        }

        // Incrementing the simulation time to get a coherent output
        this->sim_time += 1;

        // Incrementing the performance counters, if some are enabled
        for (int k = 0; k < 15; k++)
        {
            if (this->enabled_counters[k] == 1)
            {
                this->perf_counters[k] += 1;
            }
        }
        return;
    }

    /**
     *  @brief  Make the testbench sim_time to advance of a whole clock period.
     *
     *  @arg    trace   Enable the tracing into the VCD file (default = true)
     *
     *  @return None
     */
    void tick(bool trace = true)
    {
        // We just call twice the stick function, to get a full clock cycle.
        this->stick(trace);
        this->stick(trace);
        return;
    }

    /**
     *  @brief  Perform a reset of the DUT, by playing with the rst_n pin.
     *
     *  @return None
     */
    void reset()
    {
        this->tick();

        // Set the reset low (active)
        this->dut->rst_n = 0;
        this->stick();

        // Releasing the reset (inactive)
        this->dut->rst_n = 1;
        this->stick();

        // Waiting for a whole cycle
        this->tick();
        return;
    }

    /**
     *  @brief  Perform the clear of the module.
     *
     *  @return None
     */
    void clear()
    {
        // Set the reset low (active)
        this->dut->clear = 1;
        this->tick();

        // Releasing the reset (inactive)
        this->dut->clear = 0;
        this->tick();

        return;
    }

    /**
     *  @brief  Run the testbench until the condition is NOT true. The code simulation is runned at
     *          least for a single cycle.
     *          Does print in console an info message with the number of elapsed cycles.
     *
     *          Can be super-useful with start_cycle_counter / end_cycle_counter to measure the
     *          performance of a module.
     *
     *          Usage example :
     *              tb.run_until(&tb.dut->[sig], 1); will run until the [sig] get the value of
     *              '1'.
     *              tb.run_until(&tb.dut->[sig], 0x8); will run until the [sig] get the value
     *              of 8.
     *
     *  @tparam *signal     The signal that is used as comparison source
     *  @tparam value       The value that shall be taken by the signal to exit the loop.
     *  @param  max_cycles  A maximal value after which the loop will be exited, regardless of
     *                      the condition.
     *
     *  @retval The number of elapsed cycles to satisfy the condition (or, the max_cycle value).
     */
    template <typename TYPE1, typename TYPE2>
    int run_until(TYPE1 *signal, TYPE2 value, int max_cycles = 1000)
    {
        this->dut->eval(); // Registering the inputs applied.
        int cycles = 0;
        do
        {
            this->tick();
            cycles += 1;
        } while ((cycles < max_cycles) && *signal != (TYPE1)value);

        // Ensure we register the changes
        this->dut->eval();

        char str[64];
        sprintf(str, "This operation needed %d cycles to execute !", cycles);
        this->set_info(std::string(str));

        return cycles;
    }

    /**
     *  @brief  Run the testbench until the condition is true. The code simulation is runned at
     *          least for a single cycle.
     *          Does print in console an info message with the number of elapsed cycles.
     *
     *          Can be super-useful with start_cycle_counter / end_cycle_counter to measure the
     *          performance of a module.
     *
     *          Usage example :
     *              tb.run_until(&tb.dut->[sig], 1); will run while the [sig] get the value of
     *              '1'.
     *              tb.run_until(&tb.dut->[sig], 0x8); will run while the [sig] get the value
     *              of 8.
     *
     *  @tparam *signal     The signal that is used as comparison source
     *  @tparam value       The value that shall be taken by the signal to exit the loop.
     *  @param  max_cycles  A maximal value after which the loop will be exited, regardless of
     *                      the condition.
     *
     *  @retval The number of elapsed cycles to satisfy the condition (or, the max_cycle value).
     */
    template <typename TYPE1, typename TYPE2>
    int run_while(TYPE1 *signal, TYPE2 value, int max_cycles = 1000)
    {
        this->dut->eval(); // Registering the inputs applied.
        int cycles = 0;
        do
        {
            this->tick();
            cycles += 1;
        } while ((cycles < max_cycles) && *signal == (TYPE1)value);

        // Ensure we register the changes
        this->dut->eval();

        char str[64];
        sprintf(str, "This operation needed %d cycles to execute !", cycles);
        this->set_info(std::string(str));

        return cycles;
    }

    /**
     *  @brief  Run the testbench for [cycles] cycles.
     *
     *          Used to prevent dump copy-pasting of some LOC.
     *
     *  @details    The function call eval() before and after, thus ensuring that the any changes
     *              before and after WILL be runned.
     *
     *  @param  cycles  The number of cycles that shall be runned.
     *  @retval         0
     */
    int run_for(int cycles)
    {
        this->dut->eval();
        for (int k = 0; k < cycles; k += 1)
        {
            this->tick();
        }
        this->dut->eval();

        return 0;
    }

    /*
     * ===========================================================================================
     * PERFORMANCE COUNTERS
     * ===========================================================================================
     */

    /**
     * @brief   Start a performance counter at the specified ID (up to 15).
     *          Can be used to monitor the cycle difference for a specific part of the test.
     *
     * @param   ID  The ID of the performance counter (0 - 15).
     *
     * @return  int
     * @retval   0 : Counter started.
     * @retval  -1 : Invalid counter.
     * @retval  -2 : Counter already started.
     */
    int start_cycle__counter(int ID)
    {
        if ((0 > ID) || (ID > 15))
        {
            return -1;
        }

        if (this->enabled_counters[ID] == 1)
        {
            return -2;
        }

        this->enabled_counters[ID] = 1;
        return 0;
    }

    /**
     * @brief   Start a performance counter at the specified ID (up to 15).
     *          Can be used to monitor the cycle difference for a specific part of the test.
     *
     * @param   ID  The ID of the performance counter (0 - 15).
     *
     * @retval  int The number of cycles elapsed from the start of this counter. May return -1 if
     * invalid ID.
     */
    int stop_cycle_counter(int ID)
    {
        if ((0 > ID) || (ID > 15))
        {
            return -1;
        }

        // Disable the performance counter
        this->enabled_counters[ID] = 0;

        // Backup the data, and halve it (incremented at each stick, half clock period)
        uint64_t save = this->perf_counters[ID] / 2;
        this->perf_counters[ID] = 0;

        return save;
    }

    /*
     * ===========================================================================================
     * PRINTS
     * ===========================================================================================
     */

    /**
     *  @brief  Print the final message, that contain the end message, and an pass / fail count.
     *
     *  @return None
     */
    void final_print()
    {
        std::cout << KMAG << "Simulation complete." << std::endl
                  << std::dec << KYEL << HEADER << std::endl
                  << "Results : " << this->center_text(this->name, NAME_WIDTH, NAME_FILL)
                  << std::endl
                  << HEADER << std::endl
                  << KGRN << "\tPass : " << this->center_text(std::to_string(this->pass), 6, ' ')
                  << KRED << "\n\tFail : " << this->center_text(std::to_string(this->fail), 6, ' ')
                  << RST << std::endl;

        if (this->fail == 0)
        {
            std::cout << KGRN << "Tests passed !" << RST << std::endl;
        }
        else
        {
            std::cout << KRED << "Tests failed !" << RST << std::endl;
        }

        return;
    }

    /**
     *  @brief  Print the initial message, to announce that the sequence will start.
     *
     *  @return None
     */
    void initial_print()
    {
        std::cout << KMAG << HEADER << std::endl
                  << "Starting " << this->center_text(this->name, NAME_WIDTH, NAME_FILL)
                  << " simulation..." << std::endl
                  << HEADER << std::endl
                  << RST;
        return;
    }

    /*
     * ===========================================================================================
     * ASSERTIONS
     * ===========================================================================================
     */

    /**
     *  @brief  Perform an assertion, and print the output into the console, with a nice colored
     *          code.
     *
     *  @tparam *signal A member of the tested unit, to be compared against a value
     *  @tparam value   The value to be compared against
     *  @param  print   Shall we print to the console ?
     */
    template <typename TYPE1>
    int check_equality(TYPE1 signal, TYPE1 reference, std::string testname, bool print = true)
    {
        std::string tname = this->center_text(testname, NAME_WIDTH, NAME_FILL);
        std::string ttime =
            this->center_text(this->get_time(this->sim_time), TIME_WIDTH, TIME_FILL);
        std::string tcycle =
            this->center_text(std::to_string(this->cycle_count), NAME_WIDTH, NAME_FILL);

        if (signal == reference)
        {
            if (print)
                std::cout << KGRN << "[" << this->center_text("PASS", NAME_WIDTH, NAME_FILL)
                          << "] Cycle " << tcycle << "    [ " << tname << " ] @ " << ttime << RST
                          << std::dec << std::endl;
            this->pass += 1;
        }
        else
        {

            std::stringstream sigs, refs;
            sigs << std::hex << signal;
            refs << std::hex << reference;

            std::cout << KRED << "[" << this->center_text("FAIL", NAME_WIDTH, NAME_FILL)
                      << "] Cycle " << tcycle << "    [ " << tname << " ] @ " << ttime
                      << " | Got : 0x" << this->center_text(sigs.str(), SIGNAL_WIDTH, SIGNAL_FILL)
                      << " waited : 0x" << this->center_text(refs.str(), SIGNAL_WIDTH, SIGNAL_FILL)
                      << " |" << RST << std::dec << std::endl;
            this->fail += 1;
        }
        return 0;
    }

    /**
     *  @brief  Perform an assertion, and print the output into the console, with a nice colored
     *          code. The difference with check_equality is the fact that this function is used to
     *          add an argument to a previous comparison, and, if pass, won't be printed at all.
     *
     *  @tparam *signal A member of the tested unit, to be compared against a value
     *  @tparam value   The value to be compared against
     *  @param  print   Shall we print to the console ?
     */
    template <typename TYPE1>
    int check_equality_arg(TYPE1 signal, TYPE1 reference, std::string testname, bool print = true)
    {
        if (signal == reference)
        {
            this->pass += 1;
        }
        else
        {
            std::string tname = this->center_text(testname, NAME_WIDTH, NAME_FILL);
            std::string ttime =
                this->center_text(this->get_time(this->sim_time), TIME_WIDTH, TIME_FILL);
            std::string tcycle =
                this->center_text(std::to_string(this->cycle_count), NAME_WIDTH, NAME_FILL);

            std::stringstream sigs, refs;
            sigs << std::hex << signal;
            refs << std::hex << reference;

            std::cout << KRED << "[" << this->center_text("    ", NAME_WIDTH, NAME_FILL)
                      << "] Cycle " << tcycle << "    [ " << tname << " ] @ " << ttime
                      << " | Got : 0x" << this->center_text(sigs.str(), SIGNAL_WIDTH, SIGNAL_FILL)
                      << " waited : 0x" << this->center_text(refs.str(), SIGNAL_WIDTH, SIGNAL_FILL)
                      << " |" << RST << std::dec << std::endl;
            this->fail += 1;
        }
        return 0;
    }

    /*
     * ===========================================================================================
     * MISC. PRINTS
     * ===========================================================================================
     */

    /**
     *  @brief  Set the current case, and show message in the console to indicate it.
     *          Theses messages are printed in cyan.
     *
     *  @return int 0.
     */
    int set_case(std::string cases)
    {
        std::cout << std::dec << KCYN << HEADER << std::endl
                  << "Case : (" << this->center_text(this->name, NAME_WIDTH, NAME_FILL)
                  << ") : " << cases << std::endl
                  << HEADER << RST << std::endl;

        this->actual_case = cases;
        return 0;
    }

    /**
     * @brief   Function to set the current case from an iterate name value
     */
    template <typename Enum> void set_case_enum(Enum op) { set_case(get_name(op)); }

    /**
     * @brief   Similar overload, but with some additional text to be added before
     *          enum value name.
     */
    template <typename Enum> void set_case_enum(std::string text, Enum op)
    {
        std::string out = text + " " + get_name(op);
        set_case(out);
    }

    /**
     *  @brief  Show to the user an info. Shown in blue.
     *
     *  @return int 0.
     */
    int set_info(std::string message)
    {
        std::stringstream ss;
        ss << "[" << this->center_text("INFO", NAME_WIDTH, NAME_FILL) << "] (";
        std::string tstatus = ss.str();

        std::cout << std::dec << KBLU << tstatus << this->name << ") " << message << RST
                  << std::endl;

        return 0;
    }

    /**
     *  @brief  Show the user a warning. Show in yellow.
     *
     *  @return int 0.
     */
    int set_warn(std::string message)
    {
        std::stringstream ss;
        ss << "[" << this->center_text("WARN", NAME_WIDTH, NAME_FILL) << "] (";
        std::string tstatus = ss.str();

        std::cout << std::dec << KYEL << tstatus << this->name << ") " << message << RST
                  << std::endl;

        return 0;
    }

    /**
     *  @brief  Show the user an error. Show in red.
     *
     *  @return int 0.
     */
    int set_error(std::string message)
    {
        std::stringstream ss;
        ss << "[" << this->center_text("ERROR", NAME_WIDTH, NAME_FILL) << "] (";
        std::string tstatus = ss.str();

        std::cout << std::dec << KRED << tstatus
                  << this->center_text(this->name, NAME_WIDTH, NAME_FILL) << ") " << message << RST
                  << std::endl;

        return 0;
    }

    /**
     *  @brief  Show to the user an integer number as an INFO message. Mostly used
     *          to indicate an interation inside a for loop.
     *
     *  @return int 0.
     */
    int set_iter(int iter)
    {
        std::stringstream ss;
        ss << "[" << this->center_text("ITER", NAME_WIDTH, NAME_FILL) << "] (";
        std::string tstatus = ss.str();

        std::cout << std::dec << KMAG << tstatus << this->name << ") " << iter << RST << std::endl;

        return 0;
    }

    /*
     * ===========================================================================================
     * GETTING AND SETTING VALUES
     * ===========================================================================================
     */

    /**
     *  @brief  Fill the passed pointers with the pass and fail values, and return 0 if none are
     *          failed, else -1.
     *
     *  @return int 0 or -1
     */
    template <typename TYPE1, typename TYPE2> int get_return(TYPE1 *passed, TYPE2 *failed)
    {
        // Update the values
        *passed = (TYPE1)this->pass;
        *failed = (TYPE2)this->fail;

        return (this->fail != 0) ? -1 : 0;
    }

    /**
     *  @brief  Return 0 if non tests failed, else -1.
     *
     *  @return int 0 or -1
     */
    int get_return() { return (this->fail != 0) ? -1 : 0; }

    /**
     *  @brief  Increment the cycle counter by a defined value.
     *
     *  @param  int     The value to be added.
     *
     *  @return int
     *  @retval The value of the cycles after being incremented.
     */
    int increment_cycles(int value = 1)
    {
        this->cycle_count += value;
        return this->cycle_count;
    }

    /*
     * ===========================================================================================
     * SETTER AND GETTERS
     * ===========================================================================================
     */

    /**
     *  @brief  Enable to set a signal on the DUT.
     *
     *  @tparam *signal The signal to be configured.
     *  @tparam value   The value to be written.
     *
     *  @return 0
     */
    template <typename TYPE1, typename TYPE2> int set(TYPE1 *signal, TYPE2 value)
    {
        *signal = (TYPE1)value;
        return 0;
    }

    /**
     *  @brief  Enable to read a value from the DUT.
     *
     *  @tparam *signal The signal to be read.
     *
     *  @return Tparam the value readen.
     */
    template <typename TYPE> TYPE set(TYPE *signal) { return (TYPE)*signal; }

    // Public DUT to be accessed by the user.
    MODULE *dut;

  private:
    /*
     *  Variables
     */

    // Class "name" for console
    std::string name;

    // Verilated modules
    VerilatedVcdC *tfp;

    // Simulation time
    vluint64_t sim_time;
    uint64_t cycle_count;

    // Counters
    uint64_t pass;
    uint64_t fail;
    std::string actual_case;

    uint64_t enabled_counters[16];
    uint64_t perf_counters[16];

    /*
     *  Functions
     */

    /**
     *  @brief  [PRIVATE] Handle the common stuff related to the verilator config.
     */
    void verilator_init()
    {
        // Initializing variables
        this->sim_time = 0;
        this->cycle_count = 0;
        this->pass = 0;
        this->fail = 0;
        this->actual_case = std::string("default");

        // Initializing performance counters
        for (int k = 0; k < 16; k++)
        {
            this->enabled_counters[k] = 0;
            this->perf_counters[k] = 0;
        }

        // Openning the class for verilator
        this->dut = new MODULE;
        this->tfp = new VerilatedVcdC;

        // Enabling traces
        Verilated::traceEverOn(true);

        // Configuring some elements
        this->dut->trace(this->tfp, 99);

        // Creating the simulation output
        char str[64];
        snprintf(str, sizeof(str), "%s.vcd", this->name.c_str());
        tfp->open(str);

        // Logging to console the first elements
        this->initial_print();
        return;
    }

    /**
     *  @brief  [PRIVATE] Helper function to center some text into a define width
     */
    std::string center_text(const std::string &text, int width, char fill = ' ')
    {
        if ((int)text.size() >= width)
            return text.substr(0, width); // truncate if too long

        int total_padding = width - text.size();
        int left = total_padding / 2;
        int right = total_padding - left;

        return std::string(left, fill) + text + std::string(right, fill);
    }

    /**
     *  @brief  [PRIVATE] Helper function to convert the sim_time into a human friendly time.
     */
    std::string get_time(vluint64_t time)
    {
        const char *units[] = {"sec", "ms", "us", "ns", "ps"};
        const double scales[] = {1, 1e-3, 1e-6, 1e-9, 1e-12};
        double time_s = time * 1e-12;

        for (int i = 0; i < 5; ++i)
        {
            double converted = time_s / scales[i];
            if (converted >= 1.0 || i == 4)
            {
                std::ostringstream oss;
                oss << std::fixed << std::setprecision(3) << converted << " " << units[i];
                return oss.str();
            }
        }

        return "0 s"; // fallback
    }
};