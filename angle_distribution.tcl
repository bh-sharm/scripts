#source C:/Users/bharat/Desktop/angle_distribution.tcl
# source C:/backup/Zn-H2O-H2S-system/DCD_files/Angle_distribution/angle_distribution.tcl
#source C:/backup/Zn-H2O-H2S-system/DCD_files/Angle_distribution/angle_distribution_OZnO_OZnS.tcl
#cd C:/backup/Zn-H2O-H2S-system/DCD_files/Angle_distribution
cd C:/Users/bharat/Desktop
set method "AM1"

#Zn-63 water
#mol new C:/backup/Zn-H2O-H2S-system/DCD_files/Unconstraints_AM1_PM3_ThisWork/Zn-63water-wrapped-Zn-center.xyz
#mol addfile C:/backup/Zn-H2O-H2S-system/DCD_files/Unconstraints_AM1_PM3_ThisWork/Thiswork_Zn_63Water.dcd first 4000 last -1 step 1 waitfor all

# Zn-1H2S-62 water
#mol new C:/backup/Zn-H2O-H2S-system/DCD_files/Zn-1H2S-62H2O_noConstraints_RDFs/Zn_1H2S_62H2O.xyz
#mol addfile C:/backup/Zn-H2O-H2S-system/DCD_files/Zn-1H2S-62H2O_noConstraints_RDFs/PM3_H2S.dcd first 4000 last -1 step 1 waitfor all

# Zn-1HS-62 water
mol new C:/backup/Zn-H2O-H2S-system/DCD_files/Zn_HS_62H2O_noConstraints_RDFs/Zn-1HS_62H2O.xyz
mol addfile C:/backup/Zn-H2O-H2S-system/DCD_files/Zn_HS_62H2O_noConstraints_RDFs/$method.dcd first 4000 last -1 step 1000 waitfor all



set nf [molinfo top get numframes]

# For OZnS
set angledistOZnS [open "${method}_OZnS_HS-.dat" w]
puts $angledistOZnS "Frame : OZnS_degree : costheta"

# For OZnO
set angledist [open "${method}_OZnO_HS-.dat" w]
puts $angledist "Frame : OZnO_degree : costheta" 


	pbc set {12.4138 12.4138 12.4138} -all
#	pbc wrap -centersel "residue 0 " -center com -compound residue -first 0 -last 16002 waitfor all

	set selzn [atomselect top "name Zn"]
	set selS [atomselect top "name S"]
	set selO [atomselect top "name O and within 3 of name Zn"]

	for {set j 1} {$j < $nf} {incr j} {
#	mol selupdate 0 0 1

	pbc wrap -centersel "residue 0 " -center com -compound residue -first $j -last $j

	
	$selzn frame $j
	$selO frame $j
	$selS frame $j
	
	set indexzn [$selzn get index]
	set indexO [$selO get index]
	set indexS [$selS get index]
	
	puts $indexO
	
	set i 0 
	foreach O $indexO {
	set Oarray($i) $O
	incr i
	}
	puts $i
		for {set a 0} {$a < $i} {incr a} {
			for {set b [expr $a+1]} {$b <[expr $i]} {incr b} {

			set OZnO [measure angle "$Oarray($a) $indexzn $Oarray([expr $b])" frame $j]

			set costheta [expr cos($OZnO*3.1415926535897/180)]
			
#puts $angledist "$j : [expr {double (round(10*$OZnO))/10}] : [expr {double (round(10*$costheta))/10}]"
puts $angledist "$j : [expr {double (round(1*$OZnO))/1}] : [expr {double (round(10*$costheta))/10}]"


				}
			}
			
			
# For OZnS

		for {set c 0} {$c < $i} {incr c} {

			set OZnS [measure angle "$Oarray($c) $indexzn $indexS" frame $j]
			
			set costhetaS [expr cos($OZnS*3.1415926535897/180)]
			

#puts $angledistOZnS "$j : [expr {double (round(10*$OZnS))/10}] : [expr {double (round(10*$costhetaS))/10}]"
puts $angledistOZnS "$j : [expr {double (round(1*$OZnS))/1}] : [expr {double (round(10*$costhetaS))/10}]"

			}

}
close $angledist
close $angledistOZnS
