*****************************************************
***                   OptOut                      ***
***             Replication Package               ***
***                  June 2018                    ***
***          Prepared by Xiaolin Zhuo             ***
*****************************************************


*** setup

	cd "/Users/xzhuo/Projects/OptOut New/replication_package_06252018/data"
	set more off
	

*** log
	log using "../optout_session", replace
	
	
*** merge IVs and DVs and carry out multiple imputation
	do "../analysis/impute2.do"

	
*****************************************************
***            Tables in main text                ***
*****************************************************
	
*** Table 2: descriptive statistics in post-1979 sample
	
	use data_all, replace
	
	*** look at only 18-year-seq and post-1979 sample
	tab sample18 post1979_sample, m
	keep if sample18==1 & post1979_sample==1
	f
	
	***set up svy
	svyset [pweight=wt]
	
	
	* cluster membership
	tab dv18 // counts
	svy: tab dv18, format(%9.2f) // post-1979 sample
	tab dv18 
		
	
	
*** human capital	
	
	**education
	*overall
	svy: tab educ dv18, col format(%9.2f)
	//tab educ dv18 [aw=wt], col format(%9.2f)
	
	mlogit educ i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately - for significance test
	tab educ, gen(educ)

	logit educ1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ4 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	
	** hours of paid work between two and one years prior to birth
	svy: tab hours_2y_to_1y_gp dv18, col  format(%9.2f)
	
	mlogit hours_2y_to_1y_gp i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	* separately
	tab hours_2y_to_1y_gp, gen(hours)
	
	logistic hours1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic hours2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic hours3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18	
	
	drop hours1-hours3
	
	
	
	** hours of paid work during the year prior to birth
	svy: tab hours_1y_to_birth_gp dv18, col format(%9.2f)
	
	mlogit hours_1y_to_birth_gp i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	* separately
	tab hours_1y_to_birth_gp, gen(hours)
	
	logistic hours1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic hours2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logistic hours3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	drop hours1-hours3


	
	**job tenure
	by dv18, sort: sum tenure [aw=wt] if work_sample==1
	sum tenure [aw=wt] if work_sample==1
	
	reg tenure i.dv18 if work_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
	**wage - now wage is top- and bottom-coded
	by dv18, sort: sum rate_adj [aw=wt] if work_sample==1
	sum rate_adj [aw=wt] if work_sample==1
	
	reg rate_adj i.dv18 if work_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
*** attitudes & cultural models
	
	**work at age 35
	svy: tab work35 dv18, col format(%9.2f)
	
	logit work35 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	* separately
	gen work35_yes = work35==1
	gen work35_no = work35==0
	
	logit work35_yes i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit work35_no i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
		
	
	
	**ideal number of children 
	by dv18, sort: sum ideal [aw=wt]
	sum ideal [aw=wt]
	
	reg ideal i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

		
	
	**women's role
	sum womensroles // get range
	
	by dv18, sort: sum womensroles [aw=wt]
	sum womensroles [aw=wt]

	reg womensroles i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
	**mother's education
	*overall
	svy: tab mom_educ dv18, col format(%9.2f)
	
	mlogit mom_educ i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	*separately
	gen ma_educ_less_hs = mom_educ==1
	gen ma_educ_hs = mom_educ==2
	gen ma_educ_some_col = mom_educ==3
	gen ma_educ_col = mom_educ==4
	gen ma_educ_no_ma = mom_educ==0
	
	svy: mean ma_educ_no_ma, over(dv18) // same as the category ma_worked_NA below - double check to ensure same %
	
	logistic ma_educ_less_hs i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_hs i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_some_col i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_col i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_no_ma i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	

	**mother employed
	*overall
	svy: tab mom_worked dv18, col format(%9.2f)
	
	mlogit mom_worked i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen ma_worked_yes = mom_worked==1
	gen ma_worked_no = mom_worked==0
	gen ma_worked_NA = mom_worked==2
	
	svy: mean ma_worked_NA, over(dv18)
	
	logistic ma_worked_yes i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_worked_no i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_worked_NA i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	
	
	* religious attendence
	* values
	* 1 - < monthly
	* 2 - monthly but not weekly
	* 3 - weekly+
	
	svy: tab religion_freq dv18, col format(%9.2f)
		
	mlogit religion_freq i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	* separately
	tab religion_freq, gen(rel_att)

	logit rel_att1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logit rel_att2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logit rel_att3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	

*** family experience

	* numchild 
	tab numchild 
	
	by dv18, sort: sum numchild [aw=wt]
	sum numchild [aw=wt]

	reg numchild i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
	**age at first birth
	svy: tab age_gp dv18, col format(%9.2f)
	
	mlogit age_gp i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	* separately 
	tab age_gp, gen(age)
	
	logit age1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit age2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logit age3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	

	
	**marital status: now two levels only, married and nonmarried
	*overall
	svy: tab marstat dv18, col format(%9.2f)
	
	logit marstat i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen marstat_nonmarried = marstat==0
	gen marstat_married = marstat==1
	
	logistic marstat_nonmarried i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic marstat_married i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
	**spouse's earnings
	by dv18, sort: sum spouse_earning_adj [aw=wt] if married_sample==1
	sum spouse_earning_adj [aw=wt]
	
	reg spouse_earning_adj i.dv18 if married_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18	
	
	
	
	**spouse's work hours
	*overall
	svy: tab spouse_hours_gp dv18 if married_sample==1, col format(%9.2f)
	
	mlogit spouse_hours_gp i.dv18 if married_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	* separately 
	gen spouse_less_ft = spouse_hours_gp==0
	gen spouse_ft = spouse_hours_gp==1
	gen spouse_over = spouse_hours_gp==2
	
	logistic spouse_less_ft i.dv18 if married_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic spouse_ft i.dv18 if married_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logistic spouse_over i.dv18 if married_sample==1 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
*** race
	*overall
	svy: tab race dv18, col format(%9.2f)
	
	mlogit race i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen hispanic = race==1
	gen black = race==2
	gen white = race==3
	
	logistic hispanic i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic black i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic white i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
*****************************************************

*** Table 3: weighted mlogit model in post-1979 sample

	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	

*****************************************************

*** Table 4: average chagnes in predicted prob in post-1979 sample

	do "../analysis/AME.do"
	
	

*****************************************************

*** Table 5: weighted mlogit married model

	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp

	mi xeq 0: tab post1979_sample married_sample if sample18==1

	eststo clear                               
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	

*****************************************************

*** Table 6: weighted mlogit work model

	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp

	mi xeq 0: tab post1979_sample work_sample if sample18==1
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat tenure_log rate_adj_log i.race if sample18==1 & work_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat tenure_log rate_adj_log i.race if sample18==1 & work_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat tenure_log rate_adj_log i.race if sample18==1 & work_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat tenure_log rate_adj_log i.race if sample18==1 & work_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace	
	
	

*****************************************************
***          Tables in online supplement          ***
*****************************************************



*****************************************************

*** Table S1: mlogit model in post-1979 sample, unweighted
		
	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp		
		
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1, base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1, base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1, base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1, base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	
*****************************************************

*** Table S2: mlogit model in married sample, unweighted
	
	* married sample
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1, base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1, base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1, base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1, base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	
	
	
*****************************************************

*** Table S3: mlogit model in work sample, unweighted
	
	* working sample	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1, base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1, base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1, base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1, base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	

*****************************************************

*** Table S4: mlogit model in post-1979 sample, using all-survey-waves weights 
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=allwt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=allwt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=allwt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=allwt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	
	
*****************************************************

*** Table S5: mlogit model in married sample, using all-survey-waves weights 	

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=allwt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=allwt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=allwt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=allwt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	
*****************************************************

*** Table S6: mlogit model in work sample, using all-survey-waves weights 	
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1 [pw=allwt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1 [pw=allwt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1 [pw=allwt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & work_sample==1 [pw=allwt], base(4)	
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
		 

*****************************************************

*** Table S9: weighted sequential logit model, post-1979 sample

	* setup
	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp

	
	mi xeq 0: tab sample18 post1979_sample, m
	quietly mi xeq: keep if sample18==1 & post1979_sample==1
	
	
	* define new dummies
	quietly mi xeq: gen cont_work = (dv18 <= 2)
	mi xeq 0: tab dv18 cont_work
	
	quietly mi xeq: gen ever_return = (dv18==3 | dv18==4)
	mi xeq 0: tab dv18 ever_return
	
	quietly mi xeq: gen dv = dv18
	quietly mi xeq: tab dv, gen(dv)
	
	mi xeq 0: tab dv1 dv18
		 
		 
	* 1 - P(consistent employment vs. not)
	eststo clear
	mi estimate, post: logit cont_work i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt]
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	eststo clear
	mi estimate, post: logit dv1 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if cont_work==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	eststo clear
	mi estimate, post: logit ever_return i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if cont_work==0
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	eststo clear
	mi estimate, post: logit dv3 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if ever_return==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
		 
		 
		 
*****************************************************

*** Table S10: weighted sequential logit model, married sample

	* 1 - P(consistent employment vs. not)
	eststo clear
	mi estimate, post: logit cont_work i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race if married_sample==1 [pw=wt]
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	eststo clear
	mi estimate, post: logit dv1 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race [pw=wt] if married_sample==1 & cont_work==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	eststo clear
	mi estimate, post: logit ever_return i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race [pw=wt] if married_sample==1 & cont_work==0
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	eststo clear
	mi estimate, post: logit dv3 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp i.race [pw=wt] if married_sample==1 & ever_return==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append

		 
		 
*****************************************************

*** Table S11: weighted sequential logit model, work sample	

	eststo clear
	mi estimate, post: logit cont_work i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if work_sample==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	* 2 - If consistent employment, P(consistent FT| some kind of consistent)
	eststo clear
	mi estimate, post: logit dv1 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if cont_work==1 & work_sample==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 3 - If not consistent employment, P(ever returns | not consistent)
	eststo clear
	mi estimate, post: logit ever_return i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if cont_work==0 & work_sample==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	* 4 - If returns, P(returns quickly | not consistent but does return)
	eststo clear
	mi estimate, post: logit dv3 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt] if ever_return==1 & work_sample==1
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 append
	
	
	
*****************************************************

*** Table S12: diff of predicted prob in post-1979 sample, sequential logistic model

	do "../analysis/AME_seq_logit.do"

		
	
	
*****************************************************

*** Table S13: descriptive table in extended sample

	use data_all, replace
	
	*** look at only 18-year-seq
	tab sample18, m
	keep if sample18==1
	
	
	**set up svy
	svyset [pweight=wt]

	
	* clusters
	tab dv18 // counts
	svy: tab dv18, format(%9.2f) // weighted percent
	
	
	**education
	*overall
	svy: tab educ dv18, col format(%9.2f)
	
	mlogit educ i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately - for significance test
	tab educ, gen(educ)

	logit educ1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit educ4 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18


*** attitudes & culture models

	**mother's education
	*overall
	svy: tab mom_educ dv18, col format(%9.2f)
	
	mlogit mom_educ i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	*separately
	gen ma_educ_less_hs = mom_educ==1
	gen ma_educ_hs = mom_educ==2
	gen ma_educ_some_col = mom_educ==3
	gen ma_educ_col = mom_educ==4
	gen ma_educ_no_ma = mom_educ==0
	
	svy: mean ma_educ_no_ma, over(dv18) // same as the category ma_worked_NA below - double check to ensure same %
	
	logistic ma_educ_less_hs i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_hs i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_some_col i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_col i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_educ_no_ma i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	

	**mother employed
	*overall
	svy: tab mom_worked dv18, col format(%9.2f)
	
	mlogit mom_worked i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen ma_worked_yes = mom_worked==1
	gen ma_worked_no = mom_worked==0
	gen ma_worked_NA = mom_worked==2
	
	svy: mean ma_worked_NA, over(dv18)
	svy: mean ma_worked_NA
	
	logistic ma_worked_yes i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_worked_no i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic ma_worked_NA i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
*** family experiences	

	** age at first birth
	svy: tab age_gp dv18, col format(%9.2f)
	
	mlogit age_gp i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	* separately 
	tab age_gp, gen(age)
	
	logit age1 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logit age2 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	logit age3 i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18


	* numchild
	tab numchild
	
	by dv18, sort: sum numchild [aw=wt]
	sum numchild [aw=wt]

	reg numchild i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	
	
	**marital status 
	*overall
	svy: tab marstat dv18, col format(%9.2f)
	
	mlogit marstat i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen marstat_nonmarried = marstat==0
	gen marstat_married = marstat==1
	
	logistic marstat_married i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic marstat_nonmarried i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	
	
*** race
	*overall
	svy: tab race dv18, col format(%9.2f)
	
	mlogit race i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	*separately
	gen hispanic = race==1
	gen black = race==2
	gen white = race==3
	
	logistic hispanic i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic black i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18
	
	logistic white i.dv18 [pw=wt]
	test 2.dv18 3.dv18 4.dv18 5.dv18

	
	
*****************************************************

*** Table S14: weighted mlogit model in extended sample

	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	

	
*****************************************************

*** Table S15: weighted mlogit extended-sample model in post-1979 sample

	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(2)		
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(3)		
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ i.mom_educ i.mom_worked i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	


*****************************************************

*** Table S16: variable missingness

	use data_all, replace
	
	mdesc race age educ marstat mom_educ mom_grade mom_worked if sample18==1
	mdesc womensroles ideal religion_freq work35 hours_2y_to_1y hours_1y_to_birth if sample18==1 & post1979_sample == 1
	mdesc spouse_earning_adj spouse_hours spouse_hours_gp if sample18==1 & married_sample == 1
	mdesc tenure rate_adj if sample18==1 & work_sample == 1
	
	
	
	
*****************************************************
***          Extra models/effects examined        ***
*****************************************************

*** gender traditionalism value index

*** import data
	import delimited "attitude.csv", clear

*** code nonresponses ***
	foreach v of varlist * {
	 replace `v' = .a if `v'  == -1
	 replace `v' = .b if `v' == -2
	 replace `v' = .c if `v' == -3
	 replace `v' = .d if `v' == -4
	 replace `v' = .e if `v' == -5
	}
	

* keep only analytical sample
	merge 1:1 caseid_1979 using data_all
	keep if _merge==3
	
* check missing
	mdesc 

* we use 1979 attitude variables	
	/* documentation of gender role variables:
	
	Eight statements:
	womens_roles_000001: A WOMAN'S PLACE IS IN THE HOME, NOT IN THE OFFICE OR SHOP.
	womens_roles_000002: A WIFE WHO CARRIES OUT HER FULL FAMILY RESPONSIBILITIES DOESN'T HAVE TIME FOR OUTSIDE EMPLOYMENT.
	womens_roles_000003: A WORKING WIFE FEELS MORE USEFUL THAN ONE WHO DOESN'T HOLD A JOB.
	womens_roles_000004: THE EMPLOYMENT OF WIVES LEADS TO MORE JUVENILE DELINQUENCY.
	womens_roles_000005: EMPLOYMENT OF BOTH PARENTS IS NECESSARY TO KEEP UP WITH THE HIGH COST OF LIVING.
	womens_roles_000006: IT IS MUCH BETTER FOR EVERYONE CONCERNED IF THE MAN IS THE ACHIEVER OUTSIDE THE HOME AND THE WOMAN TAKES CARE OF THE HOME AND FAMILY.
	womens_roles_000007: MEN SHOULD SHARE THE WORK AROUND THE HOUSE WITH WOMEN, SUCH AS DOING DISHES, CLEANING, AND SO FORTH.
	womens_roles_000008: WOMEN ARE MUCH HAPPIER IF THEY STAY AT HOME AND TAKE CARE OF THEIR CHILDREN.
	
	Reaction options:
	1 STRONGLY DISAGREE
    2 DISAGREE
    3 AGREE
    4 STRONGLY AGREE
	
	For most variables, 1 - attitudes like a working mother, 4 - a more home-oriented mother
	womens_roles_000003, womens_roles_000005, womens_roles_000007 are reversed
	*/
	
* PCA

	* recode the reversed variables
	gen womens_roles_000003_1979_rev = 5-womens_roles_000003_1979
	gen womens_roles_000005_1979_rev = 5-womens_roles_000005_1979
	gen womens_roles_000007_1979_rev = 5-womens_roles_000007_1979

	* check if recoding was correctly done
	corr womens_roles_000003_1979_rev womens_roles_000003_1979
	corr womens_roles_000005_1979_rev womens_roles_000005_1979
	corr womens_roles_000007_1979_rev womens_roles_000007_1979

	pca womens_roles_000001_1979 womens_roles_000002_1979 womens_roles_000003_1979_rev womens_roles_000004_1979 womens_roles_000005_1979_rev womens_roles_000006_1979 womens_roles_000007_1979_rev womens_roles_000008_1979
	screeplot, yline(1) ci(het)

	
* construct our gender value measures
	egen nmis=rmiss2(womens_roles_000001_1979 womens_roles_000002_1979 womens_roles_000004_1979 womens_roles_000006_1979 womens_roles_000008_1979)
	tab nmis
	
	* no missing, post-1979 sample 
	alpha womens_roles_000001_1979 womens_roles_000002_1979 womens_roles_000004_1979 womens_roles_000006_1979 womens_roles_000008_1979 if nmis==0 & post1979_sample==1

	* no missing, post-1979 sample, 18-year-seq sample
	alpha womens_roles_000001_1979 womens_roles_000002_1979 womens_roles_000004_1979 womens_roles_000006_1979 womens_roles_000008_1979 if nmis==0 & post1979_sample==1 & sample18==1
	


*****************************************************

*** racial/ethnic origins

* import data
	import delimited "ethnicity.csv", clear

* keep only analytical sample
	merge 1:1 caseid_1979 using data_all
	keep if _merge==3
	
* recode missings
	foreach v of varlist * {
	 replace `v' = .a if `v'  == -1
	 replace `v' = .b if `v' == -2
	 replace `v' = .c if `v' == -3
	 replace `v' = .d if `v' == -4
	 replace `v' = .e if `v' == -5
	}	
	
* check missing
	mdesc 	
	
/* documentation of origin variable
 code_dict = {0: 'NONE',
             1: 'BLACK',
             2: 'CHINESE',
             3: 'ENGLISH',
             4: 'FILIPINO',
             5: 'FRENCH',
             6: 'GERMAN',
             7: 'GREEK',
             8: 'HAWAIIAN, P.I.',
             9: 'INDIAN-AMERICAN OR NATIVE AMERICAN',
             10: 'ASIAN INDIAN',
             11: 'IRISH',
             12: 'ITALIAN',
             13: 'JAPANESE',
             14: 'KOREAN',
             15: 'CUBAN',
             16: 'CHICANO',
             17: 'MEXICAN',
             18: 'MEXICAN-AMER',
             19: 'PUERTO RICAN',
             20: 'OTHER HISPANIC',
             21: 'OTHER SPANISH',
             22: 'POLISH',
             23: 'PORTUGUESE',
             24: 'RUSSIAN',
             25: 'SCOTTISH',
             26: 'VIETNAMESE',
             27: 'WELSH',
             28: 'OTHER',
             29: 'AMERICAN'
             }
			 
			 
#our white/nonwhite categories
unknown = [0, 28, 29, -3, -2] 
white = [3, 5, 6, 7, 11, 12, 22, 23, 24, 25, 27] 
nonwhite = [1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26] 	 		 
*/
		
	gen unknown1 = inlist(origin_1_1979, 0, 28, 29) | origin_1_1979 == .b | origin_1_1979 == .c
	tab origin_1_1979 unknown1, m
	
	gen white1 = inlist(origin_1_1979, 3, 5, 6, 7, 11, 12, 22, 23, 24, 25, 27)
	
	gen nonwhite1 = inlist(origin_1_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	gen nonwhite2 = inlist(origin_2_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	gen nonwhite3 = inlist(origin_3_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	gen nonwhite4 = inlist(origin_4_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	gen nonwhite5 = inlist(origin_5_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	gen nonwhite6 = inlist(origin_6_1979, 1, 2, 4, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26)
	
	tab origin_1_1979 nonwhite1, m

	*** in our “white” category
	* percent report at least one non-white ethnicity
	gen nonwhite_atleastone = nonwhite1+nonwhite2+nonwhite3+nonwhite4+nonwhite5+nonwhite6>0
	tab nonwhite_atleastone if race==3 & sample18 ==1 [w=wt]  // 19%, pw not allowed
	mean nonwhite_atleastone if race==3 & sample18==1 [pw=wt]  // 19%
	
	* percent identify a non-white ethnicity as their first ethnicity
	tab nonwhite1 if race==3 & sample18 ==1  // 7%, pw not allowed
	mean nonwhite1 if race==3 & sample18==1 [pw=wt]  // 7%
	
	* percent have missing or an unnspecified first ethnicity
	tab unknown1 if race==3 & sample18==1 [w=wt]  // 13 %
	mean unknown1 if race==3 & sample18==1 [pw=wt] // 13%

	tab unknown1 if race==3 & sample18==1 & nonwhite_atleastone==1 [w=wt] // 13 %
	mean unknown1 if race==3 & sample18==1 & nonwhite_atleastone==1 [pw=wt]  // 13%



*****************************************************

*** Table S18: interaction effects: marriage X race

	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp
	
	* create dummies of interaction terms
	mi xeq: gen hispanic = race==1
	mi xeq: gen black = race==2
	mi xeq: gen white = race==3
	
	mi xeq: gen hispanic_married = hispanic * marstat
	mi xeq: gen black_married = black * marstat
	mi xeq: gen white_married = white * marstat
	

	eststo clear
	mi estimate, post: mlogit dv18 i.race i.hispanic_married i.black_married i.white_married i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp if sample18==1 & post1979_sample==1 [pw=wt], base(1)	
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.race i.hispanic_married i.black_married i.white_married i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp if sample18==1 & post1979_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.race i.hispanic_married i.black_married i.white_married i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp if sample18==1 & post1979_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.race i.hispanic_married i.black_married i.white_married i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp if sample18==1 & post1979_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	
	* F-test
	mi estimate, post: mlogit dv18 i.race i.marstat i.race##i.marstat i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp if sample18==1 & post1979_sample==1 [pw=wt], base(1)	
	mi test 1.race#1.marstat 2.race#1.marstat
	
	


*****************************************************

*** Table S19: interaction effects: marriage X educ

	* collapse educ to <= hs and > hs
	mi xeq 1: tab educ
	quietly mi xeq: gen educ2 = .
	quietly mi xeq: replace educ2 = 0 if educ<=2
	quietly mi xeq: replace educ2 = 1 if educ>2
	mi xeq 1: tab educ educ2

	* collapse educ to <= hs and > hs, create dummies of interaction terms
	mi xeq: gen less_hs = educ<=2
	mi xeq: gen more_hs = educ>2
	mi xeq 1: tab educ2 less_hs
	mi xeq 1: tab educ2 more_hs
	
	mi xeq: gen lesshs_married = less_hs * marstat
	mi xeq: gen morehs_married = more_hs * marstat

	eststo clear
	mi estimate, post: mlogit dv18 i.educ2 i.lesshs_married i.morehs_married i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ2 i.lesshs_married i.morehs_married i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.race if sample18==1 & post1979_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ2 i.lesshs_married i.morehs_married i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.race if sample18==1 & post1979_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	eststo clear
	mi estimate, post: mlogit dv18 i.educ2 i.lesshs_married i.morehs_married i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.race if sample18==1 & post1979_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace
	
	
	* F-test
	mi estimate, post: mlogit dv18 i.educ2 i.marstat i.educ2##i.marstat i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	mi test 1.educ2#1.marstat
		
	


*****************************************************	
	
*** interaction effects per reviewer request	
	
	*** setup
	use data_mi2_edited, replace
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp


	*** collapsed dummies (sometimes cells contain too few cases and mlogit does not converge, so collapse categorical variables)

	* create dummy of < median age in full sample
	mi xeq 1: sum age [w=wt], d
	scalar med_age = r(p50) 
	di med_age // median is 23	
	
	quietly mi xeq: gen young = 0
	quietly mi xeq: replace young = 1 if age < `=med_age'
	mi xeq 1: tab young, m
	mi xeq 1: sum age if young==0
	mi xeq 1: sum age if young==1

	
	* collapse hours to FT and not-FT
	quietly mi xeq: gen hours_2y_to_1y_gp2 = hours_2y_to_1y_gp
	quietly mi xeq: replace hours_2y_to_1y_gp2 = 1 if hours_2y_to_1y_gp == 0
	mi xeq 1: tab hours_2y_to_1y_gp hours_2y_to_1y_gp2
	
	quietly mi xeq: gen hours_1y_to_birth_gp2 = hours_1y_to_birth_gp
	quietly mi xeq: replace hours_1y_to_birth_gp2 = 1 if hours_1y_to_birth_gp == 0
	mi xeq 1: tab hours_1y_to_birth_gp hours_1y_to_birth_gp2
		
	
	* collapse educ to <= hs and > hs
	mi xeq 1: tab educ
	quietly mi xeq: gen educ2 = .
	quietly mi xeq: replace educ2 = 0 if educ<=2
	quietly mi xeq: replace educ2 = 1 if educ>2
	mi xeq 1: tab educ educ2
	
	
	/* collapse year to periods
	0: before 1980
	1: 1980-84
	2: 85-89
	3: 90-95
	4: 95-97 */
	quietly mi xeq: gen period = .
	quietly mi xeq: replace period = 0 if childbirth_year < 1980
	quietly mi xeq: replace period = 1 if childbirth_year >= 1980 & childbirth_year <= 1984
	quietly mi xeq: replace period = 2 if childbirth_year >= 1985 & childbirth_year <= 1989
	quietly mi xeq: replace period = 3 if childbirth_year >= 1990 & childbirth_year <= 1994
	quietly mi xeq: replace period = 4 if childbirth_year >= 1995 
	
	mi xeq 1: tab period 
	mi xeq 1: tab childbirth_year period
	mi xeq 0: tab age_gp period, m
	
	
	
	
*** R2.1 interaction effects
	
	* (1) interact spouse earning and wife education in married sample
	mi estimate: mlogit dv18 c.spearn_p##i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.spouse_hours_gp i.race if sample18==1 & married_sample==1 [pw=wt], base(1)
	mi test 1.educ#c.spearn_p 3.educ#c.spearn_p 4.educ#c.spearn_p
	
	* (2) interact wife wage and spouse earning in married & working sample
	mi estimate, post: mlogit dv18 c.spearn_p##c.rate_adj_log i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp tenure_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.spouse_hours_gp i.race if sample18==1 & married_sample==1 & work_sample==1 [pw=wt], base(1)
	mi test c.spearn_p#c.rate_adj_log
	
	

*** R2.6 interaction effects with age

	*** interact age and marital status
	
	*** in extended sample
	
		* use original age groups & marstat
		mi estimate: mlogit dv18 i.marstat##i.age_gp i.educ i.mom_educ i.mom_worked i.race if sample18==1 [pw=wt], base(1)
		mi test 1.marstat#1.age_gp 1.marstat#3.age_gp 

	
		* use collapsed age groups & marstat
		mi estimate: mlogit dv18 i.marstat##i.young i.educ i.mom_educ i.mom_worked i.race if sample18==1 [pw=wt], base(1)
		mi test 1.marstat#1.young
	
	
	* in post-1979 sample
		* use original age groups & marstat
		mi estimate: mlogit dv18 i.marstat##i.age_gp i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
		mi estimate: mlogit dv18 i.marstat##i.age_gp i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(2)
		mi estimate: mlogit dv18 i.marstat##i.age_gp i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(3)
		mi estimate: mlogit dv18 i.marstat##i.age_gp i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(4)
		mi test 1.marstat#1.age_gp 1.marstat#3.age_gp
		mi test 1.marstat#1.age_gp
		mi test 1.marstat#3.age_gp
	

		* use collapsed age groups & marstat
		mi estimate: mlogit dv18 i.marstat##i.young i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
		mi test 1.marstat#1.young

		
	
	*** interact age with hours
	* interact age and prior employment in post-1979 sample (2 hours variables)
	mi estimate: mlogit dv18 i.educ i.hours_2y_to_1y_gp##i.young i.hours_1y_to_birth_gp##i.young i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	mi test 1.hours_2y_to_1y_gp#1.young 2.hours_2y_to_1y_gp#1.young 1.hours_1y_to_birth_gp#1.young 2.hours_1y_to_birth_gp#1.young
	
	
	*** interact age and tenure in work sample		
	mi estimate: mlogit dv18 c.tenure_log##i.age_gp i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp rate_adj_log i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.marstat i.race if sample18==1 & work_sample==1 [pw=wt], base(1)
	mi test 1.age_gp#c.tenure_log 3.age_gp#c.tenure_log
		


*** R2.13 test IIA assumption. use sequential logit model. see above.
	

*** R2.11 interact education and marital status. see above.



*****************************************************	

* 2nd re-submission

*** interact mom educ and mom worked
	mi xeq 1: tab mom_educ mom_worked
                                                  
	mi estimate, post: mlogit dv18 i.mom_educ##i.mom_worked i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.age_gp i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)	
	
	* F-test
	mi test 1.mom_educ#1.mom_worked 
	mi test 3.mom_educ#1.mom_worked
	mi test 4.mom_educ#1.mom_worked
	mi test 1.mom_educ#1.mom_worked 3.mom_educ#1.mom_worked 4.mom_educ#1.mom_worked

	
	
*** Response Letter Figure 2: examine functional form of age ***

	* use age continuous, not dummy
	mi estimate, saving(miestfile, replace): mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked age i.marstat i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
		
	mi predict xb_1 using miestfile
	mi predict xb_2 using miestfile, equation(#2)
	mi predict xb_3 using miestfile, equation(#3)
	mi predict xb_4 using miestfile, equation(#4)
	mi predict xb_5 using miestfile, equation(#5)
	
	
	mi xeq 0: sort age
	mi xeq 0: twoway (scatter xb_2 age) || lowess xb_2 age 
	mi xeq 0: twoway (scatter xb_3 age) || lowess xb_3 age
	mi xeq 0: twoway (scatter xb_4 age) || lowess xb_4 age
	mi xeq 0: twoway (scatter xb_5 age) || lowess xb_5 age



*** Response Letter Table: regress on only exogenous variables, post-1979 sample, weighted ***
	eststo clear
	mi estimate, post: mlogit dv18 i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(1)
	esttab using "output1.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(2)
	esttab using "output2.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(3)
	esttab using "output3.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	eststo clear
	mi estimate, post: mlogit dv18 i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.race if sample18==1 & post1979_sample==1 [pw=wt], base(4)
	esttab using "output4.csv", csv b( %9.2f) se(%9.2f) ar2 replace

	
	
*** alt definition of spouse overwork ***
	use data_mi2_edited, clear
	mi fvset base 3 race
	mi fvset base 2 educ
	mi fvset base 2 mom_educ
	mi fvset base 2 age_gp

	
	quietly mi xeq: gen spouse_hours_gp2 = .
	quietly mi xeq: replace spouse_hours_gp2 = 0 if spouse_hours >= 0 & spouse_hours < 35
	quietly mi xeq: replace spouse_hours_gp2 = 1 if spouse_hours >= 35 & spouse_hours < 60
	quietly mi xeq: replace spouse_hours_gp2 = 2 if spouse_hours >= 60 & spouse_hours <.
	mi xeq 1: tab spouse_hours spouse_hours_gp2, m
	
	mi fvset base 1 spouse_hours_gp2
	
	
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp2 i.race if sample18==1 & married_sample==1 [pw=wt], base(1)
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp2 i.race if sample18==1 & married_sample==1 [pw=wt], base(2)
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp2 i.race if sample18==1 & married_sample==1 [pw=wt], base(3)
	mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.spouse_hours_gp2 i.race if sample18==1 & married_sample==1 [pw=wt], base(4)
	

log close
