///basic tabulations job quality
table country goodjob_aut if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_aut))
table country goodjob_pay if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_pay))
table country goodjob_wlb if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_wlb))
table country goodjob_workload if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_workload))
table country goodjob_secureempl if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_secureempl))
table country goodjob_safe if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_safe))
table country goodjob_learn if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_learn))

///basic tabulations need for action
table country improve_pay_benefits if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_pay_benefits))
table country improve_prospects if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_prospects))
table country improve_workhours if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workhours))
table country improve_health_safety if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_health_safety))
table country improve_opportunities if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_opportunities))
table country improve_workload if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workload))
table country improve_voice if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_voice))

///definition of subgroups
generate age_gr=1 if age>=16 & age <=29
replace age_gr=2 if age>=30 & age <=49
replace age_gr=3 if age>=50 & age <=64
label define age_gr_vl 1 "16-29" 2 "30-49" 3 "50-64"
label values age_gr age_gr_vl

*use sex2 for gender 

generate educ_level=1 if isced>=0 & isced<=2
replace educ_level=2 if isced>=3 & isced<=4
replace educ_level=3 if isced>=5 & isced<=8
label define educ_level_vl 1 "Low" 2 "Medium" 3 "High"
label values educ_level educ_level_vl


generate migrant=0 if birth_region2=="Native"
replace migrant=1 if birth_region2=="EEA" | birth_region2=="EU27"
replace migrant=2 if birth_region2=="non-EU" 
label define migrant_vl 0 "Native" 1 "EU27+EEA" 2 "Non-EU"
label values migrant migrant_vl

///demo tabulations job quality
table goodjob_aut age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_aut))
table goodjob_pay age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_pay))
table goodjob_wlb age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_wlb))
table goodjob_workload age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_workload))
table goodjob_secureempl age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_secureempl))
table goodjob_safe age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_safe))
table goodjob_learn age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_learn))

table goodjob_aut sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_aut))
table goodjob_pay sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_pay))
table goodjob_wlb sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_wlb))
table goodjob_workload sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_workload))
table goodjob_secureempl sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_secureempl))
table goodjob_safe sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_safe))
table goodjob_learn sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_learn))

table goodjob_aut educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_aut))
table goodjob_pay educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_pay))
table goodjob_wlb educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_wlb))
table goodjob_workload educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_workload))
table goodjob_secureempl educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_secureempl))
table goodjob_safe educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_safe))
table goodjob_learn educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_learn))

table goodjob_aut migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_aut))
table goodjob_pay migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_pay))
table goodjob_wlb migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_wlb))
table goodjob_workload migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_workload))
table goodjob_secureempl migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_secureempl))
table goodjob_safe migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_safe))
table goodjob_learn migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(goodjob_learn))

///demo tabulations need for action
table improve_pay_benefits age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_pay_benefits))
table improve_prospects age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_prospects))
table improve_workhours age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workhours))
table improve_health_safety age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_health_safety))
table improve_opportunities age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_opportunities))
table improve_workload age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workload))
table improve_voice age_gr if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_voice))

table improve_pay_benefits sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_pay_benefits))
table improve_prospects sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_prospects))
table improve_workhours sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workhours))
table improve_health_safety sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_health_safety))
table improve_opportunities sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_opportunities))
table improve_workload sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workload))
table improve_voice sex2 if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_voice))

table improve_pay_benefits educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_pay_benefits))
table improve_prospects educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_prospects))
table improve_workhours educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workhours))
table improve_health_safety educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_health_safety))
table improve_opportunities educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_opportunities))
table improve_workload educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workload))
table improve_voice educ_level if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_voice))

table improve_pay_benefits migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_pay_benefits))
table improve_prospects migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_prospects))
table improve_workhours migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workhours))
table improve_health_safety migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_health_safety))
table improve_opportunities migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_opportunities))
table improve_workload migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_workload))
table improve_voice migrant if EU27==1 & age<65 [pweight= CalibrationWeight ], statistic(percent, across(improve_voice))