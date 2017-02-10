mol delete top
set first 1
set last 800
set step 2
set msdlength [expr {int(double( 0.5*$last/$step))}]
#set msdlength 400

#cd C:/Users/bharat/Desktop/vmd-tutorial/H-bond-MSD-new/NEW
cd C:/Users/bharat/Desktop/vmd-tutorial/MSD-FINAL

set missing_i {}


file mkdir 1ps_final
cd 1ps_final
mol new C:/Users/bharat/Desktop/vmd-tutorial/msd-script/new_msd/64-water-test.xyz
mol addfile C:/backup/SE_model_for_Proton_transfer_reaction/NVE-DCD-MSD-POSITION-MOLECULAR_DIPOLE-FILES/32791-NVE/run-01_10ps.dcd first $first last $last step $step waitfor all
set nf [molinfo top get numframes]

pbc set {12.4138 12.4138 12.4138} -all
 

set all [atomselect top all]
set residues [lsort -unique -integer [$all get residue]]


set hb00 [open "hb00.dat" w]
set hb01 [open "hb01.dat" w]
set hb02 [open "hb02.dat" w]
set hb10 [open "hb10.dat" w]
set hb11 [open "hb11.dat" w]
set hb12 [open "hb12.dat" w]
set hb20 [open "hb20.dat" w]
set hb21 [open "hb21.dat" w]
set hb22 [open "hb22.dat" w]

set hb0 [open "hb0.dat" w]
set hb1 [open "hb1.dat" w]
set hb2 [open "hb2.dat" w]
set hb3 [open "hb3.dat" w]
set hb4 [open "hb4.dat" w]

# change
set msdfile [open "msd10_2step.dat" w]    
for {set n 0} {$n < [expr $msdlength]} {incr n} {
	set sum($n) 0.00
}

for {set i 0} {$i <$msdlength} {incr i} {
#if {$i != 11 && $i != 12 && $i != 26 && $i != 27 && $i != 51 && $i != 69 && $i != 70 && $i != 84 && $i != 90 && $i != 91}
set list00 {}
set list01 {}
set list02 {}
set list10 {}
set list11 {}
set list12 {}
set list20 {}
set list21 {}
set list22 {}
set listrest {}

set number00 0
set number01 0
set number02 0
set number10 0
set number11 0
set number12 0
set number20 0
set number21 0
set number22 0
set numberrest 0




set list0 {}
set list1 {}
set list2 {}
set list3 {}
set list4 {}

set number0 0
set number1 0
set number2 0
set number3 0
set number4 0
set numberrest 0


foreach res $residues {
#    set res 36
	set aa [atomselect top "residue $res" frame $i]
	set aa_index [$aa get index]
	set wat [atomselect top "all not residue $res" frame $i]
	set wat_index [$wat get index]
	
	pbc wrap -centersel "residue $res " -center com -compound residue -first $i -last $i

	set nhbD [llength [lindex [measure hbonds 3.5 30 $aa $wat] 0]]
	set nhbA [llength [lindex [measure hbonds 3.5 30 $wat $aa] 0]]
#	$aa delete
#	$wat delete
#	unset aa
#	unset wat
			if {$nhbD == 0 && $nhbA == 0} {
			lappend list00 $res
			lappend list00_all $res
			set number00 [expr $number00 + 1]
			}
			
			if {$nhbD == 0 && $nhbA == 1} {
			lappend list01 $res
			lappend list01_all $res
			set number01 [expr $number01 + 1]
			}
			
			
			if {$nhbD == 0 && $nhbA == 2} {
			lappend list02 $res
			lappend list02_all $res
			set number02 [expr $number02 + 1]
			}
			
			if {$nhbD == 1 && $nhbA == 0} {
			lappend list10 $res
			lappend list10_all $res
			set number10 [expr $number10 + 1]
			}
			
			if {$nhbD == 1 && $nhbA == 1} {
			lappend list11 $res
			lappend list11_all $res
			set number11 [expr $number11 + 1]
			}
			
			
			if {$nhbD == 1 && $nhbA == 2} {
			lappend list12 $res
			lappend list12_all $res
			set number12 [expr $number12 + 1]
			}
			
			if {$nhbD == 2 && $nhbA == 0} {
			
			lappend list20 $res
			lappend list20_all $res
			set number20 [expr $number20 + 1]
			}
			
			if {$nhbD == 2 && $nhbA == 1} {
			lappend list21 $res
			lappend list21_all $res
			set number21 [expr $number21 + 1]
			}
			
			if {$nhbD == 2 && $nhbA == 2} {
	
			lappend list22 $res
			lappend list22_all $res
			set number22 [expr $number22 + 1]
			}
		set total [expr {$nhbA + $nhbD}]

		if {$total == 0} {
		lappend list0 $res
		set number0 [expr $number0 + 1]
		}
		if {$total == 1} {
		lappend list1 $res 
		set number1 [expr $number1 + 1]
		}
		if {$total == 2} {
		lappend list2 $res 
		set number2 [expr $number2 + 1]
		}
		if {$total == 3} {
		lappend list3 $res 
		set number3 [expr $number3 + 1]
		}
		if {$total == 4} {
		lappend list4 $res 
		set number4 [expr $number4 + 1]
		}
	if {$total > 4} {
	puts "Warning: Hydrogen bonds are greater than 4 for $res, frame $i"
	}
# foreach
}

# MSD CALCULATION STARTS

mol delete top
#mol new C:/Users/bharat/Desktop/vmd-tutorial/msd-script/new_msd/64-water-test.xyz
mol new C:/Users/bharat/Desktop/NVE-31-water.xyz
mol addfile C:/backup/SE_model_for_Proton_transfer_reaction/NVE-DCD-MSD-POSITION-MOLECULAR_DIPOLE-FILES/32791-NVE/run-01_10ps.dcd first $first last $last step $step waitfor all

# selection is for each type of H-bond 00-$list00 01-$list01 and so on
# change
set selection $list10

if {$selection == ""} {
	lappend missing_i $i
}

if {$selection != ""} {
set atmname "name O and residue $selection"
#set atmname "name O and residue 0"



set sel [atomselect top "$atmname"]
set idxlist [$sel get index]
$sel delete

# loop over residues

for {set k [expr $i]} {$k <[expr $i+$msdlength]} {incr k} {
set msd 0.0
	foreach idx $idxlist {

    set sel [atomselect top "index $idx"]
	$sel frame $i
	set ref [measure center $sel]
	$sel frame [expr $k]
	set poslist [measure center $sel]
	set msd [expr $msd + [veclength2 [vecsub $ref $poslist]]]
	
	}
# change
	set msdarray($i,$k) [expr $msd/$number10]
#	puts "$i $k $msdarray($i,$k)"
}


#for {set i 0} {$i <$msdlength} {incr i} 

#	for {set m 0} {$m <$msdlength} {incr m} {
#		set sum($i) [expr $sum($i)+$msdarray($i,[expr $m+$i])]
#}

#set t [expr $i * 0.0025* $step]
#puts $msdfile "$i [expr $sum($i)/$msdlength]"
#

}

# MSD CALCULATION ENDS 


puts $hb00 "$i|$number00|$list00"
puts $hb01 "$i|$number01|$list01"
puts $hb02 "$i|$number02|$list02"
puts $hb10 "$i|$number10|$list10"
puts $hb11 "$i|$number11|$list11"
puts $hb12 "$i|$number12|$list12"
puts $hb20 "$i|$number20|$list20"
puts $hb21 "$i|$number21|$list21"
puts $hb22 "$i|$number22|$list22"


puts $hb0 "$i|$number0|$list0"
puts $hb1 "$i|$number1|$list1"
puts $hb2 "$i|$number2|$list2"
puts $hb3 "$i|$number3|$list3"
puts $hb4 "$i|$number4|$list4"

}
#
# initialization of sum array



for {set l 0} {$l <$msdlength} {incr l} {
#		set search [lsearch $missing_i $l]
#		if {$search == -1} 
	for {set m 0} {$m <$msdlength} {incr m} {
		set search [lsearch $missing_i $m]
		if {$search == -1} {
		set sum($l) [expr $sum($l)+$msdarray($m,[expr $m+$l])]
		}
#		
		
}
set t [expr $l * 0.0025* $step]
	set nummsd [expr $msdlength - [llength $missing_i]]
puts $msdfile "$l $t [expr $sum($l)/$nummsd]"
#
}


close $hb00
close $hb01
close $hb02
close $hb10
close $hb11
close $hb12
close $hb20
close $hb21
close $hb22

close $hb0																		
close $hb1
close $hb2
close $hb3
close $hb4

close $msdfile
