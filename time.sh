#!/usr/bin/zsh

echo "Total available time:                      " $(( 120 * 60 )) "s,\t 120\tmin\n"

cd ../converted/

total_t=0

for file in *; do
    if [ -f "$file" ]; then
		strlen=${#file}
		cur_pos=$strlen

		len_s=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ${file}`
		
		total_t=$(( $total_t + $len_s ))

		echo -n $file

		while [ ${cur_pos} -lt 44 ]; do
			echo -n " "
			cur_pos=$(( $cur_pos + 1 ))
		done

		echo ${len_s%.*} "s,\t" $(printf "%.1f" $(( $len_s / 60 )) ) "\tmin"
    fi
done

echo "\nTotal time:                                " ${total_t%.*} "s,\t" $(printf "%.1f" $(( $total_t / 60 )) ) "\tmin"
