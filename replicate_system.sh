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


default_backup="git@github.com:Wisdom-Nji/current_system_repos_moved_into_one_place_to_keep_shit_save_cus_i_wanna_game_and_dont_want_to_sta....git"

system_map_dir="$HOME/.afkanerd/config"
system_map_file="${system_map_dir}/system_map.sh"
todays_date=$(date -R)

hard_reset_default() {
	mkdir -p ${system_map_dir}
	echo -e "#!/bin/bash\n\n" > ${system_map_file}
	git -C ${system_map_dir} init && git -C ${system_map_dir} remote add origin ${default_backup}
}

reset_default() {
	#file already exist, so just remove and put back
	echo -e "#!/bin/bash\n\n" > ${system_map_file}
}


if [ "$1" == "init" ] ; then
	if [ -f "$system_map_file" ] ; then
		echo "system file already present, no need to re-init"
	else
		hard_reset_default
	fi

elif [ "$1" == "reset" ] ; then
	#put test to verify you know what you are doing
	echo "resetting structure to default"
	reset_default

elif [ "$1" == "cleanse" ] ; then
	echo "would not even ask if you are sure about this!"
	rm -rf ${system_map_dir}
	
elif [ "$1" == "backup" ] ; then
	git -C ${system_map_dir} add ${system_map_file}
	git -C ${system_map_dir} commit -m "${todays_date}"
	git -C ${system_map_dir} push origin master

elif [ "$1" == "show" ] ; then
	if [ ! -f "$system_map_file" ] ; then
		echo "system not initialized, run \"init\" to create files"
	else
		echo -e "------------------[FILE: ${system_map_file}]------------"
		cat ${system_map_file}
	fi

elif [ "$1" == "ap" ] ; then
	if [ ! -f "$system_map_file" ] ; then
		echo "system not initialized, run \"init\" to create files"
	else
		#check to make sure second arg has been passed
		#check if it's a git repo, or check of response from terminal command is empty
		if [ $(git remote get-url --all origin) ] ; then
			cd ..
			current_dir="$(pwd)"
			start_command="mkdir"
			if [ $(pwd | grep $HOME) ] ; then
				present_dir=$(pwd | grep -oP "$HOME\K.*")
				#echo "Present dir: ${present_dir}"
				current_dir="\$HOME${present_dir}"
			else
				start_command="sudo mkdir"
			fi
			cd -
			echo "${start_command} -p ${current_dir} && git clone $(git remote get-url --all origin)" >> ${system_map_file} 
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
