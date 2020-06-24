capture log close
clear all
set more off


global data "\Users\aosee\Documents\UMD Spring 2020\ECON417\"
global output "\Users\aosee\Documents\UMD Spring 2020\ECON417\"

log using "${output}HW4.log", replace

use "${data}\PS4.dta"

*4
gen treated = 0 if after==1
replace	treated	= 1 if after==0

twoway (scatter treated distnoab), xtitle("Days Since Ban") ytitle("Eligible/ Ineligible")

*5
reg age after distnoab if dist<240
reg black after distnoab if dist<240
reg male after distnoab if dist<240
reg totalyearssentenced after distnoab if dist<240
reg prioroffense after distnoab if dist<240

*6
gen distround_f=floor((distnoab+0.001)/30)*30
gen distround_c=ceil((distnoab+0.001)/30)*30
gen distround=(distround_f+distround_c)/2
bys distround: egen tys_bin=mean(totalyearssentenced)

tw lfitci totalyearssentenced distnoab if after==0 & dist<240, level (90) ciplot (rline) alpattern(dash) lcolor(black) || ///
	lfitci totalyearssentenced distnoab if after==1 & dist<240, level (90) ciplot (rline) alpattern(dash) lcolor(black) || ///
	scatter tys_bin distround if dist<240, mcolor(black) xlabel(-240(60)240) ylabel(3(0.5)7) xline(0)

*7
gen after_distnoab=after*distnoab
reg finrecidany after distnoab after_distnoab if dist<240

*8
reg finrecidany after distnoab after_distnoab if dist<180
reg finrecidany after distnoab after_distnoab if dist<360
reg finrecidany after distnoab after_distnoab if dist<480
reg finrecidany after distnoab after_distnoab if dist<540

*9
gen distnoab2=distnoab^2
gen distnoab3=distnoab^3
gen after_distnoab2=after*distnoab2
gen after_distnoab3=after*distnoab3

reg finrecidany after distnoab after_distnoab if dist<240
reg finrecidany after distnoab2 after_distnoab after_distnoab2 if dist<240
reg finrecidany after distnoab3 after_distnoab after_distnoab3 if dist<240

reg finrecidany after distnoab after_distnoab if dist<600
reg finrecidany after distnoab2 after_distnoab after_distnoab2 if dist<600
reg finrecidany after distnoab3 after_distnoab after_distnoab3 if dist<600

*11
gen distround1_f=floor((distnoab+.01)/30)*30
gen distround1_c=ceil((distnoab+.01)/30)*30
gen distround1=(distround1_f+distround1_c)/2
bys distround1: egen finrecid_bin=mean(finrecidany)

tw qfitci finrecidany distnoab if after==0 & dist<600, level (90) ciplot (rline) alpattern(dash) lcolor(black) || ///
	qfitci finrecidany distnoab if after==1 & dist<600, level (90) ciplot (rline) alpattern(dash) lcolor(black) || ///
	scatter finrecid_bin distround1 if dist<600, mcolor(black) xlabel(-350(70)600) ylabel(-0.05(0.0005)0.2) xline(0)

*12
sum getsnap, detail
sum getsnap if after==0
sum getsnap if after==1
reg getsnap distnoab if after==0 & dist<240

*13a
reg getsnap distnoab after after_distnoab
*b
ivregress 2sls anyrecid getsnap distnoab after after_distnoab

translate HW4.log HW4.pdf