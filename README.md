# Autonomous Vehicle Simulation

Autonomous vehicle simulation for studying driver distraction  
  

## Controls:

### Movement:
W: Move forward
A: Steer left
D: Steer right
S: Move backwards
Space: Break
Mouse: Camera Control

### Navigation:
TAB: Open/close map

While map is open...
Left Mouse Button: Choose destination on map
Right Mouse Button: Cancel chosen destination

### General
ESC: Open/close Simulation interface
Mouse wheel: Scroll up and down the list of results.
T: Reset Interaction data


## How to start a simulation test:

When you choose a destination on the map, the simulation test starts automatically.
The vehicle will drive autonomously to the selected destination and throught the journey the user will encounter variouse hazards that they have to avoid by taking control of the vehicle.
Avoiding these potential accidents can be done by hitting the breaks or steering away from them.
The simulation will keep of the reaction time of the user by taking into account how long it took the user to manually take control of the vehicle from the moment the hazard appeared infront of them.
When the vehicle reaches the selected destination you can open the Simulatio Interface with the "ESC" key in order to see the results (use the mouse wheel to scroll up and down to see all the results in the list).


## Using a different map for the simulation
The software uses OpenStreetMap files in order to generate the environment automatically. The map can be changed following these instructions:

1. Choose a location in OpenStreetMap website
2. Click on export then download the map (it should have the ".osm" file extension).
3. Rename this file to "map" (while keeping the file extension).
4. Replace the "map.osm" file located inside the "./osm" folder with your new file.
5. Run the simulation and it should automatically generate the environment based on your new OpenStreetMap file.

* You can find a few test maps that you can use inside the "./osm/test_maps" folder. Make sure to follow the instructions above to use one of these maps
