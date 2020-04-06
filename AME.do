*********************************************************************
*** Table 4: diff of predicted prob in post-1979 sample, weighted ***
*********************************************************************

/* basic steps:
	- get predicted prob p0 at baseline value of a given variable for each cluster
	- get predicted prob p1 at comparison value of the variable for each cluster
	- get weighted mean of change in predicted prob (p1-p0) for each cluster
*/


*** set up ***

	use data_mi2_edited, replace
	
	
	
*** first, look at only post-1979 sample
	
	mi xeq 0: tab sample18 post1979_sample, m
	quietly mi xeq: keep if sample18==1 & post1979_sample==1
	
	
	
*** Educ (ref: HS): <HS, Some college, college, >college
	quietly mi xeq: gen xeduc = educ
		
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.xeduc i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 if educ is set to 2 (hs) for everyone as baseline group
	quietly mi xeq: replace xeduc = 2
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.xeduc]*2.xeduc + [pt][3.xeduc]*3.xeduc + [pt][4.xeduc]*4.xeduc + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 + ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.xeduc]*2.xeduc + [early_return][3.xeduc]*3.xeduc + [early_return][4.xeduc]*4.xeduc + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 + ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.xeduc]*2.xeduc + [late_return][3.xeduc]*3.xeduc + [late_return][4.xeduc]*4.xeduc + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 + ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.xeduc]*2.xeduc + [nonemployed][3.xeduc]*3.xeduc + [nonemployed][4.xeduc]*4.xeduc + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 + ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
		
	* iterate thru educ levels other than baseline level and calculate prob p1 
	foreach y of numlist 1 3 4 { 
		estimates use alt
		quietly mi xeq: replace xeduc = `y'
		
		quietly mi xeq: gen xb1_1 = 0  
	
		quietly mi xeq: gen xb1_2 = [pt][2.xeduc]*2.xeduc + [pt][3.xeduc]*3.xeduc + [pt][4.xeduc]*4.xeduc + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 + ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][1.marstat]*1.marstat + ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.xeduc]*2.xeduc + [early_return][3.xeduc]*3.xeduc + [early_return][4.xeduc]*4.xeduc + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 + ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][1.marstat]*1.marstat + ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.xeduc]*2.xeduc + [late_return][3.xeduc]*3.xeduc + [late_return][4.xeduc]*4.xeduc + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 + ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.xeduc]*2.xeduc + [nonemployed][3.xeduc]*3.xeduc + [nonemployed][4.xeduc]*4.xeduc + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 + ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
			
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, educ level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, educ level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, educ level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, educ level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, educ level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	}
	
	drop xeduc xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
	
*** Exper (ref: none): <FT, FT (collapse across two years)

	quietly gen xhours_2y_to_1y_gp = hours_2y_to_1y_gp
	quietly gen xhours_1y_to_birth_gp = hours_1y_to_birth_gp
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.xhours_2y_to_1y_gp i.xhours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 at baseline level
	quietly mi xeq: replace xhours_2y_to_1y_gp = 0
	quietly mi xeq: replace xhours_1y_to_birth_gp = 0
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [pt][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
			[pt][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [pt][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 + ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [early_return][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
			[early_return][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [early_return][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 + ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [late_return][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
			[late_return][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [late_return][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 + ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [nonemployed][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
			[nonemployed][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [nonemployed][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 + ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
	
	* iterate through other levels
	forval y=1/2 { 
		estimates use alt
		quietly mi xeq: replace xhours_2y_to_1y_gp = `y'
		quietly mi xeq: replace xhours_1y_to_birth_gp = `y'
		
		quietly mi xeq: gen xb1_1 = 0
	
		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [pt][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
				[pt][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [pt][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][1.marstat]*1.marstat +  ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [early_return][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
				[early_return][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [early_return][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][1.marstat]*1.marstat +  ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [late_return][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
				[late_return][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [late_return][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.xhours_2y_to_1y_gp]*1.xhours_2y_to_1y_gp + [nonemployed][2.xhours_2y_to_1y_gp]*2.xhours_2y_to_1y_gp + ///
				[nonemployed][1.xhours_1y_to_birth_gp]*1.xhours_1y_to_birth_gp + [nonemployed][2.xhours_1y_to_birth_gp]*2.xhours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]	
			
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, hours level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, hours level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, hours level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, hours level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, hours level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	}
	

	drop xhours_2y_to_1y_gp xhours_1y_to_birth_gp xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5	
	
	
	
	
*** work 35 (ref: no/don't know): yes
	
	quietly mi xeq: gen xwork35 = work35
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.xwork35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xwork35 = 0
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.xwork35]*1.xwork35 + ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.xwork35]*1.xwork35 + ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.xwork35]*1.xwork35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.xwork35]*1.xwork35 + ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
		
		
	* calculate prob p1
	estimates use alt
	quietly mi xeq: replace xwork35 = 1
	
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.xwork35]*1.xwork35 + ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.xwork35]*1.xwork35 + ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.xwork35]*1.xwork35 + ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.xwork35]*1.xwork35 + ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
			
		
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, work35"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, work35"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, work35"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, work35"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, work35"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5

		
	drop xwork35 xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
		
	

*** ideal number of children - compare 75 percentile to 25th percentile
	mi xeq 1: sum ideal [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xideal = ideal
		
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 xideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xideal = `=p25'
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][xideal]*xideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][xideal]*xideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][xideal]*xideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][xideal]*xideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))		
		
		
			
	* calculate prob p1
	quietly mi xeq: replace xideal = `=p75'
	
	estimates use alt
	
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][xideal]*xideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][xideal]*xideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][xideal]*xideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][xideal]*xideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]	
		
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, ideal"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, ideal"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, ideal"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, ideal"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, ideal"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	
	
	drop xideal xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
	
*** women's role
	mi xeq 1: sum womensroles [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	
	quietly mi xeq: gen xwomensroles = womensroles
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal xwomensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xwomensroles = `=p25'
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][xwomensroles]*xwomensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][xwomensroles]*xwomensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][xwomensroles]*xwomensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][xwomensroles]*xwomensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
	
	* calculate p1
	quietly mi xeq: replace xwomensroles = `=p75'
	
	estimates use alt
		
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///			
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][xwomensroles]*xwomensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][xwomensroles]*xwomensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][xwomensroles]*xwomensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][xwomensroles]*xwomensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
		
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, women's role"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, women's role"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, women's role"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, women's role"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, women's role"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	
	drop xwomensroles xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5

	
	

*** Religious attend (ref: < monthly): monthly, weekly
	
	quietly mi xeq: gen xreligion_freq = religion_freq
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.xreligion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
	

	* calculate prob p0 
	quietly mi xeq: replace xreligion_freq = 1 
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.xreligion_freq]*2.xreligion_freq + [pt][3.xreligion_freq]*3.xreligion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.xreligion_freq]*2.xreligion_freq + [early_return][3.xreligion_freq]*3.xreligion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.xreligion_freq]*2.xreligion_freq + [late_return][3.xreligion_freq]*3.xreligion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.xreligion_freq]*2.xreligion_freq + [nonemployed][3.xreligion_freq]*3.xreligion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))		
		
		
		
	* calculate prob p1
	forval y=2/3 { 
		quietly mi xeq: replace xreligion_freq = `y'
		
		estimates use alt
		
		quietly mi xeq: gen xb1_1 = 0
	
		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.xreligion_freq]*2.xreligion_freq + [pt][3.xreligion_freq]*3.xreligion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][1.marstat]*1.marstat +  ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.xreligion_freq]*2.xreligion_freq + [early_return][3.xreligion_freq]*3.xreligion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][1.marstat]*1.marstat +  ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.xreligion_freq]*2.xreligion_freq + [late_return][3.xreligion_freq]*3.xreligion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.xreligion_freq]*2.xreligion_freq + [nonemployed][3.xreligion_freq]*3.xreligion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
			
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, religion_freq level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, religion_freq level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, religion_freq level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, religion_freq level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, religion_freq level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5		
		
	}
		
	drop xreligion_freq xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
	
*** Mom's educ (ref: HS): <HS, some college, college+

	quietly mi xeq: gen xmom_educ = mom_educ

	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.xmom_educ i.mom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
		
	
	* calculate prob p0 
	quietly mi xeq: replace xmom_educ = 2 // baseline prob
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.xmom_educ]*1.xmom_educ + [pt][2.xmom_educ]*2.xmom_educ + [pt][3.xmom_educ]*3.xmom_educ + [pt][4.xmom_educ]*4.xmom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.xmom_educ]*1.xmom_educ + [early_return][2.xmom_educ]*2.xmom_educ + [early_return][3.xmom_educ]*3.xmom_educ + [early_return][4.xmom_educ]*4.xmom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.xmom_educ]*1.xmom_educ + [late_return][2.xmom_educ]*2.xmom_educ + [late_return][3.xmom_educ]*3.xmom_educ + [late_return][4.xmom_educ]*4.xmom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.xmom_educ]*1.xmom_educ + [nonemployed][2.xmom_educ]*2.xmom_educ + [nonemployed][3.xmom_educ]*3.xmom_educ + [nonemployed][4.xmom_educ]*4.xmom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
	
	* calculate prob p1
	foreach y of num 1 3 4 0 { 
		quietly mi xeq: replace xmom_educ = `y'
		
		estimates use alt
		
		quietly mi xeq: gen xb1_1 = 0

		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.xmom_educ]*1.xmom_educ + [pt][2.xmom_educ]*2.xmom_educ + [pt][3.xmom_educ]*3.xmom_educ + [pt][4.xmom_educ]*4.xmom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][1.marstat]*1.marstat +  ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.xmom_educ]*1.xmom_educ + [early_return][2.xmom_educ]*2.xmom_educ + [early_return][3.xmom_educ]*3.xmom_educ + [early_return][4.xmom_educ]*4.xmom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][1.marstat]*1.marstat +  ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.xmom_educ]*1.xmom_educ + [late_return][2.xmom_educ]*2.xmom_educ + [late_return][3.xmom_educ]*3.xmom_educ + [late_return][4.xmom_educ]*4.xmom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.xmom_educ]*1.xmom_educ + [nonemployed][2.xmom_educ]*2.xmom_educ + [nonemployed][3.xmom_educ]*3.xmom_educ + [nonemployed][4.xmom_educ]*4.xmom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
				
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, mom_educ level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, mom_educ level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, mom_educ level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, mom_educ level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, mom_educ level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5		
		
	}
	drop xmom_educ xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
		
	
	
*** Mom worked (ref: no): yes

	quietly mi xeq: gen xmom_worked = mom_worked

	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.xmom_worked i.age_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
		
	* calculate prob p0 
	quietly mi xeq: replace xmom_worked = 0
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.xmom_worked]*1.xmom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.xmom_worked]*1.xmom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.xmom_worked]*1.xmom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.xmom_worked]*1.xmom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))		
		
		
	* calculate prob p1		
	quietly mi xeq: replace xmom_worked = 1
	estimates use alt
	
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.xmom_worked]*1.xmom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.xmom_worked]*1.xmom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.xmom_worked]*1.xmom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.xmom_worked]*1.xmom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
			
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, mom_worked"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, mom_worked"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, mom_worked"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, mom_worked"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, mom_worked"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5

	drop xmom_worked xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
	
	
*** Age at maternity (ref: 20-25): <20, 26)
	quietly mi xeq: gen xage_gp = age_gp
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.xage_gp i.marstat i.race [pw=wt], base(1)
	estimates save alt, replace
		
	* calculate prob p0 
	quietly mi xeq: replace xage_gp = 2
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.xage_gp]*2.xage_gp + [pt][3.xage_gp]*3.xage_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.xage_gp]*2.xage_gp + [early_return][3.xage_gp]*3.xage_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.xage_gp]*2.xage_gp + [late_return][3.xage_gp]*3.xage_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.xage_gp]*2.xage_gp + [nonemployed][3.xage_gp]*3.xage_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
			
		
				
	foreach y of num 1 3 { 
		quietly mi xeq: replace xage_gp = `y'
		
		estimates use alt
		
		quietly mi xeq: gen xb1_1 = 0

		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.xage_gp]*2.xage_gp + [pt][3.xage_gp]*3.xage_gp + ///
				[pt][1.marstat]*1.marstat +  ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.xage_gp]*2.xage_gp + [early_return][3.xage_gp]*3.xage_gp + ///
				[early_return][1.marstat]*1.marstat +  ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.xage_gp]*2.xage_gp + [late_return][3.xage_gp]*3.xage_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.xage_gp]*2.xage_gp + [nonemployed][3.xage_gp]*3.xage_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
				
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, age_gp level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, age_gp level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, age_gp level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, age_gp level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, age_gp level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	}
	drop xage_gp xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
*** Marital status (ref: single/previously married): married
	quietly mi xeq: gen xmarstat = marstat
		
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.xmarstat i.race [pw=wt], base(1)
	estimates save alt, replace
			
	* calculate prob p0 
	quietly mi xeq: replace xmarstat = 0
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.xmarstat]*1.xmarstat + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.xmarstat]*1.xmarstat + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.xmarstat]*1.xmarstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.xmarstat]*1.xmarstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
		
	
	* calculate prob p1
	quietly mi xeq: replace xmarstat = 1
	
	estimates use alt
	
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.xmarstat]*1.xmarstat + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.xmarstat]*1.xmarstat + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.xmarstat]*1.xmarstat + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.xmarstat]*1.xmarstat + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]		
			
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, marstat"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, marstat"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, marstat"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, marstat"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, marstat"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
		
	drop xmarstat xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	

*** Race (ref: white): black, Hispanic
	quietly mi xeq: gen xrace = race
		
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat i.xrace [pw=wt], base(1)
	estimates save alt, replace		

	* calculate prob p0 
	quietly mi xeq: replace xrace = 3
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][2.xrace]*2.xrace + [pt][3.xrace]*3.xrace + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][2.xrace]*2.xrace + [early_return][3.xrace]*3.xrace + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][2.xrace]*2.xrace + [late_return][3.xrace]*3.xrace + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][2.xrace]*2.xrace + [nonemployed][3.xrace]*3.xrace + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))	
	
	
	
	* calculate prob p1
	forval y=1/2 { 
		quietly mi xeq: replace xrace = `y'
			
		estimates use alt
		
		quietly mi xeq: gen xb1_1 = 0

		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][1.marstat]*1.marstat +  ///
				[pt][2.xrace]*2.xrace + [pt][3.xrace]*3.xrace + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][1.marstat]*1.marstat +  ///
				[early_return][2.xrace]*2.xrace + [early_return][3.xrace]*3.xrace + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][1.marstat]*1.marstat + ///
				[late_return][2.xrace]*2.xrace + [late_return][3.xrace]*3.xrace + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][1.marstat]*1.marstat + ///
				[nonemployed][2.xrace]*2.xrace + [nonemployed][3.xrace]*3.xrace + [nonemployed][_cons]		
				
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, race level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, race level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, race level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, race level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, race level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5			
			
			
	}
	drop xrace xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
	
*** switch to work sample ***
	use data_mi2_edited, replace
	
	mi xeq 0: tab sample18 work_sample, m
	quietly mi xeq: keep if sample18==1 & work_sample==1

	
	
*** Tenure (ref: 25th): 75th
	mi xeq 1: sum tenure_log [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	quietly mi xeq: gen xtenure_log = tenure_log
	
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat xtenure_log rate_adj_log i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xtenure_log = `=p25'
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][xtenure_log]*xtenure_log + [pt][rate_adj_log]*rate_adj_log + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][xtenure_log]*xtenure_log + [early_return][rate_adj_log]*rate_adj_log + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][xtenure_log]*xtenure_log + [late_return][rate_adj_log]*rate_adj_log + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][xtenure_log]*xtenure_log + [nonemployed][rate_adj_log]*rate_adj_log + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
	
	* calculate prob p1
	quietly mi xeq: replace xtenure_log = `=p75'
	
	estimates use alt
		
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][xtenure_log]*xtenure_log + [pt][rate_adj_log]*rate_adj_log + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][xtenure_log]*xtenure_log + [early_return][rate_adj_log]*rate_adj_log + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][xtenure_log]*xtenure_log + [late_return][rate_adj_log]*rate_adj_log + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][xtenure_log]*xtenure_log + [nonemployed][rate_adj_log]*rate_adj_log + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]	
	
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, tenure"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, tenure"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, tenure"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, tenure"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, tenure"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5

	drop xtenure_log xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5			
	

*** Wage (ref: 25th): 75th
	mi xeq 1: sum rate_adj_log [w=wt], d
	scalar p25 = r(p25) 
	scalar p75 = r(p75)
	di p25
	di p75
	
	quietly mi xeq: gen xrate_adj_log = rate_adj_log

	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp i.marstat tenure_log xrate_adj_log i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xrate_adj_log = `=p25'
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][tenure_log]*tenure_log + [pt][xrate_adj_log]*xrate_adj_log + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][tenure_log]*tenure_log + [early_return][xrate_adj_log]*xrate_adj_log + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][tenure_log]*tenure_log + [late_return][xrate_adj_log]*xrate_adj_log + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][tenure_log]*tenure_log + [nonemployed][xrate_adj_log]*xrate_adj_log + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	
	
	* calculate prob p1
	quietly mi xeq: replace xrate_adj_log = `=p75'
	
	estimates use alt
		
	quietly mi xeq: gen xb1_1 = 0

	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][1.marstat]*1.marstat +  ///
			[pt][tenure_log]*tenure_log + [pt][xrate_adj_log]*xrate_adj_log + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][1.marstat]*1.marstat +  ///
			[early_return][tenure_log]*tenure_log + [early_return][xrate_adj_log]*xrate_adj_log + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][1.marstat]*1.marstat + ///
			[late_return][tenure_log]*tenure_log + [late_return][xrate_adj_log]*xrate_adj_log + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][1.marstat]*1.marstat + ///
			[nonemployed][tenure_log]*tenure_log + [nonemployed][xrate_adj_log]*xrate_adj_log + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]	
	
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, wage"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, wage"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, wage"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, wage"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, wage"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5

	drop xrate_adj_log xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5	

	
	

*** switch to married sample ***
	use data_mi2_edited, replace
	
	mi xeq 0: tab sample18 married_sample, m
	quietly mi xeq: keep if sample18==1 & married_sample==1


*** Spouse earnings (ref: 25th): 75th
	* no need to get percentile. plug in 0.25 and 0.75
	
	quietly mi xeq: gen xspearn_p = spearn_p
	
	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp xspearn_p i.spouse_hours_gp i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xspearn_p = 0.25
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][xspearn_p]*xspearn_p + ///
			[pt][1.spouse_hours_gp]*1.spouse_hours_gp + [pt][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][xspearn_p]*xspearn_p + ///
			[early_return][1.spouse_hours_gp]*1.spouse_hours_gp + [early_return][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][xspearn_p]*xspearn_p + ///
			[late_return][1.spouse_hours_gp]*1.spouse_hours_gp + [late_return][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][xspearn_p]*xspearn_p + ///
			[nonemployed][1.spouse_hours_gp]*1.spouse_hours_gp + [nonemployed][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))		
			
	
	* calculate prob p1
	quietly mi xeq: replace xspearn_p = 0.75
		
	estimates use alt
	
	quietly mi xeq: gen xb1_1 = 0		
	
	quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][xspearn_p]*xspearn_p + ///
			[pt][1.spouse_hours_gp]*1.spouse_hours_gp + [pt][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][xspearn_p]*xspearn_p + ///
			[early_return][1.spouse_hours_gp]*1.spouse_hours_gp + [early_return][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][xspearn_p]*xspearn_p + ///
			[late_return][1.spouse_hours_gp]*1.spouse_hours_gp + [late_return][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][xspearn_p]*xspearn_p + ///
			[nonemployed][1.spouse_hours_gp]*1.spouse_hours_gp + [nonemployed][2.spouse_hours_gp]*2.spouse_hours_gp + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
				
		
		
	quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
	
	
	* diff in prob
	quietly mi xeq: gen d1 = p1_1-p0_1
	quietly mi xeq: gen d2 = p1_2-p0_2
	quietly mi xeq: gen d3 = p1_3-p0_3
	quietly mi xeq: gen d4 = p1_4-p0_4
	quietly mi xeq: gen d5 = p1_5-p0_5
	

	* print results
	di "avg marginal eff for cluster 1, spouse earning"
	quietly misum d1 [aw=wt] 
			
	di %5.2f r(d1_mean)
	
	di "avg marginal eff for cluster 2, spouse earning"
	quietly misum d2 [aw=wt] 
			
	di %5.2f r(d2_mean)
	
	di "avg marginal eff for cluster 3, spouse earning"
	quietly misum d3 [aw=wt] 
			
	di %5.2f r(d3_mean)
	
	di "avg marginal eff for cluster 4, spouse earning"
	quietly misum d4 [aw=wt] 
			
	di %5.2f r(d4_mean)
	
	di "avg marginal eff for cluster 5, spouse earning"
	quietly misum d5 [aw=wt] 
			
	di %5.2f r(d5_mean)

	drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5
	
	drop xspearn_p xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5

	
*** spouse hours (ref: less than ft) | ft and overtime

	quietly mi xeq: gen xspouse_hours_gp = spouse_hours_gp

	* run mlogit model
	quietly mi estimate, post: mlogit dv18 i.educ i.hours_2y_to_1y_gp i.hours_1y_to_birth_gp i.work35 ideal womensroles i.religion_freq i.mom_educ i.mom_worked i.age_gp spearn_p i.xspouse_hours_gp i.race [pw=wt], base(1)
	estimates save alt, replace
	
	* calculate prob p0 
	quietly mi xeq: replace xspouse_hours_gp = 0
	
	quietly mi xeq: gen xb0_1 = 0 
	
	quietly mi xeq: gen xb0_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
			[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[pt][1.work35]*1.work35 +  ///
			[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
			[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
			[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
			[pt][1.mom_worked]*1.mom_worked + ///
			[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
			[pt][spearn_p]*spearn_p + ///
			[pt][1.xspouse_hours_gp]*1.xspouse_hours_gp + [pt][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
			[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
	
	quietly mi xeq: gen xb0_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
			[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[early_return][1.work35]*1.work35 +  ///
			[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
			[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
			[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
			[early_return][1.mom_worked]*1.mom_worked + ///
			[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
			[early_return][spearn_p]*spearn_p + ///
			[early_return][1.xspouse_hours_gp]*1.xspouse_hours_gp + [early_return][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
			[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
	
	quietly mi xeq: gen xb0_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
			[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[late_return][1.work35]*1.work35 +  ///
			[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
			[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
			[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
			[late_return][1.mom_worked]*1.mom_worked + ///
			[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
			[late_return][spearn_p]*spearn_p + ///
			[late_return][1.xspouse_hours_gp]*1.xspouse_hours_gp + [late_return][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
			[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
	
	quietly mi xeq: gen xb0_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
			[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
			[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
			[nonemployed][1.work35]*1.work35 +  ///
			[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
			[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
			[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
			[nonemployed][1.mom_worked]*1.mom_worked + ///
			[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
			[nonemployed][spearn_p]*spearn_p + ///
			[nonemployed][1.xspouse_hours_gp]*1.xspouse_hours_gp + [nonemployed][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
			[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
		
	
	quietly mi xeq: gen p0_1 = exp(xb0_1)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_2 = exp(xb0_2)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_3 = exp(xb0_3)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_4 = exp(xb0_4)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))
	quietly mi xeq: gen p0_5 = exp(xb0_5)/(exp(xb0_1) + exp(xb0_2) + exp(xb0_3) + exp(xb0_4) + exp(xb0_5))		
	
	
	* calculate prob p1
	forval y=1/2 { 
		quietly mi xeq: replace xspouse_hours_gp = `y'
		
		estimates use alt
		
		quietly mi xeq: gen xb1_1 = 0 
	
		quietly mi xeq: gen xb1_2 = [pt][2.educ]*2.educ + [pt][3.educ]*3.educ + [pt][4.educ]*4.educ + ///
				[pt][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [pt][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[pt][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [pt][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[pt][1.work35]*1.work35 +  ///
				[pt][ideal]*ideal + [pt][womensroles]*womensroles + ///
				[pt][2.religion_freq]*2.religion_freq + [pt][3.religion_freq]*3.religion_freq + ///
				[pt][1.mom_educ]*1.mom_educ + [pt][2.mom_educ]*2.mom_educ + [pt][3.mom_educ]*3.mom_educ + [pt][4.mom_educ]*4.mom_educ + ///
				[pt][1.mom_worked]*1.mom_worked + ///
				[pt][2.age_gp]*2.age_gp + [pt][3.age_gp]*3.age_gp + ///
				[pt][spearn_p]*spearn_p + ///
				[pt][1.xspouse_hours_gp]*1.xspouse_hours_gp + [pt][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
				[pt][2.race]*2.race + [pt][3.race]*3.race + [pt][_cons]
		
		quietly mi xeq: gen xb1_3 = [early_return][2.educ]*2.educ + [early_return][3.educ]*3.educ + [early_return][4.educ]*4.educ + ///
				[early_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [early_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[early_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [early_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[early_return][1.work35]*1.work35 +  ///
				[early_return][ideal]*ideal + [early_return][womensroles]*womensroles + ///
				[early_return][2.religion_freq]*2.religion_freq + [early_return][3.religion_freq]*3.religion_freq + ///
				[early_return][1.mom_educ]*1.mom_educ + [early_return][2.mom_educ]*2.mom_educ + [early_return][3.mom_educ]*3.mom_educ + [early_return][4.mom_educ]*4.mom_educ + ///
				[early_return][1.mom_worked]*1.mom_worked + ///
				[early_return][2.age_gp]*2.age_gp + [early_return][3.age_gp]*3.age_gp + ///
				[early_return][spearn_p]*spearn_p + ///
				[early_return][1.xspouse_hours_gp]*1.xspouse_hours_gp + [early_return][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
				[early_return][2.race]*2.race + [early_return][3.race]*3.race + [early_return][_cons]
		
		quietly mi xeq: gen xb1_4 = [late_return][2.educ]*2.educ + [late_return][3.educ]*3.educ + [late_return][4.educ]*4.educ + ///
				[late_return][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [late_return][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[late_return][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [late_return][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[late_return][1.work35]*1.work35 +  ///
				[late_return][ideal]*ideal + [late_return][womensroles]*womensroles + ///
				[late_return][2.religion_freq]*2.religion_freq + [late_return][3.religion_freq]*3.religion_freq + ///
				[late_return][1.mom_educ]*1.mom_educ + [late_return][2.mom_educ]*2.mom_educ + [late_return][3.mom_educ]*3.mom_educ + [late_return][4.mom_educ]*4.mom_educ + ///
				[late_return][1.mom_worked]*1.mom_worked + ///
				[late_return][2.age_gp]*2.age_gp + [late_return][3.age_gp]*3.age_gp + ///
				[late_return][spearn_p]*spearn_p + ///
				[late_return][1.xspouse_hours_gp]*1.xspouse_hours_gp + [late_return][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
				[late_return][2.race]*2.race + [late_return][3.race]*3.race + [late_return][_cons]
		
		quietly mi xeq: gen xb1_5 = [nonemployed][2.educ]*2.educ + [nonemployed][3.educ]*3.educ + [nonemployed][4.educ]*4.educ + ///
				[nonemployed][1.hours_2y_to_1y_gp]*1.hours_2y_to_1y_gp + [nonemployed][2.hours_2y_to_1y_gp]*2.hours_2y_to_1y_gp + ///
				[nonemployed][1.hours_1y_to_birth_gp]*1.hours_1y_to_birth_gp + [nonemployed][2.hours_1y_to_birth_gp]*2.hours_1y_to_birth_gp + ///
				[nonemployed][1.work35]*1.work35 +  ///
				[nonemployed][ideal]*ideal + [nonemployed][womensroles]*womensroles + ///
				[nonemployed][2.religion_freq]*2.religion_freq + [nonemployed][3.religion_freq]*3.religion_freq + ///
				[nonemployed][1.mom_educ]*1.mom_educ + [nonemployed][2.mom_educ]*2.mom_educ + [nonemployed][3.mom_educ]*3.mom_educ + [nonemployed][4.mom_educ]*4.mom_educ + ///
				[nonemployed][1.mom_worked]*1.mom_worked + ///
				[nonemployed][2.age_gp]*2.age_gp + [nonemployed][3.age_gp]*3.age_gp + ///
				[nonemployed][spearn_p]*spearn_p + ///
				[nonemployed][1.xspouse_hours_gp]*1.xspouse_hours_gp + [nonemployed][2.xspouse_hours_gp]*2.xspouse_hours_gp + ///
				[nonemployed][2.race]*2.race + [nonemployed][3.race]*3.race + [nonemployed][_cons]
				
		quietly mi xeq: gen p1_1 = exp(xb1_1)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_2 = exp(xb1_2)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_3 = exp(xb1_3)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_4 = exp(xb1_4)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		quietly mi xeq: gen p1_5 = exp(xb1_5)/(exp(xb1_1) + exp(xb1_2) + exp(xb1_3) + exp(xb1_4) + exp(xb1_5))
		
		
		* diff in prob
		quietly mi xeq: gen d1 = p1_1-p0_1
		quietly mi xeq: gen d2 = p1_2-p0_2
		quietly mi xeq: gen d3 = p1_3-p0_3
		quietly mi xeq: gen d4 = p1_4-p0_4
		quietly mi xeq: gen d5 = p1_5-p0_5
		

		* print results
		di "avg marginal eff for cluster 1, spouse hours level `y'"
		quietly misum d1 [aw=wt] 
				
		di %5.2f r(d1_mean)
		
		di "avg marginal eff for cluster 2, spouse hours level `y'"
		quietly misum d2 [aw=wt] 
				
		di %5.2f r(d2_mean)
		
		di "avg marginal eff for cluster 3, spouse hours level `y'"
		quietly misum d3 [aw=wt] 
				
		di %5.2f r(d3_mean)
		
		di "avg marginal eff for cluster 4, spouse hours level `y'"
		quietly misum d4 [aw=wt] 
				
		di %5.2f r(d4_mean)
		
		di "avg marginal eff for cluster 5, spouse hours level `y'"
		quietly misum d5 [aw=wt] 
				
		di %5.2f r(d5_mean)
	
		drop xb1_1 xb1_2 xb1_3 xb1_4 xb1_5 p1_1 p1_2 p1_3 p1_4 p1_5 d1 d2 d3 d4 d5		
				
	}

	drop xspouse_hours_gp xb0_1 xb0_2 xb0_3 xb0_4 xb0_5 p0_1 p0_2 p0_3 p0_4 p0_5
	
	
