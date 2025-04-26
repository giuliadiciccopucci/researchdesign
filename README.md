# researchdesign
cd "/Users/utente/Desktop/research_design"

import delimited "/Users/utente/Desktop/research_design/data/results-survey274732.csv"
save "/Users/utente/Desktop/research_design/data/results-survey274732.dta", replace 
use "/Users/utente/Desktop/research_design/data/results-survey274732.dta"


*/label variable media21whicho~l "Facebook"
label variable media22whicho~l "Instagram"
label variable media23whicho~l "X (Twitter)"
label variable media24whicho~l "Snapchat"
label variable media25whicho~l "TikTok"
label variable media26whicho~l "LinkedIn"
label variable media27whicho~l "Pinterest"
label variable media28whicho~l "YouTube"
label variable media29whicho~l "Reddit"
label variable media210which~a "WhatsApp"
label variable media211which~a "Telegram"

label variable media31whileu~o "Entertainment content"
label variable media32whileu~o "Informational content"
label variable media33whileu~o "Lifestyle content"
label variable media34whileu~o "Family/parenting content"
label variable media35whileu~o "Sexual health content"
label variable media36whileu~o "Career/professional content"
label variable media37whileu~o "Finance/economic content"
label variable media38whileu~o "Mental health content"
label variable media39whileu~o "Environmental content"
label variable media310while~w "Independent lifestyle content" 

