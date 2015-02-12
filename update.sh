./remove.sh
./packages.sh
./tweakup.sh

dpkg-scanpackages debs -m . >Packages
bzip2 Packages
