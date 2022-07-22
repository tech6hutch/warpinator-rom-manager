#! /usr/bin/bash

# Warpinator ROM Manager - moves ROMs from the Warpinator directory to your
# emulator directories.

# location for files received thru Warpinator
warpinatorDir="/home/deck/Warpinator"
# location of your rom directories
romDir="/home/deck/Emulation/roms"

# extension(s) to look for and their destination folder under romDir
declare -A parsers=(
    [.z64 .n64]=n64
    [.nds]=nds
)

# uncomment to show what files would be moved, without moving any
#dry=1


# start of script

if [ "$1" != 1 ]; then
    konsole -e bash -c "echo \"Don't execute this directly, use the other script!\"
    read -rsp \"Press enter to close...\""
    exit 1
fi

count=0

for file in ${warpinatorDir}/*; do
    [ -e "$file" ] || continue

    ((count++))
    dest=
    # see if any of the extensions match
    for exts in "${!parsers[@]}"; do
        for ext in $exts; do
            if [[ "$file" == *"$ext" ]]; then
                dest="$romDir/${parsers[$exts]}"
                break 2
            fi
        done
    done
    filename=$(basename -- "$file") # save some screen space in the output
    if [[ "$filename" == *" "* ]]; then filename=\'"$filename"\'; fi
    if [ -n "$dest" ]; then
        if [ $dry ]; then
            echo -n "Would move "
        else
            # do the actual move
            mv -i "$file" "$dest"
            echo -n "Moved "
        fi
        echo "$filename" to "$dest"
    else
        echo Ignoring "$filename"
    fi
done

if ((count == 0)); then
    echo No files found
fi

read -rsp "Press enter to close..."