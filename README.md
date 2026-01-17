# **Simker**

Simker is a specialized Docker container tailored for electronic mixed-signal simulation.
It aggregates open-source tools for analog and digital design into a single,
portable environment, without the hassle of dependency management.

---

This project started as I was tired of using the university's tools which are heavy,
require a remote desktop connection and are WAYYY too costly for a student budget.
So, I looked for open-source alternatives for a student, and, well, didn't find anything really
convincing.

- Qucs-s ? I like it, but can't run mixed-signals simulations.
- QSPICE ? I also like it, but, only available under Windows.

So, I started this project as a personnal tool, a very simple docker that did just grown a... bit too much.
And since I though it was cool to share it, here we are !

And since we're here, don't forget that this tool collection has been verified individually, so there shall not be bugs.
I can't ensure you there won't be, I don't have any ways to make it (time nor money).
Really fine for personnal projects, as I do, but, you can't thrust them as you may thrust industry standard tools.

## Key Features⚡:

- Zero-Dependency Setup: Run complex EDA tools without cluttering your host OS.

- Mixed-Signal Capable: Seamlessly handle Analog (SPICE) and Digital (HDL) workflows.

- Built-in Utilities: Custom scripts to bridge the gap between different HDL formats.

- Interactive Help: A custom CLI help system to guide you through the tools.

- Compatible with a large panel of OS : Since it's inside a docker container, which run Ubuntu 24.04,
  you can basically deploy the tool on any OS that support docker.

## Included Toolbox 🛠:

Simker comes with industry-standard open-source EDA tools:

| Category              | Tool       | Description                                                                 |
| --------------------- | ---------- | --------------------------------------------------------------------------- |
| SPICE Simulation      | NGSPICE    | The standard for open-source analog circuit simulation.                     |
| VHDL Simulation       | GHDL       | Fast VHDL simulator (GCC backend).                                          |
| Verilog/SystemVerilog | Verilator  | The fastest Verilog/SystemVerilog simulator.                                |
| Verilog-A             | OpenVAF-R  | Verilog-A compiler for compact model / custom analog functions integration. |
| Schematic Capture     | XSchem     | Hierarchical schematic capture for VLSI/mixed-signal.                       |
| Digital Viewer        | GTKWave    | Fully featured wave viewer.                                                 |
| Analog Viewer         | GAW        | Gtk Analog Wave viewer for displaying signals.                              |
| Terminal              | oh-my-posh | A better terminal than the default one in docker                            |

And some custom utilities to link theses tools :

| Tool         | Description                                                                                                       |
| ------------ | ----------------------------------------------------------------------------------------------------------------- |
| vhdl2verilog | A script to convert VHDL files into Verilog. Based on the GHDL synth features !                                   |
| wrappengen   | A wrapper generator to generate XSCHEM symbols from digital or analog logic. Usefull when integrating mixed sim ! |

And finally some ressources to build higher level tests :
| Rssource | Description |
| ------------ | ----------------------------------------------------------------------------------------------------------------- |
| /tools/include/verilator/testbench.h | A class to provide higher level of abstraction to verilator, and perform testbench controls and assertions ! |

> [!NOTE]
> And, what's even better ? Simker come with an integrated X11 server, thus, GUI apps will work out of the box !

## Getting Started 🚀 :

1. Install the tool

There's an helper script to setup it for you !

```sh
# If not already done, add yourself to the docker group (prevent for running docker as sudo)
sudo groupadd docker
sudo usermod -aG docker $USER

# Run the installer script
./installer/install.sh
```

> [!WARNING]
> This install procedure can be quite long, since it's compiling the tools from sources.
> On my high end desktop PC (core i9, 64 GB), it's done in under 10 minutes, on my mid range quite old laptop (ryzen 7 5000U, 16 GB) this can go up to 30 minutes.

> [!WARNING]
> Never run this script as sudo. Otherwise, you'll modify the root's .bashrc script, not yours.
> The tool won't be available for you.
> This shouldn't not broke your system anyway, that's just... useless.

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

## Usage & Help System 📖 :

Simker was designed to be the easiest to use and setup, even for beginners !

Once inside the container, you are greeted by the Simker shell (a stabdard bash behind).
I have included a help system to get you started immediately.

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
%  - wrappergen :                            Build XSCHEM sybmols from        %
%                                              verilog(a) sources !           %
%                                                                             %
% And, some helper files to build more advanced tests :                       %
%  - testbench.h                             Create a verilator helper class  %
%                                              to help during assertions and  %
%                                              and testbench controls.        %
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

### Tool Specific Help :

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
> Theses are disabled by default (minized system), but still copied when building the image.

## Workflow Example 🧩 :

Simker is designed for a mixed-signal flow. Here is a typical workflow you can achieve inside the container:
But, anyway, it can be used for pure analog or pure digital design without any major flaws.

The steps are :

1. Write and test each block separately (digital, analog...). Simulate using the native tool, and if needed, generate a XSCHEM schematic using **wrappergen**
2. Assemble theses blocks in the global simulation with XSCHEM.
3. Launch NGSPICE and wait !
4. See the results, and iterate if needed.

And, don't forget : There's a lot of examples, available in the /example in the container, or in the repo ! Go take a look at them !
They show near all of the available workflows.

## Hardware recommendations :

Actually, the tools does not require a lot of performance to run, the longer task is the build process of the container.
I may look, one day to store them on the cloud and only download them.

Any computer that as enough RAM to run a docker and some basic tools will work.

| Configuration | Hardware specs                                                                              |
| ------------- | ------------------------------------------------------------------------------------------- |
| Minimal       | Any cpu built in the last decade and 16 GB of RAM. About 10 GB of free storage is required. |
| Recommended   | Any CPU with at least 6 cores and 16 GB or RAM. About 15 GB of SSD available                |
| Ideal         | Any CPU with at least 8 cores and 32 GB of RAM. About 20 GB of NVMe drive available.        |

> [!WARNING]
> Theses recommendations are built on my own tests. Theses are more for reference rather than real hard limit.

## Software recommendations : 

### Linux OS : 
I tested this tool on fedora 42 and 43, as well as Ubuntu 25.04. Both of them works nice, even if the SELinux policy is maxed (as my fedora 43 on my laptop).
This is the recommended platform.

### Windows OS :
While there's no restrictions about it, I don't tested it. And, since WSL exist, you can just install it and run it from there. Will be easier to maintain
a single platform (linux) rather than different OSes.

### Mac OS : 
Finally, I don't tested it in any form under macOS. And, I don't planned to test it someday.
There's no restriction about running docker container on theses tools, so, it shall work without too much hassle, but... I don't know.

## Known limitations :

### Digital simulation :

As NGSPICE vlnggen, for which the tools depends, there can only be a single digital d_cosim block.
That's a limitation that could be bypassed by combining all theses blocks in a single top (which is easy using wrappergen).
That's not proper to the docker itself, but I wasn't really excited to change these tools behavior.

## Author & License 📝 :

Leonard HEYWANG

- leonard.heywang@proton.me

Project initiated: 03/01/2026

Distributed under the GNU GPL 3.0 License. See LICENSE for more information.

> [!WARNING]
> If you encounter "Error: cannot open display", please ensure your X11 forwarding is configured correctly on your host machine.

## Contributing and support :

As a you may have seen, I'm still a student, so, this project is developped as a side project. This mean there may be period of
inactivity. Even if I tried as hard as I could, don't expect patches to be available within professional delays.

If you think, you may be contributing to it, I'm open to any form of help.

For any help request, you may contact me by email, or, via the platform you discovered this tool, if I was the OP.

I don't have any form of paypal / financial support, as I don't want it. The greatest form of support may be starring this on github !

Thanks by advance !
