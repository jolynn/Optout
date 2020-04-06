****************************************************************************************
*** Table S12: diff of predicted prob in post-1979 sample, sequential logistic model ***
****************************************************************************************


*** set up ***

	use data_mi2_edited, replace
	
	
*** first, post-1979 sample
	
	mi xeq 0: tab sample18 post1979_sample, m
	quietly mi xeq: keep if sample18==1 & post1979_sample==1
	
	
*** define new dummies
	quietly mi xeq: gen cont_work = (dv18 <= 2)
	mi xeq 0: tab dv18 cont_work
	
	quietly mi xeq: gen ever_return = (dv18==3 | dv18==4)
	mi xeq 0: tab dv18 ever_return
	
	quietly mi xeq: gen dv = dv18
	quietly mi xeq: tab dv, gen(dv)
	
	mi xeq 0: tab dv1 dv18
	
	
/*
	basic steps: 
	- structure of DVs

	----------------------------------------------------------------------------------------
	|           consistent work           |           inconsistent work                    |
	----------------------------------------------------------------------------------------
	|   consistent FT  |  consistent PT   |      ever return           |    never return   |
	|                  |                   ----------------------------                    |
	|                  |                  | early return | late return |                   |
	----------------------------------------------------------------------------------------
	
	- estimate logit models and calculate predicted probabilities at baseline level (P0)
	and comparison level (P1) for each variable: 
		- P(consistent employment vs. not)
		- P(consistent FT| some kind of consistent work)
		- P(ever returns | not consistent)
		- P(returns quickly or early return | not consistent but does return)
		
	- calculate probabilities at baseline level and comparison level for each cluster
		- for full-time cluster, 
		P1(FT) = P1(cont work) * P1(FT | cont work)
		
		P0(FT) = P0(cont work) * P0(FT | cont work)
		
				
		- for part-time cluster, 
		P1(PT) = P1(cont work) * P1(PT | cont work) = P1(cont work) * (1 - P1(FT | cont work))
		
		P0(PT) =                                      P0(cont work) * (1 - P0(FT | cont work))

		
		- for early return cluster, 
		P1(early return) = P1(not cont work) * P1(ever return | no cont work) * P1(early return | not cont work, ever return)
		= (1-P1(cont work)) * P1(ever return | no cont work) * P1(early return | not cont work, ever return)
		
		P0(early return) 
		= (1-P0(cont work)) * P0(ever return | no cont work) * P0(early return | not cont work, ever return)
		
		
		- for late return cluster, 
		P1(late return) = P1(not cont work) * P1(ever return | no cont work) * P1(late return | not cont work, ever return)
		= (1-P1(cont work)) * P1(ever return | no cont work) * (1-P1(early return | not cont work, ever return))
		
		P0(late return) 
		= (1-P0(cont work)) * P0(ever return | no cont work) * (1-P0(early return | not cont work, ever return))
		
		
		- for nonemployed cluster,
		P1(nonemp) = P1(not cont work) * P1(not ever return | no cont work)
		= (1-P1(cont work)) * (1-P1(ever return | no cont work))
		
		P0(nonemp) 
		= (1-P0(cont work)) * (1-P0(ever return | no cont work))
		
	- get weighted mean of change in predicted prob (P1-P0) for each cluster
	
*/	
	
	
*** Educ (ref: HS): <HS, Some college, college, >college


	quietly mi xeq: gen xeduc = educ
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.xeduc i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.xeduc i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.xeduc i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.xeduc i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xeduc = 2
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	foreach y of numlist 1 3 4 { 
		
		* prob after change category
		quietly mi xeq: replace xeduc = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, educ level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xeduc
	
	
	
	
*** Exper (ref: none): <FT, FT (collapse across two years)

	quietly mi xeq: gen xhours_2y_to_1y_gp = hours_2y_to_1y_gp
	quietly mi xeq: gen xhours_1y_to_birth_gp = hours_1y_to_birth_gp
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.xhours_2y_to_1y_gp i.xhours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.xhours_2y_to_1y_gp i.xhours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.xhours_2y_to_1y_gp i.xhours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.xhours_2y_to_1y_gp i.xhours_1y_to_birth_gp [pw=wt] if ever_return==1
	
	
	* baseline prob
	quietly mi xeq: replace xhours_2y_to_1y_gp = 0
	quietly mi xeq: replace xhours_1y_to_birth_gp = 0
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	
	forval y=1/2  { 
		
		* prob after change category
		quietly mi xeq: replace xhours_2y_to_1y_gp = `y'
		quietly mi xeq: replace xhours_1y_to_birth_gp = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, hours level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xhours_2y_to_1y_gp xhours_1y_to_birth_gp
	
	
	
	
*** work 35 (ref: no/don't know): yes
	
	quietly mi xeq: gen xwork35 = work35
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.xwork35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.xwork35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.xwork35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.xwork35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	
	
	* baseline prob
	quietly mi xeq: replace xwork35 = 0
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	
	* prob after change category
	quietly mi xeq: replace xwork35 = 1
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] 
	
	
	
	di "eff for cluster 1, work35"
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 2, work35"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] 
	
	di "eff for cluster 3, work35"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 4, work35"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 5, work35 level"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d

	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xwork35
		
	
	
*** ideal number of children - compare 75 percentile to 25th percentile
	mi xeq 1: sum ideal [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xideal = ideal
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles xideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles xideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles xideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles xideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	
	
	quietly mi xeq: replace xideal = `=p25'
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	* prob after change category
	quietly mi xeq: replace xideal = `=p75'
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] 
	
	di "eff for cluster 1, ideal"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 2, ideal"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] 
	
	di "eff for cluster 3, ideal"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 4, ideal"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 5, ideal"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xideal
	
	
	
	
	
*** women's role
	mi xeq 1: sum womensroles [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xwomensroles = womensroles
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked xwomensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked xwomensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked xwomensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked xwomensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	
	
	quietly mi xeq: replace xwomensroles = `=p25'
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	* prob after change category
	quietly mi xeq: replace xwomensroles = `=p75'
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] 
	
	di "eff for cluster 1, women's role"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 2, women's role"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] 
	
	di "eff for cluster 3, women's role"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 4, women's role"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 5, women's role"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xwomensroles	
	
	
	
	
	
*** Religious attend (ref: < monthly): monthly, weekly
	
	quietly mi xeq: gen xreligion_freq = religion_freq
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.xreligion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.xreligion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.xreligion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.xreligion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xreligion_freq = 1
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	forval y=2/3 { 
		
		* prob after change category
		quietly mi xeq: replace xreligion_freq = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, religion_freq level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, religion_freq level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, religion_freq level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, religion_freq level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, religion_freq level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xreligion_freq	
	
	
	
	
*** Mom's educ (ref: HS): <HS, some college, college+

	quietly mi xeq: gen xmom_educ = mom_educ
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.xmom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.xmom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.xmom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.xmom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xmom_educ = 2
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	foreach y of num 1 3 4 0 { 
		
		* prob after change category
		quietly mi xeq: replace xmom_educ = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, mom_educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, mom_educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, mom_educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, mom_educ level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, mom_educ level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xmom_educ
	
	
	
*** Mom worked (ref: no): yes

	quietly mi xeq: gen xmom_worked = mom_worked
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.xmom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.xmom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.xmom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.xmom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xmom_worked = 0
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)

		
	* prob after change category
	quietly mi xeq: replace xmom_worked = 1
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] 
	
	di "eff for cluster 1, whether mom worked"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 2, whether mom worked"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] 
	
	di "eff for cluster 3, whether mom worked"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 4, whether mom worked"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 5, whether mom worked"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xmom_worked
	
	
	
*** Age at maternity (ref: 20-25): <20, >26
	quietly mi xeq: gen xage_gp = age_gp
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.xage_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.xage_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.xage_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.xage_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xage_gp = 2 
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	foreach y of numlist 1 3 { 
		
		* prob after change category
		quietly mi xeq: replace xage_gp = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, age level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, age level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, age level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, age level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, age level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xage_gp
	
	
	
	
*** Marital status (ref: single/previously married): married
	quietly mi xeq: gen xmarstat = marstat
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.xmarstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.xmarstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.xmarstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.xmarstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xmarstat = 0
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	
	* prob after change category
	quietly mi xeq: replace xmarstat = 1
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] 
	
	di "eff for cluster 1, marstat"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 2, marstat"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] 
	
	di "eff for cluster 3, marstat"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 4, marstat"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] 
	
	di "eff for cluster 5, marstat"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d


	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xmarstat	
	
	
*** Race (ref: white): black, Hispanic
	quietly mi xeq: gen xrace = race
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.xrace i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.xrace i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.xrace i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.xrace i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp [pw=wt] if ever_return==1
	


	* baseline prob
	quietly mi xeq: replace xrace = 3
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	foreach y of numlist 1 2 { 
		
		* prob after change category
		quietly mi xeq: replace xrace = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] 
		
		di "eff for cluster 1, race level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 2, race level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] 
		
		di "eff for cluster 3, race level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 4, race level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] 
		
		di "eff for cluster 5, race level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xrace	
	
	
	
	
*** switch to work sample ***
	
	
*** Wage (ref: 25th): 75th
	mi xeq 1: sum rate_adj_log if work_sample==1 [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xrate_adj_log = rate_adj_log

	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log xrate_adj_log if work_sample==1 [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log xrate_adj_log [pw=wt] if work_sample==1 & cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log xrate_adj_log [pw=wt] if work_sample==1 & cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log xrate_adj_log [pw=wt] if work_sample==1 & ever_return==1
	
	
	quietly mi xeq: replace xrate_adj_log = `=p25'
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	* prob after change category
	quietly mi xeq: replace xrate_adj_log = `=p75'
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 1, wage"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 2, wage"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 3, wage"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 4, wage"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 5, wage"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xrate_adj_log	
	
	
	
	
*** Tenure (ref: 25th): 75th
	mi xeq 1: sum tenure_log if work_sample==1 [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xtenure_log = tenure_log
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xtenure_log rate_adj_log [pw=wt] if work_sample==1
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xtenure_log rate_adj_log [pw=wt] if work_sample==1 & cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xtenure_log rate_adj_log [pw=wt] if work_sample==1 & cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xtenure_log rate_adj_log [pw=wt] if work_sample==1 & ever_return==1
	
	
	quietly mi xeq: replace xtenure_log = `=p25'
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	* prob after change category
	quietly mi xeq: replace xtenure_log = `=p75'
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 1, tenure"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 2, tenure"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 3, tenure"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 4, tenure"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] if work_sample==1
	
	di "eff for cluster 5, tenure"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xtenure_log	
		
	

	
*** switch to married sample ***
	

*** Spouse earnings (ref: 25th): 75th
	
	quietly mi xeq: gen xspearn_p = spearn_p

	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xspearn_p i.spouse_hours_gp if married_sample==1 [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xspearn_p i.spouse_hours_gp [pw=wt] if married_sample==1 & cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xspearn_p i.spouse_hours_gp [pw=wt] if married_sample==1 & cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp xspearn_p i.spouse_hours_gp [pw=wt] if married_sample==1 & ever_return==1
	
	
	quietly mi xeq: replace xspearn_p = 0.25
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	* prob after change category
	quietly mi xeq: replace xspearn_p = 0.75
	
	quietly mi predict xb_p1_m1 using miestfile1, storecomp
	quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
	
	quietly mi predict xb_p1_m2 using miestfile2, storecomp
	quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
	
	quietly mi predict xb_p1_m3 using miestfile3, storecomp
	quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
	
	quietly mi predict xb_p1_m4 using miestfile4, storecomp
	quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
	
	
	
	*** diff of prob
	* P(FT) = P(cont work) * P(FT | cont work)
	quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
	quietly misum d [aw=wt] if married_sample==1
	
	di "eff for cluster 1, spouse earning"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
	quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
	quietly misum d [aw=wt] if married_sample==1
	
	di "eff for cluster 2, spouse earning"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
	quietly misum d [aw=wt] if married_sample==1
	
	di "eff for cluster 3, spouse earning"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
	* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
	quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
	quietly misum d [aw=wt] if married_sample==1
	
	di "eff for cluster 4, spouse earning"
	di %5.2f r(d_mean)
	drop d
	
	
	* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
	* = (1-P(cont work)) * (1-P(ever return | no cont work))
	quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
	quietly misum d [aw=wt] if married_sample==1
	
	di "eff for cluster 5, spouse earning"
	di %5.2f r(d_mean)
	drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xspearn_p
	
	
	
*** spouse weekly work hours (ref: less than FT) | FT, overtime
	quietly mi xeq: gen xspouse_hours_gp = spouse_hours_gp
	
	* 1 - P(consistent employment vs. not)
	quietly mi estimate, saving(miestfile1, replace): logit cont_work i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp spearn_p i.xspouse_hours_gp if married_sample==1 [pw=wt]
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	quietly mi estimate, saving(miestfile2, replace): logit dv1 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp spearn_p i.xspouse_hours_gp [pw=wt] if married_sample==1 & cont_work==1
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	quietly mi estimate, saving(miestfile3, replace): logit ever_return i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp spearn_p i.xspouse_hours_gp [pw=wt] if married_sample==1 & cont_work==0
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	quietly mi estimate, saving(miestfile4, replace): logit dv3 i.race i.age_gp i.educ i.marstat i.mom_educ i.mom_worked womensroles ideal i.religion_freq i.work35 i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp spearn_p i.xspouse_hours_gp [pw=wt] if married_sample==1 & ever_return==1
	
	
	
	* baseline prob
	quietly mi xeq: replace xspouse_hours_gp = 0
	
	quietly mi predict xb_p0_m1 using miestfile1, storecomp 
	quietly mi xeq: gen p0_m1 = invlogit(xb_p0_m1)
	
	quietly mi predict xb_p0_m2 using miestfile2, storecomp 
	quietly mi xeq: gen p0_m2 = invlogit(xb_p0_m2)
	
	quietly mi predict xb_p0_m3 using miestfile3, storecomp 
	quietly mi xeq: gen p0_m3 = invlogit(xb_p0_m3)
	
	quietly mi predict xb_p0_m4 using miestfile4, storecomp 
	quietly mi xeq: gen p0_m4 = invlogit(xb_p0_m4)
	
	
	foreach y of numlist 1 2 { 
		
		* prob after change category
		quietly mi xeq: replace xspouse_hours_gp = `y'
		
		quietly mi predict xb_p1_m1 using miestfile1, storecomp
		quietly mi xeq: gen p1_m1 = invlogit(xb_p1_m1)
		
		quietly mi predict xb_p1_m2 using miestfile2, storecomp
		quietly mi xeq: gen p1_m2 = invlogit(xb_p1_m2)
		
		quietly mi predict xb_p1_m3 using miestfile3, storecomp
		quietly mi xeq: gen p1_m3 = invlogit(xb_p1_m3)
		
		quietly mi predict xb_p1_m4 using miestfile4, storecomp
		quietly mi xeq: gen p1_m4 = invlogit(xb_p1_m4)
		
		
		
		*** diff of prob
		* P(FT) = P(cont work) * P(FT | cont work)
		quietly mi xeq: gen d = p1_m1*p1_m2-p0_m1*p0_m2
		quietly misum d [aw=wt] if married_sample==1
		
		di "eff for cluster 1, spouse hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(PT) = P(cont work) * P(PT | cont work) = P(cont work) * (1 - P(FT | cont work))
		quietly mi xeq: gen d = p1_m1*(1-p1_m2)-p0_m1*(1-p0_m2)
		quietly misum d [aw=wt] if married_sample==1
		
		di "eff for cluster 2, spouse hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(early return) = P(not cont work) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * P(early return | not cont work, ever return)
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*p1_m4-(1-p0_m1)*p0_m3*p0_m4
		quietly misum d [aw=wt] if married_sample==1
		
		di "eff for cluster 3, spouse hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(late return) = P(not cont work) * P(ever return | no cont work) * P(late return | not cont work, ever return)
		* = (1-P(cont work)) * P(ever return | no cont work) * (1-P(early return | not cont work, ever return))
		quietly mi xeq: gen d = (1-p1_m1)*p1_m3*(1-p1_m4)-(1-p0_m1)*p0_m3*(1-p0_m4)
		quietly misum d [aw=wt] if married_sample==1
		
		di "eff for cluster 4, spouse hours level `y'"
		di %5.2f r(d_mean)
		drop d
		
		
		* P(nonemp) = P(not cont work) * P(not ever return | no cont work)
		* = (1-P(cont work)) * (1-P(ever return | no cont work))
		quietly mi xeq: gen d = (1-p1_m1)*(1-p1_m3)-(1-p0_m1)*(1-p0_m3)
		quietly misum d [aw=wt] if married_sample==1
		
		di "eff for cluster 5, spouse hours level `y'"
		di %5.2f r(d_mean)
		drop xb_p1_m1 p1_m1 xb_p1_m2 p1_m2 xb_p1_m3 p1_m3 xb_p1_m4 p1_m4 d
	
	}
	drop xb_p0_m1 p0_m1 xb_p0_m2 p0_m2 xb_p0_m3 p0_m3 xb_p0_m4 p0_m4 xspouse_hours_gp
		
