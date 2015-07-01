#!/bin/bash
for dir in `find projects -type d -maxdepth 1 | tail -n +2`; do
	dpkg-deb -bZgzip $dir debs
done
