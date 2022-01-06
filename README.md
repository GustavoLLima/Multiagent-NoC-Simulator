# What is that?

This is a high level abstraction NoC (Network-On-Chip) simulator developed as a Multiagent System (MAS). The simulator allows designers to evaluate routing algorithms, test alternative configurations and message formats. The simulation provides important measurements such as rate of utilization of routers, network contention and delay in sending messages.

You can get more details about the simulator construction/usage, along with case studies, on this academic article:
##A Multi-Agent-Based Network-on-Chip Simulator
https://jics.org.br/ojs/index.php/JICS/article/view/268

# Requirements

All you need to run the simulator is NetLogo. You can find more about NetLogo on:
https://ccl.northwestern.edu/netlogo/

The simulator runs on version 6.0.4 of NetLogo.

# How to use:

On the NetLogo interface, you can see buttons, green sliders/selectors, yellow monitors and the simulation grid. Each one works as follow:
- Green sliders/selectors - Here you can choose the simulation options, such as: routing algorithm, arbitrator, simulation length, routers internal configurations and so on.
- Yellow monitors - Shows information about the simulation on real time. You can check execution time, packet/flits injection, min/avg/max of hops, latency an so on.
- Simulation grid - Here (if you didn't disabled view display) you can see the simulation. Each square represents a router. The routers are represented in collors, that indicates their occupancy-rate. The rates are:
0 - White
1~24 - Blue
25~49 - Green
50~74 - Yellow
75~99 - Red
100 - Black

Besides the simulation interface, you can check/generate three type of extra information:
- CSV raw files (showing everything about the simulation on each simulation cycle, such as: occupancy rate of each in/out port for every direction for all the routers)
- Images from the simulation
- .plt files (I used them to generate Heatmaps of the NoC)

# Extra

Feel free to use the simulator as you wish. If any study you do generate any kind of article, please don't forget to refer the article cited on the first section of this page. If you need any help, you can contact me at any time.