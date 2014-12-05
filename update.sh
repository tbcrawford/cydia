./remove.sh
./packages.sh

dpkg-scanpackages debs -m . >Packages
bzip2 Packages
