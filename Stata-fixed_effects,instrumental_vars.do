capture log close
clear all
set more off


global data "\Users\aosee\Documents\UMD Spring 2020\ECON417\"
global output "\Users\aosee\Documents\UMD Spring 2020\ECON417\"

log using "${output}HW5.log", replace

use "${data}PS5_clean.dta"

tab m3g
recode m3g (1=1) (0=0) (9=.), gen(tba)

tab tba
tab m3g tba
tab m3h
recode m3h (1=1) (0=0) (9=.),gen(relative)

tab birthyr
gen predata=1 if birthyr<=2007

egen preclust=group(dhsclust predata)
bys preclust:  egen tbause=mean(tba)
replace tbause=.  if preclust==.
sum tbause, d

gen a=1 if tbause>=r(p75) & tbause!=.
replace a=0 if tbause<r(p75)

bys dhsclust:  egen high=mean(a)

*3 
bys birthyr high:egen meansba=mean(sba)
tw (connected meansba birthyr if high==1, mcolor (red) lcolor(red)) (connected meansba birthyr if high==0, mcolor(blue) lcolor(blue) ylabel(0(0.1)0.8) xline(2007))

gen high_time=high*time
reg sba high time high_time if post==0, cl(district)

gen high_post=high*post
reg twin male first young totalchildren ageatbirth christian mnoeduc snoeduc high post high_post, cl(district)

*5
tab high post, sum(sba)

*6
di(0.616-0.449)
di(0.797-0.774)
di(0.167-0.023)

*7
reg sba high post high_post

*8
egen preclust1=group(dhsclust predata)
bys preclust:  egen tbause1=mean(sba)
replace tbause=.  if preclust==.
sum tbause, d
gen aa=1 if tbause>=r(p50) & tbause!=.
replace aa=0 if tbause<r(p50)
bys dhsclust:  egen high_alt=mean(aa)

*9
bys birthyr high_alt:egen meansba1=mean(sba)
tw (connected meansba1 birthyr if high_alt==1, mcolor (red) lcolor(red)) (connected meansba1 birthyr if high_alt==0, mcolor(blue) lcolor(blue) ylabel(0(0.1)0.8) xline(2007))

gen high_alt_time=high_alt*time
reg sba high_alt time high_alt_time if post==0, cl(district)

*10
gen high_alt_post=high_alt*post
reg sba high_alt post high_alt_post

*11
areg sba high_alt post high_alt_post, abs(district) cl(district)
xi: areg sba high_alt high_alt_post i.district, abs(time) cl(district)

*12
corr sba first
corr sba ageatbirth
gen first_high_alt=first*high_alt
gen first_post=first*post
gen first_high_alt_post=first*high_alt*post
gen ageatbirth_high_alt=ageatbirth*high_alt
gen ageatbirth_post=ageatbirth*post
gen ageatbirth_high_alt_post=ageatbirth*high_alt*post
xi: areg sba first ageatbirth first_high_alt ageatbirth_high_alt first_post ageatbirth_post first_high_alt_post ageatbirth_high_alt_post i.district, abs(time) cl(district)

*15a
reg sba high post high_post
*b
predict dhat, xb
sum dhat, detail
*c
reg neomort dhat
*d
ivregress 2sls neomort dhat

translate HW5.log HW5.pdf