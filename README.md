# **Simker**

Simker is a specialized Docker container tailored for electronic mixed-signal simulation.
It aggregates the best open-source tools for analog and digital design into a single,
portable environment, allowing you to create "electronics for tomorrow" without the
hassle of dependency management.

## Key Features⚡:

- Zero-Dependency Setup: Run complex EDA tools without cluttering your host OS.

- Mixed-Signal Capable: Seamlessly handle Analog (SPICE) and Digital (HDL) workflows.

- Built-in Utilities: Custom scripts to bridge the gap between different HDL formats.

- Interactive Help: A custom CLI help system to guide you through the tools.

- Compatible with a large panel of OS : Since it's inside a docker container, which run Ubuntu 24.04,
  you can basically deploy the tool on any OS that support docker.

## Included Toolbox 🛠:

Simker comes pre-packaged with industry-standard open-source EDA tools:

| Category              | Tool       | Description                                                                 |
| --------------------- | ---------- | --------------------------------------------------------------------------- |
| SPICE Simulation      | NGSPICE    | The standard for open-source analog circuit simulation.                     |
| VHDL Simulation       | GHDL       | Fast VHDL simulator (GCC/LLVM backend).                                     |
| Verilog/SystemVerilog | Verilator  | The fastest Verilog/SystemVerilog simulator.                                |
| Verilog-A             | OpenVAF-R  | Verilog-A compiler for compact model / custom analog functions integration. |
| Schematic Capture     | XSchem     | Hierarchical schematic capture for VLSI/mixed-signal.                       |
| Digital Viewer        | GTKWave    | Fully featured wave viewer for Unix and Win32.                              |
| Analog Viewer         | GAW        | Gtk Analog Wave viewer for displaying SPICE data.                           |
| Terminal              | oh-my-posh | A better terminal than the default one in docker                            |

And some custom utilities to link theses tools :

| Tool         | Description                                                                                                       |
| ------------ | ----------------------------------------------------------------------------------------------------------------- |
| vhdl2verilog | A script to convert VHDL files into Verilog. Based on the GHDL synth features !                                   |
| wrappengen   | A wrapper generator to generate XSCHEM symbols from digital or analog logic. Usefull when integrating mixed sim ! |

> [!NOTE]
> And, what's even better ? Simker come with an integrated X11 server, thus, GUI apps will work out of the box !

## Getting Started 🚀 :

1. Install the tool

There's an helper script to setup it for you !

```sh
./installer/install.sh
```

> [!NOTE]
> You must be member of the group "docker" to be able to build the container correctly.

> [!WARNING]
> Never run this script as admin. Otherwise, you'll modify the root's .bashrc script, not yours.
> The tool won't be available for you.

This will install the container globally, and you won't need to 
manually retain the path.
The code is installed in ~/.local/share/simker/ and built from it.

Thus, you can delete this folder, the tool will be retained. 

2. Run the Container

To run the container and access the terminal,
you can type in any location : 

```sh
simker
```

The tool will mount your actual location into the /workspace of the tool.
Just go into your project directoty, launch the container and let's develop !

## Usage & Help System 📖

Simker was designed to be the easiest to use and setup, even for beginner !

Once inside the container, you are greeted by the Simker shell. We have included a robust help system to get you started immediately.
The Simker CLI

Just type simker at any time to see the welcome screen and status:

```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             ███████╗██╗███╗   ███╗██╗  ██╗███████╗██████╗     ██╗           %            
%             ██╔════╝██║████╗ ████║██║ ██╔╝██╔════╝██╔══██╗    ██║           %
%             ███████╗██║██╔████╔██║█████╔╝ █████╗  ██████╔╝    ██║           %
%             ╚════██║██║██║╚██╔╝██║██╔═██╗ ██╔══╝  ██╔══██╗    ╚═╝           %
%             ███████║██║██║ ╚═╝ ██║██║  ██╗███████╗██║  ██║    ██╗           %
%             ╚══════╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% Welcome on the SIMKER Docker container. You can now begin creatin           %
%   electronics for tomorrow !                                                %
%                                                                             %
% There's plenty of tools built-in, such as :                                 %
%   - SPICE simulator :                      NGSPICE                          %
%   - VHDL simulator :                       GHDL                             %
%   - Verilog / SystemVerilog simulator :    VERILATOR                        %
%   - VerilogA :                             OPENVAF-R                        %
%   - Digital waveform viewer :              GTKWAVE                          %
%   - Analog waveform viewer :               GAW                              %
%   - Schematic capture :                    XSCHEM                           %
%                                                                             %
% But that's not all ! There's also some usefull scripts, also included !     %
%  - vhdl2verilog :                          Convert a VHDL file into a       %
%                                              verilog one !                  %
%  - To be completed !                                                        %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% All of the tools can be used from that command line input. And, if you need %
%  some help, you can always type "simker" to show this message, as           %
%  well as simker_help [tool name] to get more specific help !                %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% Leonard HEYWANG <leonard.heywang@proton.me>                                 %
%   03/01/2026                                                                %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

### Tool Specific Help

Don't remember the flags for ghdl or ngspice? I've wrapped the help commands for you,
with a nice link to the official help page, which will be more than complete !

General Help: Type

```sh
simker_help
```

Specific Tool Help: Type

```sh
simker_help [tool_name]
```

Example:

```sh
simker_help ngspice
...
simker_help ghdl
```

Check Versions: Type

```sh
simker_help versions
```
> [!NOTE]
> For the even more nerd users, there's also man pages for the different tools (built by the developper, or custom ones).

## Workflow Example 🧩 :

Simker is designed for a mixed-signal flow. Here is a typical workflow you can achieve inside the container:
But, anyway, it can be used for pure analog or pure digital design without any major flaws.

The steps are :

- Write and test each block separately (digital, analog...). You can count on helper scripts here to help you !
- Assemble theses blocks in the global simulation without XSCHEM.
- Launch NGSPICE and wait !
- See the results, and iterate if needed.

## Author & License 📝

Leonard HEYWANG

- leonard.heywang@proton.me

Project initiated: 03/01/2026

Distributed under the GNU GPL 3.0 License. See LICENSE for more information.

> [!WARNING] > **⚠️ Technical Note on Display**
> If you encounter "Error: cannot open display", please ensure your X11 forwarding is configured correctly on your host machine.
