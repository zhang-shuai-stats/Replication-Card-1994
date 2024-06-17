* 2024/5/21
* 2024/6/13 删除临时文件
clear
cd /Users/zhangshuai/Desktop/interest/card1994_replication // 修改默认目录

*-----------------------------------------------------------------------------
* data preparation and label variable 
*-----------------------------------------------------------------------------
import excel "public.xlsx", sheet("Sheet1") clear

* string to numerical
destring L-P Q S W-AA AE-AT, replace 

* rename variables
rename (*) (store chain co_owned state southj centralj northj pa1 pa2 shore ncalls empft emppt nmgrs wage_st inctime firstinc bonus pctaff meals open hrsopen psoda pfry pentree nregs nregs11 type2	status2	date2	ncalls2	empft2	emppt2	nmgrs2	wage_st2	inctime2	firstin2	special2	meals2	open2r	hrsopen2	psoda2	pfry2	pentree2	nregs2	nregs112)

* date format
tostring date2, gen(date2var)
drop date2
gen date2 = date(date2var, "MD19Y")
format date2 %tdnn/DD/YY
order date2, after(date2var)
drop date2var

* label variables and values
label variable store "unique store id"
label variable chain "Brands"
label variable co_owned "company owned or franchisee-owned"
label variable state "state name"
label variable southj "if in southern New Jersey"
label variable centralj "if in central New Jersey"
label variable northj "if in northern New Jersey"
label variable pa1 "if in PA, northeast suburbs of Phila"
label variable pa2 "if in PA, Easton etc"
label variable shore "if on NJ shore"
label variable ncalls "number of call-backs"
label variable empft "number of full-time employees"
label variable emppt "number of part-time employees"
label variable nmgrs "number of managers/ass't managers"
label variable wage_st "starting wage ($/hr)"
label variable inctime "months to usual first raise"
label variable firstinc "usual amount of first raise ($/hr)"
label variable bonus "if cash bounty for new workers"
label variable pctaff "% employees affected by new minimum"
label variable meals "free/reduced price code"
label variable open "hour of opening"
label variable hrsopen "number hrs open per day"
label variable psoda "price of medium soda, including tax"
label variable pfry "price of small fries, including tax"
label variable pentree "price of entree, including tax"
label variable nregs "number of cash registers in store"
label variable nregs11 "number of registers open at 11:00 am"

label variable type2 "type 2nd interview"
label variable status2 "status of second interview"
label variable date2 "date of second interview mmddyy format"
label variable ncalls2 "number of call-backs"
label variable empft2 "number of full-time employees"
label variable emppt2 "number of part-time employees"
label variable nmgrs2 "number of managers/ass't managers"
label variable wage_st2 "starting wage ($/hr)"
label variable inctime2 "months to usual first raise"
label variable firstin2 "usual amount of first raise ($/hr)"
label variable special2 "if special program for new workers"
label variable meals2 "free/reduced price code"
label variable open2r "hour of opening"
label variable hrsopen2 "number hrs open per day"
label variable psoda2 "price of medium soda, including tax"
label variable pfry2 "price of small fries, including tax"
label variable pentree2 "price of entree, including tax"
label variable nregs2  "number of cash registers in store"
label variable nregs112 "number of registers open at 11:00 am"
		
labmask store, values(store)
label define chain 1 "Burger King" 2 "KFC" 3 "Roy Rogers" 4 "Wendy's"
label values chain chain 
label define co_owned 1 "Company owned" 0 "Franchisee-owned" 
label values co_owned co_owned 
label define state 1 "New Jersey" 0 "Pennsylvania" 
label values state state
label define southj 1 "Southern NJ" 0 "Elsewhere" 
label values southj southj
label define centralj 1 "Central NJ" 0 "Elsewhere" 
label values centralj centralj
label define northj 1 "Northern NJ" 0 "Elsewhere" 
label values northj northj
label define pa1 1 "northeast PA" 0 "Elsewhere" 
label values pa1 pa1
label define pa2 1 "Easton PA" 0 "Elsewhere" 
label values pa2 pa2 
label define shore 1 "NJ shore" 0 "Elsewhere" 
label values shore shore 
label define meals 1 "free meals" 2 "reduced price meals" 3 "both free and reduced price meals" 0 "none"
label values meals meals  
label values meals2 meals  

label define type2 1 "phone" 2 "personal" 
label values type2 type2  
label define status2 0 "refused second interview" 1 "answered 2nd interview" 2 "closed for renovations" 3 "closed permanently" 4 "closed for highway construction" 5 "closed due to Mall fire"
label values status2 status2 

save card1994_data, replace 

*-----------------------------------------------------------------------------
* Table 1 -- sample design and response rates
*-----------------------------------------------------------------------------
use card1994_data, clear

collect clear
label list state status2
table status2[.m 3 2 4 5 0 1] state[.m 1 0]

collect label dim state "Stores in:", modify
collect label dim status2 "Wave 2, November 5 - December 31, 1992", modify
collect label levels state .m "All" 1 "NJ" 0 "PA", modify
collect label levels status2 .m "Number of stores in sample frame:" ///
							  0 "Number of refusals:" ///
							  1 "Number interviewed:" ///
							  2 "Number under renovations:" ///
							  3 "Number closed:" ///
							  4 "Number closed for highway construction:" ///
							  5 "Number closed due to Mall fire:", modify
							  
collect style cell border_block, border(right, pattern(nil))
collect title "TABLE 1-SAMPLE DESIGN AND RESPONSE RATES"

collect preview
collect export "table1", as(docx) replace

*-----------------------------------------------------------------------------
* Table 2 -- means of key variables (另一种方法）
*-----------------------------------------------------------------------------
use card1994_data, clear

tab chain, gen(chain)
tab co_owned, gen(co_owned)

forvalues i = 1/4 {
	replace chain`i' = 100 * chain`i'
}
replace co_owned1 = 100 * co_owned1
replace co_owned2 = 100 * co_owned2

ttest chain2, by(state) unpaired unequal
ttest chain2, by(state) 

**********************************
* 1. Distribution of Stores Types:
**********************************
local myresults "NJ=r(mu_2) PA=r(mu_1) tval =(r(mu_2)-r(mu_1))/sqrt((r(sd_1))^2/r(N_1) + (r(sd_2))^2/r(N_2))"
display "`myresults'"

* 使用command的ttest只能是equal variance
collect clear
table (command) (result), ///
	command(`myresults' : ttest chain1, by(state)) ///
	command(`myresults' : ttest chain2, by(state)) ///
	command(`myresults' : ttest chain3, by(state)) ///
	command(`myresults' : ttest chain4, by(state)) ///
	command(`myresults' : ttest co_owned2, by(state)) 
	
collect remap command = part_a	
**********************************
* 2. Means in Wave 1:
**********************************
gen emp = empft + 0.5*emppt + nmgrs
gen emp_full = empft /emp * 100
gen wage_low = (wage_st == 4.25) * 100
gen full_meal = psoda + pfry + pentree
replace bonus = 100 * bonus

local myresults "NJ = r(mu_2) PA = r(mu_1) tval =(r(mu_2)-r(mu_1))/sqrt((r(sd_1))^2/r(N_1) + (r(sd_2))^2/r(N_2))"
local myresults1 "NJ = r(sd_2)/sqrt(r(N_2)) PA = r(sd_1)/sqrt(r(N_1))"

table (command) (result),  ///
	command(`myresults': ttest emp, by(state))  ///
	command(`myresults1': ttest emp, by(state))  ///
	command(`myresults': ttest emp_full, by(state)) ///
	command(`myresults1': ttest emp_full, by(state)) ///
	command(`myresults': ttest wage_st, by(state)) ///
	command(`myresults1': ttest wage_st, by(state)) ///
	command(`myresults': ttest wage_low, by(state)) ///
	command(`myresults1': ttest wage_low, by(state)) ///
	command(`myresults': ttest full_meal, by(state)) ///
	command(`myresults1': ttest full_meal, by(state)) ///
	command(`myresults': ttest hrsopen, by(state)) ///
	command(`myresults1': ttest hrsopen, by(state)) ///
	command(`myresults': ttest bonus, by(state)) ///
	command(`myresults1': ttest bonus, by(state)) append
	
collect remap command = part_b		

**********************************
* 3. Means in Wave 3:
**********************************
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
gen emp_full2 = empft2 /emp2 * 100
gen wage_low2 = (wage_st2 == 4.25) * 100 
gen wage_low3 = (wage_st2 == 5.05) * 100 
gen full_meal2 = psoda2 + pfry2 + pentree2

local myresults "NJ = r(mu_2) PA = r(mu_1) tval =(r(mu_2)-r(mu_1))/sqrt((r(sd_1))^2/r(N_1) + (r(sd_2))^2/r(N_2))"
local myresults1 "NJ = r(sd_2)/sqrt(r(N_2)) PA = r(sd_1)/sqrt(r(N_1))"

table (command) (result),  ///
	command(`myresults': ttest emp2, by(state))  ///
	command(`myresults1': ttest emp2, by(state))  ///
	command(`myresults': ttest emp_full2, by(state)) ///
	command(`myresults1': ttest emp_full2, by(state)) ///
	command(`myresults': ttest wage_st2, by(state)) ///
	command(`myresults1': ttest wage_st2, by(state)) ///
	command(`myresults': ttest wage_low2, by(state)) ///
	command(`myresults1': ttest wage_low2, by(state)) ///
	command(`myresults': ttest wage_low3, by(state)) ///
	command(`myresults1': ttest wage_low3, by(state)) ///
	command(`myresults': ttest full_meal2, by(state)) ///
	command(`myresults1': ttest full_meal2, by(state)) ///
	command(`myresults': ttest hrsopen2, by(state)) ///
	command(`myresults1': ttest hrsopen2, by(state))  append

collect remap command = part_c		

**********************************
* 合并一起
**********************************
collect  dims
collect levelsof result 
collect query autolevels command	

* 行排列
local ind
forvalues i = 1/14 {
	local ind `ind' `i'
}
collect style autolevels part_b `ind'
collect style autolevels part_c `ind'

* 行名称
collect label levels part_a  1 "a. Burger King"     ///             
                             2 "b. KFC"             ///   
                             3 "c. Roy Rogers"      ///           
                             4 "d. Wendy's"         ///   
                             5 "e. Company-owned", modify  
							 						 
local colname `" "a. FTE employment" "b. Percentage full-time employees"  "c. Starting wage"  "d. Wage = $4.25 (percentage)"  "e. Price of full meal"   "f. Hours open (weekday)"  "g. Recruiting bonus"  "'

local colname1 `" "a. FTE employment"  "b. Percentage full-time employees"  "c. Starting wage"  "d. Wage = $4.25 (percentage)"  "e. Wage = $5.05 (percentage)"  "f. Price of full meal"   "g. Hours open (weekday)"   "'

local nbs: word count `colname'
local i = 1
while `i' <= `nbs' {
	local j = 2*`i'-1
	local temp `:word `i' of `colname''
	collect label levels part_b `j' `"`temp'"', modify	
	
	local temp1 `:word `i' of `colname1''
	collect label levels part_c `j' `"`temp1'"', modify	
		
	local ++i	
}

collect label dim part_a "1. Distribution of Stores Types (percentages):", modify
collect label dim part_b "2. Means in Wave 1:", modify
collect label dim part_c "3. Means in Wave 2:", modify

* 隐藏行名称
collect style header part_b[2 4 6 8 10 12 14], level(hide)
collect style header part_c[2 4 6 8 10 12 14], level(hide)

* 列名称
collect label dim result "Stores in:", modify
collect style header result, title(label)

* 格式
collect style cell result, warn halign(center) valign(center) nformat(%6.1f)
collect style cell part_b[2 4 6 8 10 12 14], warn nformat(%6.1f) sformat((%s))
collect style cell part_b[5 9]#result[NJ PA], warn nformat(%6.2f)
collect style cell part_b[2 6 10], warn nformat(%6.2f) sformat((%s))
collect style cell part_c[2 4 6 8 10 12 14], warn nformat(%6.1f) sformat((%s))
collect style cell part_c[5 11 ]#result[NJ PA], warn nformat(%6.2f)
collect style cell part_c[2 6 12], warn nformat(%6.2f) sformat((%s))

collect title "TABLE 2-MEANS OF KEY VARIABLES"
collect style cell border_block, border(right, pattern(nil))

collect layout (part_a part_b part_c) (result)
collect export "table2", as(docx) replace	

**********************************
* 其他相关统计量
**********************************
* note 12 in p778
use card1994_data, clear

gen emp = empft + 0.5*emppt + nmgrs
gen emp_full = empft /emp * 100
gen wage_low = (wage_st == 4.25) * 100
gen full_meal = psoda + pfry + pentree
replace bonus = 100 * bonus

gen close = status2 == 3
logit close emp wage_st full_meal hrsopen bonus

*-----------------------------------------------------------------------------
* FIGURE 1. DISTRIBUTIONS OF STARTING WGAGE RRATES
*-----------------------------------------------------------------------------
use card1994_data, clear

gen wage_st1 = .
gen wage_st3 = .
replace wage_st1 = 4.25 if wage_st == 4.25
replace wage_st3 = 4.25 if wage_st2 == 4.25
forvalues i = 4.25(0.1)5.45 {
	replace wage_st1 = `i' + 0.1 if wage_st > `i' + 0.001 
	replace wage_st3 = `i' + 0.1 if wage_st2 > `i' + 0.001 
}

table wage_st if state == 1
table wage_st if state == 0
table wage_st1 if state == 1
table wage_st1 if state == 0

table wage_st2 if state == 1
table wage_st2 if state == 0
table wage_st3 if state == 1
table wage_st3 if state == 0

replace wage_st1 = wage_st1 - 0.01 if state == 1  // NJ
replace wage_st1 = wage_st1 + 0.01 if state == 0  // PA

replace wage_st3 = wage_st3 - 0.01 if state == 1  // NJ
replace wage_st3 = wage_st3 + 0.01 if state == 0  // PA

twoway (histogram wage_st1 if state == 1, discrete percent fcolor(black) lcolor(none) lpattern(dash) lalign(inside) gap(80)) (histogram wage_st1 if state == 0, discrete percent lcolor(none) gap(80)), ytitle(`"Percent of Stores"') ylabel(0(5)35) xtitle(`"Wage Range"') xlabel(4.25(0.1)5.55) legend(off) title(February 1992) 

twoway (histogram wage_st3 if state == 1, discrete percent fcolor(black) lcolor(none) lpattern(dash) lalign(inside) gap(80)) (histogram wage_st3 if state == 0, discrete percent lcolor(none) gap(80)), ytitle(`"Percent of Stores"') ylabel(0(10)90) xtitle(`"Wage Range"') xlabel(4.25(0.1)5.55) legend(order(1 "New Jersey" 2 "Pennsylvania")) title(November 1992) 
	
*-----------------------------------------------------------------------------
* TABLE 3 -AVERAGE EMPLOYMENT PER STORE BEFORE AND AFTER THE RISE IN NEW JERSEY MINIMUM WAGE
*-----------------------------------------------------------------------------
clear all
use card1994_data

gen emp = empft + 0.5*emppt + nmgrs
gen emp_full = empft /emp * 100
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
gen emp_full2 = empft2 /emp2 * 100


capture program drop create_table3
program create_table3, rclass

	args var3 val 
	
	*  row 1-3
	qui: corr emp emp2 if `var3'==`val'
	local rho=r(rho)
	local n3 = r(N)
	qui:ttest emp==emp2 if `var3'==`val', unpaired
	local n1 = r(N_1)
	local n2 = r(N_2)
	local mu1 = r(mu_1)
	local mu2 = r(mu_2)
	local sd1 = r(sd_1)/sqrt(r(N_1))
	local sd2 = r(sd_2)/sqrt(r(N_2))
	local mu3 = r(mu_2)-r(mu_1)
	local sd3 = sqrt(`sd1'^2 + `sd2'^2 - 2*`n3'*r(sd_1)*r(sd_2)*`rho'/`n1'/`n2')

	* row 4
	qui:ttest emp==emp2 if `var3'==`val'
	local mu4 = r(mu_2)-r(mu_1)
	local sd4 = r(se)

	* row 5
	qui:replace emp2 = 0  if inlist(status2,2,4,5)
	qui: ttest emp==emp2 if `var3'==`val'
	local mu5 = r(mu_2)-r(mu_1)
	local sd5 = r(se)
	qui:replace emp2 = .  if inlist(status2,2,4,5) // 修改为原数据
	
	forvalues i = 1/5 {
		return scalar mu`i' = `mu`i''
		return scalar sd`i' = `sd`i''
	}

end

* 创建表3
collect clear

* 第一列
create_table3 state 0
forvalues i = 1/5 {
	scalar mu`i'1 = r(mu`i')
	scalar sd`i'1 = r(sd`i')
	collect get m`i'=mu`i'1 sd`i'=sd`i'1, tag(model[1])
}

* 第二列
create_table3 state 1 
forvalues i = 1/5 {
	scalar mu`i'2 = r(mu`i')
	scalar sd`i'2 = r(sd`i')
	collect get m`i'=mu`i'2 sd`i'=sd`i'2, tag(model[2])
}

* 第三列
forvalues i = 1/5 {
	collect get m`i'= mu`i'2-mu`i'1 sd`i' = sqrt((sd`i'1)^2+(sd`i'2)^2), tag(model[3])
}

keep if state == 1
gen wage_cat = .
replace wage_cat = 1 if wage_st == 4.25
replace wage_cat = 2 if inrange(wage_st,4.251,4.99)
replace wage_cat = 3 if wage_st > 4.99 & !mi(wage_st)

* 第四列
create_table3 wage_cat 1 
forvalues i = 1/5 {
	scalar mu`i'4 = r(mu`i')
	scalar sd`i'4 = r(sd`i')
	collect get m`i'=mu`i'4 sd`i'=sd`i'4, tag(model[4])
}

* 第五列
create_table3 wage_cat 2 
forvalues i = 1/5 {
	scalar mu`i'5 = r(mu`i')
	scalar sd`i'5 = r(sd`i')
	collect get m`i'=mu`i'5 sd`i'=sd`i'5,tag(model[5])
}

* 第六列
create_table3 wage_cat 3 
forvalues i = 1/5 {
	scalar mu`i'6 = r(mu`i')
	scalar sd`i'6 = r(sd`i')
	collect get m`i'=mu`i'6 sd`i'=sd`i'6,tag(model[6])
}

* 第七列
forvalues i = 1/5 {
	collect get m`i'= mu`i'4-mu`i'6 sd`i' = sqrt((sd`i'4)^2+(sd`i'6)^2), tag(model[7])
}

* 第八列
forvalues i = 1/5 {
	collect get m`i'= mu`i'5-mu`i'6 sd`i' = sqrt((sd`i'5)^2+(sd`i'6)^2), tag(model[8])
}

*************
* 修改格式
*************
collect dims
collect levelsof result
collect levelsof cmdset

* 行名称
local colname `" "1.FTE employment before, all available observations"  "2.FTE employment after, all available observations" "3.Change in mean FTE employment" "4.Change in mean FTE employment,balanced sample of stores" "5.Change in mean FTE employment,setting FTE at temporarily closed stores to 0" "'

forvalues i = 1/5 {
	local temp `:word `i' of `colname''
	collect label levels result m`i' `"`temp'"', modify
}
collect style header result[sd1 sd2 sd3 sd4 sd5], level(hide)

* 列名称
collect remap model[`"1"' `"2"' `"3"'] = a[`"1"' `"2"' `"3"']
collect remap model[`"4"' `"5"' `"6"'] = b[`"1"' `"2"' `"3"']
collect remap model[`"7"' `"8"' ] = c[`"1"' `"2"']

collect label dim a "Stores by state", modify
collect label dim b "Stores in New Jersey", modify
collect label dim c "Differences within NJ", modify

collect label levels a 1 "PA" 2 "NJ" 3 "Difference, NJ-PA", modify
collect label levels b 1 "Wage=$4.25" 2 "Wage=$4.24-$4.99" 3 "Difference, NJ-PA", modify
collect label levels c 1 "Low-High" 2 "Midrange-high", modify

* 数字格式
collect style cell a b c, warn halign(center) valign(center) nformat(%6.2f)
collect style cell result[sd1 sd2 sd3 sd4 sd5], sformat("(%s)")

* 布局
collect style header a b c, title(label)
collect style column, nodelimiter dups(center) position(top) width(asis)
collect style cell border_block, border(right, pattern(nil))
collect notes `"Notes: Standard errors are shown in parentheses."'
collect title "TABLE 3-AVERAGE EMPLOYMENT PER STORE BEFORE AND AFTER THE RISE IN NEW JERSEY MINIMUM WAGE"

* 导出
collect layout (result) (a b c)
collect export "table3", as(docx) replace	

*-----------------------------------------------------------------------------
* TABLE 4-REDUCED-FORM MODELS FOR CHANGE IN EMPLOYMENT
*-----------------------------------------------------------------------------
clear all
use card1994_data

gen emp = empft + 0.5*emppt + nmgrs
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
gen delta = emp2 - emp

replace wage_st2 = 5.05 if status2 == 3 // 将永远关闭的6家店纳入样本
gen gap = 0 
replace gap = (5.05-wage_st)/wage_st if state==1 & wage_st<5.05
gen gap1 = (wage_st2-wage_st)/wage_st

keep if !mi(delta) & !mi(gap1)

summarize delta // notes 
reg gap1 gap  // R2

collect clear
table (command) (result), ///
	command(reg delta i.state) ///
	command(reg delta i.state i.chain i.co_owned) ///
	command(reg delta gap) ///
	command(reg delta gap i.chain i.co_owned) ///
	command(reg delta gap i.chain i.co_owned southj centralj northj pa1 pa2)
	
collect dims
collect levelsof result 
collect levelsof colname 

collect get col3="no", tags(command[1])
collect get col3="yes", tags(command[2])
collect get col3="no", tags(command[3])
collect get col3="yes", tags(command[4])
collect get col3="yes", tags(command[5])

collect get col4="no", tags(command[1])
collect get col4="no", tags(command[2])
collect get col4="no", tags(command[3])
collect get col4="no", tags(command[4])
collect get col4="yes", tags(command[5])

qui: reg delta i.state i.chain i.co_owned
qui: testparm i.chain i.co_owned
collect get col6=r(p), tags(command[2])

qui: reg delta gap i.chain i.co_owned
qui: testparm  i.chain i.co_owned
collect get col6=r(p), tags(command[4])

qui: reg delta gap i.chain i.co_owned southj centralj northj pa1 pa2
qui: testparm i.chain i.co_owned southj centralj northj pa1 pa2
collect get col6=r(p), tags(command[5])

collect label dim command "Model", modify
collect style header command, title(label)
collect label levels command 1 "(i)" 2 "(ii)" 3 "(iii)" 4 "(iv)" 5 "(v)", modify

collect style header result[_r_b _r_se], level(hide)
collect label levels colname 1.state "1. New Jersey dummy" gap "2. Initial wage gap", modify
collect label levels result col3 "3. Controls for chain and ownership" col4 "4. Controls for region" rmse "5. Standard error of regression" col6 "6. Probability value for controls", modify

collect style cell command, warn halign(center) valign(center) nformat(%6.2f)
collect style cell result[_r_se], sformat("(%s)")

collect title "TABLE 4-REDUCED-FORM MODELS FOR CHANGE IN EMPLOYMENT"
collect style cell border_block, border(right, pattern(nil))

collect layout (colname[1.state gap]#result[_r_b _r_se] result[col3 col4 rmse col6]) (command)
collect export "table4", as(docx) replace	

************************
* some other statistics
************************
* 同时添加虚拟变量和工资变化
reg delta i.state gap
reg delta i.state gap i.chain i.co_owned

* 使用变化率作为因变量
gen delta_prop = delta/emp 
reg delta_prop i.state
reg delta_prop gap
	
*-----------------------------------------------------------------------------
* TABLE 5-SPECIFICATION TESTS OF REDUCED-FORM EMPLOYMENT MODELS
*-----------------------------------------------------------------------------
clear all
use card1994_data

replace wage_st2 = 5.05 if inlist(status2,2,3,4,5) // 将永远关闭的6家店和暂时关闭的4家店纳入样本

gen emp = empft + 0.5*emppt + nmgrs
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
replace emp2 = 0  if inlist(status2,2,4,5) // 将暂时关闭的4家店纳入样本
gen delta = emp2 - emp
gen delta_prop = 2*delta/(emp+emp2)
replace delta_prop = -1 if inlist(status2,2,3,4,5)

gen gap = 0 
replace gap = (5.05-wage_st)/wage_st if state==1 & wage_st<5.05
gen gap1 = (wage_st2-wage_st)/wage_st

keep if !mi(delta) & !mi(gap1)

capture program drop creat_table5 
program creat_table5 
	args num
	qui:collect get _r_b _r_se, tag(row[`num'] model1[1]): reg delta i.state i.chain i.co_owned 
	qui:collect get _r_b _r_se, tag(row[`num'] model1[2]): reg delta gap i.chain i.co_owned 	
	qui:collect get _r_b _r_se, tag(row[`num'] model2[1]): reg delta_prop i.state i.chain i.co_owned 
	qui:collect get _r_b _r_se, tag(row[`num'] model2[2]): reg delta_prop gap i.chain i.co_owned 	
end

collect clear
* row 1. Base specification
preserve
keep if inlist(status2,1,3)
creat_table5 1 
restore
	
* row 2. Treat four temporarily closed stores as permanently closed
creat_table5 2 

* row 3. Exclude managers in employment count
keep if inlist(status2,1,3)
replace emp = empft + 0.5*emppt 
replace emp2 = empft2 + 0.5*emppt2 
replace delta = emp2 - emp
replace delta_prop = 2*delta/(emp+emp2)
replace delta_prop = -1 if status2==3

creat_table5 3

* row 4. Weight part-time as 0.4×full-time
replace emp = empft + 0.4*emppt + nmgrs
replace emp2 = empft2 + 0.4*emppt2 + nmgrs2
replace delta = emp2 - emp
replace delta_prop = 2*delta/(emp+emp2)
replace delta_prop = -1 if status2==3

creat_table5 4

* row 5. Weight part-time as 0.6×full-time
replace emp = empft + 0.6*emppt + nmgrs
replace emp2 = empft2 + 0.6*emppt2 + nmgrs2
replace delta = emp2 - emp
replace delta_prop = 2*delta/(emp+emp2)
replace delta_prop = -1 if status2==3

creat_table5 5

* row 6. Exclude stores in NJ area
replace emp = empft + 0.5*emppt + nmgrs
replace emp2 = empft2 + 0.5*emppt2 + nmgrs2
replace delta = emp2 - emp
replace delta_prop = 2*delta/(emp+emp2)
replace delta_prop = -1 if status2==3

preserve
drop if shore
creat_table5 6
restore

* row 7.Add controls for wave-2 interview date
gen week = week(date2)
replace week = week-5 if week>49

qui:collect get _r_b _r_se, tag(row[7] model1[1]): reg delta i.state i.chain i.co_owned i.week
qui:collect get _r_b _r_se, tag(row[7] model1[2]): reg delta gap i.chain i.co_owned i.week	
qui:collect get _r_b _r_se, tag(row[7] model2[1]): reg delta_prop i.state i.chain i.co_owned i.week
qui:collect get _r_b _r_se, tag(row[7] model2[2]): reg delta_prop gap i.chain i.co_owned i.week

* row 8. Exclude stores called more than twice in wage 1 
preserve
keep if ncalls<3
creat_table5 8
restore

* row 9. Weight by initial employment
qui:collect get _r_b _r_se, tag(row[9] model2[1]): reg delta_prop i.state i.chain i.co_owned [aw=emp]
qui:collect get _r_b _r_se, tag(row[9] model2[2]): reg delta_prop gap i.chain i.co_owned i.week [aw=emp]

* row 12. Pennsylvania stores only
preserve
keep if state == 0
replace gap = (5.05-wage_st)/wage_st if wage_st<5.05

qui:collect get _r_b _r_se, tag(row[10] model1[2]): reg delta gap i.chain i.co_owned 	
qui:collect get _r_b _r_se, tag(row[10] model2[2]): reg delta_prop gap i.chain i.co_owned 
restore

collect dims
collect levelsof result 
collect levelsof colname 

* 行名称
collect recode colname `"gap"' = `"1.state"'
collect style header colname, level(hide)
collect style header result, level(hide)

local colname `" "1. Base specification"  "2. Treat four temporarily closed stores as permanently closed" "3. Exclude managers in employment count" "4. Weight part-time as 0.4×full-time" "5. Weight part-time as 0.6×full-time" "6. Exclude stores in NJ area" "7. Add controls for wave-2 interview date" "8. Exclude stores called more than twice in wage 1" "9. Weight by initial employment" "12. Pennsylvania stores only" "'

local j = 1
foreach i in `colname' {
	collect label levels row `j' `"`i'"', modify
	local ++j
}

* 列名称
collect label dim model1 "Change in employment", modify
collect label dim model2 "Proportional change in employment", modify
collect label levels model1 1 "NJ dummy" 2 "GAP measure", modify
collect label levels model2 1 "NJ dummy" 2 "GAP measure", modify
collect style header model1, title(label)
collect style header model2, title(label)
collect style column, nodelimiter dups(center) position(top) width(asis)

* 数字格式
collect style cell model1 model2, warn halign(center) valign(center) nformat(%6.2f)
collect style cell result[_r_se], sformat("(%s)")

* 整体格式
collect title "TABLE 5-SPECIFICATION TESTS OF REDUCED-FORM EMPLOYMENT MODELS"
collect style cell border_block, border(right, pattern(nil))

collect layout (row#colname[1.state]#result) (model1 model2)	
collect export "table5", as(docx) replace	

******************
* other statistics
******************
ivregress 2sls delta i.state i.chain i.co_owned (emp=nregs nregs11)
ivregress 2sls delta gap i.chain i.co_owned (emp=nregs nregs11)	

*-----------------------------------------------------------------------------
* TABLE 6-EFFECTS OF MINIMUM-WAGE INCREASE ON OHTER OUTCOMES
*-----------------------------------------------------------------------------
clear all
use card1994_data

capture program drop create_table6
program create_table6
	args var1 var2  rowname row 
	qui: {
	ttest `var1'==`var2' if state==1
	scalar m1 = r(mu_2)-r(mu_1)
	scalar se1 = r(se)
	
	ttest `var1'==`var2' if state==0
	scalar m2 = r(mu_2)-r(mu_1)
	scalar se2 = r(se)	
	
	scalar m3 = m1 - m2
	scalar se3 = sqrt(se1^2 + se2^2)
	
	tempvar var3
	gen `var3'= `var2'-`var1'
	
	reg `var3' i.state i.chain i.co_owned
	scalar m4 = _b[1.state]
	scalar se4 = _se[1.state]
	
	reg `var3' gap i.chain i.co_owned
	scalar m5 = _b[gap]
	scalar se5 = _se[gap]	
	
	reg `var3' gap i.chain i.co_owned southj centralj northj pa1 pa2
	scalar m6 = _b[gap]
	scalar se6 = _se[gap]
	
	forvalues i = 1/6 {
		if `i' < 4 {
			collect get m=m`i' s=se`i',tag(`rowname'[`row'] model1[`i'])
		}
		else {
			collect get m=m`i' s=se`i',tag(`rowname'[`row'] model2[`i'])
		}
	}
	
	}
	
end
	
************************
* Store Characteristics:
************************
* row 1
gen emp = empft + 0.5*emppt + nmgrs
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
gen delta = emp2 - emp

gen frac = empft/emp*100 
gen frac2 = empft2/emp2*100

gen gap = 0 
replace gap = (5.05-wage_st)/wage_st if state==1 & wage_st<5.05

collect clear
create_table6 frac frac2  stack1 1

* row 2
create_table6 hrsopen hrsopen2  stack1 2

* row 3
create_table6 nregs nregs2 stack1 3

* row 4
create_table6 nregs11 nregs112 stack1 4

*************************
* Employee Meal Programs:
*************************
* row 5 & 6 & 7
tab meals, gen(meal)
tab meals2, gen(meal2)

forvalues i = 1/3 {
	replace meal`i' = meal`i'*100
	replace meal2`i' = meal2`i'*100
}

create_table6 meal3 meal23 stack2 5
create_table6 meal2 meal22 stack2 6
create_table6 meal4 meal24 stack2 7

*************************
* Wage Profile:
*************************
* row 8 & 9 & 10
gen slope = firstinc/inctime
gen slope2 = firstin2/inctime2

create_table6 inctime inctime2 stack3 8
create_table6 firstinc firstin2 stack3 9
create_table6 slope slope2 stack3 10

*************************
* 修改表格格式
*************************
collect dims
collect levelsof result 

* 行相关
collect label dim stack1 "Store Characteristics:", modify
collect label dim stack2 "Employee Meal Programs:", modify
collect label dim stack3 "Wage Profile:", modify

local colname `" "1. Fraction full-time workers (percentage)"  "2. Number of hours open per weekday" "3. Number of cash registers" "4. Number of cash registers open at 11:00 A.M." "5. Low-price meal program (percentage)" "6. Free meal program (percentage)" "7. Combination of low-price and free meals (percentage)" "8. Time to first raise (weeks)" "9. Usual amount of first raise (cents)" "10. Slope of wage profile (per cent per week)" "'

local j = 1
foreach i in `colname' {
	if `j' < 5 {
		collect label levels stack1 `j' `"`i'"', modify
	}
	else if `j' < 8 {
		collect label levels stack2 `j' `"`i'"', modify
	}
	else {
		collect label levels stack3 `j' `"`i'"', modify
	}
	local ++j
}

collect style header stack1 stack2 stack3, title(label)
collect style header result, level(hide)

*  列相关
collect label dim model1 "Mean change in outcome", modify
collect label dim model2 "Regression of change in outcome variable on:", modify

local colname `" "NJ"  "PA" "NJ-PA" "NJ dummy" "Wage gap a" "Wage gap b" "'
local j = 1
foreach i in `colname' {
	if `j' < 4 {
		collect label levels model1 `j' `"`i'"', modify
	}

	else {
		collect label levels model2 `j' `"`i'"', modify
	}
	local ++j
}

collect style header model1, title(label)
collect style header model2, title(label)
collect style column, nodelimiter dups(center) position(top) width(asis)

* 数字格式
collect style cell model1 model2, warn halign(center) valign(center) nformat(%6.2f)
collect style cell result[s], sformat("(%s)")

* 整体格式
collect title "TABLE 6-EFFECTS OF MINIMUM-WAGE INCREASE ON OHTER OUTCOMES"
collect style cell border_block, border(right, pattern(nil))

collect layout (stack1#result stack2#result stack3#result) (model1 model2)
collect export "table6", as(docx) replace	

*************************
* other statistics
*************************
table meals, statistic(percent)


*-----------------------------------------------------------------------------
* TABLE 7-REDUCED-FORM MODELS FOR CHANGE IN THE PRICE OF A FULL MEAL
*-----------------------------------------------------------------------------
clear all
use card1994_data

gen emp = empft + 0.5*emppt + nmgrs
gen emp2 = empft2 + 0.5*emppt2 + nmgrs2
gen delta = emp2 - emp

replace wage_st2 = 5.05 if status2 == 3 // 将永远关闭的6家店纳入样本
gen gap = 0 
replace gap = (5.05-wage_st)/wage_st if state==1 & wage_st<5.05
gen gap1 = (wage_st2-wage_st)/wage_st

gen price = log(psoda + pfry + pentree)
gen price2 = log(psoda2 + pfry2 + pentree2)
gen price_delta = price2 - price

keep if !mi(delta) & !mi(gap1) & !mi(price_delta)

summarize price_delta // notes 

collect clear
table (command) (result), ///
	command(reg price_delta i.state) ///
	command(reg price_delta i.state i.chain i.co_owned) ///
	command(reg price_delta gap) ///
	command(reg price_delta gap i.chain i.co_owned) ///
	command(reg price_delta gap i.chain i.co_owned southj centralj northj pa1 pa2)
	
collect dims
collect levelsof result 
collect levelsof colname 

collect get col3="no", tags(command[1])
collect get col3="yes", tags(command[2])
collect get col3="no", tags(command[3])
collect get col3="yes", tags(command[4])
collect get col3="yes", tags(command[5])

collect get col4="no", tags(command[1])
collect get col4="no", tags(command[2])
collect get col4="no", tags(command[3])
collect get col4="no", tags(command[4])
collect get col4="yes", tags(command[5])


collect label dim command "Dependent variable: change in the log price of a full meal", modify
collect style header command, title(label)
collect label levels command 1 "(i)" 2 "(ii)" 3 "(iii)" 4 "(iv)" 5 "(v)", modify

collect style header result[_r_b _r_se], level(hide)
collect label levels colname 1.state "1. New Jersey dummy" gap "2. Initial wage gap", modify
collect label levels result col3 "3. Controls for chain and ownership" col4 "4. Controls for region" rmse "5. Standard error of regression", modify

collect style cell command, warn halign(center) valign(center) nformat(%6.3f)
collect style cell result[_r_se], sformat("(%s)")

* 整体格式
collect title "TABLE 7-REDUCED-FORM MODELS FOR CHANGE IN THE PRICE OF A FULL MEAL"
collect style cell border_block, border(right, pattern(nil))

collect layout (colname[1.state gap]#result[_r_b _r_se] result[col3 col4 rmse]) (command)
collect export "table7", as(docx) replace

*-----------------------------------------------------------------------------
* 删除中间数据
*-----------------------------------------------------------------------------
local files : dir . files "*.dta" // 遍历STATA格式文件
foreach f in `files' {
	local ff = substr(`"`f'"',1,4)
	if inlist(`"`ff'"',"temp") {
		erase `f'
	}
}








	
	
	
	
	
	
	
	




