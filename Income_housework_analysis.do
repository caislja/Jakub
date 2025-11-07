///generate socdem variables
generate age=.
replace age=intdatey-dem02y if intdatem>=dem02m
replace age=intdatey-dem02y-1 if intdatem<dem02m

tabulate dem01
generate gender = dem01-1
label define gender 0 "Male" 1 "Female"
label values gender gender
tabulate gender

tabulate dem03
generate native=1 if dem03==1
replace native=0 if dem03==2
label define native 0 "Foreign-born" 1 "Domestic-born"
label values native native
tabulate native 

tabulate dem06
generate empl_stat=1 if dem06==2
replace empl_stat=2 if dem06==3
replace empl_stat=0 if dem06==1 | (dem06>=4 & dem06<=12)
label define empl_stat 0 "Other" 1 "Employed" 2 "Self-employed"
label values empl_stat empl_stat
tabulate empl_stat

tabulate dem07isced
generate educ_level=0 if dem07isced>=0 & dem07isced<=1 
replace educ_level=1 if dem07isced>=2 & dem07isced<=5
replace educ_level=2 if dem07isced>=6 & dem07isced<=8 
label define educ_level 0 "Primary" 1 "Secondary" 2 "Tertiary"
label values educ_level educ_level
tabulate educ_level

tabulate dem21
generate partner=1 if dem21==1
replace partner=0 if dem21==2
label define partner 0 "No partner" 1 "Partner"
label values partner partner
tabulate partner

generate partner_age=.
replace partner_age=intdatey-dem22y if intdatem>=dem22m & partner==1
replace partner_age=intdatey-dem22y-1 if intdatem<dem22m & partner==1
tabulate partner_age

tabulate dem23
generate partner_gender = dem23-1 if partner==1
label define partner_gender 0 "Male" 1 "Female"
label values partner_gender partner_gender
tabulate partner_gender

tabulate dem24a
generate partner_native=1 if dem24a==1 & partner==1
replace partner_native=0 if dem24a==2 & partner==1
label define partner_native 0 "Foreign-born" 1 "Domestic-born"
label values partner_native partner_native
tabulate partner_native 

tabulate dem25isced
generate partner_educ=0 if dem25isced>=0 & dem25isced<=1 & partner==1
replace partner_educ=1 if dem25isced>=2 & dem25isced<=5 & partner==1
replace partner_educ=2 if dem25isced>=6 & dem25isced<=8 & partner==1
label define partner_educ 0 "Primary" 1 "Secondary" 2 "Tertiary"
label values partner_educ partner_educ
tabulate partner_educ

tabulate dem26
generate partner_empl=1 if dem26==2 & partner==1
replace partner_empl=2 if dem26==3 & partner==1
replace partner_empl=0 if dem26==1 | (dem26>=4 & dem26<=12) & partner==1
label define partner_empl 0 "Other" 1 "Employed" 2 "Self-employed"
label values partner_empl partner_empl
tabulate partner_empl

tabulate dem28a
generate married=1 if dem28a==1 & partner==1
replace married=0 if dem28a==2 & partner==1
label define married 0 "Not married" 1 "Married"
label values married married
tabulate married 

tabulate dem30a
generate live_with_partner=1 if dem30a==1 & partner==1
replace live_with_partner=0 if dem30a==2 & partner==1
label define live_with_partner 0 "Live separate" 1 "Live with partner"
label values live_with_partner live_with_partner
tabulate live_with_partner

tabulate dem38a
generate disagr_housework=1 if (dem38a==3 | dem38a==4  |dem38a==5) & partner==1
replace disagr_housework=0 if (dem38a==1 | dem38a==2) & partner==1
label define disagr_housework 0 "Disagreement rare" 1 "Disagreement common"
label values disagr_housework disagr_housework
tabulate disagr_housework

tabulate dem38b
generate disagr_money=1 if (dem38b==3 | dem38b==4  |dem38b==5) & partner==1
replace disagr_money=0 if (dem38b==1 | dem38b==2) & partner==1
label define disagr_money 0 "Disagreement rare" 1 "Disagreement common"
label values disagr_money disagr_money
tabulate disagr_money

tabulate dem38c
generate disagr_leisure=1 if (dem38c==3 | dem38c==4  |dem38c==5) & partner==1
replace disagr_leisure=0 if (dem38c==1 | dem38c==2) & partner==1
label define disagr_leisure 0 "Disagreement rare" 1 "Disagreement common"
label values disagr_leisure disagr_leisure
tabulate disagr_leisure

tabulate dem38g
generate disagr_childraise=1 if (dem38g==3 | dem38g==4  |dem38g==5) & partner==1
replace disagr_childraise=0 if (dem38g==1 | dem38g==2) & partner==1
label define disagr_childraise 0 "Disagreement rare" 1 "Disagreement common"
label values disagr_childraise disagr_childraise
tabulate disagr_childraise

tabulate dem40
generate consider_breakup=1 if dem40==1 & partner==1
replace consider_breakup=0 if dem40==2 & partner==1
label define consider_breakup 0 "Not considered" 1 "Considered"
label values consider_breakup consider_breakup
tabulate consider_breakup

generate child_flag=.
generate under18_child_flag=.
forvalues i=1/10{
	generate child`i'=1 if lhi31_`i'>=1 & lhi31_`i'<=3
	replace child`i'=.a if lhi20>=. | lhi21>. | lhi22>. | lhi23>. | lhi31_`i'>.
	replace child_flag=.a if child`i'==.a
	generate age_child`i'=intdatey-lhi29_y1 if intdatem>=lhi29_m1 & child`i'==1
	replace age_child`i'=intdatey-lhi29_y1-1 if intdatem<lhi29_m1 & child`i'==1
	generate under18_child_`i'=1 if (lhi31_`i'>=1 & lhi31_`i'<=3) & (age_child`i'>=0 & age_child`i'<=18)
	replace under18_child_flag=.a if child`i'==.a | lhi29_y1>. | lhi29_m1>.
}
egen child_nr=rowtotal(child*) if child_flag!=.a
egen child_under18_nr=rowtotal(under18_child_*) if under18_child_flag!=.a
egen child_minage=rowmin(age_child*) if child_nr>0 & child_nr<. 
egen child_under18_minage=rowmin(age_child*) if child_under18_nr>0 & child_under18_nr<. 
tabulate child_nr
tabulate child_under18_nr
tabulate child_minage
tabulate child_under18_nr
