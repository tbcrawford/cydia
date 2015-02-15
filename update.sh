./remove.sh
./packages.sh
./import.sh

dpkg-scanpackages debs -m . >Packages
bzip2 Packages
