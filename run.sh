#!/bin/bash

##### Package only the updated projects #####

# For each directory in the projects folder
# Get the Package name, Version number, and Architecture
# Concatenate these identifiers into a string equal to their debian file names
for dir in `find projects -type d -maxdepth 1 | tail -n +2`; do
    pkg=`grep -i "^Package:.*" $dir/DEBIAN/control | cut -c 10-`
    ver=`grep -i "^Version:.*" $dir/DEBIAN/control | cut -c 10-`
    arch=`grep -i "Architecture:.*" $dir/DEBIAN/control | cut -c 15-`
    pkgid="${pkg}_${ver}_${arch}.deb"

    # For each file in the debs folder
    for file in `ls debs`; do
        # If the file name equals the debian name (pkgid), 'exists' = "true"
        # else 'exists' = "false"
        if [ "$file" == "$pkgid" ]; then
            exist="true"
            break
        else
            exist="false"
        fi
    done

    # If exists = "false", build a deb of only that file
    if [ "$exist" == "false" ]; then
        dpkg-deb -bZgzip $dir debs
    fi
done

# Build packages file, bzip2 the file
dpkg-scanpackages -m . /dev/null > Packages
bzip2 -fks Packages
