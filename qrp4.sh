quadrant=$1

# Check if the quadrant argument is provided
if [ -z "$quadrant" ]; then
    echo "Error: missing quadrant argument. Please provide a quadrant number (1, 2, 3, or 4)."
    exit 1
fi

# Check if the quadrant argument is valid
if [ $quadrant -lt 1 ] || [ $quadrant -gt 4 ]; then
    echo "Error: invalid quadrant argument. Please provide a number between 1 and 4."
    exit 1
fi

# Get the current screen width and height
widths=()
heights=()

screen_width=$(xrandr | grep '*' | awk '{print $1}' | cut -d 'x' -f1)
if [ $? -ne 0 ]; then
    echo "Error: xrandr command failed."
    exit 1
fi

screen_height=$(xrandr | grep '*' | awk '{print $1}' | cut -d 'x' -f2)
if [ $? -ne 0 ]; then
    echo "Error: xrandr command failed."
    exit 1
fi

while read -r line; do
		widths+=("$line")
done <<< "$screen_width"

while read -r line; do
		heights+=("$line")
done <<< "$screen_height"


# get the currently focused window

focused_window=$(xdotool getactivewindow)
if [ $? -ne 0 ]; then
    echo "Error: xdotool command failed."
    exit 1
fi

# Get the current window width and height
window_width=$(xdotool getwindowgeometry $focused_window | awk '/Geometry:/ {print $2}' | cut -d x -f1)
if [ $? -ne 0 ]; then
    echo "Error: xdotool command failed."
    exit 1
fi

window_height=$(xdotool getwindowgeometry $focused_window | awk '/Geometry:/ {print $2}' | cut -d x -f2)
if [ $? -ne 0 ]; then
    echo "Error: xdotool command failed."
    exit 1
fi

# Get the current window position

window_x=$(xdotool getwindowgeometry $focused_window | awk '/Position:/ {print $2}' | cut -d , -f1)
if [ $? -ne 0 ]; then
    echo "Error: xdotool command failed."
    exit 1
fi

window_y=$(xdotool getwindowgeometry $focused_window | awk '/Position:/ {print $2}' | cut -d , -f2)
if [ $? -ne 0 ]; then
    echo "Error: xdotool command failed."
    exit 1
fi

# if position is in the other monitor, determine the index of the monitor

if [ $window_x -gt "${widths[0]}" ]; then
		monitor_index=1
else
		monitor_index=0
fi

new_window_width=$((${widths[$monitor_index]} / 2))
new_window_height=$((${heights[$monitor_index]} / 2))

new_window_width=$(($new_window_width + 40))
new_window_height=$(($new_window_height + 40))

first_quad_x=$((${widths[$monitor_index]} / 2))
first_quad_y=0

second_quad_x=0
second_quad_y=0

third_quad_x=0
third_quad_y=$((${heights[$monitor_index]} / 2))

fourth_quad_x=$((${widths[$monitor_index]} / 2))
fourth_quad_y=$((${heights[$monitor_index]} / 2))


if [ $quadrant -eq 1 ]; then
	new_window_x=$(($first_quad_x - 40))
	new_window_y=$first_quad_y
elif [ $quadrant -eq 2 ]; then
	new_window_x=$(($second_quad_x - 40))
	new_window_y=$second_quad_y
elif [ $quadrant -eq 3 ]; then
	new_window_x=$(($third_quad_x - 40))
	new_window_y=$(($third_quad_y - 20))
elif [ $quadrant -eq 4 ]; then
	new_window_x=$(($fourth_quad_x - 40))
	new_window_y=$(($fourth_quad_y - 20))
fi

xdotool windowsize $focused_window $new_window_width $new_window_height
xdotool windowmove $focused_window $new_window_x $new_window_y
