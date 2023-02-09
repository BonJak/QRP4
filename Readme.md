### Quadrant Resizer
A simple shell script that resizes the currently focused window to fit within one of the four quadrants of the monitor.

#### Usage
To use the script, simply run ./quadrant_resizer.sh [quadrant number]. The quadrant number argument should be a number between 1 and 4, representing the quadrant you want the focused window to be resized to.

#### Dependencies
This script depends on the following tools:

* xrandr
* xdotool

#### Error handling
The script performs several error checks to ensure that the required tools are installed and working correctly. If any errors are encountered, an error message will be displayed and the script will exit with a non-zero exit code.


