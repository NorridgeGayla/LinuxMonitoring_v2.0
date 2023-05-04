#!/bin/bash

chmod +x check_functions.sh

. ./check_functions.sh

parameters=( $@ )

check=$( check_num_parameters $# )

if [[ $check -eq 1 ]]
then
    check=$( check_path ${parameters[0]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_number_dir ${parameters[1]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_name_dir ${parameters[2]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_number_files ${parameters[3]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_name_file ${parameters[4]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_file_size ${parameters[5]} )
fi

chmod +x create_files.sh

if [[ $check -eq 1 ]]
then
    ./create_files.sh $@
fi
