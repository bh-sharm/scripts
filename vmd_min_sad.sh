#!/bin/bash
#description     :This script will convert ART configuration files into VMD readable format and print energy values
#author          :Bharat Kumar Sharma at Concordia University, Montreal, Canada
#date            :March 2017
#usage           :sh script.sh
# There is no support and no warranty. Use this script at your own risk.
#==============================================================================
rm energy.dat  output.xyz
output=${1?output filename is missing!}

wc -l ../min1000 > aa
nline=$(awk '{ printf $1}' ./aa)
#echo "$nline"
#three=3
#natoms=$nline-$three
#echo "$natoms"
natoms=`echo "($nline - 3)" | bc`


grep -r 'accepted' ../events.list >accepted

list=$(awk '{ printf $1 " " $2 " "}' ./accepted)

coorLineNumber=3

for z in $list;do

# energy
energy=$(awk 'NR==2' ../$z)
printf  "$z $energy \n" >>energy.dat

printf  "$natoms\n" >>temp.xyz
printf "MOLECULAR TITLE $z\n" >>temp.xyz

for ((i=1; i<=$natoms; i++)); do
awk 'FNR=='$coorLineNumber+$i' {print $0}' ../${z} >>temp.xyz

done
done

sed 's/\([^ ]*\) [6]*[6][6]* /\1 C /; s/\([^ ]*\) [8]*[8][8]* /\1 O /; s/\([^ ]*\) [1]*[1][1]* /\1 H /; s/\([^ ]*\) [7]*[7][7]* /\1 N /' temp.xyz > $output


#clearing files
rm temp.xyz aa accepted
