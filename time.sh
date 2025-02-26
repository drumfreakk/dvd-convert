#!/usr/bin/zsh

#Arguments: current position in line, desired position in line
function align_upto () {
	local cur_pos=$1
	while [[ $cur_pos -lt $2 ]]; do
		printf " "
		cur_pos=$((cur_pos + 1))
	done
}

function echo_entry () {

	printf "$1"
	
	local cur_pos=${#1}

	if [[ $cur_pos -ge 43 ]]; then
		printf "\n"
		cur_pos=0
	fi
	
	align_upto $cur_pos 43

	printf "${2%.*}  \ts,\t%.1f\tmin\n" $(( $2 / 60 ))
}

function video_len () {
	len=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1`

	if [[ "$len" != "N/A" ]]; then
		printf $len
	fi
}

# Arguments: path from current dir, display path
function search_dir () {
	echo "\n" $2

	cd $1

	local dir_t=0

	local directories=()

	for file in *; do
		if [ -f "$file" ]; then
			len_s=$(video_len $file)
			dir_t=$(( dir_t + len_s ))
	
			echo_entry $file $len_s
	    elif [[ -d "$file" ]]; then
			directories+=($file)
		fi
	done

	for dir in $directories; do
		search_dir $dir "$2/$dir"
		dir_t=$(( dir_t + ? ))
	done

	echo_entry "$2 total:" $dir_t
	echo ""
	cd ..

	return dir_t
}

echo_entry "Total available time:" $(( 120 * 60 ))
search_dir $1 $1
