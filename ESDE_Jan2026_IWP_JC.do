**********************************************************
*
* ESDE QUARTERLY January 2026 - IN-WORK POVERTY - SILC CROSS-SECTIONAL DATA 09/2025
* Author: Gaelle DEBREE/Jakub CAISL
* Review: 
**********************************************************

// 0. LOADING DATA

/// 0.1. IMPORTING DATA
clear all
import delimited using "\\net1.cec.eu.int\EMPL\Public\MicroData\SILC\Microdata_2025_July\result\SILC_C_2024_all.csv", clear // change the year in the source dataset to run for another year than 2024
set more off // turning off pagination

/// 0.2. SUBSAMPLE DATA

* --- Keep only EU-27 Member States in the analysis ---
replace country = "EL" if country == "GR" // rename Greece
keep if country == "BE" | country == "BG" | country == "CZ" | country == "DK" | country == "DE" | country == "EE" | country == "IE" | country == "EL" | country == "ES" | country == "FR" | country == "HR" | country == "IT" ///
	| country == "CY" | country == "LV" | country == "LT" | country == "LU" | country == "HU" | country == "MT" | country == "NL" | country == "AT" | country == "PL" | country == "PT" | country == "RO" | country == "SI" ///
	| country == "SK" | country == "FI" | country == "SE"

// 1. CLEANING DATA

/// 1.1. SEX (quality control)
drop if rb090_f==-1
tab rb090 [aw=rb050], m // 1=male, 2=female

/// 1.2. AGE

* --- Recode values for MT (only for years 2020 and 2021) ---
replace rb080 = 1940 if rb080==1 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1945 if rb080==2 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1950 if rb080==3 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1955 if rb080==4 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1960 if rb080==5 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1965 if rb080==6 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1970 if rb080==7 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1975 if rb080==8 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1980 if rb080==9 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1985 if rb080==10 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1990 if rb080==11 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 1995 if rb080==12 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 2000 if rb080==13 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 2005 if rb080==14 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 2010 if rb080==15 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 2015 if rb080==16 & country=="MT" & (year==2021 | year==2020)
replace rb080 = 2020 if rb080==17 & country=="MT" & (year==2021 | year==2020)

* --- Generate a new age variable (new_rx010) including also MT and DE, for which RX010 contains only missing values ---
cap drop new_rx010
gen new_rx010 = rx010
label var new_rx010 "Age of individual as of RX010 including Malta and Germany" // label new age variable
replace new_rx010 = (year - (rb080 -2)) if country == "MT" & rb080!=1 // replace value for MT (MT missing from RX010); -2  added as year of birth in Malta designated the last year in the 5 year age group, e.g. 1988 in SILC 2023 meant 1984-1988
replace new_rx010 = (year - (rb080 - 2)) if country == "DE" & rb080 <2007 & year>2022 // replace value for DE (DE missing from RX010 from 2023 onwards), same process as for MT
replace new_rx010 = (year - rb080) if country == "DE" & rb080 >=2007 & year>2022
drop if new_rx010==. // keep all ages, drop missing values


// 2. PREPARATION OF INPUT VARIABLES

/// 2.1. INDIVIDUAL SOCIO-DEMOGRAPHICS

* --- Sex: generate a dummy variable for women (women=1, men=0) ---
{  // rb090 is coded in the following way (open to see)
// 1 Male
// 2 Female
}
gen female=.
replace female=1 if rb090==2
replace female=0 if rb090==1

* --- Age: generate general age categories and dummies ---
gen age_groups=.
replace age_groups=1 if new_rx010<18 // <18
replace age_groups=2 if new_rx010>=18 & new_rx010<=29 // 18-29
replace age_groups=3 if new_rx010>=30 & new_rx010<=49 // 30-49
replace age_groups=4 if new_rx010>=50 & new_rx010<=64 // 50-64
replace age_groups=5 if new_rx010>=65 // 65+

gen age18_64=0 // dummy 18-64
replace age18_64=1 if new_rx010>=18 & new_rx010<=64

gen age18_59=0 // dummy 18-64
replace age18_59=1 if new_rx010>=18 & new_rx010<=59

gen age18_29=0 // dummy 18-29
replace age18_29=1 if age_groups==2

* --- Education: generate a variable for educational attainment level ---
{  // pe041 is coded in the following way (open to see)
// 0 No formal education or below ISCED 1
// 1 Primary education (ISCED 1)
// 2 Lower secondary education (ISCED 2)
// 3 Upper secondary education (ISCED 3)	
// 4 Post-secondary non-tertiary education (ISCED 4)
// 5 Short-cycle tertiary education (ISCED 5)	
// 6 Bachelor's or equivalent (ISCED 6)
// 7 Master's or equivalent (ISCED 7)
// 8 Doctoral or equivalent level (ISCED 8)
}
gen string_educ = string(pe041)
gen educ = substr(string_educ, 1, 1)
destring educ, generate(education) force
drop string_educ educ

gen educ_level=.
replace educ_level=0 if education == 0 | education == 1 | education == 2 // low (ISCED 0-2)
replace educ_level=1 if education == 3 | education == 4 // medium (ISCED 3-4)
replace educ_level=2 if education == 5 | education == 6 | education == 7 | education == 8 // high (ISCED 5-8)

* --- Migrant background: generate a variable for migrant background ---
gen migrant_groups=.
replace migrant_groups=1 if rb280=="LOC" // (native born)
replace migrant_groups=2 if rb280=="EU" // (EU-born - mobile workers)
replace migrant_groups=3 if rb280=="OTH" // (third countries born - migrants)

* --- Disability status: generate a dummy variable for disability (some or severe limitations in activities because of health problems) ---
gen disability=.
replace disability=1 if ph030==1 | ph030==2
replace disability=0 if ph030==3

* --- Identify households with missing values for adults (>=18) for disability variable (ph030) ---
gen missing_disability=0
replace missing_disability=1 if age_groups!=1 & (ph030_f==-1 | ph030_f==-3)

bysort hh_id country: egen hh_missing_disability = max(missing_disability) // dummy =1 if at least one adult household member (>=18) has a missing value for disability variable (ph030)


/// 2.2. INDIVIDUAL LABOUR MARKET CHARACTERISTICS

* --- Employment status: generate a dummy to identify those in employment (reference period: income reference period) ---
{  // Based on variable px050 (activity status): open to see description (income reference period - pl032 for current period)
// Individual is attributed a category if they spent more than half of their total time calendar in this category
// 1 SAL (employee)
// 2 NSAL (self-employed)
// 3 Other employed (when time of SAL and NSAL is > 1/2 of total time calendar)	
// 4 Unemployed
// 5 Retired
// 6 Inactive
// 7 Other inactive (when time of unemployed, retirement and inactivity is > ½ of total time calendar)

/// See Eurostat calculation below (ACTSTA)
// egen tot= rowtotal(pl073 pl074 pl075 pl076 pl080 pl085 pl086 pl087 pl088 pl089 pl090)
// replace tot=0 if missing(tot)
// drop if tot < 6 // quality check

// gen actsta=.
// replace actsta=2 if ((pl073+pl074) / tot) > 0.5 // employees
// replace actsta=3 if ((pl075+pl076) / tot) > 0.5 // self-employed
// replace actsta=4 if ((pl073+pl074+pl075+pl076) / tot) > 0.5 // others in employment
// replace actsta=5 if ((pl080) / tot) > 0.5 // unemployed
// replace actsta=6 if ((pl085) / tot) > 0.5 // retirees
// replace actsta=7 if ((pl086+pl087+pl088+pl089+pl090) / tot) > 0.5 // inactives
// replace actsta=8 if ((pl080+pl085+pl086+pl087+pl088+pl089+pl090) / tot) > 0.5 // others not in employment
}
gen employment=.
replace employment=1 if px050==2 | px050==3 | px050==4 // employees, self-employed and other employed
replace employment=0 if px050==5 | px050==6 | px050==7 | px050==8

* --- Employment status: generate a dummy to identify those in employment (reference period: current) ---
{  // Based on variable pl032 (self-defined current economic status): open to see description
// 1 Employed
// 2 Unemployed
// 3 Retired	
// 4 Unable to work due to long-standing health problems
// 5 Student, pupil
// 6 Fulfilling domestic tasks
// 7 Compulsory military or civilian service
// 8 Other
}
// gen employment=.
// replace employment=1 if pl032==1 // employed
// replace employment=0 if pl032!=1 & pl032 !=.

* --- (Quality check): drop those who were in employment and did not receive income from work and vice-versa ---
drop if (employment==1 & py010g==0) | (employment==0 & py010g!=0)

* --- Permanency of the main job: generate a variable to identify those in temporary vs permanent employment (reference period: current) ---
{  // Based on variable pl141 (permanency of main job): open to see description
// 11 Fixed-term written contract
// 12 Fixed-term verbal contract
// 21 Permanent written contract	
// 22 Permanent verbal contract
}
gen temporary=.
replace temporary=0 if pl141==21 | pl141==22 // permanent
replace temporary=1 if pl141==11 | pl141==12 // temporary

* --- Type of contract: generate a variable for self-defined FT and PT (reference period: current) ---
{  // Based on variable pl145 (self defined full or part-time main job): open to see description
// 1 Full-time job
// 2 Part-time job
}
gen FT_PT=.
replace FT_PT=0 if pl145==1 // full-time
replace FT_PT=1 if pl145==2 // part-time

* --- Individual work intensity: generate a variable for individual WI and a variable with groups of WI ---
{  // Open to see description and calculation method
// For the working intensity, the ratio of total number of hours worked by a working-age household and the total number of hours the same individual theoretically could have worked in the same period (approximated here at 40h).
// Here:
//   (1) Hours worked in a week is based on variable pl060 (number of hours usually worked per week in the main job) and pl100 (total number of hours per week usually worked in the second, third,...jobs).
//   (2) Full potential of hours worked per week is approximated to 40h.
}
gen ind_WI=.
replace ind_WI= (pl060+pl100)/40 if age18_64==1 & pl100!=. & pl060!=.
replace ind_WI= pl060/40 if age18_64==1 & pl100==. & pl060!=.
replace ind_WI=0 if age18_64==1 & pl100==. & pl060==.

gen ind_WI_groups=.
replace ind_WI_groups=1 if ind_WI>=0 & ind_WI<0.8 & ind_WI!=. // low WI [0-0.8[
replace ind_WI_groups=2 if ind_WI>=0.8 & ind_WI!=. // high WI [0.8-...[

* --- Low earners: compute the median income from work (at the individual level) and generate a dummy =1 if income from work is below national median ---
egen median_inc_work=median(py010g) if py010g!=. & employment==1 & age18_64==1, by(country year) // median income from work by country and year
su median_inc_work
tabstat median_inc_work if employment==1 & age18_64==1 [aw=rb050], by(country) statistics (mean)

gen low_earner=.
replace low_earner=1 if py010g < 2/3*median_inc_work & py010g<.
replace low_earner=0 if py010g >= 2/3*median_inc_work & py010g<.

gen month_work=pl074 + pl073 + pl075 + pl076
gen month_inc=py010g/month_work
egen median_monthinc_work=median(month_inc) if employment==1 & age18_64==1, by(country year) // median income from work by country and year
su median_monthinc_work
tabstat median_monthinc_work if employment==1 & age18_64==1 [aw=rb050], by(country) statistics (mean)

gen low_earner2=.
replace low_earner2=1 if month_inc < 2/3*median_monthinc_work & month_inc<.
replace low_earner2=0 if month_inc >= 2/3*median_monthinc_work & month_inc<.

* --- Generate a dummy variable for households IWP (=1 if IWP, =0 if not IWP)
{  // based on variable hx080 (poverty indicator): open to see description
// 0 Not AROP - hx090 is above the AROP threshold (60% of median hx090)
// 1 AROP - hx090 is below the AROP threshold (60% of median hx090)
}
gen iwp=.
replace iwp=1 if employment==1 & hx080==1
replace iwp=0 if employment==1 & hx080==0


/// 2.3. HOUSEHOLD COMPOSITION AND TYPE

* --- Household size: hx040 defined as follow ---
{ // expand to see description
// Number of current household members.
}

* --- Household type: based on hx060 defined as follow ---
{  // hx060 is coded in the following way (open to see)
// 5 One person household
// 6 2 adults, no dependent children, both adults under 65 years
// 7 2 adults, no dependent children, at least one adult 65 years or more
// 8 Other households without dependent children
// 9 Single parent household, one or more dependent children
// 10 2 adults, one dependent child
// 11 2 adults, two dependent children
// 12 2 adults, three or more dependent children
// 13 Other households with dependent children
// 16 Other (these household are excluded from Laeken indicators calculation)
}
gen hh_type=.
replace hh_type=1 if hx060==5 // single-adult without dependent children
replace hh_type=2 if hx060==9 // single-adult with dependent children
replace hh_type=3 if hx060==6 | hx060==7 | hx060==8 // 2 or more adults without dependent children
replace hh_type=4 if hx060==10 | hx060==11 | hx060==12 | hx060==13 // 2 or more adults with dependent children

gen hh_type2=.
replace hh_type2=1 if hx060==5 | hx060==9 // single-adult
replace hh_type2=2 if hx060==6 | hx060==7 | hx060==8 | hx060==10 | hx060==11 | hx060==12 | hx060==13 // 2 or more adults


* --- Generate a dummy for single adult households (controlling for the HH size) ---
gen single_hh=0
replace single_hh=1 if (hx060==5 & hx040==1) | (hx060==9 & hx040!=1)

* --- Partners: generate a dummy variable to identify individuals living with a partner ---
gen partner=.
replace partner=1 if pb205==1
replace partner=0 if pb205==2

* --- Work intensity of the household: generate a variable with WI level based on rx040 ---
{  // rx040 is coded in the following way (open to see)
// Continuous variable from 0 to 1 (people older than 64 has WORK_INT=99). Based on persons aged 18-64 (but excluding students aged 18-24 and people who are retired according to their self-defined current economic status or who receive any pension (except survivors pension), as well as people in the age bracket 60-64 who are inactive and living in a household where the main income is pensions).
}
gen hh_WI=.
replace hh_WI=1 if rx040>=0 & rx040<=0.2 // very low WI
replace hh_WI=2 if rx040>0.2 & rx040<=0.45 // low WI
replace hh_WI=3 if rx040>0.45 & rx040<=0.55 // medium WI
replace hh_WI=4 if rx040>0.55 & rx040<=0.85 // high WI
replace hh_WI=5 if rx040>0.85 & rx040<=1 // very high WI

gen hh_WI_groups=.
replace hh_WI_groups=1 if rx040>=0 & rx040<0.8 & rx040!=. // low WI [0-0.8[
replace hh_WI_groups=2 if rx040>=0.8 & rx040<=1 & rx040!=. // high WI [0.8-...[



/// 2.4. HOUSEHOLDS EARNERS

* --- Generate a dummy variable for earners ---
gen earner=0
replace earner=1 if py010g>0 & py010g<. & employment==1

* --- Income from work: total equivalised household income from work (based on py010g - employee cash or near cash gross income) ---
// egen tot_inc_work=sum(py010g) if py010g!=., by(hh_id year country) // total gross income from work
// gen eq_gross_income_work=tot_inc_work/hx050 // equivalised with hx050

* --- Number of earners per household ---
bysort hh_id country: egen nb_earner = total(earner)

gen hh_earner=.
replace hh_earner=0 if nb_earner==0 // 0 earner
replace hh_earner=1 if nb_earner==1 // 1 earner
replace hh_earner=2 if nb_earner==2 // 2 earners
replace hh_earner=3 if nb_earner>2 // 3 or more earners

* --- Generate a dummy for single earners (only earner in the household) ---
gen single_earner=0
replace single_earner=1 if earner==1 & hh_earner==1

* --- Number of earners by WI per household ---
// bysort hh_id country: egen nb_earner_lowWI = total(earner) if ind_WI_groups==1
// bysort hh_id country: egen nb_earner_medWI = total(earner) if ind_WI_groups==2
// bysort hh_id country: egen nb_earner_highWI = total(earner) if ind_WI_groups==3

bysort hh_id country: egen nb_earner_PT = total(earner) if FT_PT==1
bysort hh_id country: egen nb_earner_FT = total(earner) if FT_PT==0

* --- Number of additional earners by WI (i.e. removing the reporting individual) per household ---
// gen nb_add_earner_lowWI= nb_earner_lowWI
// replace nb_add_earner_lowWI= (nb_earner_lowWI - 1) if earner==1 & ind_WI_groups==1

// gen nb_add_earner_medWI= nb_earner_medWI
// replace nb_add_earner_lowWI= (nb_earner_medWI - 1) if earner==1 & ind_WI_groups==2

// gen nb_add_earner_highWI= nb_earner_highWI
// replace nb_add_earner_lowWI= (nb_earner_highWI - 1) if earner==1 & ind_WI_groups==3

gen nb_add_earner_PT= nb_earner_PT
replace nb_add_earner_PT= (nb_earner_PT - 1) if earner==1 & FT_PT==1
gen nb_add_earner_FT= nb_earner_FT
replace nb_add_earner_FT= (nb_earner_FT - 1) if earner==1 & FT_PT==0

* --- Generate a variable for the presence of additional earners by WI status within the same household as the reporting individual ---
{  // open to see coding new variable
// 0 No other earner other than the reporting individual
// 1 Presence of additional earners with low WI
// 2 Presence of additional earners with medium WI
// 3 Presence of additional earners with high WI
}
// gen add_earner=.
// replace add_earner=0 if nb_earner==1
// replace add_earner=1 if nb_earner>1 & nb_add_earner_lowWI>0
// replace add_earner=2 if nb_earner>1 & nb_add_earner_medWI>0
// replace add_earner=3 if nb_earner>1 & nb_add_earner_highWI>0

gen add_earner_FTPT=.
replace add_earner_FTPT=0 if nb_earner==1
replace add_earner_FTPT=1 if nb_earner>1 & nb_add_earner_FT>0
replace add_earner_FTPT=2 if nb_earner>1 & nb_add_earner_PT>0 ///& (nb_add_earner_FT==0 | nb_add_earner_FT==.)


/// 2.5. HOUSEHOLDS DEPENDENTS

* --- Genrate a dummy variable for children ---
{  // open to see definition of dependent children
// Dependent children are: (1) All household members aged 0-17; (2) Children aged 0-17 who are household members but have parent outside the household; (3) Children aged 18-24 living with at least one parent and not being employed.
}
gen child=.
replace child=1 if age_groups==1
replace child=0 if age_groups!=1

* --- Number of children per household ---
bysort hh_id country: egen nb_children = total(child)

gen hh_children=.
replace hh_children=0 if nb_children==0 // 0 child
replace hh_children=1 if nb_children==1 // 1 child
replace hh_children=2 if nb_children==2 // 2 children
replace hh_children=3 if nb_children>2 // 3 or more children

* --- Generate a dummy variable for dependent adults ---
{  // open to see definition of dependent adults
// Dependent adults are all adults living in a household and who are not receiving any income from work.
}
gen dependent_adult=0
replace dependent_adult=1 if age_groups!=1 & employment==0

* --- Number of dependent adults per household ---
bysort hh_id country: egen nb_dependent_adult = total(dependent_adult)

gen hh_dependent_adult=.
replace hh_dependent_adult=0 if nb_dependent_adult==0 // 0 dependent adult
replace hh_dependent_adult=1 if nb_dependent_adult==1 // 1 dependent adult
replace hh_dependent_adult=2 if nb_dependent_adult>1 // multiple dependent adults

* --- Generate a dummy variable for the presence of an adult over 64 in the household ---
gen pensioner=.
replace pensioner=1 if age_groups==5
replace pensioner=0 if age_groups!=5

bysort hh_id country: egen hh_pensioner = max(pensioner)


/// 2.6. DEPENDENT TO EARNERS RATIO

* --- Generate a variable with number of children to earner ratio ---
// bysort hh_id country: gen ratio_dependent_child_earner = nb_dependent_child/nb_earner

* --- Generate a variable with number of dependent adults to earner ratio ---
// bysort hh_id country: gen ratio_dependent_adult_earner = nb_dependent_adult/nb_earner

* --- Generate a variable with number of dependents (children and adults) to earner ratio ---
// bysort hh_id country: gen ratio_dependent_earner = (nb_dependent_adult + nb_children) / nb_earner


/// 2.7. SOCIO-DEMOGRAPHIC CHARACTERISTICS OF HOUSEHOLDS' WORKING-AGE ADULTS

* --- Age: number of young people per household (18-29) ---
bysort hh_id country: egen nb_young = total(age18_29==1)

gen hh_young=.
replace hh_young=0 if nb_young==0 // 0 young
replace hh_young=1 if nb_young==1 // 1 young
replace hh_young=2 if nb_young>1 // multiple young people

* --- Educational attainment level: number of working-age adults with a low educational attainment level per household ---
bysort hh_id country: egen nb_low_educ = total(educ_level==0 & age18_64==1)

gen hh_low_educ=.
replace hh_low_educ=0 if nb_low_educ==0 // 0 person with low educ
replace hh_low_educ=1 if nb_low_educ==1 // 1 person with low educ
replace hh_low_educ=2 if nb_low_educ>1 // multiple people with low educ

* --- Migrant background: number of working-age adults who are migrants (born in a third country) per household ---
bysort hh_id country: egen nb_migrants = total(migrant_groups==3 & age18_64==1)

gen hh_migrants=.
replace hh_migrants=0 if nb_migrants==0 // 0 migrant
replace hh_migrants=1 if nb_migrants==1 // 1 migrant
replace hh_migrants=2 if nb_migrants>1 // multiple migrants

* --- Disability: number of working-age adults with disability per household ---
bysort hh_id country: egen nb_disability = total(disability==1 & age18_64==1)

gen hh_disability=.
replace hh_disability=0 if nb_disability==0 // 0 person with disability
replace hh_disability=1 if nb_disability==1 // 1 person with disability
replace hh_disability=2 if nb_disability>1 // multiple people with disability


// 3. OUTPUT: DESCRIPTIVE STATISTICS
{  // open to see note
// Figures are the same than Eurostat's one if we do not drop those in employment with 0 income from work and those not in employment with income from work (2.2, code line 179)
}

* --- Overall in-work poverty rate ---
mean iwp if employment==1 & age18_64==1 [aw=rb050]

* --- Individual characteristics (18-64) ---
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(female) statistics (mean) // sex
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(age_groups) statistics (mean) // age
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(educ_level) statistics (mean) // educational attainment level
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(migrant_groups) statistics (mean) // migrant background
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(disability) statistics (mean) // disability

tabstat iwp if employment==1 & age18_64==1 & migrant_groups==1 [aw=rb050], by(educ_level) statistics (mean) // educ and native born
tabstat iwp if employment==1 & age18_64==1 & migrant_groups==2 [aw=rb050], by(educ_level) statistics (mean) // educ and mobile worker
tabstat iwp if employment==1 & age18_64==1 & migrant_groups==3 [aw=rb050], by(educ_level) statistics (mean) // educ and migrant

* --- Labour market characteristics ---
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(temporary) statistics (mean) // temporary vs permanent
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(FT_PT) statistics (mean) // FT vs PT
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(ind_WI_groups) statistics (mean) // individual work intensity
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(low_earner) statistics (mean) // individual earnings from work

tab female temporary if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // gender and temporary
tab female ind_WI_groups if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // gender and individual WI
tab age_groups temporary if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // age and temporary
tab age_groups ind_WI_groups if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // age and individual WI
tab educ_level temporary if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // educ and temporary
tab educ_level ind_WI_groups if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // educ and individual WI
tab migrant_groups temporary if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // migrant background and temporary
tab migrant_groups ind_WI_groups if employment==1 & age18_64==1 [aw=rb050], summarize(iwp) means // migrant background and individual WI

* --- Household characteristics ---
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_WI_groups) statistics (mean) // HH work intensity
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_type) statistics (mean) // household type
tabstat iwp if employment==1 [aw=rb050], by(hh_type2) statistics (mean) // household type simple
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_earner) statistics (mean) // number of earners
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_children) statistics (mean) // number of children
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_dependent_adult) statistics (mean) // number of dependent adults

// tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(ratio_dependent_child_earner) statistics (mean) // dependent children by earner
// tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(ratio_dependent_adult_earner) statistics (mean) // dependent adults by earner
// tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(ratio_dependent_earner) statistics (mean) // dependents by earner

* --- Other households' working age adults characteristics ---
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_young) statistics (mean) // number of young earners
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_low_educ) statistics (mean) // number of earners with a low educational attainment level
tabstat iwp if employment==1 & age18_64==1 [aw=rb050], by(hh_migrants) statistics (mean) // number of earners who are migrants
tabstat iwp if employment==1 & age18_64==1 & hh_missing_disability==0 [aw=rb050], by(hh_disability) statistics (mean) // number of earners with a disability


// 4. REGRESSION ANALYSIS

* --- Encode country to numeric (for country fixed effects) ---
encode country, gen(country_num)


/// 4.1. SINGLE-ADULT HOUSEHOLDS ANALYSIS

* --- Model 1: all except income ---
logit iwp i.hh_children i.hh_WI_groups i.FT_PT i.temporary i.female ib3.age_groups i.educ_level i.migrant_groups i.country_num [pweight=db090] if employment==1 & single_hh==1 & age18_64==1, or

margins hh_children
margins hh_WI_groups
margins FT_PT
margins temporary
margins female
margins age_groups
margins educ_level
margins migrant_groups

margins, dydx(hh_children)
margins, dydx(hh_WI_groups) 
margins, dydx(FT_PT) 
margins, dydx(temporary)
margins, dydx(female)
margins, dydx(age_groups)
margins, dydx(educ_level)
margins, dydx(migrant groups)

* --- Model 2: all inlcuding income ---

logit iwp i.low_earner2 i.hh_children i.hh_WI_groups i.FT_PT i.temporary i.female ib3.age_groups i.educ_level i.migrant_groups i.country_num [pweight=db090] if employment==1 & single_hh==1 & age18_64==1, or

margins low_earner2
margins hh_children
margins hh_WI_groups
margins FT_PT
margins temporary
margins female
margins age_groups
margins educ_level
margins migrant_groups

margins, dydx(low_earner2)
margins, dydx(hh_children)
margins, dydx(hh_WI_groups) 
margins, dydx(FT_PT) 
margins, dydx(temporary)
margins, dydx(female)
margins, dydx(age_groups)
margins, dydx(educ_level)
margins, dydx(migrant_groups)

/// 4.2. MULTIPLE ADULTS HOUSEHOLDS ANALYSIS

* --- Model 3: socio-demographics of other working-age adults
logit iwp i.partner i.hh_WI_groups i.hh_children i.hh_dependent_adult i.hh_pensioner i.FT_PT i.temporary i.low_earner2##add_earner_FTPT i.hh_young i.hh_low_educ i.hh_migrants i.country_num [pweight=db090] if employment==1 & single_hh==0 & age18_64==1, or

margins partner
margins hh_children
margins hh_dependent_adult
margins hh_pensioner
margins hh_WI_groups 
margins FT_PT
margins temporary
margins low_earner2##add_earner_FTPT
margins hh_young
margins hh_low_educ
margins hh_migrants








