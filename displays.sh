#!/bin/sh

# Function to display usage
usage() {
    echo "Usage: displays [save|reset]"
    exit 1
}

# Save function
save_display_settings() {
    # Save the output of displayplacer list to a file in the home directory
    displayplacer list > ~/displayplacer_output.txt

    # Store the contents of the file in a variable
    output=$(cat ~/displayplacer_output.txt)

    # Extract display information from the output and generate the setting command
    commands=$(echo "$output" | awk '
      BEGIN { id=""; width=""; height=""; hz=""; x=""; y=""; found_mode=0; }
      /Persistent screen id:/ {
        if (id != "" && found_mode) {
          print "displayplacer \"id:" id " res:" width "x" height " hz:" hz " origin:(" x "," y ")\""
        }
        id=$4; width=""; height=""; hz=""; x=""; y=""; found_mode=0;
      }
      /Resolution:/ {
        split($2, res, "x");
        width=res[1];
        height=res[2];
      }
      /Hertz:/ { hz=$2; }
      /Origin:/ {
        sub(/.*\(/, "", $2);
        split($2, coords, ",");
        x=coords[1];
        sub(/\)/, "", coords[2]);
        y=coords[2];
      }
      /mode [0-9]+:/ {
        if ($0 ~ /current mode/) {
          split($3, res, "x");
          width=res[1];
          height=res[2];
          found_mode=1;
        }
      }
      END {
        if (id != "" && found_mode) {
          print "displayplacer \"id:" id " res:" width "x" height " hz:" hz " origin:(" x "," y ")\""
        }
      }
    ')

    # Replace res:res: with res:
    commands=$(echo "$commands" | sed 's/res:res:/res:/g')

    # Create the ~/.displays directory
    mkdir -p ~/.displays

    # Save the generated command to ~/.displays/current
    echo "$commands" > ~/.displays/current

    # Delete the temporary file
    rm -fr ~/displayplacer_output.txt

    echo "Display settings saved to ~/.displays/current"
}

# Reset function
reset_display_settings() {
    if [ ! -f ~/.displays/current ]; then
        echo "No saved display settings found in ~/.displays/current"
        exit 1
    fi

    # Read and execute the saved settings
    while IFS= read -r line; do
        eval "$line"
    done < ~/.displays/current

    echo "Display settings restored from ~/.displays/current"
}

# Argument processing
if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    save)
        save_display_settings
        ;;
    reset)
        reset_display_settings
        ;;
    *)
        usage
        ;;
esac
