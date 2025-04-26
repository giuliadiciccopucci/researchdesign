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


