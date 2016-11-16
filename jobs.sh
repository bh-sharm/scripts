#!/bin/bash
#description     :This script will submit multiple jobs 
#author          :Bharat Kumar Sharma at Concordia University, Montreal, Canada
#date            :November 16, 2016
#usage           :sh script.sh
# There is no support and no warranty. Use this script at your own risk.
#==============================================================================

dists="0.95 1.05 1.15 1.25 1.35 1.45 1.55"
for dist in  $dists
do
cp -r sample $dist
cd $dist
sed "s/VALUE/$dist/g" AM11.inp >AM1.inp
qsub -N A_water_${dist} briaree.cp2k
rm AM11.inp
cd ../

done

echo "Job submitted!!"
