#!/bin/bash

# Create a deb for all packages
for dir in `find projects -type d -maxdepth 1 | tail -n +2`; do
    dpkg-deb -bZgzip $dir debs
done

# Build packages file, bzip2 the file
dpkg-scanpackages -m . /dev/null > Packages
bzip2 -fks Packages
