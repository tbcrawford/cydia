#!/bin/bash
# for dir in `find projects -type d -maxdepth 1 | tail -n +2`; do
# 	dpkg-deb -bZgzip $dir debs
# done

dpkg-deb -bZgzip projects/devrepos debs
dpkg-deb -bZgzip projects/infiniboot4 debs
dpkg-deb -bZgzip projects/infiniboot5 debs
dpkg-deb -bZgzip projects/infiniboot6 debs
dpkg-deb -bZgzip projects/infiniboot6plus debs
dpkg-deb -bZgzip projects/infiniloader debs
dpkg-deb -bZgzip projects/lockkeyboard1-beta2 debs
dpkg-deb -bZgzip projects/personalpackages debs
cd ../projects/firsttweak
make package
mv *.deb /Users/tylercrawford/Documents/Programming/github/tcrawford14.github.io/debs