*****************************************************************************
***                   Multiple Imputation Approach 2                      ***
*** impute in the full sample treating valid missings as regular missings ***
*****************************************************************************


*** Setup
	cd "/Users/xzhuo/Projects/OptOut New/data"
	set more off
	
	
*** data cleaning
	
	clear
	
	****** IMPORTANT: manually replace NA with none in csv file first  ******
	import delimited "dv_df.csv" 
	save "dv_df.dta", replace
	
	clear
	import delimited "iv_df_seq14_all.csv"
	
	* merge with dv
	merge 1:1 caseid_1979 using dv_df
	drop _merge
	
	tab post1979_sample, m
	tab married_sample, m
	tab work_sample, m
	
	tab post1979_sample married_sample
	tab post1979_sample work_sample
	
	* create a dummy for 18-year-seq sample
	gen sample18 = 0
	replace sample18 = 1 if dv18 < .
	tab sample18 dv18, m
	
	* calculate percentiles for spouse_earning_adj 
	pctile pct_spearn = spouse_earning_adj if sample18==1 & married_sample==1 [w=wt], nq(100)
	
	* topcode wage and tenure at 99th percentil and bottomcode at 1th percentile
	sum rate_adj [w=wt], d
	scalar p1_wage = r(p1) 
	scalar p99_wage = r(p99)
	di p1_wage
	di p99_wage
	
	replace rate_adj = `=p99_wage' if rate_adj > `=p99_wage' & rate_adj < .
	replace rate_adj = `=p1_wage' if rate_adj < `=p1_wage'
	sum rate_adj
	
	
	sum tenure [w=wt], d
	scalar p1_tenure = r(p1) 
	scalar p99_tenure = r(p99)
	di p1_tenure
	di p99_tenure
	
	replace tenure = `=p99_tenure' if tenure > `=p99_tenure' & tenure < .
	replace tenure = `=p1_tenure' if tenure < `=p1_tenure'
	sum tenure	
	
	
	*** NEW 12/8/2017: collapse level 4 and 5 in respondent's educ ***
	tab educ
	replace educ = 4 if educ == 5
	tab educ
	
	
	save "data_all.dta", replace

	
	
*** models and variables ***

/* Extended Sample: traits we have for everybody pre-birth

race age educ marstat mom_educ mom_worked


Post-1979 Sample: the 1979 interview is at least a year prior to the first birth

womensroles ideal religion religion_freq work35 hours_2y_to_1y hours_1y_to_birth


Married Sample: further subset the 2nd sample to those who are married at a month 
prior to the birth and add spouse annual work hours and annual earnings in the prior calendar year

spouse_earning_adj spouse_hours_gp


Working Sample: subset the 2nd sample to those who were employed at a year prior 
to the birth and add wage and tenure at 1 year prior to the birth

tenure rate_adj



====================================

variable functional form transformation after multiple imputation:

age: < 20, 20-25, > 25

hours_2y_to_1y & hours_1y_to_birth 
zero hours == 0
in-between
full-time: >= 1820 (35 hours/week x 52 week)

take log of tenure and rate_adj

use percentiles of spouse_earning_adj

spouse_hours categories: 
less than FT: [0, 35)
FT: [35, 50)
overtime: >= 50

*/	
	
	

*** APPROACH 2: impute in the full sample treating valid missings as regular missings
*** note: use continuous variables for both mom's education and spouse work hours for MI

	use data_all, replace
	
	* check missings
	mdesc race age educ marstat mom_educ mom_grade mom_worked
	mdesc womensroles ideal religion religion_freq work35 hours_2y_to_1y hours_1y_to_birth if post1979_sample == 1
	mdesc spouse_earning_adj spouse_hours spouse_hours_gp if married_sample == 1
	mdesc tenure rate_adj if work_sample == 1
	mdesc
	

	* to use continuous variable mom_grade in place for categorical variable mom_educ
	* we first need to create a dummy has_mom to account for respondents with no mother figure,
	* which is recorded in mom_educ, but not in mom_grade
	
	tab mom_grade mom_educ, m
	* mom_educ has a category of 0, meaning no mother figure
	* whereas mom_grade has a valid value 0, mom completed grade 0
	* so we create a dummy has_mom to separate the two kinds of 0
	
	gen has_mom = 1
	replace has_mom = 0 if mom_educ==0
	tab mom_educ has_mom 
		
	tab mom_grade has_mom, m
	
	tab has_mom mom_worked, m // mom_worked category 2 is no mom figure
	replace mom_worked = . if has_mom==0
	tab has_mom mom_worked, m

	
	mi set flong
	mi register imputed marstat mom_grade mom_worked womensroles ideal religion religion_freq work35 hours_2y_to_1y hours_1y_to_birth spouse_earning_adj spouse_hours tenure rate_adj dv18
	mi register regular race age educ has_mom dv14 wt14 post1979_sample married_sample work_sample sample18
	mi describe
	

	mi impute chained ///
		(pmm, knn(3)) womensroles ideal hours_2y_to_1y hours_1y_to_birth spouse_earning_adj tenure rate_adj mom_grade spouse_hours ///
		(mlogit) marstat religion religion_freq dv18 work35 ///
		(logit) mom_worked ///
		= i.race age i.educ wt14 i.dv14 i.has_mom i.post1979_sample i.married_sample i.work_sample i.sample18, ///
		burn(10) add(20) rseed(615) augment noisily

	
	* save imputatons
	save "data_mi2.dta", replace	
	
	
	* edit imputed data
	mi xeq: replace womensroles = . if post1979_sample == 0
	mi xeq: replace ideal = . if post1979_sample == 0
	mi xeq: replace religion = . if post1979_sample == 0
	mi xeq: replace religion_freq = . if post1979_sample == 0
	mi xeq: replace work35 = . if post1979_sample == 0
	mi xeq: replace hours_2y_to_1y  = . if post1979_sample == 0
	mi xeq: replace hours_1y_to_birth = . if post1979_sample == 0
	
	mi xeq: replace spouse_earning_adj = . if married_sample == 0
	mi xeq: replace spouse_hours = . if married_sample == 0
	
	mi xeq: replace tenure = . if work_sample == 0
	mi xeq: replace rate_adj = . if work_sample == 0
	
	
	* recode mom_educ
	mi xeq: rename mom_educ mom_educ_prev
	mi xeq: gen mom_educ = .
	mi xeq: replace mom_educ = 0 if has_mom==0
	mi xeq: replace mom_educ = 1 if has_mom==1 & mom_grade>=0 & mom_grade<12
	mi xeq: replace mom_educ = 2 if has_mom==1 & mom_grade==12
	mi xeq: replace mom_educ = 3 if has_mom==1 & mom_grade>12 & mom_grade<16
	mi xeq: replace mom_educ = 4 if has_mom==1 & mom_grade>=16 // collapse level 4 and 5
	// mi xeq: replace mom_educ = 5 if has_mom==1 & mom_grade>16 & mom_grade<.	
	
	mi xeq 1: tab mom_grade mom_educ
	mi xeq 1: tab has_mom mom_educ
	
	mi xeq 1: tab mom_educ mom_educ_prev, m
	
	
	* recode mom_worked
	mi xeq: replace mom_worked = 2 if has_mom==0
	mi xeq 1: tab has_mom mom_worked
	
	
	* recode spouse_hours_gp
	mi xeq 1: hist spouse_hours
	
	mi xeq: rename spouse_hours_gp spouse_hours_gp_prev
	
	mi xeq: gen spouse_hours_gp = .
	mi xeq: replace spouse_hours_gp = 0 if spouse_hours >= 0 & spouse_hours < 35
	mi xeq: replace spouse_hours_gp = 1 if spouse_hours >= 35 & spouse_hours < 50
	mi xeq: replace spouse_hours_gp = 2 if spouse_hours >= 50 & spouse_hours <.
	mi xeq 1: tab spouse_hours_gp, m
	mi xeq 1: tab spouse_hours spouse_hours_gp_prev, m
	mi xeq 1: tab spouse_hours_gp spouse_hours_gp_prev, m // overlap due to definition change in level 2, now include 50 hrs
	
	
	* transform spouse earnings to percentile, using percentile cutoff saved from before
	* each interval include upper boundary
	mi xeq: gen spearn_p = .
	mi xeq: replace spearn_p = 1 if spouse_earning_adj <= pct_spearn[1] & married_subsample==1
	forval i=2/99 {
		mi xeq: replace spearn_p = `i' if spouse_earning_adj > pct_spearn[`i'-1] & spouse_earning_adj <= pct_spearn[`i'] & married_subsample==1
	}
	mi xeq: replace spearn_p = 100 if spouse_earning_adj > pct_spearn[99] & married_subsample==1	
	
	
	* divide percentile by 100
	mi xeq: replace spearn_p = spearn_p/100
	
	
	* topcode and bottomcode tenure and wage
	mi xeq: replace rate_adj = `=p99_wage' if rate_adj > `=p99_wage' & rate_adj < .	
	mi xeq: replace rate_adj = `=p1_wage' if rate_adj < `=p1_wage'
	di p1_wage
	di p99_wage
	mi xeq 1: sum rate_adj
		
	mi xeq: replace tenure = `=p99_tenure' if tenure > `=p99_tenure' & tenure < .
	mi xeq: replace tenure = `=p1_tenure' if tenure < `=p1_tenure'
	di p1_tenure
	di p99_tenure
	mi xeq 1: sum tenure
	
	
	* log tenure and rate adj
	mi xeq: gen rate_adj_log = .
	mi xeq: replace rate_adj_log = log(rate_adj) if work_sample==1
	
	mi xeq: gen tenure_log = .
	mi xeq: replace tenure_log = log(tenure) if work_sample==1
	
	
	* recode age
	mi xeq: gen age_gp = .
	mi xeq: replace age_gp = 1 if age < 20 // teen birth
	mi xeq: replace age_gp = 2 if age >= 20 & age < 26
	mi xeq: replace age_gp = 3 if age >= 26
	
	
	* recode hours_2y_to_1y, hours_1y_to_birth 
	* 1820 hours = 35 hours/week * 52 weeks
	mi xeq: gen hours_1y_to_birth_gp = .
	mi xeq: replace hours_1y_to_birth_gp = 0 if hours_1y_to_birth == 0 & post1979_sample==1
	mi xeq: replace hours_1y_to_birth_gp = 1 if hours_1y_to_birth > 0 & hours_1y_to_birth < 1820 & post1979_sample==1
	mi xeq: replace hours_1y_to_birth_gp = 2 if hours_1y_to_birth >= 1820 & post1979_sample==1

	mi xeq: gen hours_2y_to_1y_gp = .
	mi xeq: replace hours_2y_to_1y_gp = 0 if hours_2y_to_1y == 0 & post1979_sample==1
	mi xeq: replace hours_2y_to_1y_gp = 1 if hours_2y_to_1y > 0 & hours_2y_to_1y < 1820 & post1979_sample==1
	mi xeq: replace hours_2y_to_1y_gp = 2 if hours_2y_to_1y >= 1820 & post1979_sample==1
	

	
	* save edited data
	save "data_mi2_edited.dta", replace
	
