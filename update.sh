./remove.sh
./packages.sh

dpkg-scanpackages . /dev/null > Packages
bzip2 -fks Packages
