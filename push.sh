#!/bin/bash
# dpkg-scanpackages . /dev/null > Packages
dpkg-scanpackages . > Packages
bzip2 -fks Packages