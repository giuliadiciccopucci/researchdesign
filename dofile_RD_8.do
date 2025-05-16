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
drop if gender == "Other" | gender == "Prefer not to say"

gen gender_num = .
replace gender_num = 0 if gender == "Male"
replace gender_num = 1 if gender == "Female"

tab gender_num

*YEAR OF BITH - AGE 
tab birthpleaseindicateyouryearofbir
rename birthpleaseindicateyouryearofbir year_of_birth
tab year_of_birth
drop birthtimequestiontimebirth

gen age= 2025 - year_of_birth
tab age
drop if age > 26

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

gen edu_father_num = .
replace edu_father_num = 0 if education_father == "Less than high-school level"
replace edu_father_num = 1 if education_father == "High-school degree (or equivalent)"
replace edu_father_num = 2 if education_father == "College/university degree (or equivalent)"
tab edu_father_num

gen edu_mother_num = .
replace edu_mother_num = 0 if education_mother == "Less than high-school level"
replace edu_mother_num = 1 if education_mother == "High-school degree (or equivalent)"
replace edu_mother_num = 2 if education_mother == "College/university degree (or equivalent)"
tab edu_mother_num

gen edu_parents_index = (edu_father_num + edu_mother_num)/2
tab edu_parents_index

gen edu_parents_cat = .

replace edu_parents_cat = 0 if inrange(edu_parents_index, 0, 0.5)
replace edu_parents_cat = 1 if inrange(edu_parents_index, 1, 1.5)
replace edu_parents_cat = 2 if edu_parents_index == 2

label define edulevels 0 "Low" 1 "Medium" 2 "High"
label values edu_parents_cat edulevels
label variable edu_parents_cat "Categorical parental education level"
tab edu_parents_cat


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

gen religiosity_num = .


foreach val in 2 3 4 5 6 7 8 9 {
    replace religiosity_num = `val' if religiosity == "`val'"
}


replace religiosity_num = 1 if religiosity == "Not at all"
replace religiosity_num = 10 if religiosity == "Very"


label variable religiosity_num "Religiosity scale (1=Not at all, 10=Very)"


tab religiosity_num

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

*additive index about the factors of uncertainty from 0 to 5
gen uncertainty_index = (uncertainty_finances== "Yes") + (uncertainty_career== "Yes") + (uncertainty_health== "Yes") + (uncertainty_enviroment== "Yes") + (uncertainty_violence=="Yes") 
tab uncertainty_index

gen uncertainty_index_final = .
replace uncertainty_index_final = 1 if uncertainty_index == 0 | uncertainty_index == 1 
replace uncertainty_index_final = 2 if uncertainty_index == 2 | uncertainty_index == 3
replace uncertainty_index_final = 3 if uncertainty_index == 4 | uncertainty_index == 5
lab var uncertainty_index_final "uncertainty level"
label define uncertainty_index_final 1 "low" 2 "medium" 3 "high"
tab uncertainty_index_final 
asdoc tab uncertainty_index_final, save(uncertainty_index.doc)



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

*independence limited by children : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tab uncertain4doyoufeelthathavingchi
rename uncertain4doyoufeelthathavingchi independence_children
lab var independence_children "children would limit my indepencence"
tab independence_children

*--------------------------------------------------------------------
*social media usage recoding/renaming

*Rename "do you use any type of social media?"
tab media1doyouus~d
rename media1doyouus~d social_media_user
tab social_media_user
label variable social_media_user "Respondent uses social media"

* Rename social media usage variables
* === FACEBOOK ===
tab media21whichofthefollowingsocial
rename media21whichofthefollowingsocial facebook_usage
tab facebook_usage
label variable facebook_usage "Facebook usage"

* === INSTAGRAM ===
tab media22whichofthefollowingsocial
rename media22whichofthefollowingsocial instagram_usage
tab instagram_usage
label variable instagram_usage "Instagram usage"

* === X (ex Twitter) ===
tab media23whichofthefollowingsocial
rename media23whichofthefollowingsocial x_usage
tab x_usage
label variable x_usage "X (Twitter) usage"

* === SNAPCHAT ===
tab media24whichofthefollowingsocial
rename media24whichofthefollowingsocial snapchat_usage
tab snapchat_usage
label variable snapchat_usage "Snapchat usage"

* === TIKTOK ===
tab media25whichofthefollowingsocial
rename media25whichofthefollowingsocial tiktok_usage
tab tiktok_usage
label variable tiktok_usage "TikTok usage"

* === LINKEDIN ===
tab media26whichofthefollowingsocial
rename media26whichofthefollowingsocial linkedin_usage
tab linkedin_usage
label variable linkedin_usage "LinkedIn usage"

* === PINTEREST ===
tab media27whichofthefollowingsocial
rename media27whichofthefollowingsocial pinterest_usage
tab pinterest_usage
label variable pinterest_usage "Pinterest usage"

* === YOUTUBE ===
tab media28whichofthefollowingsocial
rename media28whichofthefollowingsocial youtube_usage
tab youtube_usage
label variable youtube_usage "YouTube usage"

* === REDDIT ===
tab media29whichofthefollowingsocial
rename media29whichofthefollowingsocial reddit_usage
tab reddit_usage
label variable reddit_usage "Reddit usage"

* === WHATSAPP ===
tab media210whichofthefollowingsocia
rename media210whichofthefollowingsocia whatsapp_usage
tab whatsapp_usage
label variable whatsapp_usage "WhatsApp usage"

* === TELEGRAM ===
tab media211whichofthefollowingsocia
rename media211whichofthefollowingsocia telegram_usage
tab telegram_usage
label variable telegram_usage "Telegram usage


* Creating "minutes" variables for each social
*--------------------------------------------------------------------

* Facebook
* the values of the variables are the means of the categories of the questions
gen facebook_minutes = .
replace facebook_minutes = 0    if facebook_usage == "Don't use it"
replace facebook_minutes = 15   if facebook_usage == "Less than 30 minutes"
replace facebook_minutes = 45   if facebook_usage == "30 minutes to 1 hour"
replace facebook_minutes = 90   if facebook_usage == "1–2 hours"
replace facebook_minutes = 150  if facebook_usage == "2–3 hours"
replace facebook_minutes = 210  if facebook_usage == "More than 3 hours"
tab facebook_minutes

* Instagram
gen instagram_minutes = .
replace instagram_minutes = 0    if instagram_usage == "Don't use it"
replace instagram_minutes = 15   if instagram_usage == "Less than 30 minutes"
replace instagram_minutes = 45   if instagram_usage == "30 minutes to 1 hour"
replace instagram_minutes = 90   if instagram_usage == "1–2 hours"
replace instagram_minutes = 150  if instagram_usage == "2–3 hours"
replace instagram_minutes = 210  if instagram_usage == "More than 3 hours"
tab instagram_minutes

*recoding for regression (M1)
gen instagram_use_cat = .
replace instagram_use_cat = 0 if inlist(instagram_usage, "Don't use it", "Less than 30 minutes")
replace instagram_use_cat = 1 if inlist(instagram_usage, "30 minutes to 1 hour", "1–2 hours")
replace instagram_use_cat = 2 if inlist(instagram_usage, "2–3 hours", "More than 3 hours")
label define instag_use_lbl 0 "Low use" 1 "Medium use" 2 "High use"
label values instagram_use_cat instag_use_lbl
tab instagram_use_cat
* put .i in the regression 


* X (ex Twitter)
gen x_minutes = .
replace x_minutes = 0    if x_usage == "Don't use it"
replace x_minutes = 15   if x_usage == "Less than 30 minutes"
replace x_minutes = 45   if x_usage == "30 minutes to 1 hour"
replace x_minutes = 90   if x_usage == "1–2 hours"
replace x_minutes = 150  if x_usage == "2–3 hours"
replace x_minutes = 210  if x_usage == "More than 3 hours"
tab x_minutes

* Snapchat
gen snapchat_minutes = .
replace snapchat_minutes = 0    if snapchat_usage == "Don't use it"
replace snapchat_minutes = 15   if snapchat_usage == "Less than 30 minutes"
replace snapchat_minutes = 45   if snapchat_usage == "30 minutes to 1 hour"
replace snapchat_minutes = 90   if snapchat_usage == "1–2 hours"
replace snapchat_minutes = 150  if snapchat_usage == "2–3 hours"
replace snapchat_minutes = 210  if snapchat_usage == "More than 3 hours"
tab snapchat_minutes

* TikTok
gen tiktok_minutes = .
replace tiktok_minutes = 0    if tiktok_usage == "Don't use it"
replace tiktok_minutes = 15   if tiktok_usage == "Less than 30 minutes"
replace tiktok_minutes = 45   if tiktok_usage == "30 minutes to 1 hour"
replace tiktok_minutes = 90   if tiktok_usage == "1–2 hours"
replace tiktok_minutes = 150  if tiktok_usage == "2–3 hours"
replace tiktok_minutes = 210  if tiktok_usage == "More than 3 hours"
tab tiktok_minutes

*recoding for the regression
gen tiktok_use_cat = .
replace tiktok_use_cat = 0 if inlist(tiktok_usage, "Don't use it", "Less than 30 minutes")
replace tiktok_use_cat = 1 if inlist(tiktok_usage, "30 minutes to 1 hour", "1–2 hours")
replace tiktok_use_cat = 2 if inlist(tiktok_usage, "2–3 hours", "More than 3 hours")
label define tiktok_use_lbl 0 "Low use" 1 "Medium use" 2 "High use"
label values tiktok_use_cat tiktok_use_lbl
tab tiktok_use_cat

* LinkedIn
gen linkedin_minutes = .
replace linkedin_minutes = 0    if linkedin_usage == "Don't use it"
replace linkedin_minutes = 15   if linkedin_usage == "Less than 30 minutes"
replace linkedin_minutes = 45   if linkedin_usage == "30 minutes to 1 hour"
replace linkedin_minutes = 90   if linkedin_usage == "1–2 hours"
replace linkedin_minutes = 150  if linkedin_usage == "2–3 hours"
replace linkedin_minutes = 210  if linkedin_usage == "More than 3 hours"
tab linkedin_minutes

* Pinterest
gen pinterest_minutes = .
replace pinterest_minutes = 0    if pinterest_usage == "Don't use it"
replace pinterest_minutes = 15   if pinterest_usage == "Less than 30 minutes"
replace pinterest_minutes = 45   if pinterest_usage == "30 minutes to 1 hour"
replace pinterest_minutes = 90   if pinterest_usage == "1–2 hours"
replace pinterest_minutes = 150  if pinterest_usage == "2–3 hours"
replace pinterest_minutes = 210  if pinterest_usage == "More than 3 hours"
tab pinterest_minutes

* YouTube
gen youtube_minutes = .
replace youtube_minutes = 0    if youtube_usage == "Don't use it"
replace youtube_minutes = 15   if youtube_usage == "Less than 30 minutes"
replace youtube_minutes = 45   if youtube_usage == "30 minutes to 1 hour"
replace youtube_minutes = 90   if youtube_usage == "1–2 hours"
replace youtube_minutes = 150  if youtube_usage == "2–3 hours"
replace youtube_minutes = 210  if youtube_usage == "More than 3 hours"
tab youtube_minutes

*recoding for the regression
gen youtube_use_cat = .
replace youtube_use_cat = 0 if inlist(youtube_usage, "Don't use it", "Less than 30 minutes")
replace youtube_use_cat = 1 if inlist(youtube_usage, "30 minutes to 1 hour", "1–2 hours")
replace youtube_use_cat = 2 if inlist(youtube_usage, "2–3 hours", "More than 3 hours")
label define youtube_use_lbl 0 "Low use" 1 "Medium use" 2 "High use"
label values youtube_use_cat youtube_use_lbl
tab youtube_use_cat

* Reddit
gen reddit_minutes = .
replace reddit_minutes = 0    if reddit_usage == "Don't use it"
replace reddit_minutes = 15   if reddit_usage == "Less than 30 minutes"
replace reddit_minutes = 45   if reddit_usage == "30 minutes to 1 hour"
replace reddit_minutes = 90   if reddit_usage == "1–2 hours"
replace reddit_minutes = 150  if reddit_usage == "2–3 hours"
replace reddit_minutes = 210  if reddit_usage == "More than 3 hours"
tab reddit_minutes

* WhatsApp
gen whatsapp_minutes = .
replace whatsapp_minutes = 0    if whatsapp_usage == "Don't use it"
replace whatsapp_minutes = 15   if whatsapp_usage == "Less than 30 minutes"
replace whatsapp_minutes = 45   if whatsapp_usage == "30 minutes to 1 hour"
replace whatsapp_minutes = 90   if whatsapp_usage == "1–2 hours"
replace whatsapp_minutes = 150  if whatsapp_usage == "2–3 hours"
replace whatsapp_minutes = 210  if whatsapp_usage == "More than 3 hours"
tab whatsapp_minutes

* Telegram
gen telegram_minutes = .
replace telegram_minutes = 0    if telegram_usage == "Don't use it"
replace telegram_minutes = 15   if telegram_usage == "Less than 30 minutes"
replace telegram_minutes = 45   if telegram_usage == "30 minutes to 1 hour"
replace telegram_minutes = 90   if telegram_usage == "1–2 hours"
replace telegram_minutes = 150  if telegram_usage == "2–3 hours"
replace telegram_minutes = 210  if telegram_usage == "More than 3 hours"
tab telegram_minutes


*Creating additive Index for total social media usage
egen Total_Time = rowtotal(facebook_minutes instagram_minutes x_minutes snapchat_minutes tiktok_minutes linkedin_minutes pinterest_minutes youtube_minutes reddit_minutes whatsapp_minutes telegram_minutes)
label variable Total_Time "Total time spent daily on social media "
tab Total_Time

*refininig index by creating 5 categories
gen social_media_time = .

replace social_media_time = 1 if Total_Time <= 120
replace social_media_time = 2 if inrange(Total_Time, 121, 240)
replace social_media_time = 3 if inrange(Total_Time, 241, 360)
replace social_media_time = 4 if inrange(Total_Time, 361, 480)
replace social_media_time = 5 if Total_Time > 480
tab social_media_time

label define socialcat 1 "Very Low (0–2h)" 2 "Low (2–4h)" 3 "Medium (4–6h)" 4 "High (6–8h)" 5 "Very High (>8h)"
label values social_media_time socialcat
label variable social_media_time "Social media usage time (5 categories)"
tab social_media_time


* === Renaming variables of contents seen on social media ===

* 1 - Entertainment (memes, funny videos, etc.)
tab media31whileusingso
rename media31whileusingso entertainment_content
tab entertainment_content
label variable entertainment_content "Exposure to entertainment content (memes, funny videos, etc.)"

* 2 - Informational (news, politics)
tab media32whileusingso
rename media32whileusingso informational_content
tab informational_content
label variable informational_content "Exposure to informational content (news, social/political issues)"

* 3 - Lifestyle (travel, fashion, fitness)
tab media33whileusingso
rename media33whileusingso lifestyle_content
tab lifestyle_content
label variable lifestyle_content "Exposure to lifestyle content (travel, fashion, beauty, fitness)"

* 4 - Family and parenting
tab media34whileusingso
rename media34whileusingso family_content
tab family_content
label variable family_content "Exposure to family and parenting-related content"

* 5 - Sexual health and contraception
tab media35whileusingso
rename media35whileusingso sexualhealth_content
tab sexualhealth_content
label variable sexualhealth_content "Exposure to sexual-health and contraception content"

* 6 - Career success or professional achievement
tab media36whileusingso
rename media36whileusingso career_content
tab career_content
label variable career_content "Exposure to career success or professional achievement content"

* 7 - Economic and personal finance
tab media37whileusingso
rename media37whileusingso finance_content
tab finance_content
label variable finance_content "Exposure to economic and personal finance content"

* 8 - Mental health and personal well-being
tab media38whileusingso
rename media38whileusingso mentalhealth_content
tab mentalhealth_content
label variable mentalhealth_content "Exposure to mental health and personal well-being content"

* 9 - Environmental and ecological issues
tab media39whileusingso
rename media39whileusingso environment_content
tab environment_content
label variable environment_content "Exposure to environmental and ecological issues content"

* 10 - Independent lifestyle
tab media310whileusingso
rename media310whileusingso independent_content
tab independent_content
label variable independent_content "Exposure to independent lifestyle content"


*--------------------------------------------------------------------
*recoding/renaming fertility variables
* Recode of the variable "fertility1doy~e" into a numeric format
* Coding scheme:
* - "Yes" → 1
* - "No" → 0
* - "I haven't decided yet" → 2
* - "Prefer not to answer" remains missing (.)
gen want_children = .
replace want_children = 1 if fertility1doyouwanttohavechildre == "Yes"
replace want_children = 0 if fertility1doyouwanttohavechildre == "No"
replace want_children = 2 if fertility1doyouwanttohavechildre == "I haven't decided yet"
label define wantkids 0 "No" 1 "Yes" 2 "Undecided"

label values want_children wantkids
label variable want_children "Desire to have children in the future (Yes/No/Undecided)"
tab want_children

* Recode of the variable about ideal number of children
* Keep 1, 2, 3, and 4+ as 1, 2, 3, 4
* Set "Prefer not to say" as missing
gen ideal_children = .
replace ideal_children = 1 if fertility2howmanychildrenwouldyo == "1"
replace ideal_children = 2 if fertility2howmanychildrenwouldyo == "2"
replace ideal_children = 3 if fertility2howmanychildrenwouldyo == "3"
replace ideal_children = 4 if fertility2howmanychildrenwouldyo == "4+"
label variable ideal_children "Ideal number of children"
tab ideal_children


* Recode of "When would you ideally want to have your first child?"
* - Recoded to numeric scale (1-5) 1 soonest 5 latest
* - Value labels assigned to indicate timing categories
* - "I haven't decided yet" set as missing
gen first_child_timing = .
replace first_child_timing = 1 if fertility3whenwouldyouideallywan == "Within the next year"
replace first_child_timing = 2 if fertility3whenwouldyouideallywan == "Within 1-2 years"
replace first_child_timing = 3 if fertility3whenwouldyouideallywan == "Within 3-5 years"
replace first_child_timing = 4 if fertility3whenwouldyouideallywan == "Within 6-10 years"
replace first_child_timing = 5 if fertility3whenwouldyouideallywan == "In over 10 years"
label define firstchildlbl 1 "Within next year" 2 "Within 1-2 years" 3 "Within 3-5 years" 4 "Within 6-10 years" 5 "In over 10 years"
label values first_child_timing firstchildlbl
label variable first_child_timing "Ideal timing for first child (ordered scale)"
tab first_child_timing

* === Check, rename, and tabulate each fertility-related belief statement ===

* 1
tab fertility41towhatextentdothefoll
rename fertility41towhatextentdothefoll financial_freedom_loss
tab financial_freedom_loss

* 2
tab fertility42towhatextentdothefoll
rename fertility42towhatextentdothefoll financial_stability_need
tab financial_stability_need

* 3
tab fertility43towhatextentdothefoll
rename fertility43towhatextentdothefoll career_impact
tab career_impact

* 4
tab fertility44towhatextentdothefoll
rename fertility44towhatextentdothefoll meaning_life_children
tab meaning_life_children

* 5
tab fertility45towhatextentdothefoll
rename fertility45towhatextentdothefoll limit_personal_freedom
tab limit_personal_freedom

* 6
tab fertility46towhatextentdothefoll
rename fertility46towhatextentdothefoll life_complete_children
tab life_complete_children

* 7
tab fertility47towhatextentdothefoll
rename fertility47towhatextentdothefoll environmental_worry
tab environmental_worry

* 8
tab fertility48towhatextentdothefoll
rename fertility48towhatextentdothefoll need_stable_relationship
tab need_stable_relationship

* 9
tab fertility49towhatextentdothefoll
rename fertility49towhatextentdothefoll strengthen_relationship
tab strengthen_relationship

* 10
tab fertility410towhatextentdothefol
rename fertility410towhatextentdothefol cultural_expectations
tab cultural_expectations

* === Assign variable labels to the renamed variables ===
label variable financial_freedom_loss "Having children would reduce my financial freedom"
label variable financial_stability_need "I need to feel financially stable before having children"
label variable career_impact "Having children would negatively impact my career goals"
label variable meaning_life_children "Having children would make my life feel more meaningful"
label variable limit_personal_freedom "Having children would limit my personal freedom"
label variable life_complete_children "Only with children can life feel complete"
label variable environmental_worry "Environmental concerns make me worry about having children"
label variable need_stable_relationship "I need to be in a stable relationship before considering having children"
label variable strengthen_relationship "Having children would strengthen my relationship with my partner"
label variable cultural_expectations "Cultural expectations influence my decision about children"


* Recode of the statement on perceived fertility knowledge
* - Recoded as a 5-point Likert scale (1 = Strongly disagree, 5 = Strongly agree)
* - "Prefer not to answer" treated as missing
gen fertility_knowledge = .
replace fertility_knowledge = 5 if fertility5ifeelthatmycurrentleve == "Strongly agree"
replace fertility_knowledge = 4 if fertility5ifeelthatmycurrentleve == "Agree"
replace fertility_knowledge = 3 if fertility5ifeelthatmycurrentleve == "Nor disagree or agree"
replace fertility_knowledge = 2 if fertility5ifeelthatmycurrentleve == "Disagree"
replace fertility_knowledge = 1 if fertility5ifeelthatmycurrentleve == "Strongly disagree"
label define fertknowlbl 1 "Strongly disagree" 2 "Disagree" 3 "Neutral" 4 "Agree" 5 "Strongly agree"
label values fertility_knowledge fertknowlbl
label variable fertility_knowledge "Confidence in fertility knowledge"
tab fertility_knowledge

*descriptive statistics of the main variables 
*independent variable: social media usage 
tab social_media_time
summarize social_media_time

ssc install estout, replace
estpost summarize social_media_time
esttab using "statistiche.doc", ///
    cells("mean sd min max") ///
    collabels("Media" "Dev. Std." "Min" "Max") ///
    replace rtf
	
estpost tabulate social_media_time
esttab using "frequenze.doc", cells("b pct") ///
    collabels("Frequenza" "%") ///
    replace rtf

graph bar (count), over(social_media_time, label(angle(45))) ///
    title("Social media usage") ///
    ylabel(, grid)


*mediators: uncertainty and independence. we cannot use independence index since the distrinbution is not normal.

tab uncertainty_index_final
summarize uncertainty_index_final

ssc install estout, replace
estpost summarize uncertainty_index_final
esttab using "statistiche1.doc", ///
    cells("mean sd min max") ///
    collabels("Media" "Dev. Std." "Min" "Max") ///
    replace rtf
	
estpost tabulate uncertainty_index_final
esttab using "frequenze1.doc", cells("b pct") ///
    collabels("Frequenza" "%") ///
    replace rtf
	
graph bar (count), over(uncertainty_index_final) ///
    bar(1, color(navy)) ///
    title("Percieved level of uncertainty")
	
tab independence_index_final
summarize independence_index_final

ssc install estout, replace
estpost summarize independence_index_final
esttab using "statistiche2.doc", ///
    cells("mean sd min max") ///
    collabels("Media" "Dev. Std." "Min" "Max") ///
    replace rtf
	
estpost tabulate independence_index_final
esttab using "frequenze2.doc", cells("b pct") ///
    collabels("Frequenza" "%") ///
    replace rtf

graph bar (count), over(independence_index_final) ///
    bar(1, color(olive)) ///
    title("Importance of independence")
	
	
* Factor analysis 
*numerical variables 
* ⁠1 - Entertainment
gen entertainment_content_cont = .
replace entertainment_content_cont = 4 if entertainment_content == "Every time"
replace entertainment_content_cont = 3 if entertainment_content == "Often"
replace entertainment_content_cont = 2 if entertainment_content == "Sometimes"
replace entertainment_content_cont = 1 if entertainment_content == "Rarely"
replace entertainment_content_cont = 0 if entertainment_content == "Never"
replace entertainment_content_cont = . if entertainment_content == "I don't know"
label variable entertainment_content_cont "Recoded exposure to entertainment content"

*⁠2 - Informational
gen informational_content_cont = .
replace informational_content_cont = 4 if informational_content == "Every time"
replace informational_content_cont = 3 if informational_content == "Often"
replace informational_content_cont = 2 if informational_content == "Sometimes"
replace informational_content_cont = 1 if informational_content == "Rarely"
replace informational_content_cont = 0 if informational_content == "Never"
replace informational_content_cont = . if informational_content == "I don't know"
label variable informational_content_cont "Recoded exposure to informational content"

* ⁠3 - Lifestyle
gen lifestyle_content_cont = .
replace lifestyle_content_cont = 4 if lifestyle_content == "Every time"
replace lifestyle_content_cont = 3 if lifestyle_content == "Often"
replace lifestyle_content_cont = 2 if lifestyle_content == "Sometimes"
replace lifestyle_content_cont = 1 if lifestyle_content == "Rarely"
replace lifestyle_content_cont = 0 if lifestyle_content == "Never"
replace lifestyle_content_cont = . if lifestyle_content == "I don't know"
label variable lifestyle_content_cont "Recoded exposure to lifestyle content"

* ⁠4 - Family
gen family_content_cont = .
replace family_content_cont = 4 if family_content == "Every time"
replace family_content_cont = 3 if family_content == "Often"
replace family_content_cont = 2 if family_content == "Sometimes"
replace family_content_cont = 1 if family_content == "Rarely"
replace family_content_cont = 0 if family_content == "Never"
replace family_content_cont = . if family_content == "I don't know"
label variable family_content_cont "Recoded exposure to family content"

* ⁠5 - Sexual health
gen sexualhealth_content_cont = .
replace sexualhealth_content_cont = 4 if sexualhealth_content == "Every time"
replace sexualhealth_content_cont = 3 if sexualhealth_content == "Often"
replace sexualhealth_content_cont = 2 if sexualhealth_content == "Sometimes"
replace sexualhealth_content_cont = 1 if sexualhealth_content == "Rarely"
replace sexualhealth_content_cont = 0 if sexualhealth_content == "Never"
replace sexualhealth_content_cont = . if sexualhealth_content == "I don't know"
label variable sexualhealth_content_cont "Recoded exposure to sexual health content"

*⁠6 - Career
gen career_content_cont = .
replace career_content_cont = 4 if career_content == "Every time"
replace career_content_cont = 3 if career_content == "Often"
replace career_content_cont = 2 if career_content == "Sometimes"
replace career_content_cont = 1 if career_content == "Rarely"
replace career_content_cont = 0 if career_content == "Never"
replace career_content_cont = . if career_content == "I don't know"
label variable career_content_cont "Recoded exposure to career content"

*7 - Finance
gen finance_content_cont = .
replace finance_content_cont = 4 if finance_content == "Every time"
replace finance_content_cont = 3 if finance_content == "Often"
replace finance_content_cont = 2 if finance_content == "Sometimes"
replace finance_content_cont = 1 if finance_content == "Rarely"
replace finance_content_cont = 0 if finance_content == "Never"
replace finance_content_cont = . if finance_content == "I don't know"
label variable finance_content_cont "Recoded exposure to finance content"

*⁠8 - Mental health
gen mentalhealth_content_cont = .
replace mentalhealth_content_cont = 4 if mentalhealth_content == "Every time"
replace mentalhealth_content_cont = 3 if mentalhealth_content == "Often"
replace mentalhealth_content_cont = 2 if mentalhealth_content == "Sometimes"
replace mentalhealth_content_cont = 1 if mentalhealth_content == "Rarely"
replace mentalhealth_content_cont = 0 if mentalhealth_content == "Never"
replace mentalhealth_content_cont = . if mentalhealth_content == "I don't know"
label variable mentalhealth_content_cont "Recoded exposure to mental health content"

* ⁠9 - Environment
gen environment_content_cont = .
replace environment_content_cont = 4 if environment_content == "Every time"
replace environment_content_cont = 3 if environment_content == "Often"
replace environment_content_cont = 2 if environment_content == "Sometimes"
replace environment_content_cont = 1 if environment_content == "Rarely"
replace environment_content_cont = 0 if environment_content == "Never"
replace environment_content_cont = . if environment_content == "I don't know"
label variable environment_content_cont "Recoded exposure to environment content"

* ⁠10 - Independent lifestyle
gen independent_content_cont = .
replace independent_content_cont = 4 if independent_content == "Every time"
replace independent_content_cont = 3 if independent_content == "Often"
replace independent_content_cont = 2 if independent_content == "Sometimes"
replace independent_content_cont = 1 if independent_content == "Rarely"
replace independent_content_cont = 0 if independent_content == "Never"
replace independent_content_cont = . if independent_content == "I don't know"
label variable independent_content_cont "Recoded exposure to independent lifestyle content"
	
describe entertainment_content_cont informational_content_cont lifestyle_content_cont family_content_cont sexualhealth_content_cont career_content_cont finance_content_cont mentalhealth_content_cont environment_content_cont independent_content_cont


factor entertainment_content_cont informational_content_cont lifestyle_content_cont family_content_cont sexualhealth_content_cont career_content_cont finance_content_cont mentalhealth_content_cont environment_content_cont independent_content_cont

estat kmo 
*keep only if >0.6. So according to this, we keep: lifestyle, family, sexual health, career, mental health, independence content  

ssc install factortest

factortest entertainment_content_cont informational_content_cont lifestyle_content_cont family_content_cont sexualhealth_content_cont career_content_cont finance_content_cont mentalhealth_content_cont environment_content_cont independent_content_cont

*balrett test is significant 
factor  lifestyle_content_cont family_content_cont sexualhealth_content_cont career_content_cont mentalhealth_content_cont  independent_content_cont, factors(6)
screeplot

*we have only one factor so we can't proceed with factor analysis 

*we have to choose social media

tab instagram_usage
tab facebook_usage 
*we won't use facebook
tab linkedin_usage
*we won't use linkedin
tab youtube_usage
tab snapchat_usage
*we won't use snapchat9
tab whatsapp_usage
tab x_usage
*we won't use x
tab pinterest_usage
tab tiktok_usage
tab reddit_usage
tab telegram_usage

*we will use tiktok instagram and youtube 

*  use of social media / content of media use (less frequent -more). sample sizes 
* ideal children only descriptive (maybe to add at hte end)

*MODELS WITH SOCIAL MEDIA USAGE (INSTAGRAM TIKTOK AND YOUTUBE) AND FERTILITY INTENTIONS
gen fertility_intentions = .
replace fertility_intentions = 0 if want_children == 0
replace fertility_intentions = 0 if want_children == 2
replace fertility_intentions = 1 if want_children == 1

label variable fertility_intentions "Do you want to have children?"
label define fertility_intentions 0 "No or haven't decided yet" 1 "Yes"
label values fertility_intentions fertility_intentions
tab fertility_intentions

*model 1, 2, 3
logistic fertility_intentions i.instagram_use_cat
logistic fertility_intentions i.tiktok_use_cat
logistic fertility_intentions i.youtube_use_cat

logistic fertility_intentions i.instagram_use_cat i.gender_num religiosity_num age 
margins, dydx(*)  // calcola Average Marginal Effects (AME)
marginsplot, recast(bar)


logistic fertility_intentions i.tiktok_use_cat i.gender_num religiosity_num age 
margins, dydx(*)  // calcola Average Marginal Effects (AME)
marginsplot, recast(bar)

logistic fertility_intentions i.youtube_use_cat i.gender_num religiosity_num age 
margins, dydx(*)  // calcola Average Marginal Effects (AME)
marginsplot, recast(bar)

*put the models together
quietly logit fertility_intentions i.instagram_use_cat i.gender_num religiosity_num age 
estimates store m1
quietly regress fertility_intentions i.tiktok_use_cat i.gender_num religiosity_num age 
estimates store m2
quietly regress fertility_intentions i.youtube_use_cat i.gender_num religiosity_num age 
estimates store m3
coefplot m1 m2 m3, drop(_cons) xline(0) 

*MODELS CONTENT- FERTILITY INTENTIONS. what about uncertainty?
** first of all we recode contents in binary variables and we aggregate some of them that are similar

* Recoding
label define freq_binary 0 "Less frequent" 1 "More frequent"

gen ent_binary = .
replace ent_binary = 0 if inlist(entertainment_content_cont, 0, 1, 2)
replace ent_binary = 1 if inlist(entertainment_content_cont, 3, 4)
label values ent_binary freq_binary
label variable ent_binary "Frequent exposure to entertainment content"

gen info_binary = .
replace info_binary = 0 if inlist(informational_content_cont, 0, 1, 2)
replace info_binary = 1 if inlist(informational_content_cont, 3, 4)
label values info_binary freq_binary
label variable info_binary "Frequent exposure to informational content"

gen life_binary = .
replace life_binary = 0 if inlist(lifestyle_content_cont, 0, 1, 2)
replace life_binary = 1 if inlist(lifestyle_content_cont, 3, 4)
label values life_binary freq_binary
label variable life_binary "Frequent exposure to lifestyle content"

gen fam_binary = .
replace fam_binary = 0 if inlist(family_content_cont, 0, 1, 2)
replace fam_binary = 1 if inlist(family_content_cont, 3, 4)
label values fam_binary freq_binary
label variable fam_binary "Frequent exposure to family content"

gen sexhlth_binary = .
replace sexhlth_binary = 0 if inlist(sexualhealth_content_cont, 0, 1, 2)
replace sexhlth_binary = 1 if inlist(sexualhealth_content_cont, 3, 4)
label values sexhlth_binary freq_binary
label variable sexhlth_binary "Frequent exposure to sexual health content"

gen career_binary = .
replace career_binary = 0 if inlist(career_content_cont, 0, 1, 2)
replace career_binary = 1 if inlist(career_content_cont, 3, 4)
label values career_binary freq_binary
label variable career_binary "Frequent exposure to career content"

gen fin_binary = .
replace fin_binary = 0 if inlist(finance_content_cont, 0, 1, 2)
replace fin_binary = 1 if inlist(finance_content_cont, 3, 4)
label values fin_binary freq_binary
label variable fin_binary "Frequent exposure to finance content"

gen mh_binary = .
replace mh_binary = 0 if inlist(mentalhealth_content_cont, 0, 1, 2)
replace mh_binary = 1 if inlist(mentalhealth_content_cont, 3, 4)
label values mh_binary freq_binary
label variable mh_binary "Frequent exposure to mental health content"

gen env_binary = .
replace env_binary = 0 if inlist(environment_content_cont, 0, 1, 2)
replace env_binary = 1 if inlist(environment_content_cont, 3, 4)
label values env_binary freq_binary
label variable env_binary "Frequent exposure to environment content"

gen ind_binary = .
replace ind_binary = 0 if inlist(independent_content_cont, 0, 1, 2)
replace ind_binary = 1 if inlist(independent_content_cont, 3, 4)
label values ind_binary freq_binary
label variable ind_binary "Frequent exposure to independent content"

tab ent_binary
tab info_binary
tab life_binary
tab fam_binary
tab sexhlth_binary
tab career_binary
tab fin_binary
tab mh_binary
tab env_binary
tab ind_binary


*correlation: we cannot aggregate them because the correlation coefficient is too low in any case
correlate ent_binary life_binary
* I cannot put them together, the correlation is 0.05
correlate career_binary fin_binary
*correlation is 0.28
correlate sexhlth_binary mh_binary
* too low (0.24)
correlate info_binary sexhlth_binary 
*0.0034

*TYPE OF CONTENTS LOGISTIC REGRESSION 
logistic fertility_intentions ent_binary
logistic fertility_intentions info_binary
logistic fertility_intentions life_binary
logistic fertility_intentions fam_binary
logistic fertility_intentions sexhlth_binary
logistic fertility_intentions career_binary
logistic fertility_intentions fin_binary
logistic fertility_intentions mh_binary
logistic fertility_intentions env_binary
logistic fertility_intentions ind_binary

*adding controls
logistic fertility_intentions ent_binary i.gender_num religiosity_num age
logistic fertility_intentions info_binary i.gender_num religiosity_num age
logistic fertility_intentions life_binary i.gender_num religiosity_num age
logistic fertility_intentions fam_binary i.gender_num religiosity_num age
logistic fertility_intentions sexhlth_binary i.gender_num religiosity_num age
logistic fertility_intentions career_binary i.gender_num religiosity_num age
logistic fertility_intentions fin_binary i.gender_num religiosity_num age
logistic fertility_intentions mh_binary i.gender_num religiosity_num age
logistic fertility_intentions env_binary i.gender_num religiosity_num age
logistic fertility_intentions ind_binary i.gender_num religiosity_num age

*comparison 
* installa estout se non lo hai già
ssc install estout, replace

eststo clear

*here i create an unique sample to make sure that all the models are based on the same sample
gen complete = !missing(fertility_intention, gender_num, religiosity_num, age, ///
    ent_binary, info_binary, life_binary, fam_binary, sexhlth_binary, ///
    career_binary, fin_binary, mh_binary, env_binary, ind_binary)
 

eststo m4: logit fertility_intention ent_binary i.gender_num religiosity_num  age if complete
margins, dydx(ent_binary)
estadd margins, dydx(ent_binary)

eststo m5: logit fertility_intention info_binary i.gender_num religiosity_num  age if complete
margins, dydx(info_binary)
estadd margins, dydx(info_binary)

eststo m6: logit fertility_intention life_binary i.gender_num religiosity_num  age if complete
margins, dydx(life_binary)
estadd margins, dydx(life_binary)

eststo m7: logit fertility_intention fam_binary i.gender_num religiosity_num  age if complete
margins, dydx(fam_binary)
estadd margins, dydx(fam_binary)

eststo m8: logit fertility_intention sexhlth_binary i.gender_num religiosity_num  age if complete
margins, dydx(sexhlth_binary)
estadd margins, dydx(sexhlth_binary)

eststo m9: logit fertility_intention career_binary i.gender_num religiosity_num  age if complete
margins, dydx(career_binary)
estadd margins, dydx(career_binary)

eststo m10: logit fertility_intention fin_binary i.gender_num religiosity_num  age if complete
margins, dydx(fin_binary)
estadd margins, dydx(fin_binary)

eststo m11: logit fertility_intention mh_binary i.gender_num religiosity_num  age if complete
margins, dydx(mh_binary)
estadd margins, dydx(mh_binary)

eststo m12: logit fertility_intention env_binary i.gender_num religiosity_num  age if complete
margins, dydx(env_binary)
estadd margins, dydx(env_binary)

eststo m13: logit fertility_intention ind_binary i.gender_num religiosity_num  age if complete
margins, dydx(ind_binary)
estadd margins, dydx(ind_binary)

*comparison
*table
esttab m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 using "fertility_models.csv", ///
  b(%9.3f) se(%9.3f) ///
  stats(N ll chi2 p aic bic) ///
  star(* 0.10 ** 0.05 *** 0.01) ///
  mtitles("Entertainment" "Informational" "Lifestyle" "Family" "Sexual health" "Career" "Finance" "Mental health" "Enviroment" "Independence") ///
  label ///
  title("Comparisons models social media content and fertility intentions") ///
  replace

*table
// extraction of margunal effects from the models
matrix ME = J(10, 1, .)
local i = 1
local vars "ent_binary info_binary life_binary fam_binary sexhlth_binary career_binary fin_binary mh_binary env_binary ind_binary"
local titles "Entertainment Informational Lifestyle Family Sexual_health Career Finance Mental_health Environment Independence"

foreach m in m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 {
    estimates restore `m'
    matrix b = e(margins_b)
    matrix ME[`i', 1] = b[1,1]
    local i = `i' + 1
}

// cration of a dataset for the graph
clear
svmat ME, names(col)
rename c1 meffect

// 
gen name = ""
local j = 1
foreach v in "Entertainment" "Informational" "Lifestyle" "Family" "Sexual health" "Career" "Finance" "Mental health" "Environment" "Independence" {
    replace name = "`v'" in `j'
    local j = `j' + 1
}

// Order of the effects from the highest to the lowest 
gsort -meffect
gen order = _n

// graph bar
graph bar meffect, over(name, sort(meffect) descending label(angle(45) labsize(medium))) ///
    bar(1, color(navy%80)) ///
    blabel(bar, format(%9.3f) color(black) size(medium)) ///
    ytitle("Marginal effect on fertility intention", size(medium)) ///
    title("Impact of different social media content on fertility intentions", size(large)) ///
    subtitle("Marginal effects estimated by logit models", size(medium)) ///
    note("Note: Effects are controlled for gender, religiosity and age.", size(small)) ///
    scheme(s1mono) ///
    yline(0, lcolor(red) lpattern(dash))
graph export "fertility_effects_simple.png", replace width(3000) height(2000)

// testing mediating effect 

// CONTENT -> FERTILITY

* MODELLO 1: content → fertility_intentions (senza controlli)

logit fertility_intentions ent_binary
margins, dydx(ent_binary)

logit fertility_intentions info_binary
margins, dydx(info_binary)

logit fertility_intentions life_binary
margins, dydx(life_binary)

logit fertility_intentions fam_binary
margins, dydx(fam_binary)

logit fertility_intentions sexhlth_binary
margins, dydx(sexhlth_binary)

logit fertility_intentions career_binary
margins, dydx(career_binary)

logit fertility_intentions fin_binary
margins, dydx(fin_binary)

logit fertility_intentions mh_binary
margins, dydx(mh_binary)

logit fertility_intentions env_binary
margins, dydx(env_binary)

logit fertility_intentions ind_binary
margins, dydx(ind_binary)

* MODELLO 2: content → fertility_intentions (CON controlli)

logit fertility_intentions ent_binary i.gender_num religiosity_num age
margins, dydx(ent_binary)

logit fertility_intentions info_binary i.gender_num religiosity_num age
margins, dydx(info_binary)

logit fertility_intentions life_binary i.gender_num religiosity_num age
margins, dydx(life_binary)

logit fertility_intentions fam_binary i.gender_num religiosity_num age
margins, dydx(fam_binary)

logit fertility_intentions sexhlth_binary i.gender_num religiosity_num age
margins, dydx(sexhlth_binary)

logit fertility_intentions career_binary i.gender_num religiosity_num age
margins, dydx(career_binary)

logit fertility_intentions fin_binary i.gender_num religiosity_num age
margins, dydx(fin_binary)

logit fertility_intentions mh_binary i.gender_num religiosity_num age
margins, dydx(mh_binary)

logit fertility_intentions env_binary i.gender_num religiosity_num age
margins, dydx(env_binary)

logit fertility_intentions ind_binary i.gender_num religiosity_num age
margins, dydx(ind_binary)

// CONTENT -> UNCERTAIN

* MODELLO 3: content → uncertainty_index_final (senza controlli)

ologit uncertainty_index_final ent_binary
margins, dydx(ent_binary)

ologit uncertainty_index_final info_binary
margins, dydx(info_binary)

ologit uncertainty_index_final life_binary
margins, dydx(life_binary)

ologit uncertainty_index_final fam_binary
margins, dydx(fam_binary)

ologit uncertainty_index_final sexhlth_binary
margins, dydx(sexhlth_binary)

ologit uncertainty_index_final career_binary
margins, dydx(career_binary)

ologit uncertainty_index_final fin_binary
margins, dydx(fin_binary)

ologit uncertainty_index_final mh_binary
margins, dydx(mh_binary)

ologit uncertainty_index_final env_binary
margins, dydx(env_binary)

ologit uncertainty_index_final ind_binary
margins, dydx(ind_binary)

* MODELLO 4: content → uncertainty_index_final (con controlli)

ologit uncertainty_index_final ent_binary i.gender_num religiosity_num age
margins, dydx(ent_binary)

ologit uncertainty_index_final info_binary i.gender_num religiosity_num age
margins, dydx(info_binary)

ologit uncertainty_index_final life_binary i.gender_num religiosity_num age
margins, dydx(life_binary)

ologit uncertainty_index_final fam_binary i.gender_num religiosity_num age
margins, dydx(fam_binary)

ologit uncertainty_index_final sexhlth_binary i.gender_num religiosity_num age
margins, dydx(sexhlth_binary)

ologit uncertainty_index_final career_binary i.gender_num religiosity_num age
margins, dydx(career_binary)

ologit uncertainty_index_final fin_binary i.gender_num religiosity_num age
margins, dydx(fin_binary)

ologit uncertainty_index_final mh_binary i.gender_num religiosity_num age
margins, dydx(mh_binary)

ologit uncertainty_index_final env_binary i.gender_num religiosity_num age
margins, dydx(env_binary)

ologit uncertainty_index_final ind_binary i.gender_num religiosity_num age
margins, dydx(ind_binary)

* MODELLO 5: uncertainty_index_final →  fertility_intentions (senza controlli)

logit fertility_intentions uncertainty_index_final
margins, dydx(uncertainty_index_final)

* MODELLO 6: uncertainty_index_final →  fertility_intentions (con controlli)

logit fertility_intentions uncertainty_index_final i.gender_num religiosity_num age
margins, dydx(uncertainty_index_final)


// Mediation Effect


// Mediation con mediate

// Info -> Uncertainty -> Fertility intentions (*no controls*) 
mediate (fertility_intentions, probit) ///  outcome, no controls
        (uncertainty_index_final, linear) ///  mediator
        (info_binary) ///  treatment
        , all

estat cde, mvalue(50 500 5000)

// Info -> Uncertainty -> Fertility intentions (*with controls*) 
mediate (fertility_intentions i.gender_num religiosity_num age, probit) /// outcome with controls
        (uncertainty_index_final, linear) /// mediator with controls
        (info_binary) /// treatment
        , all

estat cde, mvalue(50 500 5000)


// Indipendent -> Uncertainty -> Fertility intentions (*no controls*) 
mediate (fertility_intentions, probit) /// outcome, no controls
        (uncertainty_index_final, linear) /// mediator
        (ind_binary) /// treatment
        , all

estat cde, mvalue(50 500 5000)

// Indipendent -> Uncertainty -> Fertility intentions (*with controls*) 
mediate (fertility_intentions i.gender_num religiosity_num age, probit) /// outcome with controls
        (uncertainty_index_final, linear) /// mediator with controls
        (ind_binary) /// treatment
        , all

estat cde, mvalue(50 500 5000)


  


