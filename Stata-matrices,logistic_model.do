*This is the do file for HW2

clear
set more off
capture log close
cd "C:\Users\aosee\Documents\UMD Fall 2019\Econometrics\"

use PS07-Glewwe2016.dta, replace

log using PS07Results.log, replace

reg received eye female prevglas headteacher headleader zavetest
predict receivedhat, xb

sort eye
twoway (scatter received eye) (line receivedhat eye)
twoway (scatter received eye) (scatter receivedhat eye)
sum zavetest
reg received eye female prevglas headteacher headleader zavetest
matrix coef=e(b)
matrix list coef
ereturn list
gen receivedhat2f=coef[1,7]+coef[1,1]*eye+coef[1,2]*1+coef[1,3]*0+coef[1,4]*0+coef[1,5]*0+coef[1,6]*0
twoway (scatter received eye) (line receivedhat2f eye, lc(blue)) 
gen receivedhat2m=coef[1,7]+coef[1,1]*eye+coef[1,2]*0+coef[1,3]*0+coef[1,4]*0+coef[1,5]*0+coef[1,6]*0
twoway (scatter received eye) (line receivedhat2m eye, lc(blue)) (line receivedhat2f eye, lc(red))

*1e
adjust female=0 prevglas =0 headteacher=0 headleader=0 zavetest=0, by(eye) generate(receivedhat3m) 
adjust female=1 prevglas =0 headteacher=0 headleader=0 zavetest=0, by(eye) generate(receivedhat3f)

twoway (scatter received eye) (line receivedhat3m eye, lc(blue)) (line receivedhat3f eye, lc(red))

*1f
adjust female prevglas headteacher headleader zavetest, by(eye) generate(receivedhat4old)
twoway (scatter received eye) (line receivedhat4old eye)

*2a
logit received eye female prevglas headteacher headleader zavetest
mfx compute

*2c
adjust female prevglas headteacher headleader zavetest, by(eye) generate(receivedhat4)
logit received eye female prevglas headteacher headleader zavetest
mfx compute
adjust female prevglas headteacher headleader zavetest, by(eye) pr generate(recievedhatlogit)
sort eye
twoway (scatter received eye) (line recievedhatlogit eye) (line receivedhat4old eye)

log close

