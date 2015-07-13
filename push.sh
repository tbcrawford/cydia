#!/bin/bash
dpkg-scanpackages -m . /dev/null > Packages
bzip2 -fks Packages