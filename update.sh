./remove.sh
./packages.sh

dpkg-scanpackages debs -m . /dev/null >Packages
bzip2 Packages
