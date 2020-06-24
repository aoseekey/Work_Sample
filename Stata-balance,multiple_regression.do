capture log close
clear all
set more off


global data "\Users\aosee\Documents\UMD Spring 2020\ECON417\"
global output "\Users\aosee\Documents\UMD Spring 2020\ECON417\"

log using "${output}HW2.log", replace

use "${data}\PS2_2013-0533_data_endlines1and2.dta"

ssc install orth_out

orth_out area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base, by (treatment) se compare test count

local covars "area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base"

reg treatment `covars'
test `covars'

reg treatment `covars'[pweight=w1], cluster(areaid)
test `covars'

local consumption "total_exp_mo_pc_1 durables_exp_mo_pc_1 nondurable_exp_mo_pc_1 food_exp_mo_pc_1"

ssc install estout

foreach var of varlist `consumption' {
	reg `var' treatment `covars' [pweight=w1], cluster(areaid)
	est store HW2_`var'
	}

esttab HW2_* using "${output}HW2.csv", replace nocon se star keep(treatment)

local cred_access "spandana_1 othermfi_1 anymfi_1 anybank_1 anyinformal_1 anyloan_1"

foreach var of varlist `cred_access' {
	reg `var' treatment [pweight=w1], cluster(areaid)
	est store HW2a_`var'
	}

esttab HW2a_* using "${output}HW2a.csv", replace nocon se star keep(treatment)

reg anymfi_1 treatment `covars' [pweight=1] if any_old_biz==1, cluster(areaid)

reg any_old_biz treatment [pweight=w1], cluster(areaid)

local covars "area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base"
local consumption "total_exp_mo_pc_1 durables_exp_mo_pc_1 nondurable_exp_mo_pc_1 food_exp_mo_pc_1"

foreach var of varlist `consumption' {
	reg `var' treatment `covars' any_old_biz [pweight=w1], cluster(areaid)
	est store HW2b_`var'
	}

esttab HW2b_* using "${output}HW2b.csv", replace nocon se star keep(treatment)

local cred_access "spandana_1 othermfi_1 anymfi_1 anybank_1 anyinformal_1 anyloan_1"

foreach var of varlist `cred_access' {
	reg `var' treatment [pweight=w1] if any_old_biz==1, cluster(areaid)
	est store HW2c_`var'
	}

esttab HW2c_* using "${output}HW2c.csv", replace nocon se star keep(treatment)

gen treat_old=treatment*any_old_biz
reg total_exp_mo_pc_1 treatment any_old_biz treat_old [pweight=w1], cluster(areaid)

translate HW2.do HW02.pdf
translate HW2.log HW2.pdf

log close

