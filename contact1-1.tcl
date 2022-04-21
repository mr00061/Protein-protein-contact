puts "Owner: Mohammad Azizur Rahman Jewel, Chemistry, WVU"
puts "Date: 01/07/2021 "
puts "Special direction-"
puts "use dcd for contatc distribution over simulation period"
puts "Usage: contact-network <selection1> <selection2> <cotact_cutoff><molidcrystal><molid_simulationd <file1.dat> <file2.dat>"
puts "file1 witll store data from crystal distance and bin"
puts "file2 will store data from simulation as t vs fraction"


proc contact-network {text1 text2 contact molid_crys molid_sim  filb} { 
#set filea [open "$fila"  w]

 
#initial assignment for atomindex, that will be refered for simullation result
set A [atomselect $molid_crys "$text1"]
set B [atomselect $molid_crys "$text2"]
#finding contact atom index within <selection for chain A and B>
set contacts [measure contacts $contact $A $B]
set crysA [lindex $contacts 0]
set crysB [lindex $contacts 1]
set total 0
#Running for finding distance for all possible combination between atom from chain A and for chain B
foreach A1 $crysA B1 $crysB  {
	#conversion of atom index to coordinate
        set s11 [atomselect $molid_crys "serial $A1"]

	set x [measure center $s11 weight mass]

	set s22 [atomselect $molid_crys "serial $B1"]
	#Conversion of chain B atom index to coordinates
	set y [measure center $s22 weight mass]


        #finding all distance
	set dista [veclength [vecsub $x $y]]
	#running conditional loop to find contact distance
        if {$dista < 5} {
	set a 1
	set total [expr {$a + $total }]}  
	#finding total, that will be used to find fraction contact in simulated data
        if {$dista >5} {set a 0}
	#saving data
	#puts  $filea "$dista $a"
	$s11 delete
	$s22 delete
    
}
#$sell1 delete
#$sell2 delete
#close $filea
$A delete
$B delete
set fileAB [open "$filb"  w]
#Correction needed



#Running distance calculation from simulation


#set selA [atomselect 1 "protein and chain A"]
#set selB [atomselect 1 "protein and chain B"]
#set contacts1 [measure contacts 3 $selA $selB]
#set contactA [lindex $contacts1 0]
#set contactB [lindex $contacts1 1]
#set indexA [lindex $crysA $contactA]
#set indexB [lindex $crysB $contactB]
set nf [molinfo $molid_sim get numframes]

#making loop to cover all frames
for {set i 1} {$i < $nf } {incr i} { 

	set s 0
	foreach A2 $crysA B2 $crysB { 
 	set sel1 [atomselect $molid_sim "serial $A2" frame $i]
	set x1 [measure center $sel1  weight mass]
	set sel2 [atomselect $molid_sim " serial $B2" frame $i]  

	  set y1 [measure center $sel2 weight mass]
	  set distAB [veclength [vecsub $x1 $y1]]
	$sel1 delete
	$sel2 delete


          if {$distAB < 5} {
		set b 1
		set s [expr {$s + $b}]
		}
	  if {$distAB >5} {set b 0}
	  #puts $fileAB  " [expr $sumAB($i) / $total]"

         
  
#$distAB delete
}
set fraction [expr $s / $total.0 * 100.0 ]
set tim [expr 2 * $i * 0.05] 
puts $fileAB "$tim $fraction"
}
close $fileAB
 
}
