library(dplyr)
library(tidyverse)

########remove all unnecessary documentation from snippets and csv file with only snippets ###########

####### onlymale corpus #########

only__male_new <-  only__male %>% mutate(across('snippet', str_replace_all, "<.*?>", ""))
write_csv(only__male_new, 'only__male_clean.csv')

only__male_snippet <- only__male_new %>% select('snippet')
write_csv(only__male_snippet, 'only__male_snippet.csv')

################ gender corpus ###########
  
gendern_new <- comb %>% mutate(across('snippet',str_replace_all, "<.*?>", "" ))
write_csv(gendern_new, 'gendern_clean.csv')

gendern_snippet <-  gendern_new %>% select('snippet')
write_csv(gendern_snippet, 'gendern_snippet.csv')

########### mint corpus ############

clean_mint_male <- mint_only_male %>% mutate(across('snippet', str_replace_all, "<.*?>", ""))
write_csv(clean_mint_male, 'clean_mint_male.csv')

mint_male_snippet <- clean_mint_male %>% select('snippet')
write_csv(mint_male_snippet, 'mint_male_snippet.csv')
