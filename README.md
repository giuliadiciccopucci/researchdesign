# researchdesign
cd "/Users/utente/Desktop/research_design"

import delimited "/Users/utente/Desktop/research_design/data/results-survey274732.csv"
save "/Users/utente/Desktop/research_design/data/results-survey274732.dta", replace 
use "/Users/utente/Desktop/research_design/data/results-survey274732.dta"

*dataset exported in the 25th of april 2025

*socio-demographic recoding/renaming

*GENDER
rename genderchooseyourgender gender
tab gender
*drop the variables non useful for data celaning
drop gendertimequestiontimegender
drop genderotherchooseyourgenderother

*YEAR OF BITH - AGE 
tab birthpleaseindicateyouryearofbir
rename birthpleaseindicateyouryearofbir year_of_birth
tab year_of_birth
drop birthtimequestiontimebirth

gen age= 2025 - year_of_birth
tab age

*HIGH SCHOOL
drop highschoolotherwhattypeofhighsch
drop highschooltimequestiontimehighsc
tab highschoolwhattypeofhighschooldi
rename highschoolwhattypeofhighschooldi highschool_type
tab highschool_type

* being INTERNATIONAL student
tab internationalareyouaninternation
rename internationalareyouaninternation international_student
tab international_student
drop internationaltimequestiontimeint

*FIELD of study for international students
tab fieldindicatethegeneralacademica
rename fieldindicatethegeneralacademica international_students_field
tab international_students_field
tab fieldotherindicatethegeneralacad 
*there are no observation, we drop the variable 
drop fieldotherindicatethegeneralacad 

*COURSE you are enrolled in
tab courseselectthecourseyouareenrol
tab courseotherselectthecourseyouare
drop courseotherselectthecourseyouare
rename courseselectthecourseyouareenrol course
tab course

*MIGRATION - creation of the index migrational background
tab migration1wewouldliketolearnyour
tab migration2wewouldliketolearnyour
tab migration3wewouldliketolearnyour

rename migration1wewouldliketolearnyour migration_respondent
rename migration2wewouldliketolearnyour migration_mother
rename migration3wewouldliketolearnyour migration_father 

*create numerical variables 
gen migration_respondent_num = .
replace migration_respondent_num = 1 if migration_respondent == "No"
replace migration_respondent_num = 2 if migration_respondent == "Yes"

gen migration_mother_num = .
replace migration_mother_num = 1 if migration_mother == "No"
replace migration_mother_num = 2 if migration_mother == "Yes"

gen migration_father_num = .
replace migration_father_num = 1 if migration_father == "No"
replace migration_father_num = 2 if migration_father == "Yes"

gen migration_background = .

* Immigrant: if you were not born in Italy
replace migration_background = 1 if migration_respondent_num == 1

* Second generation: if you were born in Italy, but at least on of your parents is not
replace migration_background = 2 if migration_respondent_num == 2 & (migration_mother_num == 1 | migration_father_num == 1)

* Native: you born in Italy,and also your parents 
replace migration_background = 3 if migration_respondent_num == 2 & migration_mother_num == 2 & migration_father_num == 2

label define migration_lbl 1 "First generation immigrant" 2 "Second Generation immigrant" 3 "Native"
label values migration_background migration_lbl

tab migration_background

*to export the table
ssc install asdoc
asdoc tab migration_background, save(tab_mig_back.doc)

* LEVEL OF EDUCATION PARENTS
tab parentedudadwhatisthehighestleve
rename parentedudadwhatisthehighestleve education_father
tab education_father

tab parentedumomwhatisthehighestleve
rename parentedumomwhatisthehighestleve education_mother
tab education_mother

drop parentedutimequestiontimeparente

* ACADEMIC RESULTS
tab achievementhowwouldyourateyourac
rename achievementhowwouldyourateyourac academic_achievment
tab academic_achievment
drop achievementtimequestiontimeachie

* SIBILINGS
tab siblingdoyouhaveanysiblings
rename siblingdoyouhaveanysiblings sibilings
drop siblingtimequestiontimesibling

* LIVING WITH THE PARENTS 
tab livepdoyoulivewithyourparents
drop liveptimequestiontimelivep
rename livepdoyoulivewithyourparents live_parents
tab live_parents

* RELIGIOSITY 
tab religiosity1howreligiouswouldyou
rename religiosity1howreligiouswouldyou religiosity
drop religiositytimequestiontimerelig



*uncertainty/independence recoding/renaming

*HOW MUCH UNCERTAIN : this is our main mediator 

tab uncertain1howuncertaindoyoufeela
drop uncertain1timequestiontimeuncert
rename uncertain1howuncertaindoyoufeela uncertainty_feeling
tab uncertainty_feeling

* UNCERTAINTY FACTORS
*financial instability
tab uncertain21whichofthefollowingar
rename uncertain21whichofthefollowingar uncertainty_finances
tab uncertainty_finances
lab var uncertainty_finances "financial instability is a factor of uncertainty"

*career or employment instability
tab uncertain22whichofthefollowingar
rename uncertain22whichofthefollowingar uncertainty_career
tab uncertainty_career
lab var uncertainty_career "career instability is a factor of uncertainty"

*personal health
tab uncertain23whichofthefollowingar
rename uncertain23whichofthefollowingar uncertainty_health
lab var uncertainty_health "helth is a factor of uncertainty"
tab uncertainty_health

*enviromental risks
tab uncertain24whichofthefollowingar
rename uncertain24whichofthefollowingar uncertainty_enviroment
lab var uncertainty_enviroment "enviromental risks are a factor of uncertainty"
tab uncertainty_enviroment

*human violence
tab uncertain25whichofthefollowingar
rename uncertain25whichofthefollowingar uncertainty_violence
lab var uncertainty_violence "human violence is a factor of uncertainty"
tab uncertainty_violence

*other
tab uncertain2otherwhichofthefollowi
rename uncertain2otherwhichofthefollowi uncertainty_other
lab var uncertainty_other "other factors of uncertainty"
tab uncertainty_other


drop uncertain2timequestiontimeuncert

*additive intex about the factors of uncertainty from 0 to 5
gen uncertainty_index = (uncertainty_finances== "Yes") + (uncertainty_career== "Yes") + (uncertainty_health== "Yes") + (uncertainty_enviroment== "Yes") + (uncertainty_violence=="Yes") 
tab uncertainty_index
asdoc tab uncertainty_index, save(uncertainty_index.doc)


*INDEPENDENCE 
*Managing one's own finances and expenses
tab uncertain31whatdoyouconsidertobe
rename uncertain31whatdoyouconsidertobe independence_finances
lab var independence_finances "importance of finacial independence"
tab independence_finances


*Being able to deal with emotions without depending on others
tab uncertain32whatdoyouconsidertobe
rename uncertain32whatdoyouconsidertobe independence_emotions
lab var independence_emotions "importance of emotional independence"
tab independence_emotions

*Having autonomy in one's work and career choices
tab uncertain33whatdoyouconsidertobe 
rename uncertain33whatdoyouconsidertobe independence_career
lab var independence_career "importance of career independence"
tab independence_career

*Having the ability to secure and maintain one's own living space
tab uncertain34whatdoyouconsidertobe
rename uncertain34whatdoyouconsidertobe independence_house
lab var independence_house "importance of independence about living space"
tab independence_house 

*Being able to make important decisions independently
tab uncertain35whatdoyouconsidertobe
rename uncertain35whatdoyouconsidertobe independence_decisions
lab var independence_decisions "importance of independence about taking decisions"
tab independence_decisions 

foreach var of varlist independence_finances independence_emotions independence_career independence_house  independence_decisions {
    gen `var'_num = .
    replace `var'_num = 1 if `var' == "Not important at all"
    replace `var'_num = 2 if `var' == "Slightly important"
    replace `var'_num = 3 if `var' == "Moderately important"
    replace `var'_num = 4 if `var' == "Important"
    replace `var'_num = 5 if `var' == "Very important"
}

*mean of the answers to have a scale 1-5
egen independence_index = rowmean(independence_finances_num independence_emotions_num independence_career_num independence_house_num  independence_decisions_num)

tab independence_index

label variable independence_index "Independence index"

gen independence_index_final = .
replace independence_index_final = 1 if independence_index <= 2.5
replace independence_index_final = 2 if independence_index > 2.5 & independence_index <= 3.5
replace independence_index_final = 3 if independence_index > 3.5 & independence_index <= 5

lab var independence_index_final "level of importance of independence"
label define independence_index_final_lbl 1 "Low" 2 "Medium" 3 "High"
label values independence_index_final independence_index_final_lbl

tab independence_index_final

asdoc tab independence_index_final, save(independence_index_final.doc)

*independence limited by children 
tab uncertain4doyoufeelthathavingchi
rename uncertain4doyoufeelthathavingchi independence_children
lab var independence_children "children would limit my indepencence"
tab independence_children
