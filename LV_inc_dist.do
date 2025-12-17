preserve

keep if country=="LV"

su hx090 [aw=rb050], detail
generate income_median=r(p50)
pctile pct=hx090 [aw=rb050], nq(20)
list pct in 1/10

generate disp_inc=hy022/hx050
su disp_inc [aw=rb050], detail
pctile pct2=disp_inc [aw=rb050], nq(20)
list pct2 in 1/10

generate family_allow=hy050g/hx050
su family_allow [aw=rb050], detail
su family_allow if hx090<income_median  [aw=rb050] , detail
generate family_allow_freq=0 if hy050g<.
replace family_allow_freq=1 if hy050g>0 & hy050g<.
su family_allow_freq [aw=rb050], detail
su family_allow_freq if hx090<income_median [aw=rb050], detail

generate social_ex=hy060g/hx050
su social_ex [aw=rb050], detail
su social_ex if hx090<income_median [aw=rb050], detail
generate social_ex_freq=0 if hy060g<.
replace social_ex_freq=1 if hy060g>0 & hy060g<.
su social_ex_freq [aw=rb050], detail
su social_ex_freq if hx090<income_median [aw=rb050], detail

generate housing_allow=hy070g/hx050
su housing_allow [aw=rb050], detail
su housing_allow if hx090<income_median [aw=rb050], detail
generate housing_allow_freq=0 if hy070g<.
replace housing_allow_freq=1 if hy070g>0 & hy070g<.
su housing_allow_freq [aw=rb050], detail
su housing_allow_freq if hx090<income_median [aw=rb050], detail

restore