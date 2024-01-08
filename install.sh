#!/bin/bash

# Check if the requirements.txt file exists
if [ ! -f "requirements.txt" ]; then
    echo "Error: requirements.txt file not found."
    exit 1
fi

# Read each line from requirements.txt and install the packages
while IFS= read -r package; do
    # Remove leading and trailing whitespaces
    package=$(echo "$package" | xargs)

    # Install the package using sudo pacman -S
    sudo pacman -Sy  --noconfirm "$package"

    # Check the exit status of the pacman command
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install $package."
        exit 1
    fi
done < "requirements.txt"

echo "All packages installed successfully."


# Set the source and target directories
source_dir=$(pwd)
configs_dir="$HOME/.config"
fonts_dir="$HOME/.fonts"

# Ensure the target directories exist
mkdir -p "$configs_dir"
mkdir -p "$fonts_dir"

# Copy folders to ~/.configs or ~/.fonts based on the folder name
for folder in */; do
    # Remove trailing slash
    folder=${folder%/}

    if [ "$folder" == "fonts" ]; then
        # Copy to ~/.fonts
        cp -r "$source_dir/$folder" "$fonts_dir/"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to copy $folder to $fonts_dir."
            exit 1
        fi
    else
        # Copy to ~/.configs
        cp -r "$source_dir/$folder" "$configs_dir/"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to copy $folder to $configs_dir."
            exit 1
        fi
    fi
done

cp ./wallpaper.jpg $configs_dir

echo "Files copied successfully"

sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc

echo -e "exec sxhkd &\nexec bspwm &" >> ~/.xinitrc


echo "Configs installed successfully."
