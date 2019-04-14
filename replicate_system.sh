#!/bin/bash


#check what input comes in for the following
<<LEARNED
mkdir -p test/{test1,test2}
creates folder test, then 2 sub folders test1 and test2
mkdir -p test/{test1,test2}/test3
creates folder test, then 2 sub folders test1 and test2 and creates test3 in each of them
LEARNED

<<THOUGHT
//format should look like
mkdir -p dir_name && git clone -C dir_name repoa


//method:
dir_name link_to_repo
THOUGHT

system_map_dir="~/.afkanerd/config"
system_map_file="${system_map_dir}/system_map.sh"

reset_default() {
	mkdir -p ${system_map_dir}
	echo "#!/bin/bash\n\n" >> ${system_map_file}
	chmod +x ${system_map_file}
	echo "initialization complete, system file created!"
}


if [ "$1" == "init" ] ; then
	if [ -f "$system_map_file" ] ; then
		echo "system file already present, no need to re-init"
	else
		reset_default
	fi

elif [ "$1" == "reset" ] ; then
	#put test to verify you know what you are doing
	echo "resetting structure to default"
	reset_default

elif [ "$1" == "ap" ] ; then
	if [ ! -f "$system_map_file" ] ; then
		echo "system not initialized, run \"init\" to create files"
	else
		echo "mkdir -p $(pwd) && git clone $2" >> ${system_map_file} 
		echo "directory added to system mapping"
	fi

else
	echo $1
	mkdir -p /home/sherlock/Desktop/14-04-2019 && git clone afkanerd.com
fi
#mkdir -p /home/sherlock/Desktop/14-04-2019 && git clone ap
