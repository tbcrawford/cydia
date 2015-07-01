# dpkg-deb -bZgzip projects/imgurloadingwheel debs
# dpkg-deb -bZgzip projects/infiniloader debs
# dpkg-deb -bZgzip projects/infiniboot4 debs
# dpkg-deb -bZgzip projects/infiniboot5 debs
# dpkg-deb -bZgzip projects/infiniboot6 debs
# dpkg-deb -bZgzip projects/infiniboot6plus debs
# dpkg-deb -bZgzip projects/personalpackages debs
# dpkg-deb -bZgzip projects/devrepos debs

directories=`find projects -type d -maxdepth 1 | tail -n +2`

for dir in $directories; do
	dpkg-deb -bZgzip $dir debs
done
