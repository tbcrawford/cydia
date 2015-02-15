./remove.sh
./packages.sh
#./import.sh

dpkg-scanpackages -m . /dev/null > Packages
bzip2 Packages
