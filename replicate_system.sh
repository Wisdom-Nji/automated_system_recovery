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

system_map_dir="$HOME/.afkanerd/config"
system_map_file="${system_map_dir}/system_map.sh"

reset_default() {
	mkdir -p ${system_map_dir}
	echo -e "#!/bin/bash\n\n" >> ${system_map_file}
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
	rm -r ${system_map_file}
	reset_default

elif [ "$1" == "ap" ] ; then
	if [ ! -f "$system_map_file" ] ; then
		echo "system not initialized, run \"init\" to create files"
	else
		#check to make sure second arg has been passed
		#check if it's a git repo, or check of response from terminal command is empty
		if [ $(git remote get-url --all origin) ] ; then
			cd ..
			current_dir="$(pwd)"
			if [ $(pwd | grep $HOME) ] ; then
				present_dir=$(pwd | grep -oP "$HOME\K.*")
				echo "Present dir: ${present_dir}"
				current_dir="\$HOME${present_dir}"
			fi
			cd -
			echo "mkdir -p ${current_dir} && git clone $(git remote get-url --all origin)" >> ${system_map_file} 
			echo "directory added to system mapping"
		else
			echo "seems no git project is present here"
		fi
	fi

else
	#first check if it's initialized
	${system_map_file}
fi
#mkdir -p /home/sherlock/Desktop/14-04-2019 && git clone ap
