#!/bin/bash
#description     :This script extracts "FINAL HEAT OF FORMATION" from MOPAC output
#author          :Bharat Kumar Sharma at Concordia University, Montreal, Canada
#date            :December 22, 2016
#usage           :sh heat.sh
# This code is not optimized. Quickly written for quick job. 
#There is no support and no warranty. Use this script at your own risk.
#==============================================================================


rm AM1.output PM3.output thiswork.output
jobs1="3407 3610 3593 3422 3610 3768 3442 3610 3590 3638 3610 3767 3581 3593 3441 3590 3817 3590 3816 3593 3779 3590 3593"
#jobs1="3817 3581"
#jobs1="3817 3581 3407 3422 3442 3638 3593 3590 3779 3441 3816 3768 3767"


## FOR AM1 STARTS
output=AM1
for job in  $jobs1
do
cp ../../${job}_1.mop .

sed "s/PM3/AM1/g" ${job}_1.mop > ${job}.mop
#sed "s/PM3/AM1/g" ${job}_1.mop > ${job}.mop
#sed "s/PM3/PM3/g" ${job}_1.mop > ${job}.mop

./runmopac ${job}

EnergyLine=$(sed -n '/FINAL HEAT OF FORMATION/=' ${job}.out)
Energy=$(awk 'FNR == '$EnergyLine' {print $6}' ${job}.out)

printf "%s \t" $job $Energy >>${output}.output
printf "\n" >>${output}.output

done
rm *.mop *.log *.arc FOR024 *.out

## FOR AM1 ENDS

## FOR PM3 STARTS
output=PM3
for job in  $jobs1
do
cp ../../${job}_1.mop .

sed "s/PM3/PM3/g" ${job}_1.mop > ${job}.mop

./runmopac ${job}

EnergyLine=$(sed -n '/FINAL HEAT OF FORMATION/=' ${job}.out)
Energy=$(awk 'FNR == '$EnergyLine' {print $6}' ${job}.out)

printf "%s \t" $job $Energy >>${output}.output
printf "\n" >>${output}.output

done
rm *.mop *.log *.arc FOR024 *.out
## FOR PM3 ENDS

## FOR THISWORK STARTS
output=thiswork
#output=AM1
#output=PM3
for job in  $jobs1
do
cp ../../${job}_1.mop .

sed "s/PM3/AM1 EXTERNAL=PARAM-74452/g" ${job}_1.mop > ${job}.mop

./runmopac ${job}

EnergyLine=$(sed -n '/FINAL HEAT OF FORMATION/=' ${job}.out)
Energy=$(awk 'FNR == '$EnergyLine' {print $6}' ${job}.out)

printf "%s \t" $job $Energy >>${output}.output
printf "\n" >>${output}.output

done
rm *.mop *.log *.arc FOR024 *.out

paste <(awk '{print $0}' AM1.output ) <(awk '{print $2}' PM3.output ) <(awk '{print $2}' thiswork.output ) >combined
