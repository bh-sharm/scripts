#!/bin/bash
#-----------------------------------------------------------------------------------------------
# This file calculates the sensitivity of Semiempirical Parameters for water Monomer and Dimer.
# Written by Bharat K. Sharma on June 6, 2015 at CERMM lab Concordia University
#-----------------------------------------------------------------------------------------------

#CLEARING FILES
rm *.out

#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>OODimer.out
#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>OH1Monomer.out
#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>OH2Monomer.out
#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>costhetaMonomer.out
#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>bindingEnergyDimer.out
#echo -e "-0.005\t -0.004\t -0.003\t -0.002\t -0.001\t 0.000\t 0.001\t 0.002\t 0.003\t 0.004\t 0.005" >>angleBisector.out

printf  "i OO OH1 OH2 costheta_monomer bindingEnergy cosAngleBisector \n" >>all.out

# loop for PARAMETERS
#for num in {1..1};do

i=$(echo "1.0" | bc)
for a in {0..99};do

#echo $i
i=$(echo "$i+0.01" | bc)


#var1=$(awk 'NR=='$num' {print $3}' PARAM)
#var2=`echo "($var1 - $var1*$i)" | bc`
sed "s/GNORM=1.0/GNORM=$i/g" monomer_bak.mop >monomer.mop
sed "s/GNORM=1.0/GNORM=$i/g" dimer_bak.mop >dimer.mop

# RUNNING MOPAC 
./runmopac monomer
./runmopac dimer

# BINDING ENERGY CALCULATION STARTS

lineCoorDimer=$(sed -n '/ATOMIC ORBITAL ELECTRON POPULATIONS/=' dimer.out)
lineCoorMonomer=$(sed -n '/ATOMIC ORBITAL ELECTRON POPULATIONS/=' monomer.out)

EnergyLineDimer=$(sed -n '/FINAL HEAT OF FORMATION/=' dimer.out)
EnergyDimer=$(awk 'FNR == '$EnergyLineDimer' {print $6}' dimer.out)

#echo $EnergyDimer

EnergyLineMonomer=$(sed -n '/FINAL HEAT OF FORMATION/=' monomer.out)
EnergyMonomer=$(awk 'FNR == '$EnergyLineMonomer' {print $6}' monomer.out)

# binding energy calculation
bindingEnergy=`echo "($EnergyDimer - 2 * $EnergyMonomer)" | bc`

#BINDING ENERGY CALCULATION ENDS

# DIMER

O1x=$(awk 'FNR == '$lineCoorDimer-8' {print $3}' dimer.out)
O1y=$(awk 'FNR == '$lineCoorDimer-8' {print $4}' dimer.out)
O1z=$(awk 'FNR == '$lineCoorDimer-8' {print $5}' dimer.out)
O2x=$(awk 'FNR == '$lineCoorDimer-5' {print $3}' dimer.out)
O2y=$(awk 'FNR == '$lineCoorDimer-5' {print $4}' dimer.out)
O2z=$(awk 'FNR == '$lineCoorDimer-5' {print $5}' dimer.out)

# hydrogen_bisector
HB1x=$(awk 'FNR == '$lineCoorDimer-7' {print $3}' dimer.out)
HB1y=$(awk 'FNR == '$lineCoorDimer-7' {print $4}' dimer.out)
HB1z=$(awk 'FNR == '$lineCoorDimer-7' {print $5}' dimer.out)
HB2x=$(awk 'FNR == '$lineCoorDimer-6' {print $3}' dimer.out)
HB2y=$(awk 'FNR == '$lineCoorDimer-6' {print $4}' dimer.out)
HB2z=$(awk 'FNR == '$lineCoorDimer-6' {print $5}' dimer.out)

#bisector coordinate
HBx=$(echo "$HB1x $HB2x" | awk '{printf "%.10f \n", ($1+$2)/2}')
HBy=$(echo "$HB1y $HB2y" | awk '{printf "%.10f \n", ($1+$2)/2}')
HBz=$(echo "$HB1z $HB2z" | awk '{printf "%.10f \n", ($1+$2)/2}')

#O1-HB distance
O1O2=$(echo "$O1x $O1y $O1z $O2x $O2y $O2z" | awk '{printf "%.10f \n", (sqrt(($1-$4)^2+($2-$5)^2+($3-$6)^2))}')
O1HB=$(echo "$O1x $O1y $O1z $HBx $HBy $HBz" | awk '{printf "%.10f \n", (sqrt(($1-$4)^2+($2-$5)^2+($3-$6)^2))}')
O2HB=$(echo "$O2x $O2y $O2z $HBx $HBy $HBz" | awk '{printf "%.10f \n", (sqrt(($1-$4)^2+($2-$5)^2+($3-$6)^2))}')


cosAngleBisector=$(echo "$O1HB $O1O2 $O2HB" | awk '{printf "%.10f \n", (($1)^2 + ($2)^2 - ($3)^2)/(2*$1*$2)}')


deltsq=`echo "($O1x - $O2x)^2+($O1y - $O2y)^2+($O1z - $O2z)^2" | bc`
OO=$(echo "sqrt($deltsq)" | bc)

# MONOMER

MO1x=$(awk 'FNR == '$lineCoorMonomer-5' {print $3}' monomer.out)
MO1y=$(awk 'FNR == '$lineCoorMonomer-5' {print $4}' monomer.out)
MO1z=$(awk 'FNR == '$lineCoorMonomer-5' {print $5}' monomer.out)
MH1x=$(awk 'FNR == '$lineCoorMonomer-4' {print $3}' monomer.out)
MH1y=$(awk 'FNR == '$lineCoorMonomer-4' {print $4}' monomer.out)
MH1z=$(awk 'FNR == '$lineCoorMonomer-4' {print $5}' monomer.out)
MH2x=$(awk 'FNR == '$lineCoorMonomer-3' {print $3}' monomer.out)
MH2y=$(awk 'FNR == '$lineCoorMonomer-3' {print $4}' monomer.out)
MH2z=$(awk 'FNR == '$lineCoorMonomer-3' {print $5}' monomer.out)


MOH1=`echo "($MO1x - $MH1x)^2+($MO1y - $MH1y)^2+($MO1z - $MH1z)^2" | bc`
OH1=$(echo "sqrt($MOH1)" | bc)

MOH2=`echo "($MO1x - $MH2x)^2+($MO1y - $MH2y)^2+($MO1z - $MH2z)^2" | bc`
OH2=$(echo "sqrt($MOH2)" | bc)

MH1H2=`echo "($MH1x - $MH2x)^2+($MH1y - $MH2y)^2+($MH1z - $MH2z)^2" | bc`
H1H2=$(echo "sqrt($MH1H2)" | bc)

# Monomer angle

costheta1=`echo "($OH1)^2+($OH2)^2-($H1H2)^2" | bc`

costheta=$(echo "$costheta1 $OH1 $OH2" | awk '{printf "%.10f \n", $1/(2*$2*$3)}')

printf  "$i $OO\n" >>OODimer.out
printf  "$i $OH1\n" >>OH1Monomer.out
printf  "$i $OH2\n" >>OH2Monomer.out
printf  "$i $costheta\n" >>costhetaMonomer.out
printf  "$i $bindingEnergy\n" >>bindingEnergyDimer.out
printf  "$i $cosAngleBisector\n" >>cosAngleBisector.out

printf  "$i $OO $OH1 $OH2 $costheta $bindingEnergy $cosAngleBisector\n" >>all.out



# WRITING RESULTS IN EXTERNAL FILE

#printf "%s \t" $OO >>OODimer.out
#printf "%s \t" $OH1 >>OH1Monomer.out
#printf "%s \t" $OH2 >>OH2Monomer.out
#printf "%s \t" $costheta >>costhetaMonomer.out
#printf "%s \t" $bindingEnergy >>bindingEnergyDimer.out
#printf "%s \t" $cosAngleBisector >>angleBisector.out

done

# end for increment loop
#printf "\n" >>OODimer.out
#printf "\n" >>OH1Monomer.out
#printf "\n" >>OH2Monomer.out
#printf "\n" >>costhetaMonomer.out
#printf "\n" >>bindingEnergyDimer.out
#printf "\n" >>angleBisector.out

# end for parameter loop
#done
