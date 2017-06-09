#C:\Program Files\University of Illinois\VMD>vmd -dispdev text -eofexit < C:\Users\bharat\Desktop\Review_AM1LW\coordinates.tcl
cd C:/Users/bharat/Desktop/Review_AM1LW
mol new H2O-128.xyz
mol addfile 128_water.dcd first 4000 last 20000 step 4 waitfor all

set nf [molinfo top get numframes]
set coorFile [open "pos_128.xyz" w]

#set nf 10
for {set i 1} {$i <= $nf} {incr i} {
	puts "Working Frame: $i"
	puts $coorFile "384"
	puts $coorFile "$i 128-water"
	for {set j 0} {$j <128} {incr j} {

		set sel [atomselect top "residue $j" frame $i]
		set coor [$sel get {x y z}]
		set coorO [lindex $coor 0]
		set coorH1 [lindex $coor 1]
		set coorH2 [lindex $coor 2]
		set O [lindex [$sel get name] 0]
		set H1 [lindex [$sel get name] 1]
		set H2 [lindex [$sel get name] 2]

		puts $coorFile "$O $coorO"
		puts $coorFile "$H1 $coorH1"
		puts $coorFile "$H2 $coorH2"
	}
	
	unset sel
	unset coor
	unset coorO
	unset coorH1
	unset coorH2
	unset O
	unset H1
	unset H2

}

close $coorFile
