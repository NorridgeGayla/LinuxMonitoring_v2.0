#!/bin/bash

chmod +x check_functions.sh
chmod +x get_info.sh

. ./check_functions.sh
. ./get_info.sh

output=$( check_num_parameters $# )

if [[ $output -eq 0 ]]
then
    exit 1
fi

START=$( date +%H:%M:%S)

echo "$START Start script" >&2
echo "Processing..." >&2


function delete_log_files {
    for (( i=1; i < 6; i++ ))
    do
        rm -f "$i.log"
    done
}

if [[ $output -eq 1 ]]
then
    delete_log_files
    for (( i=1; i < 6; i++ ))
    do
        amount=$( get_random 100 901 )
        file_date=$( get_date )
        for (( j=0; j < amount; j++))
        do
            ip=$( get_ip )
            status=$( get_status )
            method=$( get_method )
            file_time=$( get_time )
            url=$( get_url )
            agent=$( get_agent )
            echo "$ip - - [${file_date}:${file_time} +0400] \"$method ${url}\" $status - \"-\" \"${agent}\"" >> "${i}_tmp.log"
        done
    done
    for (( i=1; i < 6; i++ ))
    do
        sort -k 4 "${i}_tmp.log" > "$i.log"
        rm "${i}_tmp.log"
    done
fi

END=$( date +%H:%M:%S )
echo "$END End script" >&2
TOTAL="$(( $( date +%s -d $END ) - $( date +%s -d $START ) ))"
MIN=$( expr $TOTAL / 60 )
SEC=$(( $TOTAL - $MIN * 60 ))
echo "Total script running time $( printf "%02d" $MIN ):$( printf "%02d" $SEC )" >&2
