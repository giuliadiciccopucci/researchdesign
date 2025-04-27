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

replace social_media_time = 1 if Total_Time_new <= 120
replace social_media_time = 2 if inrange(Total_Time_new, 121, 240)
replace social_media_time = 3 if inrange(Total_Time_new, 241, 360)
replace social_media_time = 4 if inrange(Total_Time_new, 361, 480)
replace social_media_time = 5 if Total_Time_new > 480

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


