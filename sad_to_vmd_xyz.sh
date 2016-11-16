#!/bin/bash
rm temp.xyz
natoms=8


grep -r 'accepted' ../events.list >accepted
list=$(awk '{ printf $2 " "}' ./accepted)

#list=$(awk '{ printf $2 " "}' ../events.list)

coorLineNumber=3

for z in $list;do

printf  "8\n" >>temp.xyz
printf "MOLECULAR TITLE\n" >>temp.xyz

for ((i=1; i<=$natoms; i++)); do
awk 'FNR=='$coorLineNumber+$i' {print $0}' ../${z} >>temp.xyz

done
done

sed 's/\([^ ]*\) [6]*[6][6]* /\1 C /' temp.xyz > output_C.xyz
sed 's/\([^ ]*\) [1]*[1][1]* /\1 H /' output_C.xyz > output.xyz

#clearing files
rm temp.xyz output_C.xyz 

