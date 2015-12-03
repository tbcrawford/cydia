#!/bin/bash

working_dir=$(dirname $0) # what directory are we in/where is this script running?
cur=$(pwd)                # get the present working directory

cd "$working_dir"         # go to where this script is running

# If no more parameters are given, print out the usage
if [ $# -eq 0 ]; then
    printf "Usage: $0 [<option(s)>...]

Options:
  -b        build projects into deb if deb does not exist.
  -p        update the Packages file only.
  -u        push all updates to Github.
  -a        update all items and push updates to Github.
" >&2
    exit 1
fi

if [[ $1 == *"b"* || $1 == *"a"* ]]; then
        echo "Building packages..."
        for dir in `find projects -type d -maxdepth 1 | tail -n +2`; do
            pkg=`grep -i "^Package:.*" $dir/DEBIAN/control | cut -c 10-`
            ver=`grep -i "^Version:.*" $dir/DEBIAN/control | cut -c 10-`
            arch=`grep -i "Architecture:.*" $dir/DEBIAN/control | cut -c 15-`
            pkgid="${pkg}_${ver}_${arch}.deb"

            if [[ $(ls debs) ]]; then
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
            else
                # Build package normally
                dpkg-deb -bZgzip $dir debs
            fi
        done
fi

if [[ $1 == *"p"* || $1 == *"a"* ]]; then
    echo "Updating Packages file..."
    rm Packages.bz2
    rm Packages

    for deb in debs/*.deb; do
        echo "Processing $deb..."
        dpkg-deb -f "$deb" >> Packages
        MD5sum "$deb" | echo "MD5sum: $(awk '{ print $1 }')" >> Packages
        shasum -a 1 "$deb" | echo "SHA1: $(awk '{ print $1 }')" >> Packages
        shasum -a 256 "$deb" | echo "SHA256: $(awk '{ print $1 }')" >> Packages
        wc -c "$deb" | echo "Size: $(awk '{ print $1 }')" >> Packages
        echo "Filename: $deb" >> Packages
        dpkg-deb -f "$deb" Packages |  echo "Depiction: http://tbcrawford.github.io/depictions/?p=$(dpkg-deb -f $deb Package)" >> Packages
        echo "" >> Packages
    done

    # bzip2 < Packages > Packages.bz2
    # gzip -9c < Packages > Packages.gz
    bzip2 -fks Packages

fi

if [[ $1 == *"u"* || $1 == *"a"* ]]; then
    git add -A

    if [ -z "$2" ]; then
        now=$(date +"%r %D")
        git commit -m "Repo Updates - $now"
    else
        git commit -m "${*:2}"
    fi

    git push
    echo "Updated Github repository"
fi

cd "$cur"
