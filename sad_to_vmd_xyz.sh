#!/bin/bash
#description     :This script will convert ART configuration files into VMD readable format
#author		 :Bharat Kumar Sharma at Concordia University, Montreal, Canada
#date            :November 16, 2016
#usage		 :sh script.sh
# There is no support and no warranty. Use this script at your own risk.
#==============================================================================

natoms=8


grep -r 'accepted' ../events.list >accepted
list=$(awk '{ printf $2 " "}' ./accepted)

#list=$(awk '{ printf $2 " "}' ../events.list)

coorLineNumber=3

for z in $list;do

printf  "$natoms\n" >>temp.xyz
printf "MOLECULAR TITLE\n" >>temp.xyz

for ((i=1; i<=$natoms; i++)); do
awk 'FNR=='$coorLineNumber+$i' {print $0}' ../${z} >>temp.xyz

done
done

#sed 's/\([^ ]*\) [6]*[6][6]* /\1 C /' temp.xyz > output_C.xyz
#sed 's/\([^ ]*\) [1]*[1][1]* /\1 H /' output_C.xyz > output.xyz
sed 's/\([^ ]*\) [6]*[6][6]* /\1 C /; s/\([^ ]*\) [1]*[1][1]* /\1 H /' temp.xyz > output.xyz
#sed 's/\([^ ]*\) [6]*[6][6]* /\1 C /; s/\([^ ]*\) [8]*[8][8]* /\1 O /; s/\([^ ]*\) [1]*[1][1]* /\1 H /' temp.xyz > output.xyz

#clearing files
rm temp.xyz 

